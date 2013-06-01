//
//  UsePromotionActivity.m
//  airizu
//
//  Created by 唐志华 on 13-2-11.
//
//

#import "UsePromotionActivity.h"

#import "TitleBar.h"

#import "RoomDetailDatabaseFieldsConstant.h"
#import "RoomDetailNetRequestBean.h"
#import "RoomDetailNetRespondBean.h"


#import "FreeBookNetRequestBean.h"
#import "FreeBookNetRespondBean.h"


#import "NSDictionary+Helper.h"
#import "NSObject+DeepCopyingSupport.h"

#import "PointsToOffsetControl.h"
#import "PromoCodeDiscountControl.h"











static const NSString *const TAG = @"<UsePromotionActivity>";



NSString *const kIntentExtraTagForUsePromotionActivity_FreeBookNetRequestBeanForUnusedPromotions = @"FreeBookNetRequestBeanForUnusedPromotions";
NSString *const kIntentExtraTagForUsePromotionActivity_FreeBookNetRespondBeanForUnusedPromotions = @"FreeBookNetRespondBeanForUnusedPromotions";

NSString *const kIntentExtraTagForUsePromotionActivity_FreeBookNetRequestBeanForLatest = @"FreeBookNetRequestBeanForLatest";
NSString *const kIntentExtraTagForUsePromotionActivity_FreeBookNetRespondBeanForLatest = @"FreeBookNetRespondBeanForLatest";

// 用户不想使用优惠
NSString *const kUsePromotionActivity_NotUsePromotions = @"NotUsePromotions";











@interface UsePromotionActivity ()
///
@property (nonatomic, assign) BOOL isIncomingIntentValid;

@property (nonatomic, assign) TitleBar *titleBar;

// 入参
@property (nonatomic, retain) FreeBookNetRequestBean *freeBookNetRequestBeanForUnusedPromotions;
@property (nonatomic, retain) FreeBookNetRespondBean *freeBookNetRespondBeanForUnusedPromotions;

//
@property (nonatomic, retain) FreeBookNetRequestBean *freeBookNetRequestBeanForLatest;
@property (nonatomic, retain) FreeBookNetRespondBean *freeBookNetRespondBeanForLatest;

//
@property (nonatomic, assign) NSInteger netRequestIndexForFreebook;


///
// 订单总额
@property (nonatomic, assign) NSInteger orderTotalPriceInteger;
// 预付定金
@property (nonatomic, assign) NSInteger downPaymentInteger;
// 用户积分
@property (nonatomic, assign) NSInteger linePaymentInteger;
// 当前积分可以兑换的金钱额度
@property (nonatomic, assign) NSInteger moneyWithAvailabelPointInteger;

// 用户所选择的优惠方式
@property (nonatomic, assign) VoucherMethodEnum voucherMethodEnum;

// 正在使用的优惠控件
@property (nonatomic, assign) id promotionControl;

//
@property (nonatomic, copy) NSString *titleForUpdateOrderInfoAlert;

@end










@implementation UsePromotionActivity

//
typedef NS_ENUM(NSInteger, NetRequestTagEnum) {
  // 更新订单信息
  kNetRequestTagEnum_UpdateOrderInfo = 0,
  // 测试订单有效性
  kNetRequestTagEnum_TestOrderValidity
};

typedef NS_ENUM(NSInteger, AlertType) {
  // 测试订单有效性
  kAlertType_TestOrderIsValid = 0,
  // 更新订单信息
  kAlertType_UpdateOrderInfo
};

