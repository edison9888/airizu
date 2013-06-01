//
//  CityListActivityViewController.m
//  airizu
//
//  Created by 唐志华 on 13-1-15.
//
//

#import "CityListActivity.h"

#import "TitleBar.h"
#import "PreloadingUIToolBar.h"
#import "TableHeaderForCityList.h"

#import "CityInfo.h"
#import "CitysNetRequestBean.h"
#import "CitysNetRespondBean.h"

#import "UserCurrentCityInfo.h"
#import "CityInfoListTableViewCell.h"
#import "HeaderViewForCityInfoTableView.h"

#import "RoomSearchDatabaseFieldsConstant.h"
#import "RoomListActivity.h"

#import "NSDictionary+Helper.h"

static const NSString *const TAG = @"<CityListActivity>";

// 选中城市列表 item 之后要进行的操作
NSString *const kIntentExtraTagForCityListActivity_SelectTheCityAfterTheOperation = @"SelectTheCityAfterTheOperation";

// table cell 的高度
static const NSInteger kCellHeightForHeaderInSection = 30;
static const NSInteger kCellHeightForNormal = 40;








@interface CityListActivity ()

///
@property (nonatomic, assign) BOOL isIncomingIntentValid;

@property (nonatomic, assign) TitleBar *titleBar;



// 选中城市列表 item 之后要进行的操作 :
// 1. 立刻开始搜素目标城市的房源 (从 "推荐" 页面进入到城市列表)
// 2. 返回搜索界面            (从 "搜索" 页面进入到城市列表)
@property (nonatomic, assign) SelectTheCityAfterTheOperationEnum selectTheCityAfterTheOperation;

//
@property (nonatomic, assign) NSInteger netRequestIndexForSearchCity;

// 预加载UI工具条
@property (nonatomic, retain) PreloadingUIToolBar *preloadingUIToolBar;

// 城市信息列表(普通城市列表)
@property (nonatomic, retain) NSArray *cityInfoList;

// 城市列表的 section title (就是 # A ~ Z )
@property (nonatomic, retain) NSArray *sectionTitleList;

// UISearchBar 处于搜索状态
@property (nonatomic, assign) BOOL isSearching;
// 保存搜索结果的NSArray
@property (nonatomic, retain) NSMutableArray *searchResultList;

// 整个表格的数据源, 格式是 section 对应一个NSArray
@property (nonatomic, retain) NSMutableDictionary *dataSourceForTable;


// 房源信息列表 - cell 对应的 nib
@property (nonatomic, retain) UINib *tableCellUINib;
@end








@implementation CityListActivity

-(UINib *)tableCellUINib {
  if (_tableCellUINib == nil) {
    self.tableCellUINib = [CityInfoListTableViewCell nib];
  }
  return _tableCellUINib;
}

//
typedef NS_ENUM(NSInteger, NetRequestTagEnum) {
  // 搜索城市
  kNetRequestTagEnum_SearchCity = 0
};


//
- (void)dealloc {
  
  // 一定要注销广播消息接收器
  [self unregisterReceiver];
  
  //
  [_preloadingUIToolBar release];
  //
  [_cityInfoList release];
  //
  [_sectionTitleList release];
  //
  [_searchResultList release];
  //
  [_dataSourceForTable release];
  //
  [_tableCellUINib release];
  
  // UI
  [_titleBarPlaceholder release];
  [_bodyLayout release];
  [_citySearchBar release];
  [_userCurrentCityInfoPlaceholder release];
  [_cityTableView release];
  
  [super dealloc];
}

