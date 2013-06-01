//
//  TenantReviewsForRoomDetailBasicInfo.h
//  airizu
//
//  Created by 唐志华 on 13-1-28.
//
//

#import <UIKit/UIKit.h>

@protocol CustomControlDelegate;
@class RoomDetailNetRespondBean;

@interface TenantReviewsForRoomDetailBasicInfo : UIView {
  
}

// 租客点评总分
@property (retain, nonatomic) IBOutlet UILabel *reviewLabel;
// 租客点评总条数
@property (retain, nonatomic) IBOutlet UILabel *reviewCountLabel;
// 租客点评列表，这里只显示1条记录
@property (retain, nonatomic) IBOutlet UILabel *reviewContentLabel;

//
@property (nonatomic, assign) id<CustomControlDelegate> delegate;

#pragma mark -
#pragma mark 方便构造
+(id)tenantReviewsForRoomDetailBasicInfoWithRoomDetailNetRespondBean:(RoomDetailNetRespondBean *)roomDetailNetRespondBean;



@end
