//
//  FreebookConfirmOrderInfoActivity.m
//  airizu
//
//  Created by 唐志华 on 13-1-31.
//
//

#import "FreebookConfirmOrderInfoActivity.h"

#import "TitleBar.h"

#import "OrderSubmitDatabaseFieldsConstant.h"
#import "OrderSubmitNetRequestBean.h"
#import "OrderSubmitNetRespondBean.h"

#import "FreeBookDatabaseFieldsConstant.h"
#import "FreeBookNetRequestBean.h"
#import "FreeBookNetRespondBean.h"

#import "LogonNetRespondBean.h"
#import "UserOrderDetailActivity.h"

#import "UsePromotionActivity.h"

#import "NSDictionary+Helper.h"
#import "NSObject+DeepCopyingSupport.h"

static const NSString *const TAG = @"<FreebookConfirmOrderInfoActivity>";

//
NSString *const kIntentExtraTagForFreebookConfirmOrderInfoActivity_FreeBookNetRequestBean = @"FreeBookNetRequestBean";
//
NSString *const kIntentExtraTagForFreebookConfirmOrderInfoActivity_FreeBookNetRespondBean = @"FreeBookNetRespondBean";









@interface FreebookConfirmOrderInfoActivity ()

///
@property (nonatomic, assign) BOOL isIncomingIntentValid;

@property (nonatomic, assign) TitleBar *titleBar;


// 入参
// 未使用优惠时的 FreeBookNetRequestBean 和 FreeBookNetRespondBean
@property (nonatomic, retain) FreeBookNetRequestBean *freeBookNetRequestBeanForUnusedPromotions;
@property (nonatomic, retain) FreeBookNetRespondBean *freeBookNetRespondBeanForUnusedPromotions;

//
@property (nonatomic, assign) NSInteger netRequestIndexForFreebook;
@property (nonatomic, assign) NSInteger netRequestIndexForOrderSubmit;

//
@property (nonatomic, retain) FreeBookNetRequestBean *freeBookNetRequestBeanForLatest;
@property (nonatomic, retain) FreeBookNetRespondBean *freeBookNetRespondBeanForLatest;


//
@property (nonatomic, retain) OrderSubmitNetRespondBean *orderSubmitNetRespondBean;


// 是否同意 "爱日租服务条款"
@property (nonatomic, assign) BOOL isAgreeProtocolForAirizu;
@end










@implementation FreebookConfirmOrderInfoActivity

#pragma mark -
#pragma mark 内部枚举

//
typedef NS_ENUM(NSInteger, NetRequestTagEnum) {
  // 2.20 订单预订
  kNetRequestTagEnum_OrderFreebook = 0,
  // 2.21 提交订单
  kNetRequestTagEnum_OrderSubmit
};

typedef NS_ENUM(NSInteger, IntentRequestCodeEnum) {
  // 跳转到 "使用优惠界面"
  kIntentRequestCodeEnum_ToUsePromotionActivity = 0
};


- (void)dealloc {
  
  //
  [_freeBookNetRequestBeanForUnusedPromotions release];
  [_freeBookNetRespondBeanForUnusedPromotions release];
  
  [_freeBookNetRequestBeanForLatest release];
  [_freeBookNetRespondBeanForLatest release];
  
  [_orderSubmitNetRespondBean release];
  
  // UI
  [_titleBarPlaceholder release];
  [_checkInDateLabel release];
  [_checkOutDateLabel release];
  [_occupancyLabel release];
  [_totalPriceLabel release];
  [_advancedDepositLabel release];
  [_underLinePaidLabel release];
  [_promotionMarkIconImageView release];
  [_usePromotionButton release];
  [_tenantNameLabel release];
  [_tenantPhoneLabel release];
  [_orderInfoConfirmCheckbox release];
  [_bodyLayout release];
  [super dealloc];
}

