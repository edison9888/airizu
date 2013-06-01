//
//  BasicInfoRetractableCellView.h
//  airizu
//
//  Created by 唐志华 on 13-2-12.
//
//

#import <UIKit/UIKit.h>

@class RoomDetailNetRespondBean;
@interface BasicInfoRetractableCellView : UIView {
  
}

// 房屋类型
@property (retain, nonatomic) IBOutlet UILabel *propertyType;
// 租住方式
@property (retain, nonatomic) IBOutlet UILabel *privacy;
// 卫浴类型
@property (retain, nonatomic) IBOutlet UILabel *restRoom;
// 卫生间数
@property (retain, nonatomic) IBOutlet UILabel *bathRoomNum;
// 卧室数量
@property (retain, nonatomic) IBOutlet UILabel *bedRoom;
// 可住人数
@property (retain, nonatomic) IBOutlet UILabel *accommodates;
// 房间床型
@property (retain, nonatomic) IBOutlet UILabel *bedType;
// 房间床数
@property (retain, nonatomic) IBOutlet UILabel *beds;
// 建筑面积
@property (retain, nonatomic) IBOutlet UILabel *size;
// 退房时间
@property (retain, nonatomic) IBOutlet UILabel *checkOutTime;
// 最多天数
@property (retain, nonatomic) IBOutlet UILabel *maxNights;
// 最少天数
@property (retain, nonatomic) IBOutlet UILabel *minNights;
// 提供发票
@property (retain, nonatomic) IBOutlet UILabel *tickets;
// 退订条款
@property (retain, nonatomic) IBOutlet UILabel *cancellation;
// 清洁服务类型
@property (retain, nonatomic) IBOutlet UILabel *clean;

+(id)basicInfoRetractableCellViewWithRoomDetailNetRespondBean:(RoomDetailNetRespondBean *)roomDetailNetRespondBean;
@end