- (void)dealloc {
  
  ///
  [_freeBookNetRequestBeanForUnusedPromotions release];
  [_freeBookNetRespondBeanForUnusedPromotions release];
  //
  [_freeBookNetRequestBeanForLatest release];
  [_freeBookNetRespondBeanForLatest release];
  
  /// UI
  [_titleBarPlaceholder release];
  [_orderTotalPriceLabel release];
  [_linePaymentLabel release];
  [_downPaymentLabel release];
  [_promotionControlLayout release];
  [_okButton release];
  [_bodyLayout release];
  [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  if ([DeviceInformation isIPhone5]) {
    // 这里决不能设成 autorelease 的, 网上的代码就是 autorelease的, 4.3系统会崩溃, 因为被自动释放了
    self = [super initWithNibName:@"UsePromotionActivity_iphone5" bundle:nibBundleOrNil];
  } else {
    self = [super initWithNibName:@"UsePromotionActivity" bundle:nibBundleOrNil];
  }
  if (self) {
    // Custom initialization
    
    //
    _isIncomingIntentValid = NO;
    
    
    
    
    
    // Custom initialization
    _netRequestIndexForFreebook = IDLE_NETWORK_REQUEST_ID;
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  // Do any additional setup after loading the view from its nib.
  
  [self initTitleBar];
  
  if (_isIncomingIntentValid) {
    
    // 更新订单价钱信息
    [self updateOrderPriceUseFreeBookNetRespondBean:_freeBookNetRespondBeanForUnusedPromotions];
    
    // 显示用户当前可以使用的优惠方式
    [self showCanBeUsePromotionType];
  } else {
    
    // 加载 "内部数据传递错误时的UI, 并且隐藏 bodyLayout"
    [ToolsFunctionForThisProgect loadIncomingIntentValidUIWithSuperView:self.view andHideBodyLayout:_bodyLayout];
    
  }
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
  
  ///
  self.titleBar = nil;
  self.promotionControl = nil;
  
  
  ///
  [self setTitleBarPlaceholder:nil];
  [self setOrderTotalPriceLabel:nil];
  [self setLinePaymentLabel:nil];
  [self setDownPaymentLabel:nil];
  [self setPromotionControlLayout:nil];
  [self setOkButton:nil];
  [self setBodyLayout:nil];
  [super viewDidUnload];
}

/// 测试用户填写的优惠条件是否完整, 如果不完整会返回 错误信息, 也就是 errorMessage 如果为 empty 就证明用户填写的信息完整
-(NSString *)testPromotionsToFillInIsCompleteAndReturnErrorMessage{
  NSString *errorMessage = nil;
  
  switch (_voucherMethodEnum) {
    case kVoucherMethodEnum_VipPromotions:{// VIP优惠
      // 暂时不支持
    }break;
      
    case kVoucherMethodEnum_OrdinaryCoupons:{// 普通优惠卷
      PromoCodeDiscountControl *promoCodeDiscountControl = _promotionControl;
      if ([promoCodeDiscountControl isKindOfClass:[PromoCodeDiscountControl class]]) {
        if ([NSString isEmpty:promoCodeDiscountControl.promoCode]) {
          errorMessage = @"优惠码不能为空.";
        }
      }
      
    }break;
      
    case kVoucherMethodEnum_CashVolume:{// 现金卷
      // 暂时不支持
    }break;
      
    case kVoucherMethodEnum_UsePointsToOffset:{// 积分冲抵
      PointsToOffsetControl *pointsToOffsetControl = _promotionControl;
      if ([pointsToOffsetControl isKindOfClass:[PointsToOffsetControl class]]) {
        
      }
    }break;
      
    default:
      break;
  }
  
  return errorMessage;
}

- (IBAction)okButtonOnClickListener:(id)sender {
  
  NSString *errorMessageForPromotionInfoIsIncomplete
  = [self testPromotionsToFillInIsCompleteAndReturnErrorMessage];
  if (![NSString isEmpty:errorMessageForPromotionInfoIsIncomplete]) {
    
    [SVProgressHUD showErrorWithStatus:errorMessageForPromotionInfoIsIncomplete];
    return;
  }
  
  if (IDLE_NETWORK_REQUEST_ID == _netRequestIndexForFreebook) {
    _netRequestIndexForFreebook = [self requestOrderFreebookWithNetRequestEvent:kNetRequestTagEnum_TestOrderValidity];
    if (_netRequestIndexForFreebook != IDLE_NETWORK_REQUEST_ID) {
      [SVProgressHUD showWithStatus:@"检测优惠是否有效..." maskType:SVProgressHUDMaskTypeBlack];
    }
  }
  
}


#pragma mark -
#pragma mark Activity 生命周期

-(BOOL)parseIncomingIntent:(Intent *)intent {
  do {
    if (intent == nil) {
      break;
    }
    
    if (![intent.extras containsKey:kIntentExtraTagForUsePromotionActivity_FreeBookNetRequestBeanForUnusedPromotions]) {
      NSAssert(NO, @"has not FreeBookNetRequestBeanForUnusedPromotions in incoming");
      break;
    }
    
    if (![intent.extras containsKey:kIntentExtraTagForUsePromotionActivity_FreeBookNetRespondBeanForUnusedPromotions]) {
      NSAssert(NO, @"has not FreeBookNetRespondBeanForUnusedPromotions in incoming");
      break;
    }
    
    if (![intent.extras containsKey:kIntentExtraTagForUsePromotionActivity_FreeBookNetRequestBeanForLatest]) {
      NSAssert(NO, @"has not FreeBookNetRequestBeanForLatest in incoming");
      break;
    }
    
    if (![intent.extras containsKey:kIntentExtraTagForUsePromotionActivity_FreeBookNetRespondBeanForLatest]) {
      NSAssert(NO, @"has not FreeBookNetRespondBeanForLatest in incoming");
      break;
    }
    
    //
    id freeBookNetRequestBeanForUnusedPromotions
    = [intent.extras objectForKey:kIntentExtraTagForUsePromotionActivity_FreeBookNetRequestBeanForUnusedPromotions];
    id freeBookNetRespondBeanForUnusedPromotions
    = [intent.extras objectForKey:kIntentExtraTagForUsePromotionActivity_FreeBookNetRespondBeanForUnusedPromotions];
    id freeBookNetRequestBeanForLatest
    = [intent.extras objectForKey:kIntentExtraTagForUsePromotionActivity_FreeBookNetRequestBeanForLatest];
    id freeBookNetRespondBeanForLatest
    = [intent.extras objectForKey:kIntentExtraTagForUsePromotionActivity_FreeBookNetRespondBeanForLatest];
    
    if (![freeBookNetRequestBeanForUnusedPromotions conformsToProtocol:@protocol(NSCoding)]
        || ![freeBookNetRespondBeanForUnusedPromotions conformsToProtocol:@protocol(NSCoding)]
        || ![freeBookNetRequestBeanForLatest conformsToProtocol:@protocol(NSCoding)]
        || ![freeBookNetRespondBeanForLatest conformsToProtocol:@protocol(NSCoding)]) {
      
      // 异常
      NSAssert(NO, @"入参 freeBookNetRequestBean or freeBookNetRespondBean 没有实现 NSCoding 协议");
      break;
    }
    
    _freeBookNetRequestBeanForUnusedPromotions = [freeBookNetRequestBeanForUnusedPromotions deepCopy];
    _freeBookNetRespondBeanForUnusedPromotions = [freeBookNetRespondBeanForUnusedPromotions deepCopy];
    _freeBookNetRequestBeanForLatest = [freeBookNetRequestBeanForLatest deepCopy];
    _freeBookNetRespondBeanForLatest = [freeBookNetRespondBeanForLatest deepCopy];
    
    // 订单总额
    _orderTotalPriceInteger = [_freeBookNetRespondBeanForUnusedPromotions.totalPrice integerValue];
    // 预付定金
    _downPaymentInteger = [_freeBookNetRespondBeanForUnusedPromotions.advancedDeposit integerValue];
    // 用户积分
    _linePaymentInteger = [_freeBookNetRespondBeanForUnusedPromotions.availablePoint integerValue];
    // 当前积分可以兑换的金钱额度
    _moneyWithAvailabelPointInteger = [_freeBookNetRespondBeanForUnusedPromotions.availablePoint integerValue] / 800;
    
    // 一切OK
    return YES;
  } while (false);
  
  // 出现问题
  
  return NO;
}

-(void)onCreate:(Intent *)intent {
  PRPLog(@"%@ --> onCreate ", TAG);
  
  self.isIncomingIntentValid = [self parseIncomingIntent:intent];
}

-(void)onPause {
  PRPLog(@"%@ --> onPause ", TAG);
  
  [SVProgressHUD dismiss];
  
  [[DomainProtocolNetHelperSingleton sharedInstance] cancelNetRequestByRequestIndex:_netRequestIndexForFreebook];
  _netRequestIndexForFreebook = IDLE_NETWORK_REQUEST_ID;
}

-(void)onResume {
  PRPLog(@"%@ --> onResume ", TAG);
}

#pragma mark -
#pragma mark 初始化UI
//
- (void) initTitleBar {
  TitleBar *titleBar = [TitleBar titleBar];
  titleBar.delegate = self;
  [titleBar setTitleByString:@"使用优惠"];
  // "返回按钮"
  [titleBar hideLeftButton:NO];
  //
  [self.titleBarPlaceholder addSubview:titleBar];
  
  self.titleBar = titleBar;
}

-(void)updateOrderPriceUseFreeBookNetRespondBean:(FreeBookNetRespondBean *)freeBookNetRespondBean{
  
  // 订单总额
  _orderTotalPriceLabel.text
  = [NSString stringWithFormat:@"¥%d", [freeBookNetRespondBean.totalPrice integerValue]];
  
  // 预付订金
  _downPaymentLabel.text
  = [NSString stringWithFormat:@"¥%d", [freeBookNetRespondBean.advancedDeposit integerValue]];
  
  // 线下支付
  _linePaymentLabel.text
  = [NSString stringWithFormat:@"¥%d", [freeBookNetRespondBean.underLinePaid integerValue]];
  
}

-(void)showCanBeUsePromotionType {
  
  NSString *pointsToOffset = nil;
  if (_moneyWithAvailabelPointInteger > 0
      && _downPaymentInteger > 8) { // 20130307 因为积分冲抵最少冲抵8元, 所以低于等于8元的订单, 不能使用 "积分冲抵"
    pointsToOffset = @"积分冲抵";
  }
  UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"请选择优惠方式"
                                                           delegate:self
                                                  cancelButtonTitle:@"不使用优惠"
                                             destructiveButtonTitle:pointsToOffset
                                                  otherButtonTitles:@"优惠码打折", nil];
	actionSheet.delegate = self;
	[actionSheet showInView:self.view];
	[actionSheet release];
}

-(void)loadPromotionControlByVoucherMethodEnum:(VoucherMethodEnum)voucherMethodEnum{
  
  self.voucherMethodEnum = voucherMethodEnum;
  if (_freeBookNetRequestBeanForLatest.voucherMethod != voucherMethodEnum) {
    // 用户更改了优惠方式
    self.freeBookNetRequestBeanForLatest = [[_freeBookNetRequestBeanForUnusedPromotions deepCopy] autorelease];
    
    _freeBookNetRequestBeanForLatest.voucherMethod = voucherMethodEnum;
  } else {
    // 用户没有更改优惠方式, 要恢复上一次的操作结果
    [self updateOrderPriceUseFreeBookNetRespondBean:_freeBookNetRespondBeanForLatest];
  }
  
  switch (voucherMethodEnum) {
    case kVoucherMethodEnum_VipPromotions:{// VIP优惠
      // 暂时不支持
    }break;
      
    case kVoucherMethodEnum_OrdinaryCoupons:{// 普通优惠卷
      PromoCodeDiscountControl *promoCodeDiscountControl = [PromoCodeDiscountControl promoCodeDiscountControlWithPromoCode:_freeBookNetRequestBeanForLatest.iVoucherCode];
      promoCodeDiscountControl.delegate = self;
      [_promotionControlLayout addSubview:promoCodeDiscountControl];
      
      self.promotionControl = promoCodeDiscountControl;
    }break;
      
    case kVoucherMethodEnum_CashVolume:{// 现金卷
      // 暂时不支持
    }break;
      
    case kVoucherMethodEnum_UsePointsToOffset:{// 积分冲抵
      PointsToOffsetControl *pointsToOffsetControl
      = [PointsToOffsetControl pointsToOffsetControlWithFreeBookNetRespondBeanForUnusedPromotions:_freeBookNetRespondBeanForUnusedPromotions moneyForLatest:_freeBookNetRequestBeanForLatest.pointNum delegate:self];
      [_promotionControlLayout addSubview:pointsToOffsetControl];
      
      self.promotionControl = pointsToOffsetControl;
    }break;
      
    default:
      break;
  }
  
}

-(void)gotoFreebookConfirmOrderInfoActivity{
  Intent *data = [Intent intent];
  [data.extras setObject:_freeBookNetRequestBeanForLatest forKey:kIntentExtraTagForUsePromotionActivity_FreeBookNetRequestBeanForLatest];
  [data.extras setObject:_freeBookNetRespondBeanForLatest forKey:kIntentExtraTagForUsePromotionActivity_FreeBookNetRespondBeanForLatest];
  [self setResult:kActivityResultCode_RESULT_OK data:data];
  [self finish];
}

#pragma mark -
#pragma mark 实现 CustomControlDelegate 接口
-(void)customControl:(id)control onAction:(NSUInteger)action {
  
  if ([control isKindOfClass:[TitleBar class]]) {
    switch (action) {
        
      case kTitleBarActionEnum_LeftButtonClicked:{// "返回 按钮"
        [self finish];
      }break;
        
      default:
        break;
    }
  } else if ([control isKindOfClass:[PromoCodeDiscountControl class]]) {
    if (kPromoCodeDiscountControlActionEnum_UpdatePromoCode == action) {
      _freeBookNetRequestBeanForLatest.iVoucherCode = ((PromoCodeDiscountControl *)control).promoCode;
      
      
      if (_netRequestIndexForFreebook == IDLE_NETWORK_REQUEST_ID) {
        
        _netRequestIndexForFreebook = [self requestOrderFreebookWithNetRequestEvent:kNetRequestTagEnum_UpdateOrderInfo];
        if (_netRequestIndexForFreebook != IDLE_NETWORK_REQUEST_ID) {
          self.titleForUpdateOrderInfoAlert = @"优惠码有效";
          [SVProgressHUD showWithStatus:@"验证优惠码中..." maskType:SVProgressHUDMaskTypeBlack];
        }
      }
      
    }
  }
}

#pragma mark -
#pragma mark 实现 UIActionSheetDelegate 接口 (这里只为拨打客服电话服务)
-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
  
  
	if (buttonIndex == actionSheet.cancelButtonIndex) {
    
    // 用户选择不使用优惠
    Intent *data = [Intent intent];
    [data.extras setObject:[NSNull null] forKey:kUsePromotionActivity_NotUsePromotions];
    [self setResult:kActivityResultCode_RESULT_OK data:data];
    [self finish];
    return;
    
  } else if (buttonIndex == actionSheet.destructiveButtonIndex) {
    
    // 使用 "积分冲抵"
    _voucherMethodEnum = kVoucherMethodEnum_UsePointsToOffset;
    
  } else if (buttonIndex == actionSheet.firstOtherButtonIndex) {
    
    // 使用 "优惠码打折"
    _voucherMethodEnum = kVoucherMethodEnum_OrdinaryCoupons;
    
  } else if (buttonIndex == actionSheet.firstOtherButtonIndex + 1) {
    
    
  }
  
  [self loadPromotionControlByVoucherMethodEnum:_voucherMethodEnum];
}