- (void)viewDidUnload {
  self.titleBar = nil;
  
  /// UI
  [self setTitleBarPlaceholder:nil];
  [self setBodyLayout:nil];
  [self setCitySearchBar:nil];
  [self setUserCurrentCityInfoPlaceholder:nil];
  [self setCityTableView:nil];
  
  [super viewDidUnload];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  if ([DeviceInformation isIPhone5]) {
    // 这里决不能设成 autorelease 的, 网上的代码就是 autorelease的, 4.3系统会崩溃, 因为被自动释放了
    self = [super initWithNibName:@"CityListActivity_iphone5" bundle:nibBundleOrNil];
  } else {
    self = [super initWithNibName:@"CityListActivity" bundle:nibBundleOrNil];
  }
  
  if (self) {
    
    //
    _isIncomingIntentValid = NO;
    
    
    
    
    
    // Custom initialization
    _netRequestIndexForSearchCity = IDLE_NETWORK_REQUEST_ID;
    
    _isSearching = NO;
    
    _searchResultList = [[NSMutableArray alloc] initWithCapacity:200];
    
    // # A ~ Z
    _sectionTitleList = [[NSArray alloc] initWithObjects:@"#", @"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z", nil];
    //
    _dataSourceForTable = [[NSMutableDictionary alloc] initWithCapacity:(_sectionTitleList.count)];
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
    
    [self initPreloadingUIToolBar];
    
    [self initCurrentCityInfo];
    
    // 首先检查是否有城市信息列表的缓存, 如果没有, 就从网络中拉取数据
    CitysNetRespondBean *cityInfoNetRespondBean = [GlobalDataCacheForMemorySingleton sharedInstance].cityInfoNetRespondBean;
    if (cityInfoNetRespondBean == nil || cityInfoNetRespondBean.cityInfoList == nil) {
      
      [GlobalDataCacheForMemorySingleton sharedInstance].cityInfoNetRespondBean = nil;
      
      // 显示 "预加载UI等待工具条"
      [_preloadingUIToolBar showInView:self.view];
      
      // 请求城市列表
      _netRequestIndexForSearchCity = [self requestCityList];
      
    } else {
      
      // 加载 "本界面真正的UI, 并且使用 CitysNetRespondBean 初始化"
      _bodyLayout.hidden = NO;
      
      [self initDataSourceForTableWithCitysNetRespondBean:cityInfoNetRespondBean];
    }
    
  } else {
    
    // 传入的 Intent 数据无效
    [_titleBar setTitleByString:kIncomingIntentValid];
    
  }
  
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}


-(void)gotoTargetActivityWithCityName:(NSString *)cityName cityID:(NSString *)cityID {
  
  
  if (kSelectTheCityAfterTheOperationEnum_SearchingRoomWithCity == _selectTheCityAfterTheOperation) {// 立刻开始搜素目标城市的房源
    
    Intent *intent = [Intent intentWithSpecificComponentClass:[RoomListActivity class]];
    NSMutableDictionary *roomSearchCriteriaDictionary = [NSMutableDictionary dictionary];
    
    // 城市id
    if (![NSString isEmpty:cityID]) {
      [roomSearchCriteriaDictionary setObject:cityID
                                       forKey:kRoomSearch_RequestKey_cityId];
    }
    // 城市名称
    if (![NSString isEmpty:cityName]) {
      [roomSearchCriteriaDictionary setObject:cityName
                                       forKey:kRoomSearch_RequestKey_cityName];
    }
    // 排序方式
    [roomSearchCriteriaDictionary setObject:kRoomListOrderType_OrderByAirizuCommend
                                     forKey:kRoomSearch_RequestKey_order];
    
    [intent.extras setObject:roomSearchCriteriaDictionary forKey:kIntentExtraTagForRoomListActivity_RoomSearchCriteria];
    
    [self startActivity:intent];
    
  } else if (kSelectTheCityAfterTheOperationEnum_BackToSearchActivity == _selectTheCityAfterTheOperation) {// 返回搜索界面
    
    Intent *intent = [Intent intent];
    [intent.extras setObject:cityID forKey:kRoomSearch_RequestKey_cityId];
    [intent.extras setObject:cityName forKey:kRoomSearch_RequestKey_cityName];
    [self setResult:kActivityResultCode_RESULT_OK data:intent];
    [self finish];
  }
}

#pragma mark -
#pragma mark Activity 生命周期

