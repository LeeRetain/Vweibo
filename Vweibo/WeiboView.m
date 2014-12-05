//
//  WeiboView.m
//  Vweibo
//
//  Created by 董书建 on 14/9/28.
//  Copyright (c) 2014年 Vean. All rights reserved.
//

#import "WeiboView.h"
#import "UIFactory.h"
#import "UIViewExt.h"
#import "UIImageView+WebCache.h"
#import "CONSTS.h"
#import "NSString+URLEncoding.h"
#import "RegexKitLite.h"
#import "UIUtils.h"
#import "UIView+Addtions.h"
#import "UserViewController.h"
#import "WebViewController.h"
#import "TopicViewController.h"

@implementation WeiboView

- (id) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self _initView];
        _parseText = [[NSMutableString alloc] init];
    }
    return self;
}

//初始化子视图
- (void)_initView {
    //微博内容
    _textLabel = [[RTLabel alloc] init];
    _textLabel.delegate = self;
    _textLabel.font = [UIFont systemFontOfSize:14.0f];
    //设置链接的颜色
    _textLabel.linkAttributes = [NSDictionary dictionaryWithObject:@"blue" forKey:@"color"];
    //设置连接高亮的颜色
    _textLabel.selectedLinkAttributes = [NSDictionary dictionaryWithObject:@"darkGray" forKey:@"color"];
    [self addSubview:_textLabel];
    
    //微博图片
    _image = [[UIImageView alloc] initWithFrame:CGRectZero];
    _image.image = [UIImage imageNamed:@"page_image_loading"];
    [self addSubview:_image];
    
    //转发的微博背景图片
    _repostBackgroudView = [UIFactory creataWithImageView:@"timeline_retweet_background"];
    UIImage *image = [_repostBackgroudView.image stretchableImageWithLeftCapWidth:25 topCapHeight:10];
    _repostBackgroudView.image = image;
    _repostBackgroudView.backgroundColor = [UIColor clearColor];
    //设置微博转发背景的拉伸位置
    _repostBackgroudView.leftCapWidth = 25;
    _repostBackgroudView.topCapHeight = 10;
    [self insertSubview:_repostBackgroudView atIndex:0];
    
}

//设置WeiboModel set
- (void) setWeiboModel:(WeiboModel *)weiboModel {
    if (_weiboModel != weiboModel) {
        _weiboModel = weiboModel;
    }
    //创建转发的微博视图
    if(_repostView == nil) {
        _repostView = [[WeiboView alloc] initWithFrame:CGRectZero];
        _repostView.isRepost = YES;
        _repostView.isDetail = self.isDetail;
        [self addSubview:_repostView];
    }
    //加载解析
    [self parseLink];
}

//解析微博文本超链接（根据正则表达式）
- (void) parseLink {
    [_parseText setString:@""];
    
    //判断是否为转发微博
    if (_isRepost) {
        //将原微博的作者添加前面
        //原微博作者的昵称
        NSString *nickName =  _weiboModel.userModel.screen_name;
        NSString *encodeName = [nickName URLEncodedString];
        [_parseText appendFormat:kRepostUserTextStyle, encodeName, nickName];
    }
    
    //获取微博文本
    NSString *text = _weiboModel.text;
//    NSLog(@"%@",text);
    //解析、替换超链接
    text = [UIUtils parseLink:text];
      [_parseText appendString:text];
//    NSLog(@"_parseText %@", _parseText);
}

//layoutSubviews 展示数据，加载视图
//layoutSubviews 方法有可能多次调用
-(void) layoutSubviews {
    [super layoutSubviews];
    //----------------------微博内容_textLabel子视图-------------------------
    [self _renderLabel];
    
    //----------------------源微博_repostView子视图-------------------------
    [self _renderSourceWeiboView];
    
    //----------------------微博的图片视图_image-------------------------
    [self _renderImage];
    
    //----------------------微博的微博视图背景_repostBackgroudView-------------------------
    if (self.isRepost) {
        _repostBackgroudView.frame = self.bounds;
        _repostBackgroudView.hidden = NO;
    } else {
        _repostBackgroudView.hidden = YES;
    }
}

