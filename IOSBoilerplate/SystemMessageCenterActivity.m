//
//  SystemMessageCenterActivity.m
//  airizu
//
//  Created by 唐志华 on 13-2-8.
//
//

#import "SystemMessageCenterActivity.h"

// 独立控件
#import "TitleBar.h"

#import "SystemMessageDatabaseFieldsConstant.h"
#import "SystemMessage.h"
#import "SystemMessagesNetRequestBean.h"
#import "SystemMessagesNetRespondBean.h"

#import "SystemMessageTableViewCell.h"

#import "SystemMessageDetailActivity.h"













static const NSString *const TAG = @"<SystemMessageCenterActivity>";

// table cell 的高度
static const NSInteger kCellHeightForHintInfo = 40;
static const NSInteger kCellHeightForNormal = 100;

// 第一页索引
static const NSUInteger kFirstPageIndex = 1;












@interface SystemMessageCenterActivity ()

// 房源信息列表 - cell 对应的 nib
@property (nonatomic, retain) UINib *tableCellUINib;

//
@property (nonatomic, assign) NSInteger netRequestIndexForSystemMessage;

// 和房源列表相关的数据, 如果更换了搜索条件, 这里的数据都要清空

@property (nonatomic, assign) NSUInteger pageNumber;// page 从 1 开始 (只会网络请求成功后, 才累加pageNumber, 请注意)
@property (nonatomic, retain) NSMutableArray *systemMessageBeanList;// 房源信息业务Bean列表
@property (nonatomic, assign) BOOL isLastPage;// 已经是最后一页数据了

// 这是为了解决, 如果已经获取了一屏数据了, 此时网络断开, 那么在滑到最后一行时, 会不断的重新请求网络,
// 因为在 网络出现错误时, 我们要调用 [super.table reloadData]; 来重刷表格数据来显示 最后一行的错误信息.
@property (nonatomic, assign) BOOL isNetError;
@end













@implementation SystemMessageCenterActivity

-(UINib *)tableCellUINib {
  if (_tableCellUINib == nil) {
    self.tableCellUINib = [SystemMessageTableViewCell nib];
  }
  return _tableCellUINib;
}

#pragma mark -
#pragma mark 内部枚举

typedef NS_ENUM(NSInteger, IntentRequestCodeEnum) {
  // 去 房间筛选 界面
  kIntentRequestCodeEnum_ToRoomFilterActivity = 0
};

//
typedef NS_ENUM(NSInteger, NetRequestTagEnum) {
  // 2.18 获得系统通知
  kNetRequestTagEnum_SystemMessage = 0
};



