//
//  TenantReviewsTableHeaderView.h
//  airizu
//
//  Created by 唐志华 on 13-2-13.
//
//

#import <UIKit/UIKit.h>

@class RoomReviewNetRespondBean;
@interface TenantReviewsTableHeaderView : UIView {
  
}

// 房间总的平均分
@property (retain, nonatomic) IBOutlet UILabel *avgScore;
// 评论条数
@property (retain, nonatomic) IBOutlet UILabel *reviewCount;
// 评论信息(list)
@property (retain, nonatomic) IBOutlet UIView *reviewsLayout;

+(id)tenantReviewsTableHeaderViewWithRoomReviewNetRespondBean:(RoomReviewNetRespondBean *)roomReviewNetRespondBean;

@end
