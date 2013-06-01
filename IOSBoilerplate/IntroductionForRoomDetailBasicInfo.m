//
//  AdForRoomDetailBasicInfo.m
//  airizu
//
//  Created by 唐志华 on 13-1-28.
//
//

#import "IntroductionForRoomDetailBasicInfo.h"

#import "CustomControlDelegate.h"
#import "RoomDetailOfBasicInformationActivityContent.h"
#import "RoomDetailNetRespondBean.h"

@implementation IntroductionForRoomDetailBasicInfo

- (void)dealloc {
  
  [_introductionLabel release];
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

- (IBAction)phoneButtonOnClickListener:(id)sender {
  if ([_delegate conformsToProtocol:@protocol(CustomControlDelegate)]) {
    if ([_delegate respondsToSelector:@selector(customControl:onAction:)]) {
      [_delegate customControl:self onAction:kRoomDetailOfBasicInformationActivityContentActionEnum_CustomerServicePhoneButtonClicked];
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
  // 介绍
  [_introductionLabel setText:roomDetailNetRespondBean.introduction];
}

#pragma mark -
#pragma mark 方便构造
+(id)introductionForRoomDetailBasicInfoWithRoomDetailNetRespondBean:(RoomDetailNetRespondBean *)roomDetailNetRespondBean {
  NSArray *nibObjects = [[self nib] instantiateWithOwner:nil options:nil];
  IntroductionForRoomDetailBasicInfo *introductionForRoomDetailBasicInfo = [nibObjects objectAtIndex:0];
  [introductionForRoomDetailBasicInfo initUseRoomDetailNetRespondBean:roomDetailNetRespondBean];
  return introductionForRoomDetailBasicInfo;
}

@end
