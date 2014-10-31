//
//  CommentTableView.m
//  Vweibo
//
//  Created by 董书建 on 14/10/16.
//  Copyright (c) 2014年 Vean. All rights reserved.
//

#import "CommentTableView.h"
#import "CommentCell.h"
#import "UIViewExt.h"

@implementation CommentTableView

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        
    }
    return self;
}

#pragma mark - UItableView delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identify  = @"CommentCell";
    CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CommentCell" owner:self options:nil] lastObject];
    }
    CommentModel *commentModel =  [self.data objectAtIndex:indexPath.row];
    cell.commentModel = commentModel;
    return cell;
}

//获取微博自定义的cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CommentModel *commentModel =  [self.data objectAtIndex:indexPath.row];
    float h = [CommentCell getCommentHeight:commentModel];
    return  h+40;
}

//获取Header
- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 40)];
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel *commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 20)];
    commentLabel.backgroundColor = [UIColor clearColor];
    commentLabel.textColor = [UIColor blueColor];
    commentLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    
    //判断是否有值
    if (self.commentResult != nil) {
        //转化字符串
        NSData *resultData = [self.commentResult dataUsingEncoding:NSUTF8StringEncoding];
        //转化为Dictionary对象
        NSDictionary* resultDic = [NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingMutableLeaves error:nil];
//        NSLog(@"resultDic-->>> %@",resultDic);
        //获取resultDic中的数据
        NSString *total =[resultDic objectForKey:@"total_number"];
//        NSLog(@"total-->>> %@",total);
        commentLabel.text = [NSString stringWithFormat:@"评论数：%@",total];
    }
    
    [view addSubview:commentLabel];
    UIImageView *separeView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 39, tableView.width, 1)];
    separeView.image = [UIImage imageNamed:@"userinfo_header_separator.png"];
    
    [view addSubview:separeView];
    
    return view;
}

//获取header高度
-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}


@end
