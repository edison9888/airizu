//
//  RoomDetailForRoomDetailBasicInfo.h
//  airizu
//
//  Created by 唐志华 on 13-1-28.
//
//

#import <UIKit/UIKit.h>

@protocol CustomControlDelegate;
@class RoomDetailNetRespondBean;

@interface RoomDetailForRoomDetailBasicInfo : UIView {
  
}

// 房屋类型
@property (retain, nonatomic) IBOutlet UILabel *propertyTypeLabel;
// 租住方式
@property (retain, nonatomic) IBOutlet UILabel *privacyLabel;
// 卫生间数
@property (retain, nonatomic) IBOutlet UILabel *bathRoomNumLabel;
// 卧室数
@property (retain, nonatomic) IBOutlet UILabel *bedRoomLabel;
// 可入住人数
@property (retain, nonatomic) IBOutlet UILabel *accommodatesLabel;
// 床型
@property (retain, nonatomic) IBOutlet UILabel *bedTypeLabel;
// 床数
@property (retain, nonatomic) IBOutlet UILabel *bedsLabel;
// 建筑面积
@property (retain, nonatomic) IBOutlet UILabel *sizeLabel;
// 退房时间
@property (retain, nonatomic) IBOutlet UILabel *checkOutTimeLabel;
// 最少天数
@property (retain, nonatomic) IBOutlet UILabel *minNightsLabel;


//
@property (nonatomic, assign) id<CustomControlDelegate> delegate;

#pragma mark -
#pragma mark 方便构造
+(id)roomDetailForRoomDetailBasicInfoWithRoomDetailNetRespondBean:(RoomDetailNetRespondBean *)roomDetailNetRespondBean;

@end
