//
//  UserOrderDetailActivity.m
//  airizu
//
//  Created by 唐志华 on 13-2-3.
//
//

#import "UserOrderDetailActivity.h"

#import "TitleBar.h"
#import "PreloadingUIToolBar.h"
#import "OrderStateTitleBar.h"
#import "OrderDetailBody.h"

#import "OrderDetailDatabaseFieldsConstant.h"
#import "OrderDetailNetRequestBean.h"
#import "OrderDetailNetRespondBean.h"

#import "OrderCancelDatabaseFieldsConstant.h"
#import "OrderCancelNetRequestBean.h"
#import "OrderCancelNetRespondBean.h"

#import "PayInfoDatabaseFieldsConstant.h"
#import "PayInfoNetRequestBean.h"
#import "PayInfoNetRespondBean.h"

#import "RoomDetailOfBasicInformationActivity.h"
#import "UserOrderCenterActivity.h"

#import "WriteReviewActivity.h"
#import "MainNavigationActivity.h"

#import "SimpleCallSingleton.h"

#import "NSDictionary+Helper.h"

// 支付宝 - 安全支付
#import "AlixPay.h"









static const NSString *const TAG = @"<UserOrderDetailActivity>";


// 业务说明: 会有2个入口进入 "订单详情界面"
// 1. 提交一个新订单, 并且下单成功时, 会进入此界面, 此时传递过来的是 ORDER_DETAIL_FROM_SUBMIT_ORDER, 此时不需要再联网获取订单详情了.
// 2. 从 "我的订单" 页面, 选择一个已经存在的订单后, 进入此界面, 此时传递过来的是 ORDER_ID, 此时需要联网获取订单详情.

// 订单ID
NSString *const kIntentExtraTagForUserOrderDetailActivity_OrderID = @"OrderID";
// 提交订单后返回的订单详情数据
NSString *const kIntentExtraTagForUserOrderDetailActivity_OrderDetailFromSubmitOrder = @"OrderDetailFromSubmitOrder";
// 从订单中心跳转到订单详情界面时, 订单的状态(因为订单的状态可能在用户处理完后, 发生了变化, 所以需要再返回订单中心时, 重刷旧的订单列表)
NSString *const kIntentExtraTagForUserOrderDetailActivity_OrderStateFromOrderCenter = @"OrderStateFromOrderCenter";





@interface UserOrderDetailActivity ()

///
@property (nonatomic, assign) BOOL isIncomingIntentValid;
@property (nonatomic, assign) TitleBar *titleBar;
// 预加载UI工具条
@property (nonatomic, retain) PreloadingUIToolBar *preloadingUIToolBar;


/// 外部传入的数据
//
@property (nonatomic, copy) NSString *orderIdString;
//
@property (nonatomic, retain) OrderDetailNetRespondBean *orderDetailNetRespondBean;
// 从订单中心跳转到订单详情界面时, 目标订单的状态, 这个状态可能不准确
@property (nonatomic, assign) OrderStateEnum orderStateFromOrderCenter;
///

///
@property (nonatomic, assign) NSInteger netRequestIndexForOrderDetail;
@property (nonatomic, assign) NSInteger netRequestIndexForOrderCancel;
@property (nonatomic, assign) NSInteger netRequestIndexForOrderPay;


// 标志当前订单是否是新订单
// 新订单 : 从 "free_book_confirm_order_info" 界面提交订单成功后, 到此的订单就是新订单
// 旧订单 : 从 "user_order_center" 界面选中一个订单后, 跳转到此的订单就是旧订单
@property (nonatomic, assign) BOOL isNewOrder;

// 目标订单的最新状态
@property (nonatomic, assign) OrderStateEnum latestOrderState;

// 订单详情body layout
@property (nonatomic, assign) OrderDetailBody *orderDetailBody;

// 订单状态TitleBar
@property (nonatomic, assign) OrderStateTitleBar *orderStateTitleBar;

