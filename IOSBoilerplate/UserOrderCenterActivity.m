//
//  UserOrderMainActivity.m
//  airizu
//
//  Created by 唐志华 on 13-2-1.
//
//

#import "UserOrderCenterActivity.h"

#import "TitleBar.h"
#import "OrderStateTabhostBar.h"

#import "OrderOverviewDatabaseFieldsConstant.h"
#import "OrderOverview.h"
#import "OrderOverviewListNetRequestBean.h"
#import "OrderOverviewListNetRespondBean.h"

#import "UserOrderDetailActivity.h"

#import "OrderOverviewTableViewCell.h"

#import "MainNavigationActivity.h"

static const NSString *const TAG = @"<UserOrderCenterActivity>";

//
NSString *const kIntentExtraTagForUserOrderCenterActivity_OrderState = @"OrderState";

// table cell 的高度
static const NSInteger kCellHeightForHintInfo = 40;
static const NSInteger kCellHeightForNormal = 100;









@interface UserOrderCenterActivity ()

///
@property (nonatomic, assign) BOOL isIncomingIntentValid;

@property (nonatomic, assign) TitleBar *titleBar;

/// 外部传入的数据
@property (nonatomic, assign) OrderStateEnum orderStateEnum;


// 房源信息列表 - cell 对应的 nib
@property (nonatomic, retain) UINib *tableCellUINib;

//
@property (nonatomic, assign) NSInteger netRequestIndexForOrderList;

@property (nonatomic, retain) NSMutableArray *waitConfirmOrderOverviewList;
@property (nonatomic, retain) NSMutableArray *waitPayOrderOverviewList;
@property (nonatomic, retain) NSMutableArray *waitLiveOrderOverviewList;
@property (nonatomic, retain) NSMutableArray *waitCommentOrderOverviewList;
@property (nonatomic, retain) NSMutableArray *waitHasEndedOrderOverviewList;

@property (nonatomic, assign) NSMutableArray *currentlyOrderOverviewList;

@end









@implementation UserOrderCenterActivity

-(UINib *)tableCellUINib {
  if (_tableCellUINib == nil) {
    self.tableCellUINib = [OrderOverviewTableViewCell nib];
  }
  return _tableCellUINib;
}

//
typedef NS_ENUM(NSInteger, NetRequestTagEnum) {
  //
  kNetRequestTagEnum_OrderList = 0
};

typedef NS_ENUM(NSInteger, IntentRequestCodeEnum) {
  kIntentRequestCodeEnum_ToUserOrderDetailActivity = 0
};