- (void)viewDidUnload {
  
  ///
  self.titleBar = nil;
  
  ///
  [self setTitleBarPlaceholder:nil];
  [self setCheckInDateLabel:nil];
  [self setCheckOutDateLabel:nil];
  [self setOccupancyLabel:nil];
  [self setTotalPriceLabel:nil];
  [self setAdvancedDepositLabel:nil];
  [self setUnderLinePaidLabel:nil];
  [self setPromotionMarkIconImageView:nil];
  [self setUsePromotionButton:nil];
  [self setTenantNameLabel:nil];
  [self setTenantPhoneLabel:nil];
  [self setOrderInfoConfirmCheckbox:nil];
  [self setBodyLayout:nil];
  [super viewDidUnload];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  if ([DeviceInformation isIPhone5]) {
    // 这里决不能设成 autorelease 的, 网上的代码就是 autorelease的, 4.3系统会崩溃, 因为被自动释放了
    self = [super initWithNibName:@"FreebookConfirmOrderInfoActivity_iphone5" bundle:nibBundleOrNil];
  } else {
    self = [super initWithNibName:@"FreebookConfirmOrderInfoActivity" bundle:nibBundleOrNil];
  }
  if (self) {
    // Custom initialization
    
    //
    _isIncomingIntentValid = NO;
    
    _netRequestIndexForFreebook = IDLE_NETWORK_REQUEST_ID;
    _netRequestIndexForOrderSubmit = IDLE_NETWORK_REQUEST_ID;
    
    _isAgreeProtocolForAirizu = YES;
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  // Do any additional setup after loading the view from its nib.
  
  // 初始化UI
  [self initTitleBar];
  
  if (_isIncomingIntentValid) {
    
    //
    [self initCheckInDateAndGuestNumber];
    
    //
    [self updateOrderPriceWithFreeBookNetRespondBean:_freeBookNetRespondBeanForUnusedPromotions];
    
    //
    [self initTenantNameAndPhoneNumber];
    
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



#pragma mark -
#pragma mark 控件点击监听方法

- (IBAction)usePromotionButtonOnClickListener:(id)sender {
  
  /// 每次传到使用优惠界面的数据都是未使用优惠前的状态
  Intent *intent = [Intent intentWithSpecificComponentClass:[UsePromotionActivity class]];
  [intent.extras setObject:_freeBookNetRequestBeanForLatest forKey:kIntentExtraTagForUsePromotionActivity_FreeBookNetRequestBeanForLatest];
  [intent.extras setObject:_freeBookNetRespondBeanForLatest forKey:kIntentExtraTagForUsePromotionActivity_FreeBookNetRespondBeanForLatest];
  [intent.extras setObject:_freeBookNetRequestBeanForUnusedPromotions forKey:kIntentExtraTagForUsePromotionActivity_FreeBookNetRequestBeanForUnusedPromotions];
  [intent.extras setObject:_freeBookNetRespondBeanForUnusedPromotions forKey:kIntentExtraTagForUsePromotionActivity_FreeBookNetRespondBeanForUnusedPromotions];
  [self startActivityForResult:intent requestCode:kIntentRequestCodeEnum_ToUsePromotionActivity];
}


- (IBAction)orderInfoConfirmCheckboxOnClickListener:(id)sender {
  // 更新UI
  [self updateOrderInfoConfirmCheckboxSelectedState];
}


- (IBAction)submitButtonOnClickListener:(id)sender {
  
  if (_netRequestIndexForOrderSubmit != IDLE_NETWORK_REQUEST_ID) {
    return;
  }
  
  NSString *errorMessageString = @"";
  do {
    
    if (!_isAgreeProtocolForAirizu) {
      errorMessageString = @"请您确认订单信息并同意爱日租服务条款";
      break;
    }
    
    _netRequestIndexForOrderSubmit = [self requestSubmitOrder];
    if (_netRequestIndexForOrderSubmit != IDLE_NETWORK_REQUEST_ID) {
      [SVProgressHUD showWithStatus:@"下单中..." maskType:SVProgressHUDMaskTypeBlack];
    }
    
    // 一切成功
    return;
  } while (NO);
  
  [SVProgressHUD showErrorWithStatus:errorMessageString];
}

#pragma mark -
#pragma mark Activity 生命周期

-(BOOL)parseIncomingIntent:(Intent *)intent {
  
  do {
    
    if (intent == nil) {
      break;
    }
    
    FreeBookNetRequestBean *freeBookNetRequestBeanForUnusedPromotionsTest = [intent.extras objectForKey:kIntentExtraTagForFreebookConfirmOrderInfoActivity_FreeBookNetRequestBean];
    if (![freeBookNetRequestBeanForUnusedPromotionsTest isKindOfClass:[FreeBookNetRequestBean class]]) {
      break;
    }
    
    FreeBookNetRespondBean *freeBookNetRespondBeanForUnusedPromotionsTest = [intent.extras objectForKey:kIntentExtraTagForFreebookConfirmOrderInfoActivity_FreeBookNetRespondBean];
    if (![freeBookNetRespondBeanForUnusedPromotionsTest isKindOfClass:[FreeBookNetRespondBean class]]) {
      break;
    }
    
    //
    self.freeBookNetRequestBeanForUnusedPromotions = freeBookNetRequestBeanForUnusedPromotionsTest;

    //
    self.freeBookNetRespondBeanForUnusedPromotions = freeBookNetRespondBeanForUnusedPromotionsTest;
   
    
    //
    self.freeBookNetRequestBeanForLatest = [[freeBookNetRequestBeanForUnusedPromotionsTest deepCopy] autorelease];
    self.freeBookNetRespondBeanForLatest = [[freeBookNetRespondBeanForUnusedPromotionsTest deepCopy] autorelease];
    
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
  
  [[DomainProtocolNetHelperSingleton sharedInstance] cancelAllNetRequestWithThisNetRespondDelegate:self];
  _netRequestIndexForFreebook = IDLE_NETWORK_REQUEST_ID;
  _netRequestIndexForOrderSubmit = IDLE_NETWORK_REQUEST_ID;
}

-(void)onResume {
  PRPLog(@"%@ --> onResume ", TAG);
  
}

- (void) onActivityResult:(int) requestCode
               resultCode:(int) resultCode
                     data:(Intent *) data {
  
  PRPLog(@"%@ onActivityResult", TAG);
  
  do {
    if (resultCode != kActivityResultCode_RESULT_OK) {
      break;
    }
    
    if (requestCode == kIntentRequestCodeEnum_ToUsePromotionActivity) {
      // 从 "使用界面" 返回到此的, 返回 "RESULT_OK", 证明用户使用了优惠手段, 在这里要重新进行免费预定测试
      [self onActivityResultProcessForUsePromotionWithReturnedData:data];
    }
    
  } while (false);
}


-(void)onActivityResultProcessForUsePromotionWithReturnedData:(Intent *)data {
  do {
    if (![data isKindOfClass:[Intent class]]) {
      break;
    }
    
    if ([data.extras containsKey:kUsePromotionActivity_NotUsePromotions]) {
      // 用户决定不使用优惠
      break;
    }
    
    /// 用户已经使用了优惠
    if (![data.extras containsKey:kIntentExtraTagForUsePromotionActivity_FreeBookNetRequestBeanForLatest]) {
      break;
    }
    if (![data.extras containsKey:kIntentExtraTagForUsePromotionActivity_FreeBookNetRespondBeanForLatest]) {
      break;
    }
    
    //
    self.freeBookNetRequestBeanForLatest = [data.extras objectForKey:kIntentExtraTagForUsePromotionActivity_FreeBookNetRequestBeanForLatest];
    self.freeBookNetRespondBeanForLatest = [data.extras objectForKey:kIntentExtraTagForUsePromotionActivity_FreeBookNetRespondBeanForLatest];
    
    // 认定用户使用了优惠
    [self updateUsePromotionMarkInfoByIsUsedPromotion:YES];
    
    return;
  } while (NO);
  
  // 认定用户没有使用优惠
  self.freeBookNetRequestBeanForLatest = [_freeBookNetRequestBeanForUnusedPromotions deepCopy];
  self.freeBookNetRespondBeanForLatest = [_freeBookNetRespondBeanForUnusedPromotions deepCopy];
  [self updateUsePromotionMarkInfoByIsUsedPromotion:NO];
  
}

#pragma mark -
#pragma mark 初始化UI
//
-(void)initTitleBar {
  TitleBar *titleBar = [TitleBar titleBar];
  titleBar.delegate = self;
  [titleBar setTitleByString:@"免费预订"];
  [titleBar hideLeftButton:NO];
  [self.titleBarPlaceholder addSubview:titleBar];
  
  self.titleBar = titleBar;
}

-(void)initCheckInDateAndGuestNumber {
  _checkInDateLabel.text = _freeBookNetRequestBeanForUnusedPromotions.checkInDate;
  _checkOutDateLabel.text = _freeBookNetRequestBeanForUnusedPromotions.checkOutDate;
  
  NSString *guestNumberUnitString = @"人";
  if ([_freeBookNetRequestBeanForUnusedPromotions.guestNum integerValue] >= 10) {
    guestNumberUnitString = @"人以上";
  }
  _occupancyLabel.text = [NSString stringWithFormat:@"%d%@", [_freeBookNetRequestBeanForUnusedPromotions.guestNum integerValue], guestNumberUnitString];
}

-(void)updateOrderPriceWithFreeBookNetRespondBean:(FreeBookNetRespondBean *)freeBookNetRespondBean{
  // "订单总额"
  _totalPriceLabel.text
  = [NSString stringWithFormat:@"¥%d", [freeBookNetRespondBean.totalPrice integerValue]];
  // "预付定金"
  _advancedDepositLabel.text
  = [NSString stringWithFormat:@"¥%d", [freeBookNetRespondBean.advancedDeposit integerValue]];
  // "线下支付"
  _underLinePaidLabel.text
  = [NSString stringWithFormat:@"¥%d", [freeBookNetRespondBean.underLinePaid integerValue]];
}

-(void)initTenantNameAndPhoneNumber {
  _tenantNameLabel.text = [GlobalDataCacheForMemorySingleton sharedInstance].logonNetRespondBean.userName;
  _tenantPhoneLabel.text = [GlobalDataCacheForMemorySingleton sharedInstance].usernameForLastSuccessfulLogon;
}

// 更新 "使用优惠标示" 相关的信息(icon图标/按钮标题)
-(void)updateUsePromotionMarkInfoByIsUsedPromotion:(BOOL)isUsedPromotion{
  if (isUsedPromotion) {
    _promotionMarkIconImageView.hidden = NO;
    [_usePromotionButton setTitle:@"修改优惠" forState:UIControlStateNormal];
    
    [self updateOrderPriceWithFreeBookNetRespondBean:_freeBookNetRespondBeanForLatest];
  } else {
    _promotionMarkIconImageView.hidden = YES;
    [_usePromotionButton setTitle:@"使用优惠" forState:UIControlStateNormal];
    
    [self updateOrderPriceWithFreeBookNetRespondBean:_freeBookNetRespondBeanForUnusedPromotions];
  }
  
}

-(void)updateOrderInfoConfirmCheckboxSelectedState {
  
  _isAgreeProtocolForAirizu = !_isAgreeProtocolForAirizu;
  
  if (_isAgreeProtocolForAirizu) {
    UIImage *imageForCheckboxSelected = [UIImage imageNamed:@"icon_selected_for_checkbox.png"];
    [_orderInfoConfirmCheckbox setImage:imageForCheckboxSelected forState:UIControlStateNormal];
  } else {
    UIImage *imageForCheckboxNoSelected = [UIImage imageNamed:@"icon_no_selected_for_checkbox.png"];
    [_orderInfoConfirmCheckbox setImage:imageForCheckboxNoSelected forState:UIControlStateNormal];
  }
}

#pragma mark -
#pragma mark 实现 CustomControlDelegate 接口
-(void)customControl:(id)control onAction:(NSUInteger)action {
  
  if ([control isKindOfClass:[TitleBar class]]) {
    
    switch (action) {
        
      case kTitleBarActionEnum_LeftButtonClicked:{
        [self finish];
      }break;
        
      default:
        break;
    }
    
  }
}

#pragma mark -
#pragma mark 实现 IDomainNetRespondCallback 接口

-(NSInteger)requestSubmitOrder {
  
  NSString *roomIdString = _freeBookNetRequestBeanForLatest.roomId;
  NSString *checkInDateString = _freeBookNetRequestBeanForLatest.checkInDate;
  NSString *checkOutDateString = _freeBookNetRequestBeanForLatest.checkOutDate;
  VoucherMethodEnum voucherMethod = _freeBookNetRequestBeanForLatest.voucherMethod;
  NSString *guestNumString = _freeBookNetRequestBeanForLatest.guestNum;
  NSString *checkinNameString = _tenantNameLabel.text;
  NSString *checkinPhoneString = _tenantPhoneLabel.text;
  
  OrderSubmitNetRequestBean *orderSubmitNetRequestBean
  = [OrderSubmitNetRequestBean orderSubmitNetRequestBeanWithRoomId:roomIdString
                                                       checkInDate:checkInDateString
                                                      checkOutDate:checkOutDateString
                                                     voucherMethod:voucherMethod
                                                          guestNum:guestNumString
                                                       checkinName:checkinNameString
                                                      checkinPhone:checkinPhoneString];
  switch (voucherMethod) {
    case kVoucherMethodEnum_DoNotUsePromotions:{// 不使用优惠
      
    }break;
    case kVoucherMethodEnum_VipPromotions:{// VIP优惠
      // 暂不支持
    }break;
    case kVoucherMethodEnum_OrdinaryCoupons:{// 普通优惠卷
      orderSubmitNetRequestBean.iVoucherCode = _freeBookNetRequestBeanForLatest.iVoucherCode;
    }break;
    case kVoucherMethodEnum_CashVolume:{ // 现金卷
      // 暂不支持
    }break;
    case kVoucherMethodEnum_UsePointsToOffset:{// 积分冲抵
      orderSubmitNetRequestBean.pointNum = _freeBookNetRequestBeanForLatest.pointNum;
    }break;
    default:
      break;
  }
  
  
  NSInteger netRequestIndex
  = [[DomainProtocolNetHelperSingleton sharedInstance] requestDomainProtocolWithContext:self
                                                                   andRequestDomainBean:orderSubmitNetRequestBean
                                                                        andRequestEvent:kNetRequestTagEnum_OrderSubmit
                                                                     andRespondDelegate:self];
  return netRequestIndex;
}


typedef enum {
  // 显示网络访问错误时的提示信息
  kHandlerMsgTypeEnum_ShowNetErrorMessage = 0,
  // 获取 "订单预订" 数据成功
  kHandlerMsgTypeEnum_GetOrderFreebookSuccessful,
  // 获取 "提交订单" 数据成功
  kHandlerMsgTypeEnum_GetOrderSubmitSuccessful
} HandlerMsgTypeEnum;

typedef enum {
  //
  kHandlerExtraDataTypeEnum_NetRequestTag = 0,
  //
  kHandlerExtraDataTypeEnum_NetErrorMessage,
  //
  kHandlerExtraDataTypeEnum_OrderSubmitNetRespondBean
} HandlerExtraDataTypeEnum;

- (void) handleMessage:(Message *) msg {
  
  switch (msg.what) {
      
    case kHandlerMsgTypeEnum_ShowNetErrorMessage:{
      
      NSString *netErrorMessageString
      = [msg.data objectForKey:[NSNumber numberWithUnsignedInteger:kHandlerExtraDataTypeEnum_NetErrorMessage]];
      [SVProgressHUD showErrorWithStatus:netErrorMessageString];
      
    }break;
      
    case kHandlerMsgTypeEnum_GetOrderSubmitSuccessful:{// 获取 "提交订单" 数据成功
      
      [SVProgressHUD dismiss];
      
      UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                          message:@"下单成功"
                                                         delegate:self
                                                cancelButtonTitle:@"确定"
                                                otherButtonTitles:nil];
      [alertView show];
      [alertView release];
    }break;
      
    default:
      break;
  }
}

//
- (void) clearNetRequestIndexByRequestEvent:(NSUInteger) requestEvent {
  if (kNetRequestTagEnum_OrderFreebook == requestEvent) {
    _netRequestIndexForFreebook = IDLE_NETWORK_REQUEST_ID;
  } else if (kNetRequestTagEnum_OrderSubmit == requestEvent) {
    _netRequestIndexForOrderSubmit = IDLE_NETWORK_REQUEST_ID;
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
  
  if (requestEvent == kNetRequestTagEnum_OrderSubmit) {// 2.21 提交订单
    self.orderSubmitNetRespondBean = respondDomainBean;
    PRPLog(@"%@ -> %@", TAG, _orderSubmitNetRespondBean);
    
    // 下单成功
    Message *msg = [Message obtain];
    msg.what = kHandlerMsgTypeEnum_GetOrderSubmitSuccessful;
    [self performSelectorOnMainThread:@selector(handleMessage:) withObject:msg waitUntilDone:NO];
    
    return;
    
  } else if (requestEvent == kNetRequestTagEnum_OrderFreebook) {// 2.20 订单预订
    
    self.freeBookNetRespondBeanForLatest = respondDomainBean;
    PRPLog(@"%@ -> %@", TAG, _freeBookNetRespondBeanForLatest);
    
    //
    Message *msg = [Message obtain];
    msg.what = kHandlerMsgTypeEnum_GetOrderFreebookSuccessful;
    [self performSelectorOnMainThread:@selector(handleMessage:) withObject:msg waitUntilDone:NO];
    
    return;
    
  }
}

#pragma mark -
#pragma mark 实现 UIAlertViewDelegate 接口
// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
  [self gotoUserOrderDetailActivity];
}

-(void)gotoUserOrderDetailActivity{
  Intent *intent = [Intent intentWithSpecificComponentClass:[UserOrderDetailActivity class]];
  [intent.extras setObject:_orderSubmitNetRespondBean.orderDetailNetRespondBean forKey:kIntentExtraTagForUserOrderDetailActivity_OrderDetailFromSubmitOrder];
  [self startActivity:intent];
}
@end
