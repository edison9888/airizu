//
//  RoomDetailForRoomDetailBasicInfo.m
//  airizu
//
//  Created by 唐志华 on 13-1-28.
//
//

#import "RoomDetailForRoomDetailBasicInfo.h"
#import "CustomControlDelegate.h"
#import "RoomDetailOfBasicInformationActivityContent.h"
#import "RoomDetailNetRespondBean.h"

@implementation RoomDetailForRoomDetailBasicInfo

- (void)dealloc {
  
  // UI
  [_propertyTypeLabel release];
  [_privacyLabel release];
  [_bathRoomNumLabel release];
  [_bedRoomLabel release];
  [_accommodatesLabel release];
  [_bedTypeLabel release];
  [_bedsLabel release];
  [_sizeLabel release];
  [_checkOutTimeLabel release];
  [_minNightsLabel release];
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

- (IBAction)roomDetailButtonOnClickListener:(id)sender {
  if ([_delegate conformsToProtocol:@protocol(CustomControlDelegate)]) {
    if ([_delegate respondsToSelector:@selector(customControl:onAction:)]) {
      [_delegate customControl:self onAction:kRoomDetailOfBasicInformationActivityContentActionEnum_RoomDetailButtonClicked];
    }
  }
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

#pragma mark -
#pragma mark 加载子View
-(void)initUseRoomDetailNetRespondBean:(RoomDetailNetRespondBean *)roomDetailNetRespondBean{
  
  NSString *fullString = nil;// 带 "计量单位" 的完整信息字符串
  
  // 房屋类型
  [_propertyTypeLabel setText:roomDetailNetRespondBean.propertyType];
  // 租住方式
  [_privacyLabel setText:roomDetailNetRespondBean.privacy];
  
  // 卫生间数
  fullString = roomDetailNetRespondBean.bathRoomNum;
  if (![NSString isEmpty:fullString]) {
    fullString = [NSString stringWithFormat:@"%@个", fullString];
  }
  [_bathRoomNumLabel setText:fullString];
  
  // 卧室数
  fullString = roomDetailNetRespondBean.bedRoom;
  if (![NSString isEmpty:fullString]) {
    fullString = [NSString stringWithFormat:@"%@间", fullString];
  }
  [_bedRoomLabel setText:fullString];
  
  // 可入住人数
  NSInteger accommodatesInteger = [roomDetailNetRespondBean.accommodates integerValue];
  if (accommodatesInteger >= 10) {
    fullString = [NSString stringWithFormat:@"%d人以上", accommodatesInteger];
  } else {
    fullString = [NSString stringWithFormat:@"%d人", accommodatesInteger];
  }
  [_accommodatesLabel setText:fullString];
  
  // 床型
  [_bedTypeLabel setText:roomDetailNetRespondBean.bedType];
  
  // 床数
  fullString = [roomDetailNetRespondBean.beds stringValue];
  if (![NSString isEmpty:fullString]) {
    fullString = [NSString stringWithFormat:@"%@个", fullString];
  }
  [_bedsLabel setText:fullString];
  
  // 建筑面积
  fullString = [roomDetailNetRespondBean.size stringValue];
  if (![NSString isEmpty:fullString]) {
    fullString = [NSString stringWithFormat:@"%@平米", fullString];
  }
  [_sizeLabel setText:fullString];
  
  // 退房时间
  [_checkOutTimeLabel setText:roomDetailNetRespondBean.checkOutTime];
  
  // 最少天数
  fullString = [roomDetailNetRespondBean.minNights stringValue];
  if (![NSString isEmpty:fullString]) {
    fullString = [NSString stringWithFormat:@"%@天", fullString];
  }
  [_minNightsLabel setText:fullString];
}

#pragma mark -
#pragma mark 方便构造
+(id)roomDetailForRoomDetailBasicInfoWithRoomDetailNetRespondBean:(RoomDetailNetRespondBean *)roomDetailNetRespondBean {
  NSArray *nibObjects = [[self nib] instantiateWithOwner:nil options:nil];
  RoomDetailForRoomDetailBasicInfo *roomDetailForRoomDetailBasicInfo = [nibObjects objectAtIndex:0];
  [roomDetailForRoomDetailBasicInfo initUseRoomDetailNetRespondBean:roomDetailNetRespondBean];
  return roomDetailForRoomDetailBasicInfo;
}

@end