//微博内容_textLabel子视图
- (void) _renderLabel {
    //获取字体大小
    float fontSize = [WeiboView getFontSize:self.isDetail isRepost:self.isRepost];
    _textLabel.frame = CGRectMake(0, 0, self.width, 20);
    //设置字体的大小
    _textLabel.font = [UIFont systemFontOfSize:fontSize];
    //判断是否是转发
    if (_isRepost) {
        _textLabel.frame = CGRectMake(10, 10, self.width-20, 0);
    }
    //设置微博文本
    _textLabel.text = _parseText;
    //文本的高度
    CGSize textSize = _textLabel.optimumSize;
    _textLabel.height = textSize.height;
}

//源微博_repostView子视图
- (void) _renderSourceWeiboView {
    WeiboModel *repostWeibo = _weiboModel.relModel; //转发的微博内容
    if (repostWeibo != nil) {
        _repostView.hidden = NO;
        _repostView.weiboModel = repostWeibo;
        
        float height = [WeiboView getWeiboViewHeight:repostWeibo isRepost:YES isDetail:self.isDetail];
        _repostView.frame = CGRectMake(0, _textLabel.bottom, self.width, height);
    } else {
        _repostView.hidden = YES;
    }
}

//微博的图片视图_image
- (void) _renderImage {
    if (self.isDetail) {
        //获取中等图
        NSString *bmiddlePic = _weiboModel.bmiddlePic;
        if (bmiddlePic != nil && ![@"" isEqualToString:bmiddlePic]) {
            _image.hidden = NO; //设置显示
            _image.frame = CGRectMake(10, _textLabel.bottom+10, _textLabel.width - 20, 280);
            //加载网络图
            [_image setImageWithURL:[NSURL URLWithString:bmiddlePic]];
            //图片自动适应宽高
            _image.contentMode = UIViewContentModeScaleAspectFit;
            
        } else {
            _image.hidden = YES; //设置隐藏
        }
    } else {
        //图片浏览模式
        NSInteger mode = [[NSUserDefaults standardUserDefaults] integerForKey:kBrowMode];
        if (mode == 0) {
            mode = kThumbnails;
        }
        
        if (mode == kThumbnails) {
            //获取缩略图
            NSString *thumbnailPic = _weiboModel.thumbnailPic;
            if (thumbnailPic != nil && ![@"" isEqualToString:thumbnailPic]) {
                _image.hidden = NO; //设置显示
                _image.frame = CGRectMake(10, _textLabel.bottom+10, 70, 80);
                //图片自动适应宽高
                _image.contentMode = UIViewContentModeScaleAspectFit;
                //加载网络图
                [_image setImageWithURL:[NSURL URLWithString:thumbnailPic]];
                
            } else {
                _image.hidden = YES; //设置隐藏
            }
        //大图浏览模式
        } else if (mode == kLargeImage) {
            NSString *bmiddlePic = _weiboModel.bmiddlePic;
            if (bmiddlePic != nil && ![@"" isEqualToString:bmiddlePic]) {
                _image.hidden = NO; //设置显示
                _image.frame = CGRectMake(10, _textLabel.bottom+10, self.width - 20, 180);
                //图片自动适应宽高
                _image.contentMode = UIViewContentModeScaleAspectFit;
                //加载网络图
                [_image setImageWithURL:[NSURL URLWithString:bmiddlePic]];
                
            } else {
                _image.hidden = YES; //设置隐藏
            }
        }
        
    }
}

//获取字体的大小
+ (float) getFontSize:(BOOL) isDetail  isRepost:(BOOL) isRepost {

    float fontSize = 14.0f;
    if (!isDetail && !isRepost) {
        return LIST_FONT;
    } else if (!isDetail && isRepost) {
        return LIST_REPOST_FONT;
    } else if (isDetail && !isRepost) {
        return DETAIL_FONT;
    } else if (isDetail && isRepost) {
        return DETAIL_REPOST_FONT;
    }
    return fontSize;
}