- (void)dealloc {
  
  //
  [_tableCellUINib release];
  
  //
  [_waitConfirmOrderOverviewList release];
  [_waitPayOrderOverviewList release];
  [_waitLiveOrderOverviewList release];
  [_waitCommentOrderOverviewList release];
  [_waitHasEndedOrderOverviewList release];
  
  // UI
  [_titleBarPlaceholder release];
  [_orderStateTabhostBarPlaceholder release];
  [_bodyLayout release];
  [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  if ([DeviceInformation isIPhone5]) {
    // 这里决不能设成 autorelease 的, 网上的代码就是 autorelease的, 4.3系统会崩溃, 因为被自动释放了
    self = [super initWithNibName:@"UserOrderCenterActivity_iphone5" bundle:nibBundleOrNil];
  } else {
    self = [super initWithNibName:@"UserOrderCenterActivity" bundle:nibBundleOrNil];
  }
  if (self) {
    // Custom initialization
    
    _netRequestIndexForOrderList = IDLE_NETWORK_REQUEST_ID;
    
    _orderStateEnum = kOrderStateEnum_WaitConfirm;
    
    _waitConfirmOrderOverviewList = [[NSMutableArray alloc] initWithCapacity:20];
    _waitPayOrderOverviewList = [[NSMutableArray alloc] initWithCapacity:20];
    _waitLiveOrderOverviewList = [[NSMutableArray alloc] initWithCapacity:20];
    _waitCommentOrderOverviewList = [[NSMutableArray alloc] initWithCapacity:20];
    _waitHasEndedOrderOverviewList = [[NSMutableArray alloc] initWithCapacity:100];
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
    [self initOrderStateTabhostBar];
    
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
  
  /// UI
  [self setTitleBarPlaceholder:nil];
  [self setOrderStateTabhostBarPlaceholder:nil];
  [self setBodyLayout:nil];
  [super viewDidUnload];
}

#pragma mark -
#pragma mark 初始化UI
//
-(void)initTitleBar {
  TitleBar *titleBar = [TitleBar titleBar];
  titleBar.delegate = self;
  [titleBar setTitleByString:@"我的订单"];
  [titleBar hideLeftButton:NO];
  [self.titleBarPlaceholder addSubview:titleBar];
  
  self.titleBar = titleBar;
}

//
-(void)initOrderStateTabhostBar {
  OrderStateTabhostBar *orderStateTabhostBar = [OrderStateTabhostBar orderStateTabhostBarWithDefaultOrderState:_orderStateEnum];
  orderStateTabhostBar.delegate = self;
  [self customControl:orderStateTabhostBar onAction:_orderStateEnum];
  [self.orderStateTabhostBarPlaceholder addSubview:orderStateTabhostBar];
}

-(void)gotoAccountActivity {
  Intent *intent = [Intent intentWithSpecificComponentClass:[MainNavigationActivity class]];
  [intent setFlags:FLAG_ACTIVITY_CLEAR_TOP];
  [self startActivity:intent];
}

-(void)gotoOrderDetailActivity:(NSNumber *)orderID {
  if (![orderID isKindOfClass:[NSNumber class]]) {
    return;
  }
  
  Intent *intent = [Intent intentWithSpecificComponentClass:[UserOrderDetailActivity class]];
  [intent.extras setObject:[orderID stringValue] forKey:kIntentExtraTagForUserOrderDetailActivity_OrderID];
  [intent.extras setObject:[NSNumber numberWithInteger:_orderStateEnum] forKey:kIntentExtraTagForUserOrderDetailActivity_OrderStateFromOrderCenter];
  [self startActivityForResult:intent requestCode:kIntentRequestCodeEnum_ToUserOrderDetailActivity];
}

#pragma mark -
#pragma mark 实现 CustomControlDelegate 接口
-(void)customControl:(id)control onAction:(NSUInteger)action {
  
  if ([control isKindOfClass:[TitleBar class]]) {
    
    switch (action) {
        
      case kTitleBarActionEnum_LeftButtonClicked:{
        [self gotoAccountActivity];
      }break;
        
      default:
        break;
    }
    
  } else if ([control isKindOfClass:[OrderStateTabhostBar class]]) {
    
    _orderStateEnum = action;
    
    [[DomainProtocolNetHelperSingleton sharedInstance] cancelNetRequestByRequestIndex:_netRequestIndexForOrderList];
    _netRequestIndexForOrderList = IDLE_NETWORK_REQUEST_ID;
    
    switch(action) {
      case kOrderStateEnum_WaitConfirm:{// "待确认"
        _currentlyOrderOverviewList = _waitConfirmOrderOverviewList;
      }break;
      case kOrderStateEnum_WaitPay:{// "待支付"
        _currentlyOrderOverviewList = _waitPayOrderOverviewList;
      }break;
      case kOrderStateEnum_WaitLive:{// "待入住"
        _currentlyOrderOverviewList = _waitLiveOrderOverviewList;
      }break;
      case kOrderStateEnum_WaitComment:{// "待评价"
        _currentlyOrderOverviewList = _waitCommentOrderOverviewList;
      }break;
      case kOrderStateEnum_HasEnded:{// "已完成"
        _currentlyOrderOverviewList = _waitHasEndedOrderOverviewList;
      }break;
      default:
        break;
    }
    
    if (_currentlyOrderOverviewList.count <= 0) {
      [self requestOrderListByOrderState:_orderStateEnum];
    }
    
    [super.table reloadData];
  }
}

#pragma mark -
#pragma mark Activity 生命周期

-(BOOL)parseIncomingIntent:(Intent *)intent {
  
  do {
    
    if (intent == nil) {
      break;
    }
    
    //
    NSNumber *orderStateEnumTest
    = [intent.extras objectForKey:kIntentExtraTagForUserOrderCenterActivity_OrderState];
    if (![orderStateEnumTest isKindOfClass:[NSNumber class]]) {
      break;
    }
    
    self.orderStateEnum = [orderStateEnumTest integerValue];
    
    
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
  
  [[DomainProtocolNetHelperSingleton sharedInstance] cancelNetRequestByRequestIndex:_netRequestIndexForOrderList];
  _netRequestIndexForOrderList = IDLE_NETWORK_REQUEST_ID;
  
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
    
    if (requestCode == kIntentRequestCodeEnum_ToUserOrderDetailActivity) {
      [_currentlyOrderOverviewList removeAllObjects];
      [super.table reloadData];
      
      [self requestOrderListByOrderState:_orderStateEnum];
    }
    
  } while (false);
}

#pragma mark -
#pragma mark 实现 UITableViewDataSource 接口

- (NSInteger) numberOfSectionsInTableView:(UITableView *) tableView {
  return 1;
}

- (NSInteger) tableView:(UITableView *) tableView
  numberOfRowsInSection:(NSInteger) section {
  
  // 最后一个item项作为数据提示作用
  if ([_currentlyOrderOverviewList isKindOfClass:[NSArray class]] && _currentlyOrderOverviewList.count > 0) {
    // 显示 table cell 分割线
    super.table.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    return _currentlyOrderOverviewList.count + 1;
  } else {
    // 隐藏 table cell 分割线
    super.table.separatorStyle = UITableViewCellSeparatorStyleNone;
    return 1;
  }
}

- (UITableViewCell *)tableView:(UITableView *) tableView
         cellForRowAtIndexPath:(NSIndexPath *) indexPath {
  
  if (indexPath.row + 1 >= [tableView numberOfRowsInSection:0]) {// table 行数从 0 开始
    // table 最后一行作为信息显示
    
    UITableViewCell *cellForHintMessage
    = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                              reuseIdentifier:nil] autorelease];
    cellForHintMessage.textLabel.textAlignment = UITextAlignmentCenter;
    cellForHintMessage.textLabel.font = [UIFont systemFontOfSize:15];
    cellForHintMessage.textLabel.text = @"暂无更多数据";
    cellForHintMessage.selectionStyle = UITableViewCellSelectionStyleNone;
    return cellForHintMessage;
    
  } else {
    
    NSInteger row = indexPath.row;
    //
    OrderOverviewTableViewCell *cell
    = [OrderOverviewTableViewCell cellForTableView:tableView fromNib:self.tableCellUINib];
    // 关闭 TableViewCell 的点击响应
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // 初始化 TableViewCell 中的数据
    if (_currentlyOrderOverviewList != nil && _currentlyOrderOverviewList.count > 0 && row < _currentlyOrderOverviewList.count) {
      
      [cell initTableViewCellDataWithOrderOverview:[_currentlyOrderOverviewList objectAtIndex:row] orderStateEnum:_orderStateEnum];
      
    } else {
      // 异常
      
    }
    
    return cell;
  }
  
}