-(BOOL)parseIncomingIntent:(Intent *)intent {
  do {
    
    if (intent == nil) {
      break;
    }
    
    if (![intent.extras containsKey:kIntentExtraTagForCityListActivity_SelectTheCityAfterTheOperation]) {
      NSAssert(NO, @"has not SelectTheCityAfterTheOperation in incoming");
      break;
    }
    
    // 选中城市列表 item 之后要进行的操作
    self.selectTheCityAfterTheOperation
    = [[intent.extras objectForKey:kIntentExtraTagForCityListActivity_SelectTheCityAfterTheOperation] integerValue];
    
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
  
  if (_isSearching) {
    [_citySearchBar resignFirstResponder];
  }
  
  [SVProgressHUD dismiss];
  
  [[DomainProtocolNetHelperSingleton sharedInstance] cancelNetRequestByRequestIndex:_netRequestIndexForSearchCity];
  _netRequestIndexForSearchCity = IDLE_NETWORK_REQUEST_ID;
  
}

-(void)onResume {
  PRPLog(@"%@ --> onResume ", TAG);
  
  if (_isSearching) {
    [_citySearchBar becomeFirstResponder];
  }
}

#pragma mark -
#pragma mark 初始化UI
//
-(void)initTitleBar {
  TitleBar *titleBar = [TitleBar titleBar];
  titleBar.delegate = self;
  [titleBar setTitleByString:@"选择城市"];
  [titleBar hideLeftButton:NO];
  [self.titleBarPlaceholder addSubview:titleBar];
  
  self.titleBar = titleBar;
}

// 初始化 "预加载UI工具条"
-(void)initPreloadingUIToolBar {
  self.preloadingUIToolBar = [PreloadingUIToolBar preloadingUIToolBar];
  _preloadingUIToolBar.delegate = self;
}

-(void)initCurrentCityInfo {
  if ([GlobalDataCacheForMemorySingleton sharedInstance].lastMKAddrInfo == nil) {
    // 接收 : 获取用户地址成功
    [self registerBroadcastReceiver];
    
    
  } else {
    [self loadCurrentCityInfoUI];
  }
}

-(void)loadCurrentCityInfoUI {
  BMKAddrInfo *lastMKAddrInfo = [GlobalDataCacheForMemorySingleton sharedInstance].lastMKAddrInfo;
  
  UserCurrentCityInfo *userCurrentCityInfo = [UserCurrentCityInfo userCurrentCityInfoWithCityName:lastMKAddrInfo.addressComponent.city];
  userCurrentCityInfo.delegate = self;
  
  _userCurrentCityInfoPlaceholder.frame = CGRectMake(CGRectGetMinX(_userCurrentCityInfoPlaceholder.frame),
                                                     CGRectGetMinY(_userCurrentCityInfoPlaceholder.frame),
                                                     CGRectGetWidth(userCurrentCityInfo.frame),
                                                     CGRectGetHeight(userCurrentCityInfo.frame));
  [_userCurrentCityInfoPlaceholder addSubview:userCurrentCityInfo];
  
  super.table.frame = CGRectMake(CGRectGetMinX(super.table.frame),
                                 CGRectGetMaxY(_userCurrentCityInfoPlaceholder.frame),
                                 CGRectGetWidth(super.table.frame),
                                 CGRectGetHeight(super.table.frame) - CGRectGetHeight(_userCurrentCityInfoPlaceholder.frame));
  
}

-(void)initDataSourceForTableWithCitysNetRespondBean:(CitysNetRespondBean *)citysNetRespondBean {
  
  if (citysNetRespondBean == nil) {
    return;
  }
  
  // 热门城市列表
  //self.hotCityList = citysNetRespondBean.topCitys;
  // 普通城市列表
  self.cityInfoList = citysNetRespondBean.cityInfoList;
  
  // 一定要先清理掉历史数据
  [_dataSourceForTable removeAllObjects];
  
  for (NSString *sectionTitle in _sectionTitleList) {
    [_dataSourceForTable setObject:[NSMutableArray arrayWithCapacity:50] forKey:sectionTitle];
  }
  
  // 增加 "热门城市"
  [_dataSourceForTable setObject:citysNetRespondBean.topCitys forKey:_sectionTitleList[0]];
  
  NSRange range = NSMakeRange(0, 1);
  for (int i=0; i<citysNetRespondBean.cityInfoList.count; i++) {
    
    CityInfo *cityInfo = [citysNetRespondBean.cityInfoList objectAtIndex:i];
    if (cityInfo == nil) {
      continue;
    }
    NSString *firstLetter = [[cityInfo.code substringWithRange:range] uppercaseString];
		if ([firstLetter characterAtIndex:0] < 'A' || [firstLetter characterAtIndex:0] > 'Z') {
			continue;
		}
    
    NSMutableArray *cityGroup = [_dataSourceForTable objectForKey:firstLetter];
    if (cityGroup == nil) {
      continue;
    }
    [cityGroup addObject:cityInfo];
  }
  
}

#pragma mark -
#pragma mark 实现 CustomControlDelegate 接口
-(void)customControl:(id)control onAction:(NSUInteger)action {
  
  if ([control isKindOfClass:[TitleBar class]]) {
    
    switch (action) {
        
      case kTitleBarActionEnum_LeftButtonClicked:{
        [self setRequestCode:kActivityResultCode_RESULT_CANCELED];
        [self finish];
      }break;
        
      default:
        break;
    }
    
  } else if ([control isKindOfClass:[PreloadingUIToolBar class]]) {
    if (kPreloadingUIToolBarActionEnum_RefreshButtonClicked == action) {
      
      if (_netRequestIndexForSearchCity == IDLE_NETWORK_REQUEST_ID) {
        _netRequestIndexForSearchCity = [self requestCityList];
        if (_netRequestIndexForSearchCity != IDLE_NETWORK_REQUEST_ID) {
          [_preloadingUIToolBar showRefreshButton:NO];
        }
      }
    }
  } else if ([control isKindOfClass:[UserCurrentCityInfo class]]) {
    if (kUserCurrentCityInfoActionEnum_SearchCurrentCityRoomInfo == action) {
      
      
    }
  }
}

#pragma mark -
#pragma mark 实现 UITableViewDataSource 接口

- (NSInteger) numberOfSectionsInTableView:(UITableView *) tableView {
  if (_isSearching) {
    return 1;
  } else {
    return _sectionTitleList.count;
  }
}

- (NSInteger) tableView:(UITableView *) tableView
  numberOfRowsInSection:(NSInteger) section {
  
  if (_isSearching) {
    
    return _searchResultList.count;
    
  } else {
    
    do {
      if (section >= _sectionTitleList.count) {
        break;
      }
      
      NSString *sectionTitle = [_sectionTitleList objectAtIndex:section];
      if ([NSString isEmpty:sectionTitle]) {
        break;
      }
      
      NSArray *rows = [_dataSourceForTable objectForKey:sectionTitle];
      if (![rows isKindOfClass:[NSArray class]]) {
        break;
      }
      return rows.count;
    } while (NO);
    
    return 0;
  }
}

- (UITableViewCell *)tableView:(UITableView *) tableView
         cellForRowAtIndexPath:(NSIndexPath *) indexPath {
  
  NSInteger row = [indexPath row];
	NSInteger section = [indexPath section];
	
	CityInfo *cityInfo = nil;
	if (_isSearching) {
		cityInfo = [_searchResultList objectAtIndex:row];
	} else {
		cityInfo = [[_dataSourceForTable objectForKey:[_sectionTitleList objectAtIndex:section]] objectAtIndex:row];
	}
  
  CityInfoListTableViewCell *cell
  = [CityInfoListTableViewCell cellForTableView:tableView fromNib:self.tableCellUINib];
  // 关闭 TableViewCell 的点击响应
  cell.selectionStyle = UITableViewCellSelectionStyleNone;
  [cell initTableViewCellDataWithCityInfo:cityInfo];
  
  return cell;
  
}

#pragma mark -
#pragma mark 实现 UITableViewDelegate 接口

- (void) tableView:(UITableView *) tableView didSelectRowAtIndexPath:(NSIndexPath *) indexPath {
  
  NSInteger section = [indexPath section];
  NSInteger row = [indexPath row];
  
  CityInfo *cityInfo = nil;
  if (_isSearching) {
    
    do {
      if (row >= _searchResultList.count) {
        break;
      }
      cityInfo = [_searchResultList objectAtIndex:row];
    } while (NO);
    
  } else {
    
    do {
      if (section >= _sectionTitleList.count) {
        break;
      }
      NSString *sectionTitle = [_sectionTitleList objectAtIndex:section];
      if ([NSString isEmpty:sectionTitle]) {
        break;
      }
      NSArray *cityGroup = [_dataSourceForTable objectForKey:sectionTitle];
      if (row >= cityGroup.count) {
        break;
      }
      cityInfo = [cityGroup objectAtIndex:row];
    } while (NO);
    
  }
  
  if (cityInfo != nil) {
    NSString *cityName = cityInfo.name;
    NSString *cityId = [cityInfo.ID stringValue];
    
    [self gotoTargetActivityWithCityName:cityName cityID:cityId];
  }
  
}

// 这个方法是返回每个 item 的高度, 这里不能调用 [tableView numberOfRowsInSection:] 会引起死循环
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  return kCellHeightForNormal;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
  
  if (_isSearching) {
    return nil;
    
  } else {
    
    NSString *title = nil;
    if (0 == section) {
      title = @"热门城市";
    } else {
      title = [_sectionTitleList objectAtIndex:section];
    }
    
    HeaderViewForCityInfoTableView *headerView = [HeaderViewForCityInfoTableView headerViewForCityInfoTableViewWithTitle:title];
    return headerView;
  }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
  if (_isSearching) {
    return 0;
  } else {
    return kCellHeightForHeaderInSection;
  }
	
}

