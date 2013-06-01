//
//  RoomTitleForRoomDetailBasicInfo.m
//  airizu
//
//  Created by 唐志华 on 13-1-28.
//
//

#import "RoomTitleForRoomDetailBasicInfo.h"
#import "CustomControlDelegate.h"
#import "RoomDetailOfBasicInformationActivityContent.h"
#import "RoomDetailNetRespondBean.h"

@implementation RoomTitleForRoomDetailBasicInfo

- (void)dealloc {
  
  // UI
  [_roomTitleLabel release];
  [_roomAddressLabel release];
  [_roomNumberLabel release];
  [_roomScheduledCountLabel release];
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

- (IBAction)mapButtonOnClickListener:(id)sender {
  if ([_delegate conformsToProtocol:@protocol(CustomControlDelegate)]) {
    if ([_delegate respondsToSelector:@selector(customControl:onAction:)]) {
      [_delegate customControl:self onAction:kRoomDetailOfBasicInformationActivityContentActionEnum_MapButtonClicked];
    }
  }
}


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
  
  NSString *roomTitleString = roomDetailNetRespondBean.title;
  NSInteger numberOfRoomsInteger = [roomDetailNetRespondBean.roomNumber integerValue];
  if (numberOfRoomsInteger > 1) {// 如果为 1 套时就不显示套数了
    roomTitleString = [NSString stringWithFormat:@"%@(%d套)", roomDetailNetRespondBean.title, numberOfRoomsInteger];
  }
  [_roomTitleLabel setText:roomTitleString];
  [_roomAddressLabel setText:roomDetailNetRespondBean.address];
  NSString *roomNumberString = [NSString stringWithFormat:@"房间编号: %@", [roomDetailNetRespondBean.number stringValue]];
  [_roomNumberLabel setText:roomNumberString];
  NSString *roomScheduledCountString = [NSString stringWithFormat:@"曾被预订: %@ 晚", roomDetailNetRespondBean.scheduled];
  [_roomScheduledCountLabel setText:roomScheduledCountString];
}


#pragma mark -
#pragma mark 方便构造
+(id)roomTitleForRoomDetailBasicInfoWithRoomDetailNetRespondBean:(RoomDetailNetRespondBean *)roomDetailNetRespondBean {
  NSArray *nibObjects = [[self nib] instantiateWithOwner:nil options:nil];
  RoomTitleForRoomDetailBasicInfo *roomTitleForRoomDetailBasicInfo = [nibObjects objectAtIndex:0];
  [roomTitleForRoomDetailBasicInfo initUseRoomDetailNetRespondBean:roomDetailNetRespondBean];
  return roomTitleForRoomDetailBasicInfo;
}

@end
