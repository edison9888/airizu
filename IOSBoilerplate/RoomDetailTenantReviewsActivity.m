//
//  RoomDetailTenantReviewsActivity.m
//  airizu
//
//  Created by 唐志华 on 13-2-11.
//
//

#import "RoomDetailTenantReviewsActivity.h"
#import "TitleBar.h"
#import "FreebookToolBar.h"
#import "PreloadingUIToolBar.h"

#import "RoomDetailDatabaseFieldsConstant.h"
#import "RoomDetailNetRequestBean.h"
#import "RoomDetailNetRespondBean.h"

#import "FreebookConfirmCheckinTimeActivity.h"
#import "LoginActivity.h"
#import "RoomDetailPhotoActivity.h"

#import "RoomReviewDatabaseFieldsConstant.h"
#import "RoomReview.h"
#import "RoomReviewNetRequestBean.h"
#import "RoomReviewNetRespondBean.h"

#import "TenantReviewsTableHeaderView.h"
#import "TenantReviewsTableViewCell.h"








static const NSString *const TAG = @"<RoomDetailTenantReviewsActivity>";










//
NSString *const kIntentExtraTagForRoomDetailTenantReviewsActivity_RoomDetailNetRespondBean = @"RoomDetailNetRespondBean";

// 第一页索引
static const NSUInteger kFirstPageIndex = 1;
// table cell 的高度
static const NSInteger kCellHeightForHintInfo = 40;










@interface RoomDetailTenantReviewsActivity ()

///
@property (nonatomic, assign) BOOL isIncomingIntentValid;
@property (nonatomic, assign) TitleBar *titleBar;

//
@property (nonatomic, assign) NSInteger netRequestIndexForRoomReview;

@property (nonatomic, assign) NSInteger pageNumber;// 从1开始(只会网络请求成功后, 才累加pageNumber, 请注意)
@property (nonatomic, retain) NSMutableArray *roomReviewBeanList;
@property (nonatomic, assign) RoomDetailNetRespondBean *roomDetailNetRespondBean;

// 预加载UI工具条
@property (nonatomic, retain) PreloadingUIToolBar *preloadingUIToolBar;

//
@property (nonatomic, retain) RoomReviewNetRespondBean *roomReviewNetRespondBean;

@property (nonatomic, assign) BOOL isLastPage;// 已经是最后一页数据了

// 这是为了解决, 如果已经获取了一屏数据了, 此时网络断开, 那么在滑到最后一行时, 会不断的重新请求网络,
// 因为在 网络出现错误时, 我们要调用 [super.table reloadData]; 来重刷表格数据来显示 最后一行的错误信息.
@property (nonatomic, assign) BOOL isNetError;

// 房源信息列表 - cell 对应的 nib
@property (nonatomic, retain) UINib *tableCellUINib;

//
@property (nonatomic, retain) TenantReviewsTableViewCell *tenantReviewsTableViewCell;
@end












@implementation RoomDetailTenantReviewsActivity

-(UINib *)tableCellUINib {
  if (_tableCellUINib == nil) {
    self.tableCellUINib = [TenantReviewsTableViewCell nib];
  }
  return _tableCellUINib;
}

//
typedef NS_ENUM(NSInteger, NetRequestTagEnum) {
  // 2.25 获得房间评论
  kNetRequestTagEnum_RoomReview = 0
};


typedef NS_ENUM(NSInteger, IntentRequestCodeEnum) {
  // 跳转到 "登录界面"
  kIntentRequestCodeEnum_ToLoginActivity = 0
};

