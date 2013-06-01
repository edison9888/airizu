//
//  ToolBarForRoomListActivity.m
//  airizu
//
//  Created by 唐志华 on 12-12-27.
//
//

#import "ToolBarForRoomListActivity.h"

static const NSString *const TAG = @"<ToolBarForRoomListActivity>";

@implementation ToolBarForRoomListActivity

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

- (void)dealloc {
  PRPLog(@"dealloc: %@ [0x%x]", TAG, [self hash]);
  
  [_filterButton release];
  [_sortButton release];
  [_mapButton release];
  [super dealloc];
}

#pragma mark -
#pragma mark
+ (NSString *) nibName {
  return NSStringFromClass([self class]);
}

+ (UINib *) nib {
  NSBundle *classBundle = [NSBundle bundleForClass:[self class]];
  return [UINib nibWithNibName:[self nibName] bundle:classBundle];
}

+ (id) toolBar {
  NSArray *nibObjects = [[self nib] instantiateWithOwner:nil options:nil];
  return [nibObjects objectAtIndex:0];
}
@end