// 是否处于订单支付状态
@property (nonatomic, assign) BOOL isOrderPaying;
@end









@implementation UserOrderDetailActivity

#pragma mark -
#pragma mark 内部枚举

//
typedef NS_ENUM(NSInteger, NetRequestTagEnum) {
  // 2.23 查看订单详情
  kNetRequestTagEnum_OrderDetail,
  // 2.24 取消订单
  kNetRequestTagEnum_OrderCancel,
  // 请求支付宝
  kNetRequestTagEnum_PayInfo
};

typedef NS_ENUM(NSInteger, IntentRequestCodeEnum) {
  // 跳转到 "订单评论界面"
  kIntentRequestCodeEnum_ToWriteReviewActivity = 0
};

typedef NS_ENUM(NSInteger, AlertType) {
  // 支付宝 - 安全支付 客户端未安装
  kAlertType_AlixPayWithAlipayClientNotInstalled = 0,
  // 取消一个订单
  kAlertType_CancelOrder,
  // 拨打房东电话
  kAlertType_CallHostPhone,
  // 拨打房东备用电话
  kAlertType_CallHostBackupPhone
};

#pragma mark -
#pragma mark 内部方法
- (void)dealloc {
  
  // 一定要注销广播消息接收器
  [self unregisterReceiver];
  
  //
  [_preloadingUIToolBar release];
  //
  [_orderIdString release];
  //
  [_orderDetailNetRespondBean release];
  
  // UI
  [_titleBarPlaceholder release];
  [_orderStateTitleBarPlaceholder release];
  [_bodyScrollView release];
  [_bodyLayout release];
  [super dealloc];
}