- (void)dealloc {
  //
  [_tableCellUINib release];
  
  //
  [_systemMessageBeanList release];
  
  // UI
  [_titleBarPlaceholder release];
  [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  if ([DeviceInformation isIPhone5]) {
    // 这里决不能设成 autorelease 的, 网上的代码就是 autorelease的, 4.3系统会崩溃, 因为被自动释放了
    self = [super initWithNibName:@"SystemMessageCenterActivity_iphone5" bundle:nibBundleOrNil];
  } else {
    self = [super initWithNibName:@"SystemMessageCenterActivity" bundle:nibBundleOrNil];
  }
  if (self) {
    // Custom initialization
    
    //
    _isNetError = NO;
    
    //
    _netRequestIndexForSystemMessage = IDLE_NETWORK_REQUEST_ID;
    
    //
    _systemMessageBeanList = [[NSMutableArray alloc] initWithCapacity:200];
    _pageNumber = kFirstPageIndex;
    _isLastPage = NO;
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  // Do any additional setup after loading the view from its nib.
  
  /// 初始化UI
  [self initTitleBar];
  
  // 查询目标条件对应的房源
  [self requestSystemMessageByPage:_pageNumber];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}


- (void)viewDidUnload {
  //
  [self setTableCellUINib:nil];
  //
  [self setTitleBarPlaceholder:nil];
  [super viewDidUnload];
}

#pragma mark -
#pragma mark Activity 生命周期
-(void)onCreate:(Intent *)intent{
  PRPLog(@"%@ --> onCreate ", TAG);
  
  
}

-(void)onResume {
  PRPLog(@"%@ --> onResume ", TAG);
  
}

-(void)onPause {
  PRPLog(@"%@ --> onPause ", TAG);
  
  if (_reloading) {
    [super doneLoadingTableViewData];
  }
  
  [SVProgressHUD dismiss];
  
  [[DomainProtocolNetHelperSingleton sharedInstance] cancelNetRequestByRequestIndex:_netRequestIndexForSystemMessage];
  _netRequestIndexForSystemMessage = IDLE_NETWORK_REQUEST_ID;
}

#pragma mark -
#pragma mark 初始化UI

//
- (void) initTitleBar {
  TitleBar *titleBar = [TitleBar titleBar];
  titleBar.delegate = self;
  [titleBar setTitleByString:@"系统消息"];
  [titleBar hideLeftButton:NO];
  [self.titleBarPlaceholder addSubview:titleBar];
}

// 移动 TableView 到第一行, 因为现在的设计是, 只有当前网络请求成功后, 才会清理掉 TableView 中旧的数据,
// 所以, 如果之前已经滑动表格到1屏后(数据已经超过了10条), 并且此时重新请求房源数据时, 在新请求的数据返回时, 会重新加载表格数据,
// 当加载完成后, 因为表格数据总数是10条, 那么 会触发 tableView:willDisplayCell:forRowAtIndexPath:
// 中关于 "滑动屏幕到最后一条时, 会自动请求下一屏数据的事件", 之前外包开发的App就有这个bug
-(void)scrollToFirstRowForTableView{
  NSIndexPath *firstIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
  [self.table scrollToRowAtIndexPath:firstIndexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
}

#pragma mark -
#pragma mark 实现 UITableViewDataSource 接口

- (NSInteger) numberOfSectionsInTableView:(UITableView *) tableView {
  return 1;
}

- (NSInteger) tableView:(UITableView *) tableView
  numberOfRowsInSection:(NSInteger) section {
  
  // 最后一个item项作为数据提示作用
  if ([_systemMessageBeanList isKindOfClass:[NSArray class]] && _systemMessageBeanList.count > 0) {
    // 显示 table cell 分割线
    super.table.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    return _systemMessageBeanList.count + 1;
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
    
    NSString *errorMessage = nil;
    if (_netRequestIndexForSystemMessage != IDLE_NETWORK_REQUEST_ID) {
      errorMessage = @"数据加载中...";
    } else if (_isLastPage) {
      errorMessage = @"暂无更多数据";
    } else if (_isNetError) {
      errorMessage = @"网络访问错误";
    } else {
      errorMessage = @"数据加载中...";
    }
    UITableViewCell *cellForHintMessage
    = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                              reuseIdentifier:nil] autorelease];
    cellForHintMessage.textLabel.textAlignment = UITextAlignmentCenter;
    cellForHintMessage.textLabel.font = [UIFont systemFontOfSize:15];
    cellForHintMessage.textLabel.text = errorMessage;
    cellForHintMessage.selectionStyle = UITableViewCellSelectionStyleNone;
    return cellForHintMessage;
    
  } else {
    
    NSInteger row = indexPath.row;
    //
    SystemMessageTableViewCell *cell
    = [SystemMessageTableViewCell cellForTableView:tableView fromNib:self.tableCellUINib];
    // 关闭 TableViewCell 的点击响应
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // 初始化 TableViewCell 中的数据
    if (_systemMessageBeanList != nil && _systemMessageBeanList.count > 0 && row < _systemMessageBeanList.count) {
      
      [cell initTableViewCellDataWithSystemMessage:[_systemMessageBeanList objectAtIndex:row]];
      
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
    
    if (_systemMessageBeanList == nil || _systemMessageBeanList.count <= 0 || indexPath.row >= _systemMessageBeanList.count) {
      break;
    }
    SystemMessage *systemMessage = [_systemMessageBeanList objectAtIndex:indexPath.row];
    if (systemMessage == nil) {
      break;
    }
    
    // 先停掉网络请求, 防止进入 "房间详情界面" 后, 房源列表被更换.
    [[DomainProtocolNetHelperSingleton sharedInstance] cancelNetRequestByRequestIndex:_netRequestIndexForSystemMessage];
    _netRequestIndexForSystemMessage = IDLE_NETWORK_REQUEST_ID;
    
    // 跳转 "房间详情" 界面
    Intent *intent = [Intent intentWithSpecificComponentClass:[SystemMessageDetailActivity class]];
    [intent.extras setObject:systemMessage forKey:kIntentExtraTagForSystemMessageDetailActivity_SystemMessageBean];
    [self startActivity:intent];
    
    return;
  } while (NO);
  
}

// 这个方法是返回每个 item 的高度, 这里不能调用 [tableView numberOfRowsInSection:] 会引起死循环
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  // 这里一定要小心, Array.count 是无符号类型, 那么在C语言语系下, 如果这里写成 (_roomInfoBeanList.count - 1) 的话
  // 如果count的值为0时, 那么根本不会得到 -1, 因为会转型成无符号整数, 就变成最大值了
  if (indexPath.row >= _systemMessageBeanList.count) {
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
  
  // 判断滚动到底部
  do {
    NSInteger rows = [tableView numberOfRowsInSection:0];
    if (rows <= 1) {
      // 因为 listview最后一行是用于显示信息的, 所以这里判断table是否为空的标志是 1
      break;
    }
    if (_netRequestIndexForSystemMessage != IDLE_NETWORK_REQUEST_ID) {
      // 本次网络数据还未请求回来
      break;
    }
    
    NSInteger row = indexPath.row;
    if (row + 1 < rows) {// 表格行索引从 0 开始
      // 没滑到列表最后一行
      break;
    }
    
    if (_isNetError) {
      _isNetError = NO;
      break;
    }
    
    if (_isLastPage) {
      // 暂无更多数据了
      break;
    }
    
    // _pageNumber 在网络请求成功后, 才会累加, 所这里不要累加 _pageNumber
    [self requestSystemMessageByPage:_pageNumber];
  } while (NO);
  
}

#pragma mark -
#pragma mark 网络请求相关方法群

-(void)requestSystemMessageByPage:(NSInteger)page{
  SystemMessagesNetRequestBean *systemMessagesNetRequestBean
  = [SystemMessagesNetRequestBean systemMessagesNetRequestBeanWithPageNum:[NSNumber numberWithInteger:page]];
  _netRequestIndexForSystemMessage
  = [[DomainProtocolNetHelperSingleton sharedInstance] requestDomainProtocolWithContext:self
                                                                   andRequestDomainBean:systemMessagesNetRequestBean
                                                                        andRequestEvent:kNetRequestTagEnum_SystemMessage
                                                                     andRespondDelegate:self];
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
  kHandlerExtraDataTypeEnum_SystemMessagesNetRespondBean
} HandlerExtraDataTypeEnum;

- (void) handleMessage:(Message *) msg {
  PRPLog(@"%@ -> handleMessage --- start ! ", TAG);
  
  // 关闭 EGORefreshTableHeader
  if (_reloading) {
    [super doneLoadingTableViewData];
  }
  
  switch (msg.what) {
      
    case kHandlerMsgTypeEnum_ShowNetErrorMessage:{
      //
      _isNetError = YES;
      
      NSString *netErrorMessageString
      = [msg.data objectForKey:[NSNumber numberWithUnsignedInteger:kHandlerExtraDataTypeEnum_NetErrorMessage]];
      
      [SVProgressHUD showErrorWithStatus:netErrorMessageString];
      
      [super.table reloadData];
      
    }break;
      
    case kHandlerMsgTypeEnum_RefreshUIForTable:{
      //
      _isNetError = NO;
      
      SystemMessagesNetRespondBean *systemMessagesNetRespondBean
      = [msg.data objectForKey:[NSNumber numberWithUnsignedInteger:kHandlerExtraDataTypeEnum_SystemMessagesNetRespondBean]];
      
      // 这里的设计是考虑, 用户向下拖动table时, 重刷本次房源搜索条件对应的房源信息,
      // 如果是这种情况, 就要先清理掉之前房源信息
      if (_pageNumber <= 1 && _systemMessageBeanList.count > 0) {
        [_systemMessageBeanList removeAllObjects];
      }
      
      if (systemMessagesNetRespondBean.systemMessageList.count > 0) {
        // 保存本次请求获取的房源列表信息
        [_systemMessageBeanList addObjectsFromArray:systemMessagesNetRespondBean.systemMessageList];
        
        // 本次房源信息请求成功, 累加房源信息页数计数器
        _pageNumber += 1;
        
      } else {
        _isLastPage = YES;
      }
      
      // 更新UI数据
      [super.table reloadData];
    }break;
      
    default:
      break;
  }
}

- (void) clearNetRequestIndexByRequestEvent:(NSUInteger) requestEvent {
  if (kNetRequestTagEnum_SystemMessage == requestEvent) {
    _netRequestIndexForSystemMessage = IDLE_NETWORK_REQUEST_ID;
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
  
  if (requestEvent == kNetRequestTagEnum_SystemMessage) {// 2.18 获得系统通知
    SystemMessagesNetRespondBean *systemMessagesNetRespondBean = respondDomainBean;
    //PRPLog(@"%@ -> %@", TAG, roomSearchNetRespondBean);
    
    // 刷新 推荐城市 TableView
    Message *msg = [Message obtain];
    msg.what = kHandlerMsgTypeEnum_RefreshUIForTable;
    [msg.data setObject:systemMessagesNetRespondBean
                 forKey:[NSNumber numberWithUnsignedInteger:kHandlerExtraDataTypeEnum_SystemMessagesNetRespondBean]];
    [self performSelectorOnMainThread:@selector(handleMessage:) withObject:msg waitUntilDone:NO];
  }
}

#pragma mark -
#pragma mark 实现 ListActivity 向下滑动事件的响应方法

// This is the core method you should implement
- (void)reloadTableViewDataSource {
	_reloading = YES;
  
  do {
    if (_netRequestIndexForSystemMessage != IDLE_NETWORK_REQUEST_ID) {
      break;
    }
    
    // 重刷当前房源搜索条件对应的房源信息
    _pageNumber = kFirstPageIndex;
    _isLastPage = NO;
    [self requestSystemMessageByPage:_pageNumber];
    
    //
    return;
  } while (NO);
  
  // 20130223 tangzhihua : 不能在这里直接调用 doneLoadingTableViewData, 否则关不掉当前界面
  // Here you would make an HTTP request or something like that
  // Call [self doneLoadingTableViewData] when you are done
  [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:0.0];
}

#pragma mark -
#pragma mark 实现 CustomControlDelegate 接口
-(void)customControl:(id)control onAction:(NSUInteger)action {
  switch (action) {
      
    case kTitleBarActionEnum_LeftButtonClicked:{
      [self finish];
    }break;
      
    default:
      break;
  }
}
@end

