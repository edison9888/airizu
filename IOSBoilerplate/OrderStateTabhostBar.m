//
//  CustomSegmentedControl.m
//  airizu
//
//  Created by 唐志华 on 13-2-1.
//
//

#import "OrderStateTabhostBar.h"

@implementation OrderStateTabhostBar

- (void)dealloc {
  
  // UI
  [_waitConfirmButton release];
  [_waitPayButton release];
  [_waitLiveButton release];
  [_waitCommentButton release];
  [_hasEndedButton release];
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
  NSString *imageNameString = @"";
  if (kOrderStateEnum_WaitConfirm == button.tag) {
    imageNameString = @"tab_icon_left_focus_for_order_main_activity.png";
  } else if (kOrderStateEnum_HasEnded == button.tag) {
    imageNameString = @"tab_icon_right_focus_for_order_main_activity.png";
  } else {
    imageNameString = @"tab_icon_middle_focus_for_order_main_activity.png";
  }
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

+(id)orderStateTabhostBarWithDefaultOrderState:(OrderStateEnum)orderStateEnum {
  NSArray *nibObjects = [[self nib] instantiateWithOwner:nil options:nil];
  OrderStateTabhostBar *orderStateTabhostBar = [nibObjects objectAtIndex:0];
  orderStateTabhostBar.selectedItem = -1;
  
  orderStateTabhostBar.waitConfirmButton.tag = kOrderStateEnum_WaitConfirm; // "待确认"
  orderStateTabhostBar.waitPayButton.tag     = kOrderStateEnum_WaitPay;     // "待支付"
  orderStateTabhostBar.waitLiveButton.tag    = kOrderStateEnum_WaitLive;    // "待入住"
  orderStateTabhostBar.waitCommentButton.tag = kOrderStateEnum_WaitComment; // "待评价"
  orderStateTabhostBar.hasEndedButton.tag    = kOrderStateEnum_HasEnded;    // "已完成"
  
  NSArray *subviews = orderStateTabhostBar.subviews;
  for (id subview in subviews) {
    if ([subview isKindOfClass:[UIButton class]]) {
      if (((UIButton *)subview).tag == orderStateEnum) {
        [orderStateTabhostBar buttonOnClickListener:subview];
      }
    }
  }
  
  return orderStateTabhostBar;
}

@end






