//
//  OrderStateTitleBar.m
//  airizu
//
//  Created by 唐志华 on 13-2-3.
//
//

#import "OrderStateTitleBar.h"

#import "UIColor+ColorSchemes.h"

@implementation OrderStateTitleBar

- (void)dealloc {
  [_waitConfirmLabel release];
  [_waitPayLabel release];
  [_waitLiveLabel release];
  [_waitCommentLabel release];
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

+(id)orderStateTitleBar {
  NSArray *nibObjects = [[self nib] instantiateWithOwner:nil options:nil];
  OrderStateTitleBar *orderStateTitleBar = [nibObjects objectAtIndex:0];
  return orderStateTitleBar;
}

-(void)setOrderStateFocusItemByOrderState:(OrderStateEnum)orderStateEnum {
  
  _waitConfirmLabel.textColor = [UIColor lightGrayColor];
  _waitPayLabel.textColor = [UIColor lightGrayColor];
  _waitLiveLabel.textColor = [UIColor lightGrayColor];
  _waitCommentLabel.textColor = [UIColor lightGrayColor];
  
  switch (orderStateEnum) {
    case kOrderStateEnum_WaitConfirm:{// "待确认"
      _waitConfirmLabel.textColor = [UIColor colorForLabelOrangeText];
    }break;
    case kOrderStateEnum_WaitPay:{// "待支付"
      _waitPayLabel.textColor = [UIColor colorForLabelOrangeText];
    }break;
    case kOrderStateEnum_WaitLive:{// "待入住"
      _waitLiveLabel.textColor = [UIColor colorForLabelOrangeText];
    }break;
    case kOrderStateEnum_WaitComment:{// "待评价"
      _waitCommentLabel.textColor = [UIColor colorForLabelOrangeText];
    }break;
    default:{
      //self.frame = CGRectZero;
    }break;
  }
  
}

@end