#pragma mark -
#pragma mark 实现 UITableViewDelegate 接口

- (void) tableView:(UITableView *) tableView didSelectRowAtIndexPath:(NSIndexPath *) indexPath {
  
  do {
    
    if (_currentlyOrderOverviewList == nil || _currentlyOrderOverviewList.count <= 0 || indexPath.row >= _currentlyOrderOverviewList.count) {
      break;
    }
    OrderOverview *orderOverview = [_currentlyOrderOverviewList objectAtIndex:indexPath.row];
    if (orderOverview == nil) {
      break;
    }
    
    // 先停掉网络请求, 防止进入 "房间详情界面" 后, 房源列表被更换.
    [[DomainProtocolNetHelperSingleton sharedInstance] cancelNetRequestByRequestIndex:_netRequestIndexForOrderList];
    _netRequestIndexForOrderList = IDLE_NETWORK_REQUEST_ID;
    
    // 跳转 "订单详情" 界面
    [self gotoOrderDetailActivity:orderOverview.orderId];
    
    return;
  } while (NO);
  
}

// 这个方法是返回每个 item 的高度, 这里不能调用 [tableView numberOfRowsInSection:] 会引起死循环
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  // 这里一定要小心, Array.count 是无符号类型, 那么在C语言语系下, 如果这里写成 (_roomInfoBeanList.count - 1) 的话
  // 如果count的值为0时, 那么根本不会得到 -1, 因为会转型成无符号整数, 就变成最大值了
  if (indexPath.row >= _currentlyOrderOverviewList.count) {
    // table 最后一行作为信息显示
    return kCellHeightForHintInfo;
  } else {
    return kCellHeightForNormal;
  }
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
  // 去掉右边的 delete 按钮
  return NO;
}

- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath {
  
  
}

#pragma mark -
#pragma mark 网络请求相关方法群

