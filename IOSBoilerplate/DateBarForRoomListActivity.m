//
//  DateBarForRoomListActivity.m
//  airizu
//
//  Created by 唐志华 on 12-12-28.
//
//

#import "DateBarForRoomListActivity.h"

static const NSString *const TAG = @"<DateBarForRoomListActivity>";

@implementation DateBarForRoomListActivity

- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    // Initialization code
    PRPLog(@"init %@ [0x%x]", TAG, [self hash]);
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

#pragma mark -
#pragma mark
+ (NSString *) nibName {
  return NSStringFromClass([self class]);
}

+ (UINib *) nib {
  NSBundle *classBundle = [NSBundle bundleForClass:[self class]];
  return [UINib nibWithNibName:[self nibName] bundle:classBundle];
}

+ (id) dateBar {
  NSArray *nibObjects = [[self nib] instantiateWithOwner:nil options:nil];
  return [nibObjects objectAtIndex:0];
}

- (void)dealloc {
  PRPLog(@"dealloc: %@ [0x%x]", TAG, [self hash]);
  
  [_checkinDateLabel release];
  [_checkoutDateLabel release];
  [_roomTotalLabel release];
  [super dealloc];
}

-(void)setCheckinDate:(NSString *)checkinDate {
  [_checkinDateLabel setText:checkinDate];
}
-(void)setCheckoutDate:(NSString *)checkoutDate {
  [_checkoutDateLabel setText:checkoutDate];
}
-(void)setRoomTotal:(NSString *)roomTotal {
  [_roomTotalLabel setText:roomTotal];
}
@end
