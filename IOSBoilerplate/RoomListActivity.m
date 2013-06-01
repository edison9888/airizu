//
//  RoomListActivityViewController.m
//  airizu
//
//  Created by 唐志华 on 12-12-27.
//
//

#import "RoomListActivity.h"

// 独立控件
#import "TitleBar.h"
#import "DateBarForRoomListActivity.h"
#import "ToolBarForRoomListActivity.h"
#import "RoomInfoTableViewCell.h"
#import "RadioPopupList.h"

#import "RoomSearchDatabaseFieldsConstant.h"
#import "RoomInfo.h"
#import "RoomSearchNetRequestBean.h"
#import "RoomSearchNetRespondBean.h"

#import "DeviceInformation.h"

#import "NSDictionary+Helper.h"

#import "BaiduLBSSingleton.h"

#import "MacroConstantForThisProject.h"

#import "RoomFilterActivity.h"
#import "RoomDetailOfBasicInformationActivity.h"

#import "SVProgressHUD.h"
#import "NSString+Expand.h"
#import "GlobalDataCacheForMemorySingleton.h"

#import "BMapKit.h"

#import "RoomMapActivityByBaiduLBS.h"









static const NSString *const TAG = @"<RoomListActivity>";

// 房间搜索条件
NSString *const kIntentExtraTagForRoomListActivity_RoomSearchCriteria = @"RoomSearchCriteria";
// 标志当前是否是 "附近" 界面
NSString *const kIntentExtraTagForRoomListActivity_IsNearby = @"IsNearby";


// table cell 的高度
static const NSInteger kCellHeightForHintInfo = 40;
static const NSInteger kCellHeightForRoomInfo = 100;

// 房间搜索时, 每次最大请求房源条数
static const NSUInteger roomSearchMaxNumber = 10;








@interface RoomListActivity ()

///
@property (nonatomic, assign) BOOL isIncomingIntentValid;
@property (nonatomic, assign) TitleBar *titleBar;

/// 外部传入的数据
// 房源搜索条件
@property (nonatomic, retain) NSMutableDictionary *roomSearchCriteriaDictionary;


// 房源信息列表 - cell 对应的 nib
@property (nonatomic, retain) UINib *roomInfoTableCellUINib;

//
@property (nonatomic, assign) NSInteger netRequestIndexForRoomInfo;

// 和房源列表相关的数据, 如果更换了搜索条件, 这里的数据都要清空
@property (nonatomic, retain) NSMutableArray *roomInfoBeanList;// 房源信息业务Bean列表
@property (nonatomic, assign) NSUInteger roomTotalNumber;// 当前正在搜索的房源总数
@property (nonatomic, assign) NSUInteger roomSearchStartIndex;// 房间搜索时, 查询从哪行开始

//
@property (nonatomic, assign) DateBarForRoomListActivity *dateBar;
@property (nonatomic, assign) ToolBarForRoomListActivity *toolBar;

// 标志当前是否是 "附近" 界面
@property (nonatomic, assign) BOOL isNearby;
@property (nonatomic, assign) BOOL isPositioning;// 是否是在定位中...
@property(nonatomic, retain) SimpleLocationHelperForBaiduLBS *userLocationForBaiduLBS;

// 这是为了解决, 如果已经获取了一屏数据了, 此时网络断开, 那么在滑到最后一行时, 会不断的重新请求网络,
// 因为在 网络出现错误时, 我们要调用 [super.table reloadData]; 来重刷表格数据来显示 最后一行的错误信息.
@property (nonatomic, assign) BOOL isNetError;

@end








@implementation RoomListActivity

- (UINib *) roomInfoTableCellUINib {
  if (_roomInfoTableCellUINib == nil) {
    self.roomInfoTableCellUINib = [RoomInfoTableViewCell nib];
  }
  return _roomInfoTableCellUINib;
}

#pragma mark -
#pragma mark 内部枚举
typedef NS_ENUM(NSInteger, IntentRequestCodeEnum) {
  // 去 房间筛选 界面
  kIntentRequestCodeEnum_ToRoomFilterActivity = 0
};

//
typedef NS_ENUM(NSInteger, NetRequestTagEnum) {
  //
  kNetRequestTagEnum_RoomSearch = 0
};

