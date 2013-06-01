//
//  BasicInfoRetractableCellView.m
//  airizu
//
//  Created by 唐志华 on 13-2-12.
//
//

#import "BasicInfoRetractableCellView.h"

#import "RoomDetailNetRespondBean.h"

@implementation BasicInfoRetractableCellView

- (void)dealloc {
  
  // UI
  [_propertyType release];
  [_privacy release];
  [_restRoom release];
  [_bathRoomNum release];
  [_bedRoom release];
  [_accommodates release];
  [_bedType release];
  [_beds release];
  [_size release];
  [_checkOutTime release];
  [_maxNights release];
  [_minNights release];
  [_tickets release];
  [_cancellation release];
  [_clean release];
  [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    // Initialization code
  }
  return self;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

+ (NSString *) nibName {
  return NSStringFromClass([self class]);
}

+ (UINib *) nib {
  NSBundle *classBundle = [NSBundle bundleForClass:[self class]];
  return [UINib nibWithNibName:[self nibName] bundle:classBundle];
}

+(id)basicInfoRetractableCellViewWithRoomDetailNetRespondBean:(RoomDetailNetRespondBean *)roomDetailNetRespondBean {
  NSArray *nibObjects = [[self nib] instantiateWithOwner:nil options:nil];
  BasicInfoRetractableCellView *basicInfoRetractableCellView = [nibObjects objectAtIndex:0];
  
  NSString *fullString = nil;// 带 "计量单位" 的完整信息字符串
  
  // 房屋类型
  basicInfoRetractableCellView.propertyType.text = roomDetailNetRespondBean.propertyType;
  // 租住方式
  basicInfoRetractableCellView.privacy.text = roomDetailNetRespondBean.privacy;
  // 卫浴类型
  basicInfoRetractableCellView.restRoom.text = roomDetailNetRespondBean.restRoom;
  
  // 卫生间数
  fullString = roomDetailNetRespondBean.bathRoomNum;
  if (![NSString isEmpty:fullString]) {
    fullString = [NSString stringWithFormat:@"%@个", fullString];
  }
  basicInfoRetractableCellView.bathRoomNum.text = fullString;
  
  // 卧室数量
  fullString = roomDetailNetRespondBean.bedRoom;
  if (![NSString isEmpty:fullString]) {
    fullString = [NSString stringWithFormat:@"%@间", fullString];
  }
  basicInfoRetractableCellView.bedRoom.text =fullString;
  
  // 可住人数
  NSInteger accommodatesInteger = [roomDetailNetRespondBean.accommodates integerValue];
  if (accommodatesInteger >= 10) {
    fullString = [NSString stringWithFormat:@"%d人以上", accommodatesInteger];
  } else {
    fullString = [NSString stringWithFormat:@"%d人", accommodatesInteger];
  }
  basicInfoRetractableCellView.accommodates.text = fullString;
  
  // 房间床型
  basicInfoRetractableCellView.bedType.text = roomDetailNetRespondBean.bedType;
  
  // 房间床数
  fullString = [roomDetailNetRespondBean.beds stringValue];
  if (![NSString isEmpty:fullString]) {
    fullString = [NSString stringWithFormat:@"%@个", fullString];
  }
  basicInfoRetractableCellView.beds.text = fullString;
  
  // 建筑面积
  fullString = [roomDetailNetRespondBean.size stringValue];
  if (![NSString isEmpty:fullString]) {
    fullString = [NSString stringWithFormat:@"%@平米", fullString];
  }
  basicInfoRetractableCellView.size.text = fullString;
  
  // 退房时间
  basicInfoRetractableCellView.checkOutTime.text = roomDetailNetRespondBean.checkOutTime;
  
  // 最多天数
  NSInteger maxNightsInteger = [roomDetailNetRespondBean.maxNights integerValue];
  if (maxNightsInteger >= 10) {
    fullString = [NSString stringWithFormat:@"%d天以上", maxNightsInteger];
  } else {
    fullString = [NSString stringWithFormat:@"%d", maxNightsInteger];
  }
  basicInfoRetractableCellView.maxNights.text = fullString;

  // 最少天数
  fullString = [roomDetailNetRespondBean.minNights stringValue];
  if (![NSString isEmpty:fullString]) {
    fullString = [NSString stringWithFormat:@"%@天", fullString];
  }
  basicInfoRetractableCellView.minNights.text = fullString;
  
  // 提供发票
  NSString *isProvideAnInvoiceString;
  if (roomDetailNetRespondBean.tickets) {
    isProvideAnInvoiceString = @"是";
  } else {
    isProvideAnInvoiceString = @"否";
  }
  basicInfoRetractableCellView.tickets.text = isProvideAnInvoiceString;
  
  // 退订条款
  basicInfoRetractableCellView.cancellation.text = roomDetailNetRespondBean.cancellation;
  
  // 清洁服务类型
  basicInfoRetractableCellView.clean.text = roomDetailNetRespondBean.clean;
  
  return basicInfoRetractableCellView;
}

@end