-(NSArray*)sectionIndexTitlesForTableView:(UITableView *)tableView{
  if (_isSearching) {
    return nil;
  } else {
    return _sectionTitleList;
  }
  
}

-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
	return index;
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
  // 去掉右边的 delete 按钮
  return NO;
}

#pragma mark -
#pragma mark 实现 UISearchBarDelegate 协议
// return NO to not become first responder
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
  [_citySearchBar setShowsCancelButton:YES animated:YES];
  
  // 配置 UISearchBar UI
  NSArray *views = [searchBar subviews];
  for (id view in views) {
    if ([view isKindOfClass:[UIButton class]]) {
      UIButton *cancelButton = view;
      
      [cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
      cancelButton.titleLabel.font = [UIFont systemFontOfSize:14];
      /*
       [cancelButton setBackgroundImage:[UIImage imageNamed:@"short_highlight_button.png"] forState:UIControlStateNormal];
       [cancelButton setBackgroundImage:[UIImage imageNamed:@"short_highlight_button_focus.png"] forState:UIControlStateHighlighted];
       */
      break;
    } else if ([view isKindOfClass:[UITextField class]]) {
      UITextField *textField = view;
      [textField setReturnKeyType:UIReturnKeyDone];
    }
  }
  
  //
  
  _isSearching = YES;
  // 进入搜索状态时, 要关闭table 的向下滑动属性
  super.table.bounces = NO;
  [super.table reloadData];
  
  return YES;
}

