//
//  RoomDetailOfBasicInformationActivityContent.h
//  airizu
//
//  Created by 唐志华 on 13-1-28.
//
//

#import <UIKit/UIKit.h>
 
#import "CustomControlDelegate.h"

typedef enum  {
  // 房间图片点击事件
  kRoomDetailOfBasicInformationActivityContentActionEnum_RoomPhotoClicked = 0,
  // 房间交通地图按钮点击事件
  kRoomDetailOfBasicInformationActivityContentActionEnum_MapButtonClicked,
  // 房间详情按钮点击事件
  kRoomDetailOfBasicInformationActivityContentActionEnum_RoomDetailButtonClicked,
  // 租客点评按钮点击事件
  kRoomDetailOfBasicInformationActivityContentActionEnum_TenantReviewsButtonClicked,
  // 客服电话按钮点击事件
  kRoomDetailOfBasicInformationActivityContentActionEnum_CustomerServicePhoneButtonClicked
} RoomDetailOfBasicInformationActivityContentActionEnum;


@class RoomDetailNetRespondBean;

@interface RoomDetailOfBasicInformationActivityContent : UIView <CustomControlDelegate>{
  
}

// 房间照片画廊上面的 房间价格
@property (retain, nonatomic) IBOutlet UILabel *roomPriceLabel;

// 目前将UI 分为6个子部分
// 1.房间照片画廊
@property (retain, nonatomic) IBOutlet UIView *roomPhotoGalleryPlaceholder;
// 2.房间 title 信息区域
@property (retain, nonatomic) IBOutlet UIView *roomTitlePlaceholder;
// 3.房间详情 区域
@property (retain, nonatomic) IBOutlet UIView *roomDetailPlaceholder;
// 4.租客点评 区域
@property (retain, nonatomic) IBOutlet UIView *tenantReviewsPlaceholder;
// 5.房间特色 区域
@property (retain, nonatomic) IBOutlet UIView *roomFeaturesPlaceholder;
// 6.介绍区域
@property (retain, nonatomic) IBOutlet UIView *introductionPlaceholder;



//
@property (nonatomic, assign) id<CustomControlDelegate> delegate;

#pragma mark -
#pragma mark 方便构造
+(id)roomDetailOfBasicInformationActivityContentWithRoomDetailNetRespondBean:(RoomDetailNetRespondBean *)roomDetailNetRespondBean;
@end
