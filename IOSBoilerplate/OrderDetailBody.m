//
//  OrderDetailBody.m
//  airizu
//
//  Created by 唐志华 on 13-2-3.
//
//

#import "OrderDetailBody.h"

#import "OrderDetailNetRespondBean.h"

@interface OrderDetailBody ()
//
@property (nonatomic, assign) BOOL isNewOrder;
//
@property (nonatomic, assign) OrderDetailNetRespondBean *dataSource;
@end



@implementation OrderDetailBody


- (void)dealloc {
  
  // UI
  [_statusContentLabel release];
  [_functionButton1 release];
  [_hostInforLayout release];
  [_hostNameLabel release];
  [_hostPhoneLabel release];
  [_hostBackupPhoneLayout release];
  [_hostBackupPhoneLabel release];
  [_orderDetailLayout release];
  [_roomPhotoImageView release];
  [_roomTitleLabel release];
  [_roomAddressLabel release];
  [_orderIdLabel release];
  [_checkInDateLabel release];
  [_checkOutDateLabel release];
  [_guestNumberLabel release];
  [_pricePerNightLabel release];
  [_linePayLabel release];
  [_subPriceLabel release];
  [_functionButton2 release];
  [_hostPhoneLayout release];
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

- (IBAction)functionButton1OnClickListener:(id)sender {
  if ([_delegate conformsToProtocol:@protocol(CustomControlDelegate)]) {
    if ([_delegate respondsToSelector:@selector(customControl:onAction:)]) {
      if (_dataSource.orderStateEnum == kOrderStateEnum_WaitPay) {
        [_delegate customControl:self onAction:kOrderDetailBodyActionEnum_ToPayButtonClicked];
      } else if (_dataSource.orderStateEnum == kOrderStateEnum_WaitComment) {
        [_delegate customControl:self onAction:kOrderDetailBodyActionEnum_ToReviewButtonClicked];
      }
    }
  }
}

- (IBAction)hostPhoneOnClickListener:(id)sender {
  if ([_delegate conformsToProtocol:@protocol(CustomControlDelegate)]) {
    if ([_delegate respondsToSelector:@selector(customControl:onAction:)]) {
      [_delegate customControl:self onAction:kOrderDetailBodyActionEnum_HostPhoneButtonClicked];
    }
  }
}


- (IBAction)hostBackupPhoneOnClickListener:(id)sender {
  if ([_delegate conformsToProtocol:@protocol(CustomControlDelegate)]) {
    if ([_delegate respondsToSelector:@selector(customControl:onAction:)]) {
      [_delegate customControl:self onAction:kOrderDetailBodyActionEnum_HostBackupPhoneButtonClicked];
    }
  }
}

- (IBAction)gotoRoomDetailActivityButtonOnClickListener:(id)sender {
  if ([_delegate conformsToProtocol:@protocol(CustomControlDelegate)]) {
    if ([_delegate respondsToSelector:@selector(customControl:onAction:)]) {
      [_delegate customControl:self onAction:kOrderDetailBodyActionEnum_ToRoomDetailButtonClicked];
    }
  }
  
}


- (IBAction)functionButton2OnClickListener:(id)sender {
  if ([_delegate conformsToProtocol:@protocol(CustomControlDelegate)]) {
    if ([_delegate respondsToSelector:@selector(customControl:onAction:)]) {
      if (_isNewOrder) {
        [_delegate customControl:self onAction:kOrderDetailBodyActionEnum_ManageOrderButtonClicked];
      } else {
        [_delegate customControl:self onAction:kOrderDetailBodyActionEnum_CancelOrderButtonClicked];
      }
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

+(id)orderDetailBodyWithOrderDetailNetRespondBean:(OrderDetailNetRespondBean *)orderDetailNetRespondBean isNewOrder:(BOOL)isNewOrder {
  
  NSArray *nibObjects = [[self nib] instantiateWithOwner:nil options:nil];
  OrderDetailBody *orderDetailBody = [nibObjects objectAtIndex:0];
  orderDetailBody.isNewOrder = isNewOrder;
  orderDetailBody.dataSource = orderDetailNetRespondBean;
  [orderDetailBody initUI];
  return orderDetailBody;
}


-(void)initUI {
  
  CGRect functionButton1Frame = _functionButton1.frame;
  CGRect hostInforLayoutFrame = _hostInforLayout.frame;
  CGRect orderDetailLayoutFrame = _orderDetailLayout.frame;
  CGRect functionButton2Frame = _functionButton2.frame;
  
  switch (_dataSource.orderStateEnum) {
      
    case kOrderStateEnum_WaitConfirm:{// "待确认"
      _functionButton1.hidden = YES;
      _hostInforLayout.hidden = YES;
      _orderDetailLayout.frame
      = CGRectMake(CGRectGetMinX(_orderDetailLayout.frame),
                   CGRectGetMinY(_functionButton1.frame),
                   CGRectGetWidth(_orderDetailLayout.frame),
                   CGRectGetHeight(_orderDetailLayout.frame));
      if (_isNewOrder) {
        [_functionButton2 setTitle:@"管理订单" forState:UIControlStateNormal];
      } else {
        [_functionButton2 setTitle:@"取消订单" forState:UIControlStateNormal];
      }
      _functionButton2.frame
      = CGRectMake(CGRectGetMinX(_functionButton2.frame),
                   CGRectGetMinY(_functionButton2.frame) - (CGRectGetHeight(_hostInforLayout.frame) + CGRectGetHeight(_functionButton1.frame) + 10*2),
                   CGRectGetWidth(_functionButton2.frame),
                   CGRectGetHeight(_functionButton2.frame));
      
      self.frame = CGRectMake(CGRectGetMinX(self.frame),
                              CGRectGetMinY(self.frame),
                              CGRectGetWidth(self.frame),
                              CGRectGetHeight(self.frame) - (CGRectGetHeight(_functionButton1.frame) + CGRectGetHeight(_hostInforLayout.frame) + 10*2));
    }break;
      
    case kOrderStateEnum_WaitPay:{// "待支付"
      [_functionButton1 setTitle:@"去付款" forState:UIControlStateNormal];
      _hostInforLayout.hidden = YES;
      _orderDetailLayout.frame
      = CGRectMake(CGRectGetMinX(_orderDetailLayout.frame),
                   CGRectGetMinY(_hostInforLayout.frame),
                   CGRectGetWidth(_orderDetailLayout.frame),
                   CGRectGetHeight(_orderDetailLayout.frame));
      
      if (_isNewOrder) {
        [_functionButton2 setTitle:@"管理订单" forState:UIControlStateNormal];
      } else {
        [_functionButton2 setTitle:@"取消订单" forState:UIControlStateNormal];
      }
      _functionButton2.frame
      = CGRectMake(CGRectGetMinX(_functionButton2.frame),
                   CGRectGetMinY(_functionButton2.frame) - (CGRectGetHeight(_hostInforLayout.frame) + 10),
                   CGRectGetWidth(_functionButton2.frame),
                   CGRectGetHeight(_functionButton2.frame));
      
      self.frame = CGRectMake(CGRectGetMinX(self.frame),
                              CGRectGetMinY(self.frame),
                              CGRectGetWidth(self.frame),
                              CGRectGetHeight(self.frame) - (CGRectGetHeight(_hostInforLayout.frame) + 10));
    }break;
      
    case kOrderStateEnum_WaitLive:{// "待入住"
      _functionButton1.hidden = YES;
      
      
      /// 房东信息区域需要被隐藏掉的总高度
      CGFloat hostInforLayoutNeedHideHeight = CGRectGetHeight(_hostInforLayout.frame);
      
      do {
  
        if ([NSString isEmpty:_dataSource.hostName]
            || ([NSString isEmpty:_dataSource.hostPhone] && [NSString isEmpty:_dataSource.hostBackupPhone])) {
          _hostInforLayout.hidden = YES;
          _hostInforLayout.frame = CGRectZero;
          break;
        }
        // 房东姓名
        _hostNameLabel.text = _dataSource.hostName;
        
        hostInforLayoutNeedHideHeight = 0;
                
        if ([NSString isEmpty:_dataSource.hostPhone]) {
          hostInforLayoutNeedHideHeight += CGRectGetHeight(_hostPhoneLayout.frame);
          
          _hostPhoneLayout.hidden = YES;
          
          _hostBackupPhoneLayout.frame = _hostPhoneLayout.frame;
        } else {
          // 房东电话
          _hostPhoneLabel.text = _dataSource.hostPhone;
        }
        
        if ([NSString isEmpty:_dataSource.hostBackupPhone]) {
          hostInforLayoutNeedHideHeight += CGRectGetHeight(_hostBackupPhoneLayout.frame);
          
          _hostBackupPhoneLayout.hidden = YES;
          
        } else {
          // 房东备用电话
          _hostBackupPhoneLabel.text = _dataSource.hostBackupPhone;
   
        }
        
      } while (NO);
      
      CGFloat hostInforLayoutRealHeight = CGRectGetHeight(_hostInforLayout.frame) - hostInforLayoutNeedHideHeight;
      _hostInforLayout.frame
      = CGRectMake(CGRectGetMinX(hostInforLayoutFrame),
                   CGRectGetMinY(functionButton1Frame),
                   CGRectGetWidth(hostInforLayoutFrame),
                   hostInforLayoutRealHeight);
      
      if (hostInforLayoutRealHeight == 0) {
        // 如果真实高度为0的话, 就证明要隐藏 房东联系信息布局, 但是要增加个 高度偏移度
        hostInforLayoutNeedHideHeight += 10;
      }
      _orderDetailLayout.frame
      = CGRectMake(CGRectGetMinX(orderDetailLayoutFrame),
                   CGRectGetMinY(orderDetailLayoutFrame) - (CGRectGetHeight(_functionButton1.frame) + 10) - hostInforLayoutNeedHideHeight,
                   CGRectGetWidth(orderDetailLayoutFrame),
                   CGRectGetHeight(orderDetailLayoutFrame));
      
      
      
      _functionButton2.hidden = YES;
      
      self.frame = CGRectMake(CGRectGetMinX(self.frame),
                              CGRectGetMinY(self.frame),
                              CGRectGetWidth(self.frame),
                              CGRectGetMaxY(_orderDetailLayout.frame));
    }break;
      
    case kOrderStateEnum_WaitComment:{// "待评价"
      [_functionButton1 setTitle:@"去评价" forState:UIControlStateNormal];
      _hostInforLayout.hidden = YES;
      _orderDetailLayout.frame
      = CGRectMake(CGRectGetMinX(_orderDetailLayout.frame),
                   CGRectGetMinY(_hostInforLayout.frame),
                   CGRectGetWidth(_orderDetailLayout.frame),
                   CGRectGetHeight(_orderDetailLayout.frame));
      
      _functionButton2.hidden = YES;
      
      self.frame = CGRectMake(CGRectGetMinX(self.frame),
                              CGRectGetMinY(self.frame),
                              CGRectGetWidth(self.frame),
                              CGRectGetMaxY(_orderDetailLayout.frame));
    }break;
      
    case kOrderStateEnum_HasEnded:{// "已完成"
      _functionButton1.hidden = YES;
      _hostInforLayout.hidden = YES;
      _orderDetailLayout.frame
      = CGRectMake(CGRectGetMinX(_orderDetailLayout.frame),
                   CGRectGetMinY(_functionButton1.frame),
                   CGRectGetWidth(_orderDetailLayout.frame),
                   CGRectGetHeight(_orderDetailLayout.frame));
      
      _functionButton2.hidden = YES;
      
      self.frame = CGRectMake(CGRectGetMinX(self.frame),
                              CGRectGetMinY(self.frame),
                              CGRectGetWidth(self.frame),
                              CGRectGetMaxY(_orderDetailLayout.frame));
    }break;
      
    default:
      break;
  }
  
  // 订单状态提示内容
  _statusContentLabel.text = _dataSource.statusContent;
  
  [_roomPhotoImageView setImageWithURL:[NSURL URLWithString:_dataSource.image] placeholderImage:[UIImage imageNamed:@"room_photo_placeholderImage_for_order_detail_activity.png"]];
  
  _roomTitleLabel.text = _dataSource.title;
  
  _roomAddressLabel.text = _dataSource.address;
  
  _orderIdLabel.text = [_dataSource.orderId stringValue];
  
  _checkInDateLabel.text = _dataSource.chenckInDate;
  
  _checkOutDateLabel.text = _dataSource.chenckOutDate;
  
  int guestNumber = [_dataSource.guestNum intValue];
  NSString *guestNumberString = @"";
  if (guestNumber >= 10) {
    guestNumberString = @"10人以上";
  } else {
    guestNumberString = [NSString stringWithFormat:@"%d 人", guestNumber];
  }
  _guestNumberLabel.text = guestNumberString;
  
  _pricePerNightLabel.text = [NSString stringWithFormat:@"¥%d", [_dataSource.pricePerNight intValue]];
  _linePayLabel.text = [NSString stringWithFormat:@"¥%d", [_dataSource.linePay intValue]];
  _subPriceLabel.text = [NSString stringWithFormat:@"¥%d", [_dataSource.subPrice intValue]];
}

@end