// called when text starts editing
//- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar;

// return NO to not resign first responder
//- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar;

// called when text ends editing
//- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar;

// called when text changes (including clear)
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
  if (!_isSearching) {
    // 20130225 tangzhihua : iOS4.3 会在调用 _citySearchBar.text = @""; 之后立刻同步调用 当前方法,照成死循环
    return;
  }
  
  if (0 == searchText.length) {
    // 检索字符串为空时, 显示全部数据
    [_searchResultList removeAllObjects];
    
    [super.table reloadData];
    
  } else {
    // 检索字符串非空时, 进行实时检索
    _isSearching = YES;
    
    [_searchResultList removeAllObjects];
    
    for (CityInfo *cityInfo in _cityInfoList) {
      NSString *name = cityInfo.name;
      NSString *code = cityInfo.code;
      if ([NSString isEmpty:name] || [NSString isEmpty:code]) {
        continue;
      }
      
      if (![name hasPrefix:searchText] && ![code hasPrefix:searchText]) {
        continue;
      }
      
      [_searchResultList addObject:cityInfo];
    }
    
    [super.table reloadData];
  }
}

// called before text changes
//- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text NS_AVAILABLE_IOS(3_0);

// 当点击键盘中的 "搜素" 按钮后触发的事件
// called when keyboard search button pressed
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
  [_citySearchBar resignFirstResponder];
  
  //
  NSArray *views = [searchBar subviews];
  for (id view in views) {
    if ([view isKindOfClass:[UIButton class]]) {
      UIButton *cancelButton = view;
      
      [cancelButton setEnabled:YES];
      break;
    }
  }
}

// called when bookmark button pressed
//- (void)searchBarBookmarkButtonClicked:(UISearchBar *)searchBar;

// called when cancel button pressed
- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar {
  _isSearching = NO;
  [_searchResultList removeAllObjects];
  _citySearchBar.text = @"";
	[_citySearchBar setShowsCancelButton:NO animated:YES];
	[_citySearchBar resignFirstResponder];
  // 退出搜索状态时, 要关闭table 的向下滑动属性
  super.table.bounces = YES;
  [super.table reloadData];
}

// called when search results button pressed
//- (void)searchBarResultsListButtonClicked:(UISearchBar *)searchBar NS_AVAILABLE_IOS(3_2);

//- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope NS_AVAILABLE_IOS(3_0);


#pragma mark -
#pragma mark 网络请求相关方法群

-(NSInteger)requestCityList{
  CitysNetRequestBean *netRequestBean
  = [CitysNetRequestBean citysNetRequestBean];
  NSInteger netRequestIndex
  = [[DomainProtocolNetHelperSingleton sharedInstance] requestDomainProtocolWithContext:self
                                                                   andRequestDomainBean:netRequestBean
                                                                        andRequestEvent:kNetRequestTagEnum_SearchCity
                                                                     andRespondDelegate:self];
  return netRequestIndex;
}