#pragma mark -
#pragma mark 内部方法群
- (void)dealloc {
  PRPLog(@"dealloc: %@ [0x%x]", TAG, [self hash]);
  
  // 注销 "广播接收器"
  [self unregisterReceiver];
  
  //
  [_roomInfoTableCellUINib release];
  
  //
  [_roomSearchCriteriaDictionary release];
  //
  [_roomInfoBeanList release];
  
  //
  [_userLocationForBaiduLBS release];
  
  
  // UI相关
  [_titleBarPlaceholder release];
  [_dateBarPlaceholder release];
  [_toolBarPlaceholder release];
  [_bodyLayout release];
  [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  if ([DeviceInformation isIPhone5]) {
    // 这里决不能设成 autorelease 的, 网上的代码就是 autorelease的, 4.3系统会崩溃, 因为被自动释放了
    self = [super initWithNibName:@"RoomListActivity_iphone5" bundle:nibBundleOrNil];
  } else {
    self = [super initWithNibName:@"RoomListActivity" bundle:nibBundleOrNil];
  }
  if (self) {
    // Custom initialization
    PRPLog(@"init %@ [0x%x]", TAG, [self hash]);
    
    _netRequestIndexForRoomInfo = IDLE_NETWORK_REQUEST_ID;
    
    _isNearby = NO;
    _isPositioning = NO;
    
    _isNetError = NO;
    
    //
    self.roomSearchCriteriaDictionary = [NSMutableDictionary dictionaryWithCapacity:30];
    
    
    //
    self.roomInfoBeanList = [NSMutableArray arrayWithCapacity:200];
    _roomSearchStartIndex = 0;
    _roomTotalNumber = 0;
    
  }
  
  return self;
}

- (void)viewDidLoad
{
  PRPLog(@"%@ --> viewDidLoad ", TAG);
  
  [super viewDidLoad];
  // Do any additional setup after loading the view from its nib.
  
  /// 初始化UI
  [self initTitleBar];
  
  if (_isIncomingIntentValid) {
    
    [self initDateBar];
    [self initToolBar];
    
    if (_isNearby) {
      
      // 调整UI
      [self adjustUIForNearby];
      
    } else {
      // 查询目标条件对应的房源
      _netRequestIndexForRoomInfo = [self requestRoomInfoList];
    }
    
  } else {
    
    if (_isNearby) {
      
      // 这里是为 "附近界面, 出现传入数据错误时的, 特殊的处理"
      [self adjustUIForNearby];
      _titleBarPlaceholder.hidden = YES;
    }
    
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
  PRPLog(@"%@ --> viewDidUnload ", TAG);
  
  self.roomInfoTableCellUINib = nil;
  
  self.titleBar = nil;
  self.dateBar = nil;
  self.toolBar = nil;
  
  [self setTitleBarPlaceholder:nil];
  [self setDateBarPlaceholder:nil];
  [self setToolBarPlaceholder:nil];
  
  [self setBodyLayout:nil];
  [super viewDidUnload];
}

#pragma mark -
#pragma mark Activity 生命周期

-(BOOL)parseIncomingIntent:(Intent *)intent {
  do {
    
    if (intent == nil) {
      break;
    }
    
    NSNumber *isNearbyTest = [intent.extras objectForKey:kIntentExtraTagForRoomListActivity_IsNearby];
    if ([isNearbyTest isKindOfClass:[NSNumber class]]) {
      _isNearby = [isNearbyTest boolValue];
    } else {
      // 否则认为就不会 "附近界面"
      _isNearby = NO;
    }
    
    if (_isNearby) {
      
      /// 获取当前界面类型, 是否是附近
      if (_isNearby && [SimpleLocationHelperForBaiduLBS getLastLocation] == nil) {
        [self registerBroadcastReceiverForUserLocation];
      }
      
    } else {
      
      NSDictionary *roomSearchCriteriaTest = [intent.extras objectForKey:kIntentExtraTagForRoomListActivity_RoomSearchCriteria];
      if (![roomSearchCriteriaTest isKindOfClass:[NSDictionary class]] || [roomSearchCriteriaTest count] <= 0) {
        break;
      }
      
      /// 获取外部传进来的 房源搜索条件字典
      [_roomSearchCriteriaDictionary setDictionary:roomSearchCriteriaTest];
    }
    
    // 一切OK
    return YES;
  } while (false);
  
  // 出现问题
  
  return NO;
}


-(void)onCreate:(Intent *)intent{
  PRPLog(@"%@ --> onCreate ", TAG);
  
  self.isIncomingIntentValid = [self parseIncomingIntent:intent];
}

-(void)onResume {
  PRPLog(@"%@ --> onResume ", TAG);
  
  if (_isNearby) {
    [self queryNearbyRoomsForUser];
  }
}

-(void)onPause {
  PRPLog(@"%@ --> onPause ", TAG);
  
  if (_reloading) {
    [super doneLoadingTableViewData];
  }
  
  [SVProgressHUD dismiss];
  
  [[DomainProtocolNetHelperSingleton sharedInstance] cancelNetRequestByRequestIndex:_netRequestIndexForRoomInfo];
  _netRequestIndexForRoomInfo = IDLE_NETWORK_REQUEST_ID;
}

- (void) onActivityResult:(int) requestCode
               resultCode:(int) resultCode
                     data:(Intent *) data {
  PRPLog(@"%@ onActivityResult", TAG);
  
  if (requestCode == kIntentRequestCodeEnum_ToRoomFilterActivity) {
    do {
      if (resultCode != kActivityResultCode_RESULT_OK) {
        break;
      }
      if (![data isKindOfClass:[Intent class]]) {
        // 异常
        break;
      }
      NSDictionary *newRoomSearchCriteriaDictionary = [data.extras objectForKey:kIntentExtraTagForRoomListActivity_RoomSearchCriteria];
      if (![newRoomSearchCriteriaDictionary isKindOfClass:[NSDictionary class]]) {
        // 异常
        break;
      }
      if (newRoomSearchCriteriaDictionary.count <= 0) {
        // 异常
        break;
      }
      
      // 检测 房源搜索条件是否发生改变
      if (![self isRoomSearchCriteriaChanged:newRoomSearchCriteriaDictionary]) {
        break;
      }
      
      // 用户更改了房源搜索条件, 我们要重新查询房源信息
      [self setTitleNameUseRoomSearchCriteriaDictionary:newRoomSearchCriteriaDictionary];
      self.roomSearchCriteriaDictionary = (NSMutableDictionary *)newRoomSearchCriteriaDictionary;
      
      // 重刷当前房源搜索条件对应的房源信息
      _roomSearchStartIndex = 0;
      //
      _netRequestIndexForRoomInfo = [self requestRoomInfoList];
      if (_netRequestIndexForRoomInfo != IDLE_NETWORK_REQUEST_ID) {
        
        // 复位 TableView 的scroll 位置
        [self scrollToFirstRowForTableView];
        
        [SVProgressHUD showWithStatus:@"联网中..."];
      }
      
    } while (NO);
  }
}

#pragma mark -
#pragma mark 初始化UI

-(void)adjustUIForNearby{
  
  [_titleBarPlaceholder setFrame:CGRectZero];
  _bodyLayout.frame = CGRectMake(0, 0, CGRectGetWidth(_bodyLayout.frame), CGRectGetHeight(_bodyLayout.frame));
}

-(void)setTitleNameUseRoomSearchCriteriaDictionary:(NSDictionary *)roomSearchCriteriaDictionary{
  
  if (_titleBar != nil && roomSearchCriteriaDictionary != nil) {
    NSString *titleName = nil;
    NSString *cityName = [roomSearchCriteriaDictionary objectForKey:kRoomSearch_RequestKey_cityName];
    NSString *streetName = [roomSearchCriteriaDictionary objectForKey:kRoomSearch_RequestKey_streetName];
    if ([NSString isEmpty:streetName]) {
      titleName = cityName;
    } else {
      titleName = [NSString stringWithFormat:@"%@-%@", cityName, streetName];
    }
    [_titleBar setTitleByString:titleName];
  }
  
}
//
- (void) initTitleBar {
  
  
  self.titleBar = [TitleBar titleBar];
  [self setTitleNameUseRoomSearchCriteriaDictionary:_roomSearchCriteriaDictionary];
  _titleBar.delegate = self;
  [_titleBar hideLeftButton:NO];
  [self.titleBarPlaceholder addSubview:_titleBar];
  
  
}

// 房源列表界面中, "入住时间" "退房时间" "房源数量"
- (void) initDateBar {
  DateBarForRoomListActivity *dateBar = [DateBarForRoomListActivity dateBar];
  NSString *checkInDate = [_roomSearchCriteriaDictionary objectForKey:kRoomSearch_RequestKey_checkinDate];
  if (![NSString isEmpty:checkInDate]) {
    [dateBar setCheckinDate:checkInDate];
  }
  NSString *checkOutDate = [_roomSearchCriteriaDictionary objectForKey:kRoomSearch_RequestKey_checkoutDate];
  if (![NSString isEmpty:checkOutDate]) {
    [dateBar setCheckoutDate:checkOutDate];
  }
  [self.dateBarPlaceholder addSubview:dateBar];
  
  self.dateBar = dateBar;
}

// toolsbar : 筛选按钮/排序按钮/地图按钮
- (void) initToolBar {
  ToolBarForRoomListActivity *toolBar = [ToolBarForRoomListActivity toolBar];
  
  // 设置按钮监听
  toolBar.filterButton.tag = kButtonTagInToolBarEnum_FilterButton;
  [toolBar.filterButton addTarget:self action:@selector(toolBarOnClickListener:) forControlEvents:UIControlEventTouchUpInside];
  toolBar.sortButton.tag = kButtonTagInToolBarEnum_SortButton;
  [toolBar.sortButton addTarget:self action:@selector(toolBarOnClickListener:) forControlEvents:UIControlEventTouchUpInside];
  toolBar.mapButton.tag = kButtonTagInToolBarEnum_MapButton;
  [toolBar.mapButton addTarget:self action:@selector(toolBarOnClickListener:) forControlEvents:UIControlEventTouchUpInside];
  
  [self.toolBarPlaceholder addSubview:toolBar];
  
  self.toolBar = toolBar;
}

// 移动 TableView 到第一行, 因为现在的设计是, 只有当前网络请求成功后, 才会清理掉 TableView 中旧的数据,
// 所以, 如果之前已经滑动表格到1屏后(数据已经超过了10条), 并且此时重新请求房源数据时, 在新请求的数据返回时, 会重新加载表格数据,
// 当加载完成后, 因为表格数据总数是10条, 那么 会触发 tableView:willDisplayCell:forRowAtIndexPath:
// 中关于 "滑动屏幕到最后一条时, 会自动请求下一屏数据的事件", 之前外包开发的App就有这个bug
-(void)scrollToFirstRowForTableView{
  NSIndexPath *firstIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
  [self.table scrollToRowAtIndexPath:firstIndexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
}

#pragma mark ToolBar (筛选/排序/地图) 功能按钮监听方法
typedef enum {
  // "筛选"
  kButtonTagInToolBarEnum_FilterButton = 0,
  // "排序"
  kButtonTagInToolBarEnum_SortButton,
  // "地图"
  kButtonTagInToolBarEnum_MapButton
} ButtonTagInToolBarEnum;

/**
 * 判断 "工具栏" 是否可用
 *
 * @return
 */
-(BOOL) toolsBarIsAvailable {
  do {
    if (_roomSearchCriteriaDictionary == nil || _roomSearchCriteriaDictionary.count <= 0) {
      break;
    }
    
    if (_isNearby) {
      if (![[BaiduLBSSingleton sharedInstance] gpsIsEnable]) {
        // 在附近界面时, 如果GPS没有打开, 是不允许使用 功能按钮的
        break;
      }
    }
    
    if (_netRequestIndexForRoomInfo != IDLE_NETWORK_REQUEST_ID) {
      // 上一个网络请求还未回来
      break;
    }
    return YES;
  } while (NO);
  
  return NO;
}

-(void)gotoRoomFilterActivity {
  Intent *intent = [Intent intentWithSpecificComponentClass:[RoomFilterActivity class]];
  [intent.extras setObject:_roomSearchCriteriaDictionary forKey:kIntentExtraTagForRoomFilterActivity_RoomSearchCriteria];
  if (_isNearby) {
    [intent.extras setObject:[NSNumber numberWithBool:YES] forKey:kIntentExtraTagForRoomFilterActivity_IsNearby];
  }
  [self startActivityForResult:intent requestCode:kIntentRequestCodeEnum_ToRoomFilterActivity];
}

-(void)gotoRoomMapActivity {
  Intent *intent = [Intent intentWithSpecificComponentClass:[RoomMapActivityByBaiduLBS class]];
  NSString *titleNameForRoomMapActivity = nil;
  
  UiTypeEnumForRoomMapActivity uiTypeEnum;
  if (_isNearby) {
    // 从 "附近"模块进入 "房源列表"
    if ([SimpleLocationHelperForBaiduLBS getLastMKAddrInfo] != nil) {
      NSString *district = [SimpleLocationHelperForBaiduLBS getLastMKAddrInfo].addressComponent.district;
      NSString *streetName = [SimpleLocationHelperForBaiduLBS getLastMKAddrInfo].addressComponent.streetName;
      titleNameForRoomMapActivity = [NSString stringWithFormat:@"%@%@", district, streetName];
    } else {
      titleNameForRoomMapActivity = @"附近";
    }
    
    uiTypeEnum = kUiTypeEnumForRoomMapActivity_GroupRoomForNearby;
  } else {
    // 从 "其他"模块进入 "房源列表"
    titleNameForRoomMapActivity = _titleBar.titleLabel.text;
    
    uiTypeEnum = kUiTypeEnumForRoomMapActivity_GroupRoomForCity;
  }
  
  if ([NSString isEmpty:titleNameForRoomMapActivity]) {
    // 容错
    titleNameForRoomMapActivity = @"地图界面";
  }
  ///
  [intent.extras setObject:[NSNumber numberWithUnsignedInteger:uiTypeEnum] forKey:kIntentExtraTagForRoomMapActivity_UiType];
  [intent.extras setObject:_roomInfoBeanList forKey:kIntentExtraTagForRoomMapActivity_Data];
  [intent.extras setObject:titleNameForRoomMapActivity forKey:kIntentExtraTagForRoomMapActivity_TitleName];
  
  [self startActivity:intent];
}

- (void) toolBarOnClickListener:(id) sender {
  if (![self toolsBarIsAvailable]) {
    return;
  }
  
  UIButton *button = sender;
  switch (button.tag) {
      
    case kButtonTagInToolBarEnum_FilterButton:{// "筛选"
      [self gotoRoomFilterActivity];
    }break;
      
    case kButtonTagInToolBarEnum_SortButton:{// "排序"
      [SVProgressHUD dismiss];
      
      NSMutableArray *dataSource = [NSMutableArray array];
      [dataSource addObjectsFromArray:[[GlobalDataCacheForDataDictionary sharedInstance].dataSourceForSortTypeList allKeys]];
      // 业务逻辑 : 只有房源搜索条件中有 "地标" 时, 才显示 "距离由近到远" 这个选项.
      NSString *streetName = [_roomSearchCriteriaDictionary objectForKey:kRoomSearch_RequestKey_streetName];
      if ([NSString isEmpty:streetName] && !_isNearby) {
        [dataSource removeLastObject];
      }
      // 业务逻辑 : 恢复上一次排序索引
      NSString *lastSortTypeValue = [_roomSearchCriteriaDictionary objectForKey:kRoomSearch_RequestKey_order];
      NSInteger defaultSelectedIndex = 0;
      if (![NSString isEmpty:lastSortTypeValue]) {
        NSArray *keys = [[GlobalDataCacheForDataDictionary sharedInstance].dataSourceForSortTypeList allKeysForObject:lastSortTypeValue];
        defaultSelectedIndex = [dataSource indexOfObject:[keys objectAtIndex:0]];
      } else {
        // 排序方式是不能为空的....
      }
      
      RadioPopupList *radioPopupList = [RadioPopupList radioPopupListWithTitle:@"房源排序" dataSource:dataSource delegate:self];
      [radioPopupList setDefaultSelectedIndex:defaultSelectedIndex];
      CGRect frameForRadioPopupList = CGRectMake(_bodyLayout.frame.origin.x,
                                                 _bodyLayout.frame.origin.y,
                                                 _bodyLayout.frame.size.width,
                                                 [DeviceInformation screenHeight] - _bodyLayout.frame.origin.y);
      [radioPopupList setFrame:frameForRadioPopupList];
      [radioPopupList showInView:self.view];
    }break;
      
    case kButtonTagInToolBarEnum_MapButton:{// "地图"
      if (_roomInfoBeanList.count <= 0) {
        // 没有有效数据的时候, 不要进入地图Activity
        break;
      }
      
      [self gotoRoomMapActivity];
      
    }break;
      
    default:
      break;
  }
}

#pragma mark -
#pragma mark 实现 RadioPopupListDelegate 接口
- (void)radioPopupList:(RadioPopupList *)radioPopupList didSelectRowAtIndex:(NSUInteger)index {
  
  NSString *value = [radioPopupList objectAtIndex:index];
  NSString *lastSortTypeValue = [[GlobalDataCacheForDataDictionary sharedInstance].dataSourceForSortTypeList objectForKey:value];
  [_roomSearchCriteriaDictionary setObject:lastSortTypeValue forKey:kRoomSearch_RequestKey_order];
  
  // 重刷当前房源搜索条件对应的房源信息
  _roomSearchStartIndex = 0;
  //
  _netRequestIndexForRoomInfo = [self requestRoomInfoList];
  if (_netRequestIndexForRoomInfo != IDLE_NETWORK_REQUEST_ID) {
    
    // 复位 TableView 的scroll 位置
    [self scrollToFirstRowForTableView];
    
    [SVProgressHUD showWithStatus:@"联网中..."];
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
  if ([_roomInfoBeanList isKindOfClass:[NSArray class]] && _roomInfoBeanList.count > 0) {
    // 显示 table cell 分割线
    super.table.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    return _roomInfoBeanList.count + 1;
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
    if (_netRequestIndexForRoomInfo != IDLE_NETWORK_REQUEST_ID) {
      errorMessage = @"房源加载中...";
    } else if (_roomTotalNumber <= 0) {
      errorMessage = @"暂无房源";
    } else if (indexPath.row >= _roomTotalNumber) {
      errorMessage = @"暂无更多房源";
    } else if (_isNetError){
      errorMessage = @"网络访问错误";
    } else {
      errorMessage = @"房源加载中...";
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
    RoomInfoTableViewCell *cell
    = [RoomInfoTableViewCell cellForTableView:tableView fromNib:self.roomInfoTableCellUINib];
    // 关闭 TableViewCell 的点击响应
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // 初始化 TableViewCell 中的数据
    if (_roomInfoBeanList != nil && _roomInfoBeanList.count > 0 && row < _roomInfoBeanList.count) {
      BOOL isShowDistance = NO;
      NSString *streetName = [_roomSearchCriteriaDictionary objectForKey:kRoomSearch_RequestKey_streetName];
      if (![NSString isEmpty:streetName] || _isNearby) {
        isShowDistance = YES;
      }
      [cell initTableViewCellDataWithRoomInfo:[_roomInfoBeanList objectAtIndex:row] showDistance:isShowDistance];
      
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
    
    if (_roomInfoBeanList == nil || _roomInfoBeanList.count <= 0 || indexPath.row >= _roomInfoBeanList.count) {
      break;
    }
    RoomInfo *roomInfo = [_roomInfoBeanList objectAtIndex:indexPath.row];
    if (roomInfo == nil) {
      break;
    }
    NSNumber *roomNumber = roomInfo.roomId;
    if ([NSString isEmpty:[roomNumber stringValue]]) {
      break;
    }
    
    // 先停掉网络请求, 防止进入 "房间详情界面" 后, 房源列表被更换.
    [[DomainProtocolNetHelperSingleton sharedInstance] cancelNetRequestByRequestIndex:_netRequestIndexForRoomInfo];
    _netRequestIndexForRoomInfo = IDLE_NETWORK_REQUEST_ID;
    
    // 跳转 "房间详情" 界面
    Intent *intent = [Intent intentWithSpecificComponentClass:[RoomDetailOfBasicInformationActivity class]];
    [intent.extras setObject:roomNumber forKey:kIntentExtraTagForRoomDetailOfBasicInfoActivity_RoomNumber];
    [self startActivity:intent];
    
    return;
  } while (NO);
  
}

// 这个方法是返回每个 item 的高度, 这里不能调用 [tableView numberOfRowsInSection:] 会引起死循环
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  // 这里一定要小心, Array.count 是无符号类型, 那么在C语言语系下, 如果这里写成 (_roomInfoBeanList.count - 1) 的话
  // 如果count的值为0时, 那么根本不会得到 -1, 因为会转型成无符号整数, 就变成最大值了
  if (indexPath.row >= _roomInfoBeanList.count) {
    // table 最后一行作为信息显示
    return kCellHeightForHintInfo;
  } else {
    return kCellHeightForRoomInfo;
  }
}

- (UITableViewCellEditingStyle) tableView:(UITableView *) tableView
            editingStyleForRowAtIndexPath:(NSIndexPath *) indexPath {
  
  // 去掉右边的 delete 按钮
  return UITableViewCellEditingStyleNone;
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
    if (_netRequestIndexForRoomInfo != IDLE_NETWORK_REQUEST_ID) {
      // 本次网络数据还未请求回来
      break;
    }
    
    NSInteger row = indexPath.row;
    if (row + 1 < rows) {// 表格行索引从 0 开始
      // 没滑到列表最后一行
      break;
    }
    
    if (_roomInfoBeanList.count >= _roomTotalNumber) {
      // 暂无更多数据了
      break;
    }
    
    if (_isNetError) {
      _isNetError = NO;
      break;
    }
    
    _netRequestIndexForRoomInfo = [self requestRoomInfoList];
    if (_netRequestIndexForRoomInfo != IDLE_NETWORK_REQUEST_ID) {
      //[SVProgressHUD showWithStatus:@"联网中..."];
    }
  } while (NO);
  
}

#pragma mark -
#pragma mark 网络请求相关方法群

/**
 * 检测房源搜索条件是否有效(会尝试校正能够校正的错误)
 *
 * @param roomSearchCriteriaDictionary 房源搜索条件
 * @param isNearBy 是否是搜索用户附近的房源
 * @return
 */
static BOOL isValidRoomSearchCriteria(NSMutableDictionary *roomSearchCriteriaDictionary, BOOL isNearBy) {
  
  do {
    //
    if (![roomSearchCriteriaDictionary isKindOfClass:[NSMutableDictionary class]]) {
      //NSAssert(NO, @"入参 : 房源搜索条件字典 类型不是 NSMutableDictionary!");
      PRPLog(@"??????? 入参 : 房源搜索条件字典 类型不是 NSMutableDictionary!");
      break;
    }
    
    if (roomSearchCriteriaDictionary.count <= 0) {
      //NSAssert(NO, @"入参 : 房源搜索条件字典为空 !");
      PRPLog(@"??????? 入参 : 房源搜索条件字典为空 ");
      break;
    }
    
    // 房源排序方式
    NSString *order = [roomSearchCriteriaDictionary objectForKey:kRoomSearch_RequestKey_order];
    // 距离筛选( 500 , 1000, 3000)
    NSString *distance = [roomSearchCriteriaDictionary objectForKey:kRoomSearch_RequestKey_distance];
    // 地标名 (从 2.4 房间推荐 接口 可以获取, 另外可以从搜索界面中获取用户手动输入的地标.
		// 业务说明 : 带地标条件的搜索时, order默认是jla(由近及远), distance默认是3000
    NSString *streetName = [roomSearchCriteriaDictionary objectForKey:kRoomSearch_RequestKey_streetName];
    
    
    
    // 20130307 : 新确认的需求, 如果有 "房间价格" 字段时, 排序默认就是 "价格从低到高排序"
    NSString *priceDifference = [roomSearchCriteriaDictionary objectForKey:kRoomSearch_RequestKey_priceDifference];
    if (![NSString isEmpty:priceDifference]) {
      order = kRoomListOrderType_OrderByPriceLowToHeight;
      [roomSearchCriteriaDictionary setObject:order
                                       forKey:kRoomSearch_RequestKey_order];
    }
    
    
    if (isNearBy) {
      
      // 如要要搜索用户附近房源, 不需要 城市名称/ID
      [roomSearchCriteriaDictionary removeObjectForKey:kRoomSearch_RequestKey_cityId];
      [roomSearchCriteriaDictionary removeObjectForKey:kRoomSearch_RequestKey_cityName];
      // 如果是查询 用户附近的房源, 就不能有 "地标名", 要互斥
      [roomSearchCriteriaDictionary removeObjectForKey:kRoomSearch_RequestKey_streetName];
      // 如果是查询 用户附近的房源, 就不能有 "房屋位置 - 就是区ID/区名称", 要互斥
      [roomSearchCriteriaDictionary removeObjectForKey:kRoomSearch_RequestKey_districtId];
      [roomSearchCriteriaDictionary removeObjectForKey:kRoomSearch_RequestKey_districtName];
      
      NSString *nearby = [roomSearchCriteriaDictionary objectForKey:kRoomSearch_RequestKey_nearby];
      if ([NSString isEmpty:nearby]) {
        // 查询用户 "附近" 房源, 必须带 "nearby" 字段
        [roomSearchCriteriaDictionary setObject:kRoomSearchCriteriaDefaultValue_nearby forKey:kRoomSearch_RequestKey_nearby];
      }
      
      // 设置 经纬度
      NSString *locationLat = [roomSearchCriteriaDictionary objectForKey:kRoomSearch_RequestKey_locationLat];
      NSString *locationLng = [roomSearchCriteriaDictionary objectForKey:kRoomSearch_RequestKey_locationLng];
      if ([NSString isEmpty:locationLat] || [NSString isEmpty:locationLng]
          || [locationLat isEqualToString:@"0"] || [locationLng isEqualToString:@"0"]) {
        PRPLog(@" ??????? 查询用户附近房源时, locationLat && locationLng 字段 必须二者皆存在.");
        
        // 尝试恢复错误
        BMKUserLocation *userLocation = [SimpleLocationHelperForBaiduLBS getLastLocation];
        if (userLocation != nil) {
          // 经度
          NSNumber *locationLng = [NSNumber numberWithDouble:userLocation.location.coordinate.longitude];
          [roomSearchCriteriaDictionary setObject:[locationLng stringValue] forKey:kRoomSearch_RequestKey_locationLng];
          // 纬度
          NSNumber *locationLat = [NSNumber numberWithDouble:userLocation.location.coordinate.latitude];
          [roomSearchCriteriaDictionary setObject:[locationLat stringValue] forKey:kRoomSearch_RequestKey_locationLat];
          
        } else {
          PRPLog(@"%@ ??????? 恢复 经纬度参数失败.", TAG);
          break;
        }
        
      }
      
      // 如果搜索用户附近房源, 默认的排序是 : 距离由近到远
      if ([NSString isEmpty:order]) {
        [roomSearchCriteriaDictionary setObject:kRoomListOrderType_OrderByDistance
                                         forKey:kRoomSearch_RequestKey_order];
      }
      
      // 如果搜索用户附近房源, 默认的距离范围是 : 3公里
      if ([NSString isEmpty:distance]) {
        [roomSearchCriteriaDictionary setObject:kRoomSearchCriteriaDefaultValue_distance
                                         forKey:kRoomSearch_RequestKey_distance];
      }
      
      
    } else {
      
      
      // 非用户附近房源搜索, 不需要 nearby/经纬度 等字段
      [roomSearchCriteriaDictionary removeObjectForKey:kRoomSearch_RequestKey_nearby];
      [roomSearchCriteriaDictionary removeObjectForKey:kRoomSearch_RequestKey_locationLat];
      [roomSearchCriteriaDictionary removeObjectForKey:kRoomSearch_RequestKey_locationLng];
      
      // 城市id
      NSString *cityId = [roomSearchCriteriaDictionary objectForKey:kRoomSearch_RequestKey_cityId];
      // 城市名称
      NSString *cityName = [roomSearchCriteriaDictionary objectForKey:kRoomSearch_RequestKey_cityName];
      
      if ([NSString isEmpty:cityId] || [NSString isEmpty:cityName]) {
        PRPLog(@"%@ ??????? 查询非用户附近房源时 cityId 和 cityName 二者必有其一", TAG);
        break;
      }
      
      // 如果带有 "地标" 字段时, 如果 "排序类型" 和 "房源距离" 字段为空时, 要进行默认补全
      if (![NSString isEmpty:streetName]) {
        // 排序 : "由近及远"
        if ([NSString isEmpty:order]) {
          [roomSearchCriteriaDictionary setObject:kRoomListOrderType_OrderByDistance
                                           forKey:kRoomSearch_RequestKey_order];
        }
        // 距离 : 3公里
        if ([NSString isEmpty:distance]) {
          [roomSearchCriteriaDictionary setObject:kRoomSearchCriteriaDefaultValue_distance
                                           forKey:kRoomSearch_RequestKey_distance];
        }
        
      } else {
        
        // 如果搜索非用户附近房源, 默认的排序是 : 爱日租推荐
        if ([NSString isEmpty:order]) {
          [roomSearchCriteriaDictionary setObject:kRoomListOrderType_OrderByAirizuCommend
                                           forKey:kRoomSearch_RequestKey_order];
        }
        
        // 如果不是搜索用户附近房源, 并且搜索条件中, 没有目标地标时, 需要去掉 距离 字段
        [roomSearchCriteriaDictionary removeObjectForKey:kRoomSearch_RequestKey_distance];
      }
    }
    
    PRPLog(@"%@ 本次房源搜索条件有效!", TAG);
    return YES;
  } while (NO);
  
  PRPLog(@"%@ 本次房源搜索条件无效! ", TAG);
  return NO;
}

/**
 * 请求房源列表信息
 *
 * @param data 查询条件
 * @return
 */
-(NSInteger)requestRoomInfoListWithSearchCriteriaDictionary:(NSMutableDictionary *)roomSearchCriteriaDictionary
                                               withIsNearby:(BOOL)isNearby
                                       withRequestEventEnum:(NSUInteger)netRequestEventEnum
                                                withContext:(id)context
                                     withNetRespondDelegate:(id)netRespondDelegate
                                                 withOffset:(NSUInteger)offset
                                                    withMax:(NSUInteger)max
                                    withLastNetRequestIndex:(NSInteger)lastNetRequestIndex {
  
  do {
    
    PRPLog(@"%@ 入参房源搜索条件=%@", TAG, roomSearchCriteriaDictionary);
    
    BOOL isValid = isValidRoomSearchCriteria(roomSearchCriteriaDictionary, isNearby);
    PRPLog(@"%@ 校正后的房源搜索条件=%@", TAG, roomSearchCriteriaDictionary);
    if (!isValid) {
      NSAssert(NO, @"房源搜索条件无效");
      break;
    }
    
    RoomSearchNetRequestBean *roomSearchNetRequestBean = [[RoomSearchNetRequestBean alloc] init];
    
    // 城市id
    roomSearchNetRequestBean.cityId = [roomSearchCriteriaDictionary objectForKey:kRoomSearch_RequestKey_cityId];
    
    // 城市名称
    roomSearchNetRequestBean.cityName = [roomSearchCriteriaDictionary objectForKey:kRoomSearch_RequestKey_cityName];
    
    // 设置 是否是搜索 "用户附近" 的房源的标志位
    roomSearchNetRequestBean.nearby = [roomSearchCriteriaDictionary objectForKey:kRoomSearch_RequestKey_nearby];
    
    // 设置 经纬度
    roomSearchNetRequestBean.locationLat = [roomSearchCriteriaDictionary objectForKey:kRoomSearch_RequestKey_locationLat];
    roomSearchNetRequestBean.locationLng = [roomSearchCriteriaDictionary objectForKey:kRoomSearch_RequestKey_locationLng];
    
    // 地标名
    roomSearchNetRequestBean.streetName = [roomSearchCriteriaDictionary objectForKey:kRoomSearch_RequestKey_streetName];
    
    // 房源排序方式
    roomSearchNetRequestBean.order = [roomSearchCriteriaDictionary objectForKey:kRoomSearch_RequestKey_order];
    
    // 距离筛选
    roomSearchNetRequestBean.distance = [roomSearchCriteriaDictionary objectForKey:kRoomSearch_RequestKey_distance];
    
    
    // 入住时间
    roomSearchNetRequestBean.checkinDate = [roomSearchCriteriaDictionary objectForKey:kRoomSearch_RequestKey_checkinDate];
    
    // 退房时间
    roomSearchNetRequestBean.checkoutDate = [roomSearchCriteriaDictionary objectForKey:kRoomSearch_RequestKey_checkoutDate];
    
    // 入住人数
    roomSearchNetRequestBean.occupancyCount = [roomSearchCriteriaDictionary objectForKey:kRoomSearch_RequestKey_occupancyCount];
    
    // 房间编号
    roomSearchNetRequestBean.roomNumber = [roomSearchCriteriaDictionary objectForKey:kRoomSearch_RequestKey_roomNumber];
    
    // 价格区间
    roomSearchNetRequestBean.priceDifference = [roomSearchCriteriaDictionary objectForKey:kRoomSearch_RequestKey_priceDifference];
    
    // 区名称
    roomSearchNetRequestBean.districtName = [roomSearchCriteriaDictionary objectForKey:kRoomSearch_RequestKey_districtName];
    
    // 区ID
    roomSearchNetRequestBean.districtId = [roomSearchCriteriaDictionary objectForKey:kRoomSearch_RequestKey_districtId];
    
    // 房屋类型(可在 2.8 初始化字典 接口获取)
    roomSearchNetRequestBean.roomType = [roomSearchCriteriaDictionary objectForKey:kRoomSearch_RequestKey_roomType];
    
    // 出租方式(可在 2.8 初始化字典接口获取)
    roomSearchNetRequestBean.rentType = [roomSearchCriteriaDictionary objectForKey:kRoomSearch_RequestKey_rentType];
    
    // 设施设备(可在 2.8 初始化字典接口获取)
    roomSearchNetRequestBean.tamenities = [roomSearchCriteriaDictionary objectForKey:kRoomSearch_RequestKey_tamenities];
    
    // 设置 房源查询起始索引
    roomSearchNetRequestBean.offset = [[NSNumber numberWithInteger:offset] stringValue];
    roomSearchNetRequestBean.max = [[NSNumber numberWithInteger:max] stringValue];
    
    if (lastNetRequestIndex != IDLE_NETWORK_REQUEST_ID) {
      // 要注销上一次的房源请求.
      [[DomainProtocolNetHelperSingleton sharedInstance] cancelNetRequestByRequestIndex:lastNetRequestIndex];
    }
    lastNetRequestIndex = [[DomainProtocolNetHelperSingleton sharedInstance] requestDomainProtocolWithContext:context
                                                                                         andRequestDomainBean:roomSearchNetRequestBean
                                                                                              andRequestEvent:netRequestEventEnum
                                                                                           andRespondDelegate:netRespondDelegate];
    [roomSearchNetRequestBean release];
    
    return lastNetRequestIndex;
  } while (NO);
  
  return NO;
}


/**
 * 检查 "房间搜索条件" 是否有变化
 *
 * @param newRoomSearchCriteriaBundle
 * @return
 */
-(BOOL)isRoomSearchCriteriaChanged:(NSDictionary *)newRoomSearchCriteriaDictionary {
  
  if (![newRoomSearchCriteriaDictionary isKindOfClass:[NSDictionary class]] || newRoomSearchCriteriaDictionary.count <= 0) {
    // 入参异常
    return NO;
  }
  
  do {
    
    NSString *oldValue = @"";
    NSString *newValue = @"";
    
    if (!_isNearby) {
      //
      oldValue = [_roomSearchCriteriaDictionary objectForKey:kRoomSearch_RequestKey_streetName];
      newValue = [newRoomSearchCriteriaDictionary objectForKey:kRoomSearch_RequestKey_streetName];
      if (![NSString compareTwoStringsAreTheSameWithStringA:oldValue andStringB:newValue]) {
        break;
      }
      //
      oldValue = [_roomSearchCriteriaDictionary objectForKey:kRoomSearch_RequestKey_districtId];
      newValue = [newRoomSearchCriteriaDictionary objectForKey:kRoomSearch_RequestKey_districtId];
      if (![NSString compareTwoStringsAreTheSameWithStringA:oldValue andStringB:newValue]) {
        break;
      }
    }
    
    //
    oldValue = [_roomSearchCriteriaDictionary objectForKey:kRoomSearch_RequestKey_priceDifference];
    newValue = [newRoomSearchCriteriaDictionary objectForKey:kRoomSearch_RequestKey_priceDifference];
    if (![NSString compareTwoStringsAreTheSameWithStringA:oldValue andStringB:newValue]) {
      break;
    }
    //
    oldValue = [_roomSearchCriteriaDictionary objectForKey:kRoomSearch_RequestKey_rentType];
    newValue = [newRoomSearchCriteriaDictionary objectForKey:kRoomSearch_RequestKey_rentType];
    if (![NSString compareTwoStringsAreTheSameWithStringA:oldValue andStringB:newValue]) {
      break;
    }
    //
    oldValue = [_roomSearchCriteriaDictionary objectForKey:kRoomSearch_RequestKey_tamenities];
    newValue = [newRoomSearchCriteriaDictionary objectForKey:kRoomSearch_RequestKey_tamenities];
    if (![NSString compareTwoStringsAreTheSameWithStringA:oldValue andStringB:newValue]) {
      break;
    }
    //
    oldValue = [_roomSearchCriteriaDictionary objectForKey:kRoomSearch_RequestKey_order];
    newValue = [newRoomSearchCriteriaDictionary objectForKey:kRoomSearch_RequestKey_order];
    if (![NSString compareTwoStringsAreTheSameWithStringA:oldValue andStringB:newValue]) {
      break;
    }
    //
    oldValue = [_roomSearchCriteriaDictionary objectForKey:kRoomSearch_RequestKey_distance];
    newValue = [newRoomSearchCriteriaDictionary objectForKey:kRoomSearch_RequestKey_distance];
    if (![NSString compareTwoStringsAreTheSameWithStringA:oldValue andStringB:newValue]) {
      break;
    }
    
    // 搜索条没有变化
    return NO;
  } while (NO);
  
  // 搜索条件有变化
  return YES;
}

- (void) updateRoomTotalNumberLabel:(NSUInteger)roomTotal {
  [_dateBar setRoomTotal:[NSString stringWithFormat:@"共%d套房间", roomTotal]];
}

/**
 * 清理掉 房源列表 的数据
 */
- (void) clearListViewData {
  [self.roomInfoBeanList removeAllObjects];
  _roomSearchStartIndex = 0;
  _roomTotalNumber = 0;
  
  
  [self updateRoomTotalNumberLabel:0];
}

// 请求用户附近房源信息
-(void)requestRoomInfoListForUserNearby{
  
  // 只要调用本方法, 就证明已经获取到了用户当前坐标
  _isPositioning = NO;
  
  // 是否是 "附近房源" 的标志
  [_roomSearchCriteriaDictionary setObject:kRoomSearchCriteriaDefaultValue_nearby forKey:kRoomSearch_RequestKey_nearby];
  // 房源距离
  [_roomSearchCriteriaDictionary setObject:kRoomSearchCriteriaDefaultValue_distance forKey:kRoomSearch_RequestKey_distance];
  // 房源排序规则
  [_roomSearchCriteriaDictionary setObject:kRoomListOrderType_OrderByDistance forKey:kRoomSearch_RequestKey_order];
  
  // 经度
  NSNumber *locationLng = [NSNumber numberWithDouble:[GlobalDataCacheForMemorySingleton sharedInstance].lastLocation.location.coordinate.longitude];
  [_roomSearchCriteriaDictionary setObject:[locationLng stringValue] forKey:kRoomSearch_RequestKey_locationLng];
  // 纬度
  NSNumber *locationLat = [NSNumber numberWithDouble:[GlobalDataCacheForMemorySingleton sharedInstance].lastLocation.location.coordinate.latitude];
  [_roomSearchCriteriaDictionary setObject:[locationLat stringValue] forKey:kRoomSearch_RequestKey_locationLat];
  
  // 查询目标条件对应的房源
  _netRequestIndexForRoomInfo = [self requestRoomInfoList];
  if (_netRequestIndexForRoomInfo != IDLE_NETWORK_REQUEST_ID) {
    //[SVProgressHUD showWithStatus:@"联网中..."];
  }
}

-(void)sendGotoSearchActivityBroadcast {
  Intent *intent = [Intent intent];
  [intent setAction:[[NSNumber numberWithUnsignedInteger:kUserNotificationEnum_GotoSearchActivity] stringValue]];
  [self sendBroadcast:intent];
}

/**
 * 查询用户附近的房源信息 (这个方法每次进入 onResume 后只能调用一次)
 */
-(void)queryNearbyRoomsForUser {
  
  if (!_isNearby) {
    NSAssert(NO, @"只能在附近界面调用 queryNearbyRoomsForUser 方法");
    return;
  }
  
  if (![[BaiduLBSSingleton sharedInstance] gpsIsEnable]) {
    UIAlertView * alertView
    = [[UIAlertView alloc] initWithTitle:nil
                                 message:@"定位失败, 启动\"定位服务\"来允许\"爱日租\"确定您的位置"
                                delegate:self
                       cancelButtonTitle:@"确定"
                       otherButtonTitles:nil];
    [alertView show];
    [alertView release];
    
    // 要跳转到 "搜索界面"
    return;
  }
  
  if (_roomInfoBeanList.count <= 0) {
    
    if ([GlobalDataCacheForMemorySingleton sharedInstance].lastLocation != nil) {
      // 已经定位到用户当前坐标
      [self requestRoomInfoListForUserNearby];
      
    } else {
      
      // 还没有定位到用户当前的坐标, 先要定位用户的坐标, 然后在查询用户附近房源信息
      if (_userLocationForBaiduLBS != nil) {
        _userLocationForBaiduLBS.locationDelegate = nil;
        _userLocationForBaiduLBS.addrInfoDelegate = nil;
      }
      self.userLocationForBaiduLBS = [SimpleLocationHelperForBaiduLBS simpleLocationHelperForBaiduLBS];
      _userLocationForBaiduLBS.locationDelegate = self;
      _userLocationForBaiduLBS.addrInfoDelegate = self;
      
      [SVProgressHUD showWithStatus:@"定位中..."];
      
      _isPositioning = YES;
    }
  }
}

/**
 * 请求房源列表信息
 *
 * @param data 查询条件
 * @return
 */
- (NSInteger) requestRoomInfoList {
  
  return [self requestRoomInfoListWithSearchCriteriaDictionary:_roomSearchCriteriaDictionary
                                                  withIsNearby:_isNearby
                                          withRequestEventEnum:kNetRequestTagEnum_RoomSearch
                                                   withContext:self
                                        withNetRespondDelegate:self
                                                    withOffset:_roomSearchStartIndex
                                                       withMax:roomSearchMaxNumber
                                       withLastNetRequestIndex:_netRequestIndexForRoomInfo];
  
}

typedef enum {
  //
  kHandlerMsgTypeEnum_ShowNetErrorMessage = 0,
  //
  kHandlerMsgTypeEnum_RefreshUIForRoomInfoTable
} HandlerMsgTypeEnum;

typedef enum {
  //
  kHandlerExtraDataTypeEnum_NetRequestTag = 0,
  //
  kHandlerExtraDataTypeEnum_NetErrorMessage,
  //
  kHandlerExtraDataTypeEnum_RoomSearchNetRespondBean
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
      
      // 这里是对 向下拖动 table 时重刷房源信息时的复位操作.
      _roomSearchStartIndex =_roomInfoBeanList.count;
      // 因为是使用 table 的最后一个 item 作为显示各种信息之用的, 所以这里要reload table, 要更新提示信息.
      [super.table reloadData];
      
    }break;
      
    case kHandlerMsgTypeEnum_RefreshUIForRoomInfoTable:{
      
      //
      _isNetError = NO;
      
      RoomSearchNetRespondBean *roomSearchNetRespondBean
      = [msg.data objectForKey:[NSNumber numberWithUnsignedInteger:kHandlerExtraDataTypeEnum_RoomSearchNetRespondBean]];
      
      // 这里的设计是考虑, 用户向下拖动table时, 重刷本次房源搜索条件对应的房源信息,
      // 如果是这种情况, 就要先清理掉之前房源信息
      if (_roomSearchStartIndex <= 0 && _roomInfoBeanList.count > 0) {
        [_roomInfoBeanList removeAllObjects];
      }
      
      // 更新 房源总数
      _roomTotalNumber = [roomSearchNetRespondBean.roomCount integerValue];
      // 保存本次请求获取的房源列表信息
      [_roomInfoBeanList addObjectsFromArray:roomSearchNetRespondBean.roomInfoList];
      
      // 本次房源信息请求成功, 累加房源信息页数计数器
      _roomSearchStartIndex = _roomInfoBeanList.count;
      
      // 更新UI数据
      [self updateRoomTotalNumberLabel:_roomTotalNumber];
      [super.table reloadData];
      
      //
      [SVProgressHUD dismiss];
    }break;
      
    default:
      break;
  }
  
  
}


- (void) clearNetRequestIndexByRequestEvent:(NSUInteger) requestEvent {
  if (kNetRequestTagEnum_RoomSearch == requestEvent) {
    _netRequestIndexForRoomInfo = IDLE_NETWORK_REQUEST_ID;
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
  
  if (requestEvent == kNetRequestTagEnum_RoomSearch) {// 2.5房间搜索
    RoomSearchNetRespondBean *roomSearchNetRespondBean = respondDomainBean;
    //PRPLog(@"%@ -> %@", TAG, roomSearchNetRespondBean);
    
    // 刷新 推荐城市 TableView
    Message *msg = [Message obtain];
    msg.what = kHandlerMsgTypeEnum_RefreshUIForRoomInfoTable;
    [msg.data setObject:roomSearchNetRespondBean
                 forKey:[NSNumber numberWithUnsignedInteger:kHandlerExtraDataTypeEnum_RoomSearchNetRespondBean]];
    [self performSelectorOnMainThread:@selector(handleMessage:) withObject:msg waitUntilDone:NO];
  }
}

#pragma mark -
#pragma mark 实现 ListActivity 向下滑动事件的响应方法

// This is the core method you should implement
- (void)reloadTableViewDataSource {
	_reloading = YES;
  
  do {
    
    if (_netRequestIndexForRoomInfo != IDLE_NETWORK_REQUEST_ID) {
      break;
    }
    
    if (_isNearby && _isPositioning) {
      // 处于 "附近" 界面, 并且正在获取用户当前坐标中...
      break;
    }
    
    // 重刷当前房源搜索条件对应的房源信息
    _roomSearchStartIndex = 0;
    
    if (_isNearby) {
      // 重新查询用户附近房源
      [self requestRoomInfoListForUserNearby];
      
    } else {
      
      // 重新查询普通房源
      _netRequestIndexForRoomInfo = [self requestRoomInfoList];
    }
    
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

#pragma mark -
#pragma mark 实现 UIAlertViewDelegate 接口
// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
  // 发送跳转到 "搜索界面" 的广播消息, 因为当前界面处于 tabHost 控件区域内, 所以不能自己跳转到 tabHost 其他item项,
  // 只能通过发送一条 跳转广播消息, 让 MainNavigationActivity 来完成跳转.
  [self sendGotoSearchActivityBroadcast];
}

#pragma mark -
#pragma mark 实现 LocationDelegate 接口
// 用户当前坐标回调(经纬度)
- (void) locationCallback:(BMKUserLocation *)userLocation {
  // 注销接收 "获取用户坐标成功" 的广播消息
  [self unregisterReceiver];
  
  // 请求用户附近房源信息
  [self requestRoomInfoListForUserNearby];
}

#pragma mark -
#pragma mark 实现 AddrInfoDelegate 接口
// 用户当前位置信息回调(街道号码->街道名称->区县名称->城市名称->省份名称)
- (void) addrInfoCallback:(BMKAddrInfo *)location {
  // 发送 "获取用户当前地址信息成功" 的广播消息
  Intent *intent = [Intent intent];
  NSString *action = [[NSNumber numberWithUnsignedInteger:kUserNotificationEnum_GetUserAddressSuccess] stringValue];
  [intent setAction:action];
  [self sendBroadcast:intent];
}

#pragma mark -
#pragma mark 接收 "获取用户坐标成功" 广播消息
-(void)registerBroadcastReceiverForUserLocation {
  IntentFilter *intentFilter = [IntentFilter intentFilter];
  [intentFilter.actions addObject:[[NSNumber numberWithUnsignedInteger:kUserNotificationEnum_GetUserLocationSuccess] stringValue]];
  [self registerReceiver:intentFilter];
}
-(void)onReceive:(Intent *)intent {
  NSInteger userNotificationEnum = [[intent action] integerValue];
  
  if (userNotificationEnum == kUserNotificationEnum_GetUserLocationSuccess) {
    
    // 注销 "获取用户坐标代理"
    [_userLocationForBaiduLBS setLocationDelegate:nil];
    
    // 请求用户附近房源信息
    [self requestRoomInfoListForUserNearby];
  }
}

@end