//计算微博视图的高度
+ (CGFloat) getWeiboViewHeight:(WeiboModel *) weiboModel isRepost:(BOOL) isRepost isDetail:(BOOL) isDetail {
    
    /**
     *      实现思路，计算每个子视图的高度，然后相加
     **/
    float height = 0;
    
    //---------------------计算微博内容text的高度------------------------
    
    RTLabel *textLabel = [[RTLabel alloc] initWithFrame:CGRectZero];
    float fontSize = [WeiboView getFontSize:isDetail isRepost:isRepost];
    textLabel.font = [UIFont systemFontOfSize:fontSize];
    //判断微博是否显示在详情页面
    if (isDetail) {
        textLabel.width = kWeibo_Width_Detail;
    } else  {
        textLabel.width = kWeibo_Width_List;
    }
    
    if(isRepost) {
        textLabel.width -= 20;
    }
    //设置显示微博内容
    textLabel.text = weiboModel.text;
    //设置微博正文的高度
    height += textLabel.optimumSize.height;
    
    //---------------------计算微博图片的高度------------------------
    
    if(isDetail) {
        NSString *bmiddlePic = weiboModel.bmiddlePic;
        if (bmiddlePic != nil && ![@"" isEqualToString:bmiddlePic]) {
            height += kBmiddlePic;
        }
    } else {
        //图片浏览模式
        NSInteger mode = [[NSUserDefaults standardUserDefaults] integerForKey:kBrowMode];
        if (mode == 0) {
            mode = kThumbnails;
        }
        if (mode == kThumbnails) {
            NSString *thumbnailPic = weiboModel.thumbnailPic;
            if (thumbnailPic != nil && ![@"" isEqualToString:thumbnailPic]) {
                height += kThumbnailPic;
            }
        } else if (mode == kLargeImage) {
            NSString *bmiddlePic = weiboModel.bmiddlePic;
            if (bmiddlePic != nil && ![@"" isEqualToString:bmiddlePic]) {
                height += kLargePic;
            }
        }
    }
    
    //---------------------计算转发的微博的视图高度------------------------
    //转发的微博内容
    WeiboModel *relWeibo = weiboModel.relModel;
    if (relWeibo != nil) {
        //转发微博视图的高度
        float repostHeight = [WeiboView getWeiboViewHeight:relWeibo isRepost:YES isDetail:isDetail];
        height += (repostHeight);
    }
    
    if (isRepost == YES) {
        height += 40;
    }
    return height;
}

#pragma mark - RTLabel Delegate
- (void)rtLabel:(id)rtLabel didSelectLinkWithURL:(NSURL*)url {

    //获取微博文本中的超链接
    NSString *absoluteString = [url absoluteString];
    //判断是否是user信息，然后获取user
    if ([absoluteString hasPrefix:@"user"]) {
        NSString *strUrl = [url host];
        strUrl = [strUrl URLDecodedString];
        //判断字符串中是否有 "@" 字符
        if ([strUrl hasPrefix:@"@"]) {
            //截取字符串
            strUrl = [strUrl substringFromIndex:1];
        }
//        NSLog(@"user-->>>%@",strUrl);
        //转到个人信息
        UserViewController *viewCtr = [[UserViewController alloc] init];
        viewCtr.userName = strUrl;
        [self.viewController.navigationController pushViewController:viewCtr animated:YES];
        
    //判断是否是 url 然后获取url
    } else  if ([absoluteString hasPrefix:@"http"]) {
        NSString *url = [absoluteString URLDecodedString];
//        NSLog(@"url-->>>%@",[absoluteString URLDecodedString]);
        WebViewController *webViewController = [[WebViewController alloc] initWithURL:url];
        [self.viewController.navigationController pushViewController:webViewController animated:YES];
        
    //判断是否是话题，获取话题链接
    } else if ([absoluteString hasPrefix:@"topic"]) {
        NSString *strUrl = [url host];
        strUrl = [strUrl URLDecodedString];
        strUrl = [strUrl substringFromIndex:1];
        strUrl = [strUrl substringToIndex:(strUrl.length-1)];
        NSLog(@"topic-->>>%@",strUrl);
        TopicViewController *topicViewController = [[TopicViewController alloc] init];
        topicViewController.userName = strUrl;
        [self.viewController.navigationController pushViewController:topicViewController animated:YES];
    }
}

@end