typedef enum {
  //
  kHandlerMsgTypeEnum_ShowNetErrorMessage = 0,
  //
  kHandlerMsgTypeEnum_RefreshUIForTableView
} HandlerMsgTypeEnum;

typedef enum {
  //
  kHandlerExtraDataTypeEnum_NetRequestTag = 0,
  //
  kHandlerExtraDataTypeEnum_NetErrorMessage
} HandlerExtraDataTypeEnum;

- (void) handleMessage:(Message *) msg {
  PRPLog(@"%@ -> handleMessage --- start ! ", TAG);
  
  [super doneLoadingTableViewData];
  
  switch (msg.what) {
      
    case kHandlerMsgTypeEnum_ShowNetErrorMessage:{
      
      NSString *netErrorMessageString
      = [msg.data objectForKey:[NSNumber numberWithUnsignedInteger:kHandlerExtraDataTypeEnum_NetErrorMessage]];
      
      [SVProgressHUD showErrorWithStatus:netErrorMessageString];
      
      [_preloadingUIToolBar showRefreshButton:YES];
      
    }break;
      
    case kHandlerMsgTypeEnum_RefreshUIForTableView:{
      
      // 关闭 "界面预加载UI"
      [_preloadingUIToolBar dismiss];
      
      // 显示真正的UI
      _bodyLayout.hidden = NO;
      
      // 更新UI数据
      [super.table reloadData];
    }break;
      
    default:
      break;
  }
}

- (void) clearNetRequestIndexByRequestEvent:(NSUInteger) requestEvent {
  if (kNetRequestTagEnum_SearchCity == requestEvent) {
    _netRequestIndexForSearchCity = IDLE_NETWORK_REQUEST_ID;
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
  
  if (requestEvent == kNetRequestTagEnum_SearchCity) {
    CitysNetRespondBean *citysNetRespondBean = respondDomainBean;
    //PRPLog(@"%@ -> %@", TAG, roomSearchNetRespondBean);
    
    // 缓存城市列表
    [GlobalDataCacheForMemorySingleton sharedInstance].cityInfoNetRespondBean = citysNetRespondBean;
    
    //
    [self initDataSourceForTableWithCitysNetRespondBean:citysNetRespondBean];
    
    // 刷新 推荐城市 TableView
    Message *msg = [Message obtain];
    msg.what = kHandlerMsgTypeEnum_RefreshUIForTableView;
    [self performSelectorOnMainThread:@selector(handleMessage:) withObject:msg waitUntilDone:NO];
  }
}

#pragma mark -
#pragma mark 实现 BroadcastReceiverDelegate 代理

//
-(void)registerBroadcastReceiver {
  
  IntentFilter *intentFilter = [IntentFilter intentFilter];
  // 向通知中心注册通知 : 获取用户当前地址 "成功"
  [intentFilter.actions addObject:[[NSNumber numberWithUnsignedInteger:kUserNotificationEnum_GetUserAddressSuccess] stringValue]];
  
  [self registerReceiver:intentFilter];
}

-(void)onReceive:(Intent *)intent {
  NSInteger userNotificationEnum = [[intent action] integerValue];
  switch (userNotificationEnum) {
      
    case kUserNotificationEnum_GetUserAddressSuccess:{
      if ([SimpleLocationHelperForBaiduLBS getLastMKAddrInfo] != nil) {
        [self loadCurrentCityInfoUI];
      }
    }break;
      
    default:{
      
    }break;
  }
}

#pragma mark -
#pragma mark 实现 ListActivity 向下滑动事件的响应方法
// This is the core method you should implement
- (void)reloadTableViewDataSource {
	_reloading = YES;
  
  do {
    
    if (_netRequestIndexForSearchCity != IDLE_NETWORK_REQUEST_ID) {
      break;
    }
    
    // 重新请求 "城市列表"
    _netRequestIndexForSearchCity = [self requestCityList];
    
    //
    return;
  } while (NO);
  
  // 20130223 tangzhihua : 不能在这里直接调用 doneLoadingTableViewData, 否则关不掉当前界面
  // Here you would make an HTTP request or something like that
  // Call [self doneLoadingTableViewData] when you are done
  [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:0.0];
}

@end