#pragma mark -
#pragma mark 实现 PointsToOffsetControlDelegate 接口
- (void)sliderDidChange:(PointsToOffsetControl *)sender {
  NSInteger valueInteger = sender.value;
  // 订单总额
  _orderTotalPriceLabel.text
  = [NSString stringWithFormat:@"¥%d", _orderTotalPriceInteger - valueInteger];
  
  // 预付订金
  _downPaymentLabel.text
  = [NSString stringWithFormat:@"¥%d", _downPaymentInteger - valueInteger];
  
  // 更新 "要冲抵的积分"
  _freeBookNetRequestBeanForLatest.pointNum = [NSString stringWithFormat:@"%d", valueInteger];
}

#pragma mark -
#pragma mark 实现 IDomainNetRespondCallback 接口

-(NSInteger)requestOrderFreebookWithNetRequestEvent:(NSInteger)netRequestEvent {
  
  NSInteger netRequestIndex
  = [[DomainProtocolNetHelperSingleton sharedInstance] requestDomainProtocolWithContext:self
                                                                   andRequestDomainBean:_freeBookNetRequestBeanForLatest
                                                                        andRequestEvent:netRequestEvent
                                                                     andRespondDelegate:self];
  return netRequestIndex;
}


typedef enum {
  // 显示网络访问错误时的提示信息
  kHandlerMsgTypeEnum_ShowNetErrorMessage = 0,
  // 更新 "订单信息" 成功
  kHandlerMsgTypeEnum_UpdateOrderInfoSuccessful,
  // 测试 "订单有效性" 成功
  kHandlerMsgTypeEnum_TestOrderValiditySuccessful
} HandlerMsgTypeEnum;

