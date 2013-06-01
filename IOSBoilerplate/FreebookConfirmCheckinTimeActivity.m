//
//  FreebookConfirmCheckinTimeActivity.m
//  airizu
//
//  Created by 唐志华 on 13-1-30.
//
//

#import "FreebookConfirmCheckinTimeActivity.h"

#import "FreebookConfirmOrderInfoActivity.h"
#import "TitleBar.h"

#import "RoomCalendarDatabaseFieldsConstant.h"
#import "RoomCalendarNetRequestBean.h"
#import "RoomCalendarNetRespondBean.h"

#import "FreeBookDatabaseFieldsConstant.h"
#import "FreeBookNetRequestBean.h"
#import "FreeBookNetRespondBean.h"

#import "RadioPopupList.h"

#import "CalendarActivity.h"
#import "NSDate+Convenience.h"

#import "LoginActivity.h"

#import "PreloadingUIToolBar.h"










static const NSString *const TAG = @"<FreebookConfirmCheckinTimeActivity>";


// 房间编号(房间ID)
NSString *const kIntentExtraTagForFreebookConfirmCheckinTimeActivity_RoomNumber = @"RoomNumber";
// 当前房间最大入住人数
NSString *const kIntentExtraTagForFreebookConfirmCheckinTimeActivity_Accommodates = @"Accommodates";






@interface FreebookConfirmCheckinTimeActivity ()

///
@property (nonatomic, assign) BOOL isIncomingIntentValid;
@property (nonatomic, assign) TitleBar *titleBar;


//
@property (nonatomic, assign) NSInteger netRequestIndexForRoomCalendar;
@property (nonatomic, assign) NSInteger netRequestIndexForFreebook;
@property (nonatomic, assign) NSInteger netRequestIndexForTestOrderValidity;

//
@property (nonatomic, retain) RoomCalendarNetRespondBean *roomCalendarNetRespondBean;
@property (nonatomic, retain) FreeBookNetRequestBean *freeBookNetRequestBean;
@property (nonatomic, retain) FreeBookNetRespondBean *freeBookNetRespondBean;

// 外部传入的数据
@property (nonatomic, copy) NSNumber *roomNumber;
@property (nonatomic, copy) NSNumber *accommodates;

//
@property (nonatomic, retain) NSDate *dateForCheckIn; // "入住时间"
@property (nonatomic, retain) NSDate *dateForCheckOut;// "退房时间"

// 预加载UI工具条
@property (nonatomic, retain) PreloadingUIToolBar *preloadingUIToolBar;

// "入住人数" 单选列表数据源
@property (nonatomic, retain) NSMutableArray *dataSourceForOccupancyCountList;
@end









@implementation FreebookConfirmCheckinTimeActivity
//
-(NSDate *)dateForCheckIn{
  if (_dateForCheckIn == nil) {
    self.dateForCheckIn = [NSDate todayDate];
  }
  return _dateForCheckIn;
}

#pragma mark -
#pragma mark 内部枚举

//
typedef NS_ENUM(NSInteger, NetRequestTagEnum) {
  // 2.28 房间日历
  kNetRequestTagEnum_RoomCalendar = 0,
  // 2.20 订单预订
  kNetRequestTagEnum_OrderFreebook,
  // 测试订单有效性
  kNetRequestTagEnum_TestOrderValidity
};

typedef NS_ENUM(NSInteger, RadioPopupListTypeTag) {
  // "入住人数"
  kRadioPopupListTypeTag_Occupancy = 0
};

typedef NS_ENUM(NSInteger, RoomCalendarTypeTag) {
  // "入住时间"
  kRoomCalendarTypeTag_CheckInDate = 0,
  // "退房时间"
  kRoomCalendarTypeTag_CheckOutDate
};

typedef NS_ENUM(NSInteger, IntentRequestCodeEnum) {
  // 跳转到 "登录界面"
  kIntentRequestCodeEnum_ToLoginActivity = 0,
  // 跳转到 "房间日历界面"
  kIntentRequestCodeEnum_ToCalendarActivity
};


