//
//  HelpTypeTabhostBar.m
//  airizu
//
//  Created by 唐志华 on 13-2-7.
//
//

#import "HelpTypeTabhostBar.h"
#import "CustomControlDelegate.h"

@implementation HelpTypeTabhostBar

- (void)dealloc {
  // UI
  [_button1 release];
  [_button2 release];
  [_button3 release];
  [_button4 release];
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

-(void)setFocusButtonUI:(UIButton *)button {
  NSString *imageNameString = @"tab_icon_for_help_activity.png";
  [button setBackgroundImage:[UIImage imageNamed:imageNameString]
                    forState:UIControlStateNormal];
  [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
  
  //
  [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
}

-(void)setNormalButtonUI:(UIButton *)button {
  [button setBackgroundImage:nil forState:UIControlStateNormal];
  [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
  
  //
  [button setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
}

- (IBAction)buttonOnClickListener:(UIButton *)sender {
  if (_selectedItem == sender.tag) {
    // 用户点选了同一 tab 项
    return;
  }
  _selectedItem = sender.tag;
  
  NSArray *subviews = self.subviews;
  for (id subview in subviews) {
    if ([subview isKindOfClass:[UIButton class]]) {
      if (sender == subview) {
        // 当前被选中的 item button
        [self setFocusButtonUI:sender];
      } else {
        // 那些未被选中的按钮
        [self setNormalButtonUI:subview];
      }
    }
  }
  
  if ([_delegate conformsToProtocol:@protocol(CustomControlDelegate)]) {
    if ([_delegate respondsToSelector:@selector(customControl:onAction:)]) {
      [_delegate customControl:self onAction:sender.tag];
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

+(id)helpTypeTabhostBarWithHelpNetRespondBean:(HelpNetRespondBean *)helpNetRespondBean {
  NSArray *nibObjects = [[self nib] instantiateWithOwner:nil options:nil];
  HelpTypeTabhostBar *helpTypeTabhostBar = [nibObjects objectAtIndex:0];
  
  //
  helpTypeTabhostBar.selectedItem = -1;
  //
  NSArray *subviews = helpTypeTabhostBar.subviews;
  for (id subview in subviews) {
    if ([subview isKindOfClass:[UIButton class]]) {
      if (((UIButton *)subview).tag == 0) {
        [helpTypeTabhostBar buttonOnClickListener:subview];
      }
    }
  }
  
  return helpTypeTabhostBar;
}

@end