- (void)dealloc {
  
  //
  [_roomReviewBeanList release];
  //
  [_preloadingUIToolBar release];
  //
  [_roomReviewNetRespondBean release];
  //
  [_tableCellUINib release];
  //
  [_tenantReviewsTableViewCell release];
  
  /// UI
  [_titleBarPlaceholder release];
  [_tableView release];
  [_freebookToolBarPlaceholder release];
  
  [_bodyLayout release];
  [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  if ([DeviceInformation isIPhone5]) {
    // 这里决不能设成 autorelease 的, 网上的代码就是 autorelease的, 4.3系统会崩溃, 因为被自动释放了
    self = [super initWithNibName:@"RoomDetailTenantReviewsActivity_iphone5" bundle:nibBundleOrNil];
  } else {
    self = [super initWithNibName:@"RoomDetailTenantReviewsActivity" bundle:nibBundleOrNil];
  }
  if (self) {
    // Custom initialization
    
    //
    _netRequestIndexForRoomReview = IDLE_NETWORK_REQUEST_ID;
    //
    _pageNumber = kFirstPageIndex;// 从1开始
    //
    _roomReviewBeanList = [[NSMutableArray alloc] initWithCapacity:100];
    _isLastPage = NO;
    
    //
    _isNetError = NO;
    
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  // Do any additional setup after loading the view from its nib.
  
  //
  [self initTitleBar];
  
  if (_isIncomingIntentValid) {
    
    //
    self.tenantReviewsTableViewCell = [TenantReviewsTableViewCell tenantReviewsTableViewCell];
    
    // 去掉tableview的分割线
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    //
    
    [self initFreebookToolBar];
    
    // 初始化 "预加载UI等待工具条"
    [self initPreloadingUIToolBar];
    // 显示 "预加载UI"
    [_preloadingUIToolBar showInView:self.view];
    
    // 请求当前房间评论
    _netRequestIndexForRoomReview
    = [self requestRoomReviewByRoomNumber:_roomDetailNetRespondBean.number pageNumber:_pageNumber];
    
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
  [self setTableView:nil];
  [self setFreebookToolBarPlaceholder:nil];
  [self setBodyLayout:nil];
  [super viewDidUnload];
}

-(void)gotoLoginActivity {
  Intent *intent =[Intent intentWithSpecificComponentClass:[LoginActivity class]];
  [self startActivityForResult:intent requestCode:kIntentRequestCodeEnum_ToLoginActivity];
}

-(void)gotoFreebookConfirmCheckinTimeActivity {
  Intent *intent = [Intent intentWithSpecificComponentClass:[FreebookConfirmCheckinTimeActivity class]];
  [intent.extras setObject:_roomDetailNetRespondBean.number forKey:kIntentExtraTagForFreebookConfirmCheckinTimeActivity_RoomNumber];
  if (_roomDetailNetRespondBean != nil) {
    [intent.extras setObject:_roomDetailNetRespondBean.accommodates forKey:kIntentExtraTagForFreebookConfirmCheckinTimeActivity_Accommodates];
  }
  
  [self startActivity:intent];
}

#pragma mark -
#pragma mark Activity 生命周期

-(BOOL)parseIncomingIntent:(Intent *)intent {
  do {
    
    if (intent == nil) {
      break;
    }
    
    RoomDetailNetRespondBean *roomDetailNetRespondBeanTest
    = [intent.extras objectForKey:kIntentExtraTagForRoomDetailPhotoActivity_RoomDetailNetRespondBean];
    
    if (![roomDetailNetRespondBeanTest isKindOfClass:[RoomDetailNetRespondBean class]]) {
      break;
    }
    
    self.roomDetailNetRespondBean = roomDetailNetRespondBeanTest;
    
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
  
  [[DomainProtocolNetHelperSingleton sharedInstance] cancelNetRequestByRequestIndex:_netRequestIndexForRoomReview];
  _netRequestIndexForRoomReview = IDLE_NETWORK_REQUEST_ID;
}

-(void)onResume {
  PRPLog(@"%@ --> onResume ", TAG);
}

- (void) onActivityResult:(int) requestCode
               resultCode:(int) resultCode
                     data:(Intent *) data {
  
  PRPLog(@"%@ onActivityResult", TAG);
  
  do {
    
    if (requestCode == kIntentRequestCodeEnum_ToLoginActivity) {
      if (resultCode == kActivityResultCode_RESULT_OK) {
				// 用户已经登录成功
        [self gotoFreebookConfirmCheckinTimeActivity];
			}
    }
    
  } while (false);
}

#pragma mark -
#pragma mark 初始化UI
//
- (void) initTitleBar {
  TitleBar *titleBar = [TitleBar titleBar];
  titleBar.delegate = self;
  NSString *titleString = [NSString stringWithFormat:@"房间 : %@", _roomDetailNetRespondBean.number];
  [titleBar setTitleByString:titleString];
  // "返回按钮"
  [titleBar hideLeftButton:NO];
  // "预定电话按钮"
  [titleBar hideRightButton:NO];
  //
  [self.titleBarPlaceholder addSubview:titleBar];
  
  ///
  self.titleBar = titleBar;
}

// 初始化 "预加载UI工具条"
-(void)initPreloadingUIToolBar {
  self.preloadingUIToolBar = [PreloadingUIToolBar preloadingUIToolBar];
  _preloadingUIToolBar.delegate = self;
}

-(void)initTableHeaderView {
  TenantReviewsTableHeaderView *tableHeaderView = [TenantReviewsTableHeaderView tenantReviewsTableHeaderViewWithRoomReviewNetRespondBean:_roomReviewNetRespondBean];
  _tableView.tableHeaderView = tableHeaderView;
}

//
- (void) initFreebookToolBar {
  FreebookToolBar *freebookToolBar = [FreebookToolBar freebookToolBar];
  freebookToolBar.delegate = self;
  [freebookToolBar setRoomPrice:_roomDetailNetRespondBean.price];
  //
  [self.freebookToolBarPlaceholder addSubview:freebookToolBar];
}

#pragma mark -
#pragma mark 实现 CustomControlDelegate 接口
-(void)customControl:(id)control onAction:(NSUInteger)action {
  
  if ([control isKindOfClass:[TitleBar class]]) {
    switch (action) {
        
      case kTitleBarActionEnum_LeftButtonClicked:{// "返回 按钮"
        [self finish];
      }break;
        
      case kTitleBarActionEnum_RightButtonClicked:{// "预定电话 按钮"
        [[SimpleCallSingleton sharedInstance] callCustomerServicePhoneAndShowInThisView:self.view.window];
      }break;
      default:
        break;
    }
    
  } else if ([control isKindOfClass:[FreebookToolBar class]]) {
    
    if (kFreebookToolBarActionEnum_FreebookButtonClicked == action) {
      
      if ([GlobalDataCacheForMemorySingleton sharedInstance].logonNetRespondBean == nil) {
        [self gotoLoginActivity];
      } else {
        [self gotoFreebookConfirmCheckinTimeActivity];
      }
      
    }
    
  } else if ([control isKindOfClass:[PreloadingUIToolBar class]]) {
    
    if (kPreloadingUIToolBarActionEnum_RefreshButtonClicked == action) {
      // 重新请求当前房间的第一页评论
      if (_netRequestIndexForRoomReview == IDLE_NETWORK_REQUEST_ID) {
        _netRequestIndexForRoomReview = [self requestRoomReviewByRoomNumber:_roomDetailNetRespondBean.number pageNumber:_pageNumber];
        if (_netRequestIndexForRoomReview != IDLE_NETWORK_REQUEST_ID) {
          [_preloadingUIToolBar showRefreshButton:NO];
        }
      }
    }
    
  }
}

#pragma mark -
#pragma mark 网络方法群

-(NSInteger)requestRoomReviewByRoomNumber:(NSNumber *)roomNumber pageNumber:(NSInteger)pageNumber {
  if ([NSString isEmpty:[roomNumber stringValue]]) {
    return IDLE_NETWORK_REQUEST_ID;
  }
  
  RoomReviewNetRequestBean *netRequestBean
  = [RoomReviewNetRequestBean roomReviewNetRequestBeanWithRoomId:[roomNumber stringValue] pageNum:pageNumber];
  
  NSInteger netRequestIndex
  = [[DomainProtocolNetHelperSingleton sharedInstance] requestDomainProtocolWithContext:self
                                                                   andRequestDomainBean:netRequestBean
                                                                        andRequestEvent:kNetRequestTagEnum_RoomReview
                                                                     andRespondDelegate:self];
  return netRequestIndex;
}


typedef enum {
  // 显示网络访问错误时的提示信息
  kHandlerMsgTypeEnum_ShowNetErrorMessage = 0,
  // 获取 "房间评论" 数据成功
  kHandlerMsgTypeEnum_GetRoomReviewSuccessful
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
      
      if (!_preloadingUIToolBar.isDismissed) {
        
        [_preloadingUIToolBar showRefreshButton:YES];
        
      } else {
        
        // 因为是使用 table 的最后一个 item 作为显示各种信息之用的, 所以这里要reload table, 要更新提示信息.
        _isNetError = YES;
        _tableView.hidden = NO;
        [_tableView reloadData];
      }
    }break;
      
    case kHandlerMsgTypeEnum_GetRoomReviewSuccessful:{
      //
      _isNetError = NO;
      
      _tableView.hidden = NO;
      
      // 删除 "预加载UI"
      if (!_preloadingUIToolBar.isDismissed) {
        [_preloadingUIToolBar dismiss];
        
        // 初始化 table view header view 部分的UI
        [self initTableHeaderView];
      }
      
      if (_roomReviewNetRespondBean.roomReviewList.count != 0) {
        
        // 本次房源信息请求成功, 累加房源信息页数计数器
        _pageNumber += 1;
        
      } else {
        _isLastPage = YES;
      }
      
      
      //
      [_tableView reloadData];
    }break;
      
    default:
      break;
  }
}

//
- (void) clearNetRequestIndexByRequestEvent:(NSUInteger) requestEvent {
  if (kNetRequestTagEnum_RoomReview == requestEvent) {
    _netRequestIndexForRoomReview = IDLE_NETWORK_REQUEST_ID;
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
  
  if (requestEvent == kNetRequestTagEnum_RoomReview) {// 2.25 获得房间评论
    self.roomReviewNetRespondBean = respondDomainBean;
    //PRPLog(@"%@ -> %@", TAG, roomDetailNetRespondBean);
    
    if (_roomReviewNetRespondBean.roomReviewList.count != 0) {
      [_roomReviewBeanList addObjectsFromArray:_roomReviewNetRespondBean.roomReviewList];
    }
    
    // 跳转到 "房间详情界面"
    Message *msg = [Message obtain];
    msg.what = kHandlerMsgTypeEnum_GetRoomReviewSuccessful;
    [self performSelectorOnMainThread:@selector(handleMessage:) withObject:msg waitUntilDone:NO];
    
    return;
    
  }
}

#pragma mark -
#pragma mark 实现 UITableViewDataSource 接口

- (NSInteger) numberOfSectionsInTableView:(UITableView *) tableView {
  return 1;
}

- (NSInteger) tableView:(UITableView *) tableView
  numberOfRowsInSection:(NSInteger) section {
  
  // 最后一个item项作为数据提示作用
  if ([_roomReviewBeanList isKindOfClass:[NSArray class]] && _roomReviewBeanList.count > 0) {
    // 显示 table cell 分割线
    //_tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    return _roomReviewBeanList.count + 1;
  } else {
    // 隐藏 table cell 分割线
    //_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    return 1;
  }
}

- (UITableViewCell *)tableView:(UITableView *) tableView
         cellForRowAtIndexPath:(NSIndexPath *) indexPath {
  
  if (indexPath.row + 1 >= [tableView numberOfRowsInSection:0]) {// table 行数从 0 开始
    // table 最后一行作为信息显示
    
    NSString *errorMessage = nil;
    if (_netRequestIndexForRoomReview != IDLE_NETWORK_REQUEST_ID) {
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
    TenantReviewsTableViewCell *cell
    = [TenantReviewsTableViewCell cellForTableView:tableView fromNib:self.tableCellUINib];
    // 关闭 TableViewCell 的点击响应
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // 初始化 TableViewCell 中的数据
    if (_roomReviewBeanList != nil && _roomReviewBeanList.count > 0 && row < _roomReviewBeanList.count) {
      
      [cell initTableViewCellDataWithRoomReview:[_roomReviewBeanList objectAtIndex:row]];
      
    } else {
      // 异常
      
    }
    
    return cell;
  }
  
}

#pragma mark -
#pragma mark 实现 UITableViewDelegate 接口

- (void) tableView:(UITableView *) tableView didSelectRowAtIndexPath:(NSIndexPath *) indexPath {
  
}

// 这个方法是返回每个 item 的高度, 这里不能调用 [tableView numberOfRowsInSection:] 会引起死循环
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  // 这里一定要小心, Array.count 是无符号类型, 那么在C语言语系下, 如果这里写成 (_roomInfoBeanList.count - 1) 的话
  // 如果count的值为0时, 那么根本不会得到 -1, 因为会转型成无符号整数, 就变成最大值了
  if (indexPath.row >= _roomReviewBeanList.count) {
    // table 最后一行作为信息显示
    return kCellHeightForHintInfo;
  } else {
    
    RoomReview *roomReview = [_roomReviewBeanList objectAtIndex:indexPath.row];
    
    CGFloat cellHeight = 0;
    CGFloat offsetY = CGRectGetMaxY(_tenantReviewsTableViewCell.userReviewLayout.frame);
    
    // 用户评论
    CGRect userReviewFrame;
    if (![NSString isEmpty:roomReview.userReview]) {
      
      userReviewFrame = _tenantReviewsTableViewCell.userReview.frame;
      CGSize size = [roomReview.userReview sizeWithFont:_tenantReviewsTableViewCell.userReview.font constrainedToSize:CGSizeMake(userReviewFrame.size.width, 1000) lineBreakMode:UILineBreakModeCharacterWrap];
      userReviewFrame = CGRectMake(CGRectGetMinX(userReviewFrame),
                                   CGRectGetMinY(userReviewFrame),
                                   size.width,
                                   size.height);
      offsetY = CGRectGetMaxY(userReviewFrame) + 10;
    } else {
      
    }
    CGRect userReviewLayoutFrame = _tenantReviewsTableViewCell.userReviewLayout.frame;
    userReviewLayoutFrame.size.height = offsetY;
    
    offsetY = CGRectGetMaxY(userReviewLayoutFrame) + 8;
    cellHeight = offsetY;
    
    //// -----------------------------------------------------------------------------
    
    CGRect hostReviewLayoutFrame = _tenantReviewsTableViewCell.hostReviewLayout.frame;
    hostReviewLayoutFrame.origin.y = offsetY;
    
    // 房东回复
    if (![NSString isEmpty:roomReview.hostReview]) {
      
      CGRect hostReviewFrame = _tenantReviewsTableViewCell.hostReview.frame;
      CGSize size = [roomReview.hostReview sizeWithFont:_tenantReviewsTableViewCell.hostReview.font constrainedToSize:CGSizeMake(hostReviewFrame.size.width, 1000) lineBreakMode:UILineBreakModeCharacterWrap];
      hostReviewFrame = CGRectMake(CGRectGetMinX(hostReviewFrame),
                                   CGRectGetMinY(hostReviewFrame),
                                   size.width,
                                   size.height);
      offsetY = CGRectGetMaxY(hostReviewFrame) + 10;
      cellHeight += (offsetY + 10);
    }
    
    return cellHeight;
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
    if (_netRequestIndexForRoomReview != IDLE_NETWORK_REQUEST_ID) {
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
    
    // 请求下一页数据
    // _pageNumber 在网络请求成功后, 才会累加, 所这里不要累加 _pageNumber
    _netRequestIndexForRoomReview = [self requestRoomReviewByRoomNumber:_roomDetailNetRespondBean.number pageNumber:_pageNumber];
  } while (NO);
  
}

@end