#pragma mark -
#pragma mark 内部方法群

- (void)dealloc {
  
  //
  [_roomCalendarNetRespondBean release];
  [_freeBookNetRequestBean release];
  [_freeBookNetRespondBean release];
  
  //
  [_roomNumber release];
  [_accommodates release];
  
  //
  [_dateForCheckIn release];
  [_dateForCheckOut release];
  
  //
  [_preloadingUIToolBar release];
  //
  [_dataSourceForOccupancyCountList release];
  
  
  /// UI
  [_titleBarPlaceholder release];
  [_checkInDateLabel release];
  [_checkOutDateLabel release];
  [_occupancyLabel release];
  [_totalPriceLayout release];
  [_totalPriceLabel release];
  [_occupancyBackgroundImageView release];
  [_okButton release];
  [_bodyLayout release];
  [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  if ([DeviceInformation isIPhone5]) {
    // 这里决不能设成 autorelease 的, 网上的代码就是 autorelease的, 4.3系统会崩溃, 因为被自动释放了
    self = [super initWithNibName:@"FreebookConfirmCheckinTimeActivity_iphone5" bundle:nibBundleOrNil];
  } else {
    self = [super initWithNibName:@"FreebookConfirmCheckinTimeActivity" bundle:nibBundleOrNil];
  }
  if (self) {
    // Custom initialization
    
    _netRequestIndexForRoomCalendar = IDLE_NETWORK_REQUEST_ID;
    _netRequestIndexForFreebook = IDLE_NETWORK_REQUEST_ID;
    _netRequestIndexForTestOrderValidity = IDLE_NETWORK_REQUEST_ID;
    
    // 初始化 "入住人数" 数据源
    self.dataSourceForOccupancyCountList = [NSMutableArray array];
    [_dataSourceForOccupancyCountList addObjectsFromArray:[[GlobalDataCacheForDataDictionary sharedInstance].dataSourceForOccupancyCountList allKeys]];
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
    
    // 初始化 页面预加载UI
    [self initPreloadingUIToolBar];
    
    // 显示 预加载界面UI
    [_preloadingUIToolBar showInView:self.view];
    
    // 获取房源日历
    _netRequestIndexForRoomCalendar = [self requestRoomCalendarWithRoomNumber:_roomNumber];
    
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
  
  /// ui
  [self setTitleBarPlaceholder:nil];
  [self setCheckInDateLabel:nil];
  [self setCheckOutDateLabel:nil];
  [self setOccupancyLabel:nil];
  [self setTotalPriceLayout:nil];
  [self setTotalPriceLabel:nil];
  [self setOccupancyBackgroundImageView:nil];
  [self setOkButton:nil];
  [self setBodyLayout:nil];
  [super viewDidUnload];
}

#pragma mark -
#pragma mark 控件点击事件监听方法群

// 激活 "入住时间 - 房间日历"
-(void)activateCheckInDateRoomCalendar{
  
  Intent *intent = [Intent intentWithSpecificComponentClass:[CalendarActivity class]];
  [intent.extras setObject:[NSNumber numberWithInteger:kCalendarTypeEnum_CheckInDate] forKey:kIntentExtraTagForCalendarActivity_CalendarType];
  // 设置房间日历的最大有效时间跨度(目前业务规定 : 目前房东仅接受60天之内的入住请求)
  [intent.extras setObject:[NSNumber numberWithInteger:60] forKey:kIntentExtraTagForCalendarActivity_MaxNumberOfDaysSpanInteger];
  // 这个用于 "选择入住时间" 界面, 传入的是目标房间的 3个月内 不可预订的时间数组
  [intent.extras setObject:_roomCalendarNetRespondBean.roomUnselectableCalendarList forKey:kIntentExtraTagForCalendarActivity_DataSourceForUnselectableDate];
  
  [self startActivityForResult:intent requestCode:kIntentRequestCodeEnum_ToCalendarActivity];
  
}

// 激活 "退房时间 - 房间日历"
-(void)activateCheckOutDateRoomCalendar {
  
  Intent *intent = [Intent intentWithSpecificComponentClass:[CalendarActivity class]];
  [intent.extras setObject:[NSNumber numberWithInteger:kCalendarTypeEnum_CheckOutDate] forKey:kIntentExtraTagForCalendarActivity_CalendarType];
  // 设置房间日历 可选范围, 这里是对 "入住时间" 和 "退房时间" 业务逻辑的体现.
  if (_dateForCheckIn != nil) {
    [intent.extras setObject:self.dateForCheckIn forKey:kIntentExtraTagForCalendarActivity_SelectableDayMarkForStart];
  }
  
  [self startActivityForResult:intent requestCode:kIntentRequestCodeEnum_ToCalendarActivity];
}

// "入住时间"
- (IBAction)checkInDateButtonOnClickListener:(id)sender {
  [self activateCheckInDateRoomCalendar];
}

// "退房时间"
- (IBAction)checkOutDateButtonOnClickListener:(id)sender {
  if ([_checkInDateLabel.text isEqualToString:@"不限"]) {
    // 如果用户还没有选择入住时间, 要先激活入住时间
    [self activateCheckInDateRoomCalendar];
  } else {
    [self activateCheckOutDateRoomCalendar];
  }
}

// "入住人数"
- (IBAction)occupancyButtonOnClickListener:(id)sender {
  
  // 调整 "入住人数" 的上线
  RadioPopupList *radioPopupList
  = [RadioPopupList radioPopupListWithTitle:@"入住人数" dataSource:_dataSourceForOccupancyCountList delegate:self];
  radioPopupList.tag = kRadioPopupListTypeTag_Occupancy;
  // 恢复上一次的选择结果
  NSString *lastValue = _occupancyLabel.text;
  NSInteger defaultSelectedIndex = [_dataSourceForOccupancyCountList indexOfObject:lastValue];
  [radioPopupList setDefaultSelectedIndex:defaultSelectedIndex];
  //
  [radioPopupList setFrame:CGRectMake(CGRectGetMinX(self.view.frame),
                                      CGRectGetMaxY(_titleBarPlaceholder.frame),
                                      CGRectGetWidth(self.view.frame),
                                      CGRectGetHeight(self.view.frame) - CGRectGetHeight(_titleBarPlaceholder.frame))];
  [radioPopupList showInView:self.view];
}


- (IBAction)okButtonOnClickListener:(id)sender {
  
  NSString *errorMessageString = @"";
  
  do {
    
    if (_dateForCheckIn == nil) {
      errorMessageString = @"请选择入住时间";
      break;
    }
    
    if (_dateForCheckOut == nil) {
      errorMessageString = @"请选择退房时间";
      break;
    }
    
    NSDate *laterDate = [_dateForCheckIn laterDate:_dateForCheckOut];
    if (laterDate == _dateForCheckIn) {
      // "退房时间应该晚于入住时间"
      errorMessageString = @"退房时间应该晚于入住时间";
      break;
    }
    
    [self requestTestOrderValidity];
    return;
  } while (NO);
  
  [SVProgressHUD showErrorWithStatus:errorMessageString];
  
}

-(void)gotoConfirmOrderInfoActivity {
  Intent *intent = [Intent intentWithSpecificComponentClass:[FreebookConfirmOrderInfoActivity class]];
  [intent.extras setObject:_freeBookNetRequestBean forKey:kIntentExtraTagForFreebookConfirmOrderInfoActivity_FreeBookNetRequestBean];
  [intent.extras setObject:_freeBookNetRespondBean forKey:kIntentExtraTagForFreebookConfirmOrderInfoActivity_FreeBookNetRespondBean];
  [self startActivity:intent];
}

#pragma mark -
#pragma mark Activity 生命周期

-(BOOL)parseIncomingIntent:(Intent *)intent {
  do {
    
    if (intent == nil) {
      break;
    }
    
    // 房间编号
    NSNumber *roomNumberTest
    = [intent.extras objectForKey:kIntentExtraTagForFreebookConfirmCheckinTimeActivity_RoomNumber];
    if (![roomNumberTest isKindOfClass:[NSNumber class]]) {
      break;
    }
    self.roomNumber = roomNumberTest;
    
    // 当前房间最大入住人数
    NSNumber *accommodatesTest
    = [intent.extras objectForKey:kIntentExtraTagForFreebookConfirmCheckinTimeActivity_Accommodates];
    if (![accommodatesTest isKindOfClass:[NSNumber class]]) {
      break;
    }
    self.accommodates = accommodatesTest;
    
    // 校正 入住人数 弹出选选列表的数据源
    if ([_accommodates intValue] > 0) {
      [_dataSourceForOccupancyCountList removeAllObjects];
      
      NSArray *keys
      = [[GlobalDataCacheForDataDictionary sharedInstance].dataSourceForOccupancyCountList allKeys];
      
      for (int i=0; i<[_accommodates intValue]; i++) {
        [_dataSourceForOccupancyCountList addObject:[keys objectAtIndex:i]];
      }
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
  _netRequestIndexForFreebook = IDLE_NETWORK_REQUEST_ID;
  _netRequestIndexForRoomCalendar = IDLE_NETWORK_REQUEST_ID;
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
    
    switch (requestCode) {
      case kIntentRequestCodeEnum_ToLoginActivity:{
        
      }break;
        
      case kIntentRequestCodeEnum_ToCalendarActivity:{
        [self onActivityResultProcessForToCalendarActivityWithReturnedData:data];
      }break;
        
      default:
        break;
    }
    
  } while (NO);
  
}

-(BOOL)onActivityResultProcessForToCalendarActivityWithReturnedData:(Intent *)data {
  do {
    if (![data isKindOfClass:[Intent class]]) {
      break;
    }
    
    id checkInDate = [data.extras objectForKey:[NSNumber numberWithInteger:kCalendarTypeEnum_CheckInDate]];
    if ([checkInDate isKindOfClass:[NSDate class]]) {
      [self saveCheckInDateAndUpdateDateControls:checkInDate];
    }
    
    id checkOutDate = [data.extras objectForKey:[NSNumber numberWithInteger:kCalendarTypeEnum_CheckOutDate]];
    if (![checkOutDate isKindOfClass:[NSDate class]]) {
      
      // 这里是为用户选择了 入住时间, 但是不选 退房时间的一个容错, 默认取 入住时间 的后一天
      if (_dateForCheckIn != nil) {
        NSDate *laterDate = [_dateForCheckIn laterDate:_dateForCheckOut];
        if (laterDate != _dateForCheckOut || [_dateForCheckIn isEqualToDate:_dateForCheckOut withDateFormat:@"yyyyMMdd"]) {
          [self saveCheckOutDateAndUpdateDateControls:[_dateForCheckIn offsetDay:1]];
        }
      }
    } else {
      [self saveCheckOutDateAndUpdateDateControls:checkOutDate];
    }
    
    // 如果 "入住时间" 和 "退房时间" 有效的话, 就请求 订单总额
    [self requestOrderTotalPrice];
    
    return YES;
  } while (NO);
  
  
  return NO;
}

#pragma mark -
#pragma mark 初始化UI

//
// 初始化 "预加载UI工具条"
-(void)initPreloadingUIToolBar {
  self.preloadingUIToolBar = [PreloadingUIToolBar preloadingUIToolBar];
  _preloadingUIToolBar.delegate = self;
}

//
-(void)initTitleBar {
  TitleBar *titleBar = [TitleBar titleBar];
  titleBar.delegate = self;
  [titleBar setTitleByString:@"免费预订"];
  [titleBar hideLeftButton:NO];
  [self.titleBarPlaceholder addSubview:titleBar];
  
  self.titleBar = titleBar;
}

-(void)adjustOrderTotalPriceLayout {
  _occupancyBackgroundImageView.image = [UIImage imageNamed:@"textfield_bg_middle.png"];
  _totalPriceLayout.hidden = NO;
}

-(void)adjustOkButtonCoordinate {
  
  CGRect totalPriceLayoutFrame = _totalPriceLayout.frame;
  CGRect okButtonFrame = _okButton.frame;
  
  if (_totalPriceLayout.hidden) {
    _okButton.frame = CGRectMake(CGRectGetMinX(okButtonFrame), CGRectGetMinY(totalPriceLayoutFrame) + 8, CGRectGetWidth(okButtonFrame), CGRectGetHeight(okButtonFrame));
  } else {
    _okButton.frame = CGRectMake(CGRectGetMinX(okButtonFrame), CGRectGetMaxY(totalPriceLayoutFrame) + 8, CGRectGetWidth(okButtonFrame), CGRectGetHeight(okButtonFrame));
  }
}

-(void)updateOrderTotalPrice{
  _totalPriceLabel.text = [NSString stringWithFormat:@"¥ %d",[_freeBookNetRespondBean.totalPrice integerValue]];
  
  [self adjustOrderTotalPriceLayout];
  [self adjustOkButtonCoordinate];
}

-(void)saveCheckInDateAndUpdateDateControls:(NSDate *)checkInDate{
  
  self.dateForCheckIn = checkInDate;
  _checkInDateLabel.text = [checkInDate stringWithDateFormat:@"yyyy-MM-dd"];
}
-(void)clearCheckInDate{
  
}
-(void)saveCheckOutDateAndUpdateDateControls:(NSDate *)checkOutDate{
  
  self.dateForCheckOut = checkOutDate;
  _checkOutDateLabel.text = [checkOutDate stringWithDateFormat:@"yyyy-MM-dd"];
}
-(void)clearCheckOutDate{
  
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
    
  } else if ([control isKindOfClass:[PreloadingUIToolBar class]]) {
    
    if (kPreloadingUIToolBarActionEnum_RefreshButtonClicked == action) {
      // 重新请求 "房间日历"
      if (_netRequestIndexForRoomCalendar == IDLE_NETWORK_REQUEST_ID) {
        _netRequestIndexForRoomCalendar = [self requestRoomCalendarWithRoomNumber:_roomNumber];
        if (_netRequestIndexForRoomCalendar != IDLE_NETWORK_REQUEST_ID) {
          [_preloadingUIToolBar showRefreshButton:YES];
        }
      }
      
    }
    
  }
  
}

#pragma mark -
#pragma mark 实现 RadioPopupListDelegate 接口
- (void)radioPopupList:(RadioPopupList *)radioPopupList didSelectRowAtIndex:(NSUInteger)index {
  NSString *value = [radioPopupList objectAtIndex:index];
  switch (radioPopupList.tag) {
      
    case kRadioPopupListTypeTag_Occupancy:{// "入住人数"
      [_occupancyLabel setText:value];
      
      [self requestOrderTotalPrice];
    }break;
      
    default:
      break;
  }
}

#pragma mark -
#pragma mark 实现 IDomainNetRespondCallback 接口

// 测试订单有效性
-(void)requestTestOrderValidity {
  
  if (_freeBookNetRequestBean == nil) {
    NSAssert(NO, @"_freeBookNetRequestBean 为 nil.");
    return;
  }
  
  [[DomainProtocolNetHelperSingleton sharedInstance] cancelNetRequestByRequestIndex:_netRequestIndexForFreebook];
  _netRequestIndexForFreebook = IDLE_NETWORK_REQUEST_ID;
  
  _netRequestIndexForTestOrderValidity
  = [[DomainProtocolNetHelperSingleton sharedInstance] requestDomainProtocolWithContext:self
                                                                   andRequestDomainBean:_freeBookNetRequestBean
                                                                        andRequestEvent:kNetRequestTagEnum_TestOrderValidity
                                                                     andRespondDelegate:self];
  if (_netRequestIndexForTestOrderValidity != IDLE_NETWORK_REQUEST_ID) {
    [SVProgressHUD showWithStatus:@"检测订单有效性..." maskType:SVProgressHUDMaskTypeBlack];
  }
}

-(void)requestOrderTotalPrice {
  
  do {
    if (_dateForCheckIn == nil || _dateForCheckOut == nil) {
      break;
    }
    
    NSDate *laterDate = [_dateForCheckIn laterDate:_dateForCheckOut];
    if (laterDate == _dateForCheckIn) {
      // "退房时间应该晚于入住时间"
      break;
    }
    
    [[DomainProtocolNetHelperSingleton sharedInstance] cancelNetRequestByRequestIndex:_netRequestIndexForFreebook];
    _netRequestIndexForFreebook = IDLE_NETWORK_REQUEST_ID;
    
    NSString *roomNumberString = [_roomNumber stringValue];
    NSString *checkInDateString = [_dateForCheckIn stringWithDateFormat:@"yyyy-MM-dd"];
    NSString *checkOutDateString = [_dateForCheckOut stringWithDateFormat:@"yyyy-MM-dd"];
    NSString *guestNumString = [[GlobalDataCacheForDataDictionary sharedInstance].dataSourceForOccupancyCountList objectForKey:_occupancyLabel.text];
    
    self.freeBookNetRequestBean
    = [FreeBookNetRequestBean freeBookNetRequestBeanWithRoomId:roomNumberString
                                                   checkInDate:checkInDateString
                                                  checkOutDate:checkOutDateString
                                                 voucherMethod:kVoucherMethodEnum_DoNotUsePromotions
                                                      guestNum:guestNumString];
    _netRequestIndexForFreebook
    = [[DomainProtocolNetHelperSingleton sharedInstance] requestDomainProtocolWithContext:self
                                                                     andRequestDomainBean:_freeBookNetRequestBean
                                                                          andRequestEvent:kNetRequestTagEnum_OrderFreebook
                                                                       andRespondDelegate:self];
    
  } while (NO);
}

-(NSInteger)requestRoomCalendarWithRoomNumber:(NSNumber *)roomNumber {
  RoomCalendarNetRequestBean *requestBean
  = [RoomCalendarNetRequestBean roomCalendarNetRequestBeanWithRoomId:roomNumber];
  NSInteger netRequestIndex
  = [[DomainProtocolNetHelperSingleton sharedInstance] requestDomainProtocolWithContext:self
                                                                   andRequestDomainBean:requestBean
                                                                        andRequestEvent:kNetRequestTagEnum_RoomCalendar
                                                                     andRespondDelegate:self];
  return netRequestIndex;
}

typedef enum {
  // 显示网络访问错误时的提示信息
  kHandlerMsgTypeEnum_ShowNetErrorMessage = 0,
  // 获取 "订单总金额" 数据成功
  kHandlerMsgTypeEnum_GetOrderTotalPriceSuccessful,
  // 获取 "房间日历" 数据成功
  kHandlerMsgTypeEnum_GetRoomCalendarSuccessful,
  // 获取 "测试订单有效性" 数据成功
  kHandlerMsgTypeEnum_GetTestOrderValiditySuccessful
} HandlerMsgTypeEnum;

typedef enum {
  //
  kHandlerExtraDataTypeEnum_NetRequestTag = 0,
  //
  kHandlerExtraDataTypeEnum_NetErrorMessage,
  //
  kHandlerExtraDataTypeEnum_RoomCalendarNetRespondBean,
  //
  kHandlerExtraDataTypeEnum_FreeBookNetRespondBean
} HandlerExtraDataTypeEnum;

- (void) handleMessage:(Message *) msg {
  
  switch (msg.what) {
      
    case kHandlerMsgTypeEnum_ShowNetErrorMessage:{
      
      NSString *netErrorMessageString
      = [msg.data objectForKey:[NSNumber numberWithUnsignedInteger:kHandlerExtraDataTypeEnum_NetErrorMessage]];
      NSNumber *netRequestTag
      = [msg.data objectForKey:[NSNumber numberWithUnsignedInteger:kHandlerExtraDataTypeEnum_NetRequestTag]];
      
      if ([netRequestTag integerValue] == kNetRequestTagEnum_RoomCalendar) {
        [_preloadingUIToolBar showRefreshButton:YES];
      }
      
      [SVProgressHUD showErrorWithStatus:netErrorMessageString];
      
    }break;
      
    case kHandlerMsgTypeEnum_GetOrderTotalPriceSuccessful:{// 获取 "订单总金额" 数据成功
      
      //
      [self updateOrderTotalPrice];
      
      
    }break;
      
    case kHandlerMsgTypeEnum_GetRoomCalendarSuccessful:{// 获取 "房间日历" 数据成功
      
      // 隐藏 "预加载UI"
      [_preloadingUIToolBar dismiss];
      
      //
      _bodyLayout.hidden = NO;
    }break;
      
    case kHandlerMsgTypeEnum_GetTestOrderValiditySuccessful:{// 获取 "测试订单有效性" 数据成功
      
      //
      [self gotoConfirmOrderInfoActivity];
    }break;
      
    default:
      break;
  }
}

//
- (void) clearNetRequestIndexByRequestEvent:(NSUInteger) requestEvent {
  if (kNetRequestTagEnum_RoomCalendar == requestEvent) {
    _netRequestIndexForRoomCalendar = IDLE_NETWORK_REQUEST_ID;
  } else if (kNetRequestTagEnum_OrderFreebook == requestEvent) {
    _netRequestIndexForFreebook = IDLE_NETWORK_REQUEST_ID;
  } else if (kNetRequestTagEnum_TestOrderValidity == requestEvent) {
    _netRequestIndexForTestOrderValidity = IDLE_NETWORK_REQUEST_ID;
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
  
  if (requestEvent == kNetRequestTagEnum_RoomCalendar) {// 2.28 房间日历
    self.roomCalendarNetRespondBean = respondDomainBean;
    PRPLog(@"%@ -> %@", TAG, _roomCalendarNetRespondBean);
    
    // 跳转到 "房间详情界面"
    Message *msg = [Message obtain];
    msg.what = kHandlerMsgTypeEnum_GetRoomCalendarSuccessful;
    [self performSelectorOnMainThread:@selector(handleMessage:) withObject:msg waitUntilDone:NO];
    
    return;
    
  } else if (requestEvent == kNetRequestTagEnum_OrderFreebook) {// 2.20 订单预订
    
    self.freeBookNetRespondBean = respondDomainBean;
    PRPLog(@"%@ -> %@", TAG, _freeBookNetRespondBean);
    
    // 跳转到 "房间详情界面"
    Message *msg = [Message obtain];
    msg.what = kHandlerMsgTypeEnum_GetOrderTotalPriceSuccessful;
    [self performSelectorOnMainThread:@selector(handleMessage:) withObject:msg waitUntilDone:NO];
    
    return;
    
  } else if (requestEvent == kNetRequestTagEnum_TestOrderValidity) {// 测试订单有效性
    
    self.freeBookNetRespondBean = respondDomainBean;
    PRPLog(@"%@ -> %@", TAG, _freeBookNetRespondBean);
    
    // 跳转到 "房间详情界面"
    Message *msg = [Message obtain];
    msg.what = kHandlerMsgTypeEnum_GetTestOrderValiditySuccessful;
    [self performSelectorOnMainThread:@selector(handleMessage:) withObject:msg waitUntilDone:NO];
    
    return;
    
  }
  
}



@end