-(void)requestOrderListByOrderState:(OrderStateEnum)orderStateEnum{
  OrderOverviewListNetRequestBean *netRequestBean
  = [OrderOverviewListNetRequestBean orderOverviewListNetRequestBeanWithOrderState:[NSString stringWithFormat:@"%d", _orderStateEnum]];
  _netRequestIndexForOrderList
  = [[DomainProtocolNetHelperSingleton sharedInstance] requestDomainProtocolWithContext:self
                                                                   andRequestDomainBean:netRequestBean
                                                                        andRequestEvent:kNetRequestTagEnum_OrderList
                                                                     andRespondDelegate:self];
  if (_netRequestIndexForOrderList != IDLE_NETWORK_REQUEST_ID) {
    [SVProgressHUD showWithStatus:@"联网中..." maskType:SVProgressHUDMaskTypeBlack];
  }
}

typedef enum {
  //
  kHandlerMsgTypeEnum_ShowNetErrorMessage = 0,
  //
  kHandlerMsgTypeEnum_RefreshUIForTable
} HandlerMsgTypeEnum;

typedef enum {
  //
  kHandlerExtraDataTypeEnum_NetRequestTag = 0,
  //
  kHandlerExtraDataTypeEnum_NetErrorMessage,
  //
  kHandlerExtraDataTypeEnum_OrderOverviewListNetRespondBean
} HandlerExtraDataTypeEnum;

- (void) handleMessage:(Message *) msg {
  PRPLog(@"%@ -> handleMessage --- start ! ", TAG);
  
  // 关闭 EGORefreshTableHeader
  if (_reloading) {
    [super doneLoadingTableViewData];
  }
  
  switch (msg.what) {
      
    case kHandlerMsgTypeEnum_ShowNetErrorMessage:{
      
      NSString *netErrorMessageString
      = [msg.data objectForKey:[NSNumber numberWithUnsignedInteger:kHandlerExtraDataTypeEnum_NetErrorMessage]];
      
      [SVProgressHUD showErrorWithStatus:netErrorMessageString];
      
      [super.table reloadData];
      
    }break;
      
    case kHandlerMsgTypeEnum_RefreshUIForTable:{
      
      [SVProgressHUD dismiss];
      
      OrderOverviewListNetRespondBean *orderOverviewListNetRespondBean
      = [msg.data objectForKey:[NSNumber numberWithUnsignedInteger:kHandlerExtraDataTypeEnum_OrderOverviewListNetRespondBean]];
      
      [_currentlyOrderOverviewList removeAllObjects];
      [_currentlyOrderOverviewList setArray:orderOverviewListNetRespondBean.orderOverviewList];
      
      // 更新UI数据
      [super.table reloadData];
    }break;
      
    default:
      break;
  }
}

- (void) clearNetRequestIndexByRequestEvent:(NSUInteger) requestEvent {
  if (kNetRequestTagEnum_OrderList == requestEvent) {
    _netRequestIndexForOrderList = IDLE_NETWORK_REQUEST_ID;
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
  
  if (requestEvent == kNetRequestTagEnum_OrderList) {
    OrderOverviewListNetRespondBean *orderOverviewListNetRespondBean = respondDomainBean;
    //PRPLog(@"%@ -> %@", TAG, roomSearchNetRespondBean);
    
    // 刷新 推荐城市 TableView
    Message *msg = [Message obtain];
    msg.what = kHandlerMsgTypeEnum_RefreshUIForTable;
    [msg.data setObject:orderOverviewListNetRespondBean
                 forKey:[NSNumber numberWithUnsignedInteger:kHandlerExtraDataTypeEnum_OrderOverviewListNetRespondBean]];
    [self performSelectorOnMainThread:@selector(handleMessage:) withObject:msg waitUntilDone:NO];
  }
}

#pragma mark -
#pragma mark 实现 ListActivity 向下滑动事件的响应方法

// This is the core method you should implement
- (void)reloadTableViewDataSource {
	_reloading = YES;
  
  do {
    if (_netRequestIndexForOrderList != IDLE_NETWORK_REQUEST_ID) {
      break;
    }
    
    [self requestOrderListByOrderState:_orderStateEnum];
    //
    return;
  } while (NO);
  
  // 20130223 tangzhihua : 不能在这里直接调用 doneLoadingTableViewData, 否则关不掉当前界面
  // Here you would make an HTTP request or something like that
  // Call [self doneLoadingTableViewData] when you are done
  [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:0.0];
}

@end
