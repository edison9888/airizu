//
//  TenantReviewsTableViewCell.h
//  airizu
//
//  Created by 唐志华 on 13-2-13.
//
//

#import <UIKit/UIKit.h>

@class RoomReview;
@interface TenantReviewsTableViewCell : UITableViewCell {
  
}

/// 用户评论内容布局
@property (retain, nonatomic) IBOutlet UIView *userReviewLayout;
// 用户姓名
@property (retain, nonatomic) IBOutlet UILabel *userName;
// 用户发布评论时间
@property (retain, nonatomic) IBOutlet UILabel *userReviewTime;
// 用户评论内容
@property (retain, nonatomic) IBOutlet UILabel *userReview;

/// 房东回复内容布局
@property (retain, nonatomic) IBOutlet UIView *hostReviewLayout;
// 房东回复时间
@property (retain, nonatomic) IBOutlet UILabel *hostReviewTime;
// 房东回复内容
@property (retain, nonatomic) IBOutlet UILabel *hostReview;

#pragma mark -
#pragma mark 使用 IB编辑 table cell

+ (id)cellForTableView:(UITableView *)tableView fromNib:(UINib *)nib;
+ (UINib *)nib;

-(void)initTableViewCellDataWithRoomReview:(RoomReview *)roomReview;

+(id)tenantReviewsTableViewCell;
@end