typedef enum {
  //
  kHandlerExtraDataTypeEnum_NetRequestTag = 0,
  //
  kHandlerExtraDataTypeEnum_NetErrorMessage
} HandlerExtraDataTypeEnum;

- (void) handleMessage:(Message *) msg {
  
  switch (msg.what) {
      
    case kHandlerMsgTypeEnum_ShowNetErrorMessage:{
      
      NSString *netErrorMessageString
      = [msg.data objectForKey:[NSNumber numberWithUnsignedInteger:kHandlerExtraDataTypeEnum_NetErrorMessage]];
      [SVProgressHUD showErrorWithStatus:netErrorMessageString];
      NSNumber *netRequestTag
      = [msg.data objectForKey:[NSNumber numberWithUnsignedInteger:kHandlerExtraDataTypeEnum_NetRequestTag]];
      if ([netRequestTag integerValue] == kNetRequestTagEnum_UpdateOrderInfo) {
        [self updateOrderPriceUseFreeBookNetRespondBean:_freeBookNetRespondBeanForUnusedPromotions];
      }
    }break;
      
    case kHandlerMsgTypeEnum_UpdateOrderInfoSuccessful:{
      
      [SVProgressHUD dismiss];
      
      [self updateOrderPriceUseFreeBookNetRespondBean:_freeBookNetRespondBeanForLatest];
      
      UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                          message:_titleForUpdateOrderInfoAlert
                                                         delegate:self
                                                cancelButtonTitle:@"确定"
                                                otherButtonTitles:nil];
      alertView.tag = kAlertType_UpdateOrderInfo;
      [alertView show];
      [alertView release];
    }break;
      
    case kHandlerMsgTypeEnum_TestOrderValiditySuccessful:{
      
      [SVProgressHUD dismiss];
      
      UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                          message:@"使用优惠成功"
                                                         delegate:self
                                                cancelButtonTitle:@"确定"
                                                otherButtonTitles:nil];
      alertView.tag = kAlertType_TestOrderIsValid;
      [alertView show];
      [alertView release];
    }break;
      
    default:
      break;
  }
}