- (void)viewDidUnload {
  ///
  self.titleBar = nil;
  self.preloadingUIToolBar = nil;
  self.orderDetailBody = nil;
  self.orderStateTitleBar = nil;
  
  /// UI
  [self setTitleBarPlaceholder:nil];
  [self setOrderStateTitleBarPlaceholder:nil];
  [self setBodyScrollView:nil];
  [self setBodyLayout:nil];
  [super viewDidUnload];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  if ([DeviceInformation isIPhone5]) {
    // 这里决不能设成 autorelease 的, 网上的代码就是 autorelease的, 4.3系统会崩溃, 因为被自动释放了
    self = [super initWithNibName:@"UserOrderDetailActivity_iphone5" bundle:nibBundleOrNil];
  } else {
    self = [super initWithNibName:@"UserOrderDetailActivity" bundle:nibBundleOrNil];
  }
  if (self) {
    // Custom initialization
    
    _netRequestIndexForOrderDetail = IDLE_NETWORK_REQUEST_ID;
    _netRequestIndexForOrderCancel = IDLE_NETWORK_REQUEST_ID;
    _netRequestIndexForOrderPay = IDLE_NETWORK_REQUEST_ID;
    
    _isNewOrder = NO;
    _isOrderPaying = NO;
    
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  // Do any additional setup after loading the view from its nib.
  
  // 初始化 TitleBar
  [self initTitleBar];
  
  if (_isIncomingIntentValid) {
    
    // 初始化 "预加载UI等待工具条"
    [self initPreloadingUIToolBar];
    
    // 初始化 订单状态TitleBar
    [self initOrderStateTitleBar];
    
    if (_isNewOrder) {
      
      // 新订单
      
      //
      [self initOrderDetailUI];
      
    } else {
      
      /// 旧订单
      
      // 显示 "预加载UI等待工具条"
      [_preloadingUIToolBar showInView:self.view];
      
      // 请求订单详情信息
      _netRequestIndexForOrderDetail = [self requestOrderDetailByOrderID:_orderIdString];
      
    }
    
    
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
#pragma mark 初始化UI
//
-(void)initTitleBar {
  TitleBar *titleBar = [TitleBar titleBar];
  titleBar.delegate = self;
  [titleBar setTitleByString:[NSString stringWithFormat:@"订单:%@", _orderIdString]];
  [titleBar hideLeftButton:NO];
  [self.titleBarPlaceholder addSubview:titleBar];
  
  //
  self.titleBar = titleBar;
}

//
-(void)initOrderStateTitleBar {
  OrderStateTitleBar *orderStateTitleBar = [OrderStateTitleBar orderStateTitleBar];
  [orderStateTitleBar setOrderStateFocusItemByOrderState:_latestOrderState];
  [self.orderStateTitleBarPlaceholder addSubview:orderStateTitleBar];
  
  ///
  self.orderStateTitleBar = orderStateTitleBar;
}

// 初始化 "预加载UI工具条"
-(void)initPreloadingUIToolBar {
  
  self.preloadingUIToolBar = [PreloadingUIToolBar preloadingUIToolBar];
  _preloadingUIToolBar.delegate = self;
}

-(void)initOrderDetailUI{
  if (_orderDetailBody != nil) {
    // 这里是为 从 "待支付" 状态跳转到 "待入住" 状态时的设计
    [_orderDetailBody removeFromSuperview];
    self.orderDetailBody = nil;
  }
  OrderDetailBody *orderDetailBody
  = [OrderDetailBody orderDetailBodyWithOrderDetailNetRespondBean:_orderDetailNetRespondBean
                                                       isNewOrder:_isNewOrder];
  orderDetailBody.delegate = self;
  [_bodyScrollView addSubview:orderDetailBody];
  [_bodyScrollView setContentSize:orderDetailBody.frame.size];
  
  self.orderDetailBody = orderDetailBody;
}

-(void)gotoRoomDetailActivity{
  
  if (_isNewOrder) {
    
    Intent *intent = [Intent intentWithSpecificComponentClass:[RoomDetailOfBasicInformationActivity class]];
    [intent setFlags:FLAG_ACTIVITY_CLEAR_TOP];
    [self startActivity:intent];
    
  } else {
    
    Intent *intent = [Intent intentWithSpecificComponentClass:[RoomDetailOfBasicInformationActivity class]];
    [intent.extras setObject:_orderDetailNetRespondBean.number forKey:kIntentExtraTagForRoomDetailOfBasicInfoActivity_RoomNumber];
    [self startActivity:intent];
    
  }
}

-(void)gotoOrderCenterActivity{
  
  if (_isNewOrder) {
    
    // 新订单的话, 点击 "管理订单" 按钮后, 要跳转到 "订单中心"界面, 并且要删除Activity堆栈中
    // 主界面(MainNavigationActivity) 之上的所有原界面, 并且将新创建的 "订单中心" 界面插入到 主界面之上.
    Intent *intent = [Intent intentWithSpecificComponentClass:[UserOrderCenterActivity class]];
    [intent.extras setObject:[NSNumber numberWithUnsignedInteger:_latestOrderState] forKey:kIntentExtraTagForUserOrderCenterActivity_OrderState];
    [self startActivityByIntent:intent andMoveToTheAboveTargetActivityClass:[MainNavigationActivity class]];
    
  } else {
    
    [self setResult:kActivityResultCode_RESULT_OK];
    [self finish];
    
  }
}

-(void)startAlixPayWithPayInfo:(NSString *)payInfo{
  //应用注册scheme,在AlixPayDemo-Info.plist定义URL types,用于安全支付成功后重新唤起商户应用
  // 这个 scheme 必须和项目的名称一样, 否则不能再支付成功后重新唤起应用
  NSString *appScheme = @"airizu";
  //获取安全支付单例并调用安全支付接口
  AlixPay *alixpay = [AlixPay shared];
  // 订单支付接口。
  /*
   orderString
   包含商户信息以及订单信息的字符串。格式为:
   <orderInfo>&sign=”<signString>”&signType=”<signType>”
   其中<orderInfo>的值为 SPOrder 类的 description 方法返回的字符串 <signString>的值为对<orderInfo>进行 RSA 签名后的结果 <singType>的值默认为: @”RSA”
   applicationScheme
   应用程序注册的 scheme,写在相应 info.plist 中 URL types 字段。
   
   这是一个异步方法,可以在 UI 线程中调用。 安全支付结束时,会生成一个如下的 URL:
   <yourApplicationScheme>://safepay/?<query> 并且会对这个 URL 调用如下的方法:
   [[UIApplication sharedApplication] openURL:url]; 返回外部商户程序,需要处理该 URL
   */
  int ret = [alixpay pay:payInfo applicationScheme:appScheme];
  switch (ret) {
    case kSPErrorOK:{// 接口调用成功。
      
      _isOrderPaying = YES;
      
      // 注册接收 "用户支付订单成功的消息"
      [self registerBroadcastReceiver];
    }break;
      
    case kSPErrorAlipayClientNotInstalled:{// 没有安装支付宝客户端。
      UIAlertView * alertView
      = [[UIAlertView alloc] initWithTitle:nil
                                   message:@"您还没有安装支付宝的客户端，请先装。"
                                  delegate:self
                         cancelButtonTitle:@"确定"
                         otherButtonTitles:nil];
      [alertView setTag:kAlertType_AlixPayWithAlipayClientNotInstalled];
      [alertView show];
      [alertView release];
    }break;
      
    case kSPErrorSignError:{// 签名错误。
      [SVProgressHUD showErrorWithStatus:@"签名错误!"];
      _isOrderPaying = NO;
    }break;
      
    default:
      break;
  }
  
}

#pragma mark -
#pragma mark 实现 CustomControlDelegate 接口
-(void)customControl:(id)control onAction:(NSUInteger)action {
  
  if ([control isKindOfClass:[TitleBar class]]) {
    
    switch (action) {
        
      case kTitleBarActionEnum_LeftButtonClicked:{
        
        if (_isNewOrder) {
          [self gotoRoomDetailActivity];
          
        } else {
          
          //
          [self finish];
        }
        
      }break;
        
      default:
        break;
    }
    
  } else if ([control isKindOfClass:[OrderDetailBody class]]) {
    
    switch (action) {
      case kOrderDetailBodyActionEnum_ToPayButtonClicked:{// 支付订单
        if (_isOrderPaying) {
          [SVProgressHUD showErrorWithStatus:@"订单支付未完成, 请稍等."];
        } else {
          [self requestOrderPayInfoByOrderID:_orderIdString];
        }
      }break;
        
      case kOrderDetailBodyActionEnum_ToReviewButtonClicked:{// 评论订单
        Intent *intent = [Intent intentWithSpecificComponentClass:[WriteReviewActivity class]];
        [intent.extras setObject:_orderIdString forKey:kIntentExtraTagForWriteReviewActivity_OrderID];
        [self startActivityForResult:intent requestCode:kIntentRequestCodeEnum_ToWriteReviewActivity];
      }break;
        
      case kOrderDetailBodyActionEnum_ManageOrderButtonClicked:{// 管理订单
        [self gotoOrderCenterActivity];
      }break;
        
      case kOrderDetailBodyActionEnum_CancelOrderButtonClicked:{// 取消订单
        if (_isOrderPaying) {
          [SVProgressHUD showErrorWithStatus:@"订单支付未完成, 请稍等."];
        } else {
          UIAlertView *alert
          = [[UIAlertView alloc] initWithTitle:nil
                                       message:@"您确定取消当前订单？"
                                      delegate:self
                             cancelButtonTitle:@"取消"
                             otherButtonTitles:@"确定", nil];
          alert.tag = kAlertType_CancelOrder;
          [alert show];
          [alert release];
        }
      }break;
        
      case kOrderDetailBodyActionEnum_ToRoomDetailButtonClicked:{// 跳转到房间详情
        [self gotoRoomDetailActivity];
      }break;
        
      case kOrderDetailBodyActionEnum_HostPhoneButtonClicked:{// 房东电话
        UIAlertView *alert
        = [[UIAlertView alloc] initWithTitle:nil
                                     message:@"您确定要拨打房东电话？"
                                    delegate:self
                           cancelButtonTitle:@"取消"
                           otherButtonTitles:@"确定", nil];
        alert.tag = kAlertType_CallHostPhone;
        [alert show];
        [alert release];
      }break;
        
      case kOrderDetailBodyActionEnum_HostBackupPhoneButtonClicked:{// 房东备用电话
        UIAlertView *alert
        = [[UIAlertView alloc] initWithTitle:nil
                                     message:@"您确定要拨打房东备用电话？"
                                    delegate:self
                           cancelButtonTitle:@"取消"
                           otherButtonTitles:@"确定", nil];
        alert.tag = kAlertType_CallHostBackupPhone;
        [alert show];
        [alert release];
      }break;
        
      default:
        break;
    }
  } else if ([control isKindOfClass:[PreloadingUIToolBar class]]) {
    
    if (kPreloadingUIToolBarActionEnum_RefreshButtonClicked == action) {
      // 重新请求 订单详情
      if (_netRequestIndexForOrderDetail == IDLE_NETWORK_REQUEST_ID) {
        _netRequestIndexForOrderDetail = [self requestOrderDetailByOrderID:_orderIdString];
        if (_netRequestIndexForOrderDetail != IDLE_NETWORK_REQUEST_ID) {
          [_preloadingUIToolBar showRefreshButton:NO];
        }
      }
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
    
    if ([intent.extras containsKey:kIntentExtraTagForUserOrderDetailActivity_OrderID]) {
      // 当前订单是旧订单
      
      // 订单ID
      id orderIdTest
      = [intent.extras objectForKey:kIntentExtraTagForUserOrderDetailActivity_OrderID];
      if (![orderIdTest isKindOfClass:[NSString class]] || [NSString isEmpty:orderIdTest]) {
        // 入参问题
        NSAssert(NO, @"外传传入的Intent中有错误参数 : OrderID");
        break;
      }
      
      // 订单在订单中心时的状态
      id orderStateFromOrderCenterTest = [intent.extras objectForKey:kIntentExtraTagForUserOrderDetailActivity_OrderStateFromOrderCenter];
      if (![orderStateFromOrderCenterTest isKindOfClass:[NSNumber class]]) {
        // 入参问题
        NSAssert(NO, @"外传传入的Intent中有错误参数 : OrderDetailFromSubmitOrder");
        break;
      }
      
      //
      self.isNewOrder = NO;
      self.orderIdString = orderIdTest;
      self.orderStateFromOrderCenter = [orderStateFromOrderCenterTest integerValue];
      
    } else {
      
      // 当前订单是新订单
      
      // 订单详情Bean
      id orderDetailNetRespondBeanTest
      = [intent.extras objectForKey:kIntentExtraTagForUserOrderDetailActivity_OrderDetailFromSubmitOrder];
      if (![orderDetailNetRespondBeanTest isKindOfClass:[OrderDetailNetRespondBean class]]) {
        // 入参问题
        NSAssert(NO, @"外传传入的Intent中有错误参数 : OrderDetailFromSubmitOrder");
        break;
      }
      
      //
      self.orderDetailNetRespondBean = orderDetailNetRespondBeanTest;
      self.isNewOrder = YES;
      self.orderIdString = [_orderDetailNetRespondBean.orderId stringValue];
      self.latestOrderState = _orderDetailNetRespondBean.orderStateEnum;
      
    }
    
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
  _netRequestIndexForOrderDetail = IDLE_NETWORK_REQUEST_ID;
  _netRequestIndexForOrderCancel = IDLE_NETWORK_REQUEST_ID;
  _netRequestIndexForOrderPay = IDLE_NETWORK_REQUEST_ID;
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
    
    if (requestCode == kIntentRequestCodeEnum_ToWriteReviewActivity) {
      /// 更新订单详情信息
      [self updateOrderDetailInfo];
    }
    
  } while (false);
}

#pragma mark -
#pragma mark 实现 IDomainNetRespondCallback 接口

-(void)updateOrderDetailInfo {
  if (_orderDetailBody != nil) {
    [_orderDetailBody removeFromSuperview];
    _orderDetailBody = nil;
  }
  
  // 支付完成后, 要重新请求当前订单的详情信息, 然后更新页面UI
  [_preloadingUIToolBar showRefreshButton:NO];
  [_preloadingUIToolBar showInView:self.view];
  
  _netRequestIndexForOrderDetail = [self requestOrderDetailByOrderID:_orderIdString];
  
}

-(NSInteger)requestOrderDetailByOrderID:(NSString *)orderID {
  
  if ([NSString isEmpty:orderID]) {
    // 入参异常
    return IDLE_NETWORK_REQUEST_ID;
  }
  
  OrderDetailNetRequestBean *netRequestBean = [OrderDetailNetRequestBean orderDetailNetRequestBeanWithOrderId:orderID];
  NSInteger netRequestIndex
  = [[DomainProtocolNetHelperSingleton sharedInstance] requestDomainProtocolWithContext:self
                                                                   andRequestDomainBean:netRequestBean
                                                                        andRequestEvent:kNetRequestTagEnum_OrderDetail
                                                                     andRespondDelegate:self];
  return netRequestIndex;
}

-(void)requestOrderCancelByOrderID:(NSString *)orderID {
  
  do {
    if ([NSString isEmpty:orderID]) {
      // 入参异常
      break;
    }
    
    OrderCancelNetRequestBean *netRequestBean = [OrderCancelNetRequestBean orderCancelNetRequestBeanWithOrderId:orderID];
    _netRequestIndexForOrderCancel
    = [[DomainProtocolNetHelperSingleton sharedInstance] requestDomainProtocolWithContext:self
                                                                     andRequestDomainBean:netRequestBean
                                                                          andRequestEvent:kNetRequestTagEnum_OrderCancel
                                                                       andRespondDelegate:self];
    if (_netRequestIndexForOrderCancel != IDLE_NETWORK_REQUEST_ID) {
      [SVProgressHUD showWithStatus:@"订单取消中..." maskType:SVProgressHUDMaskTypeBlack];
    }
  } while (NO);
}

-(void)requestOrderPayInfoByOrderID:(NSString *)orderID {
  
  do {
    if ([NSString isEmpty:orderID]) {
      // 入参异常
      break;
    }
    
    PayInfoNetRequestBean *netRequestBean = [PayInfoNetRequestBean payInfoNetRequestBeanWithOrderId:orderID];
    _netRequestIndexForOrderPay
    = [[DomainProtocolNetHelperSingleton sharedInstance] requestDomainProtocolWithContext:self
                                                                     andRequestDomainBean:netRequestBean
                                                                          andRequestEvent:kNetRequestTagEnum_PayInfo
                                                                       andRespondDelegate:self];
    if (_netRequestIndexForOrderPay != IDLE_NETWORK_REQUEST_ID) {
      [SVProgressHUD showWithStatus:@"获取支付信息中..." maskType:SVProgressHUDMaskTypeBlack];
    }
  } while (NO);
}

typedef enum {
  // 显示网络访问错误时的提示信息
  kHandlerMsgTypeEnum_ShowNetErrorMessage = 0,
  // 获取 "订单详情" 数据成功
  kHandlerMsgTypeEnum_GetOrderDetailSuccessful,
  // 获取 "取消订单" 数据成功
  kHandlerMsgTypeEnum_GetOrderCancelSuccessful,
  // 获取 "支付信息" 数据成功
  kHandlerMsgTypeEnum_GetOrderPayInfoSuccessful
} HandlerMsgTypeEnum;

typedef enum {
  //
  kHandlerExtraDataTypeEnum_NetRequestTag = 0,
  //
  kHandlerExtraDataTypeEnum_NetErrorMessage,
  //
  kHandlerExtraDataTypeEnum_PayInfoNetRespondBean
} HandlerExtraDataTypeEnum;

- (void) handleMessage:(Message *) msg {
  
  switch (msg.what) {
      
    case kHandlerMsgTypeEnum_ShowNetErrorMessage:{
      
      NSString *netErrorMessageString
      = [msg.data objectForKey:[NSNumber numberWithUnsignedInteger:kHandlerExtraDataTypeEnum_NetErrorMessage]];
      [SVProgressHUD showErrorWithStatus:netErrorMessageString];
      
      if (!_preloadingUIToolBar.isDismissed) {
        [_preloadingUIToolBar showRefreshButton:YES];
      }
    }break;
      
    case kHandlerMsgTypeEnum_GetOrderDetailSuccessful:{
      
      // 隐藏 "预加载UI"
      [_preloadingUIToolBar dismiss];
      
      // 更新当前订单的最新状态
      self.latestOrderState = _orderDetailNetRespondBean.orderStateEnum;
      [_orderStateTitleBar setOrderStateFocusItemByOrderState:_latestOrderState];
      
      // 加载真正的UI
      [self initOrderDetailUI];
    }break;
      
    case kHandlerMsgTypeEnum_GetOrderCancelSuccessful:{
      [SVProgressHUD dismiss];
      [self gotoOrderCenterActivity];
    }break;
      
    case kHandlerMsgTypeEnum_GetOrderPayInfoSuccessful:{
      [SVProgressHUD dismiss];
      
      PayInfoNetRespondBean *payInfoNetRespondBean
      = [msg.data objectForKey:[NSNumber numberWithUnsignedInteger:kHandlerExtraDataTypeEnum_PayInfoNetRespondBean]];
      [self startAlixPayWithPayInfo:payInfoNetRespondBean.payInfo];
      
    }break;
      
    default:
      break;
  }
}

//
- (void) clearNetRequestIndexByRequestEvent:(NSUInteger) requestEvent {
  if (kNetRequestTagEnum_OrderDetail == requestEvent) {
    _netRequestIndexForOrderDetail = IDLE_NETWORK_REQUEST_ID;
  } else if (kNetRequestTagEnum_OrderCancel == requestEvent) {
    _netRequestIndexForOrderCancel = IDLE_NETWORK_REQUEST_ID;
  } else if (kNetRequestTagEnum_PayInfo == requestEvent) {
    _netRequestIndexForOrderPay = IDLE_NETWORK_REQUEST_ID;
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
  
  if (requestEvent == kNetRequestTagEnum_OrderDetail) {// 2.23 查看订单详情
    self.orderDetailNetRespondBean = respondDomainBean;
    PRPLog(@"%@ -> %@", TAG, respondDomainBean);
    
    //
    Message *msg = [Message obtain];
    msg.what = kHandlerMsgTypeEnum_GetOrderDetailSuccessful;
    [self performSelectorOnMainThread:@selector(handleMessage:) withObject:msg waitUntilDone:NO];
    
    return;
    
  } else if (requestEvent == kNetRequestTagEnum_OrderCancel) {// 2.24 取消订单
    
    PRPLog(@"%@ -> %@", TAG, respondDomainBean);
    
    //
    Message *msg = [Message obtain];
    msg.what = kHandlerMsgTypeEnum_GetOrderCancelSuccessful;
    [self performSelectorOnMainThread:@selector(handleMessage:) withObject:msg waitUntilDone:NO];
    
    return;
    
  } else if (requestEvent == kNetRequestTagEnum_PayInfo) {
    
    //
    Message *msg = [Message obtain];
    [msg.data setObject:respondDomainBean forKey:[NSNumber numberWithUnsignedInteger:kHandlerExtraDataTypeEnum_PayInfoNetRespondBean]];
    msg.what = kHandlerMsgTypeEnum_GetOrderPayInfoSuccessful;
    [self performSelectorOnMainThread:@selector(handleMessage:) withObject:msg waitUntilDone:NO];
    
    return;
    
  }
  
}

#pragma mark -
#pragma mark 实现 UIAlertViewDelegate 接口
// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
  
  switch (alertView.tag) {
    case kAlertType_AlixPayWithAlipayClientNotInstalled:{// "安全支付客户端未安装"
      NSString *URLString = @"http://itunes.apple.com/cn/app/id535715926?mt=8";
      [[UIApplication sharedApplication] openURL:[NSURL URLWithString:URLString]];
    }break;
      
    case kAlertType_CancelOrder:{
      if (![alertView cancelButtonIndex] == buttonIndex) {
        [self requestOrderCancelByOrderID:_orderIdString];
      }
    }break;
      
    case kAlertType_CallHostPhone:{// 拨打房东电话
      if (![alertView cancelButtonIndex] == buttonIndex) {
        [[SimpleCallSingleton sharedInstance] callWithPhoneNumber:_orderDetailNetRespondBean.hostPhone];
      }
      
    }break;
      
    case kAlertType_CallHostBackupPhone:{// 拨打房东备用电话
      if (![alertView cancelButtonIndex] == buttonIndex) {
        [[SimpleCallSingleton sharedInstance] callWithPhoneNumber:_orderDetailNetRespondBean.hostBackupPhone];
      }
      
    }break;
      
    default:
      break;
  }
}

#pragma mark -
#pragma mark 实现 BroadcastReceiverDelegate 代理
-(void)onReceive:(Intent *)intent {
  
  NSInteger userNotificationEnum = [[intent action] integerValue];
  switch (userNotificationEnum) {
    case kUserNotificationEnum_OrderPaySucceed:{
      
      // 因为会重复调用 registerBroadcastReceiver 注册 kUserNotificationEnum_OrderPaySucceed 消息,
      // 所以这里要确保只接收一次kUserNotificationEnum_OrderPaySucceed消息
      [self unregisterReceiverWithActionName:[[NSNumber numberWithUnsignedInteger:kUserNotificationEnum_OrderPaySucceed] stringValue]];
      
      /// 如果用户支付成功的话, 就重新获取当前订单的详情信息(待入住状态)
      _isOrderPaying = NO;
      
      // 更新订单详情状态
      [self updateOrderDetailInfo];
    }break;
      
    case kUserNotificationEnum_OrderPayFailed:{
      
      // 因为会重复调用 registerBroadcastReceiver 注册 kUserNotificationEnum_OrderPayFailed 消息,
      // 所以这里要确保只接收一次kUserNotificationEnum_OrderPayFailed消息
      [self unregisterReceiverWithActionName:[[NSNumber numberWithUnsignedInteger:kUserNotificationEnum_OrderPayFailed] stringValue]];
      
      /// 如果用户支付失败, 就复位 _isOrderPaying
      _isOrderPaying = NO;
      
    }break;
    default:{
      
    }break;
  }
}

//
-(void)registerBroadcastReceiver {
  
  IntentFilter *intentFilter = [IntentFilter intentFilter];
  // 向通知中心注册通知 : "订单支付成功" 消息
  [intentFilter.actions addObject:[[NSNumber numberWithUnsignedInteger:kUserNotificationEnum_OrderPaySucceed] stringValue]];
  // 向通知中心注册通知 : "订单支付失败" 消息
  [intentFilter.actions addObject:[[NSNumber numberWithUnsignedInteger:kUserNotificationEnum_OrderPayFailed] stringValue]];
  [self registerReceiver:intentFilter];
}

@end