//
- (void) clearNetRequestIndexByRequestEvent:(NSUInteger) requestEvent {
  if (kNetRequestTagEnum_UpdateOrderInfo == requestEvent) {
    _netRequestIndexForFreebook = IDLE_NETWORK_REQUEST_ID;
  } else if (kNetRequestTagEnum_TestOrderValidity == requestEvent) {
    _netRequestIndexForFreebook = IDLE_NETWORK_REQUEST_ID;
  }
}

/**
 * 此方法处于非UI线程中
 *
 * @param requestEvent
 * @param errorBean
 * @param respondDomainBean
 */
- (void) domainNetRespondHandleInNonUIThread:(in NSUInteger) requestEvent
                                   errorBean:(in NetErrorBean *) errorBean
                           respondDomainBean:(in id) respondDomainBean {
  
  PRPLog(@"%@ -> domainNetRespondHandleInNonUIThread --- start ! ", TAG);
  [self clearNetRequestIndexByRequestEvent:requestEvent];
  
  if (errorBean.errorType != NET_ERROR_TYPE_SUCCESS) {
    Message *msg = [Message obtain];
    msg.what = kHandlerMsgTypeEnum_ShowNetErrorMessage;
    // 出现错误的 网络事件 tag
    [msg.data setObject:[NSNumber numberWithUnsignedInteger:requestEvent]
                 forKey:[NSNumber numberWithUnsignedInteger:kHandlerExtraDataTypeEnum_NetRequestTag]];
    // 该 网络事件, 对应的错误信息
    [msg.data setObject:errorBean.errorMessage
                 forKey:[NSNumber numberWithUnsignedInteger:kHandlerExtraDataTypeEnum_NetErrorMessage]];
    
    [self performSelectorOnMainThread:@selector(handleMessage:) withObject:msg waitUntilDone:NO];
    
    return;
  }
  
  if (requestEvent == kNetRequestTagEnum_UpdateOrderInfo) {
    
    self.freeBookNetRespondBeanForLatest = respondDomainBean;
    
    //
    Message *msg = [Message obtain];
    msg.what = kHandlerMsgTypeEnum_UpdateOrderInfoSuccessful;
    [self performSelectorOnMainThread:@selector(handleMessage:) withObject:msg waitUntilDone:NO];
    
    return;
    
  } else if (requestEvent == kNetRequestTagEnum_TestOrderValidity) {
    
    self.freeBookNetRespondBeanForLatest = respondDomainBean;
    
    //
    Message *msg = [Message obtain];
    msg.what = kHandlerMsgTypeEnum_TestOrderValiditySuccessful;
    [self performSelectorOnMainThread:@selector(handleMessage:) withObject:msg waitUntilDone:NO];
    
    return;
    
  }
}

#pragma mark -
#pragma mark 实现 UIAlertViewDelegate 接口
// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
  
  switch (alertView.tag) {
    case kAlertType_UpdateOrderInfo:{
      
    }break;
     
    case kAlertType_TestOrderIsValid:{
      [self gotoFreebookConfirmOrderInfoActivity];
    }break;
      
    default:
      break;
  }
  
}
@end
