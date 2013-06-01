//
//  RoomFilter.m
//  airizu
//
//  Created by 唐志华 on 13-1-26.
//
//

#import "RoomFilterActivity.h"

#import "TitleBar.h"

#import "RoomSearchDatabaseFieldsConstant.h"

#import "DictionaryDatabaseFieldsConstant.h"
#import "DictionaryNetRequestBean.h"
#import "DictionaryNetRespondBean.h"
#import "RoomType.h"
#import "RentManner.h"
#import "Equipment.h"

#import "DistrictsDatabaseFieldsConstant.h"
#import "DistrictsNetRequestBean.h"
#import "DistrictsNetRespondBean.h"
#import "DistrictInfo.h"

#import "RoomListActivity.h"







static const NSString *const TAG = @"<PasswordForgetActivity>";


// 房间搜索条件
NSString *const kIntentExtraTagForRoomFilterActivity_RoomSearchCriteria = @"RoomSearchCriteria";
// 标志当前是否是 "附近" 界面
NSString *const kIntentExtraTagForRoomFilterActivity_IsNearby = @"IsNearby";





@interface RoomFilterActivity ()

///
@property (nonatomic, assign) BOOL isIncomingIntentValid;
@property (nonatomic, assign) TitleBar *titleBar;

/// 外部传入的数据
// 标志当前是否是 "附近" 界面
@property (nonatomic, assign) BOOL isNearby;
// 房源搜索条件
@property (nonatomic, retain) NSMutableDictionary *roomSearchCriteriaDictionary;

//
@property (nonatomic, assign) NSInteger netRequestIndexForDictionary;
@property (nonatomic, assign) NSInteger netRequestIndexForDistricts;

//
// 2.7 根据城市获取区县
@property (nonatomic, retain) DistrictsNetRespondBean *districtsNetRespondBean;

// 数据源
// "房屋位置"
@property (nonatomic, retain) OrderedDictionary *dataSourceForDistrictNameList;
// "出租方式"
@property (nonatomic, retain) OrderedDictionary *dataSourceForRentTypeList;
// "设施设备"
@property (nonatomic, retain) OrderedDictionary *dataSourceForEquipmentList;

@property (nonatomic, assign) CGRect layoutForStreetTextFiledFrame;

@end








@implementation RoomFilterActivity

//
typedef NS_ENUM(NSInteger, NetRequestTagEnum) {
  // 2.8 初始化字典
  kNetRequestTagEnum_Dictionary = 0,
  // 2.7 根据城市获取区县
  kNetRequestTagEnum_Districts
};

typedef NS_ENUM(NSInteger, RadioPopupListTypeTag) {
  // "房屋位置"
  kRadioPopupListTypeTag_DistrictName = 0,
  // "每晚价格"
  kRadioPopupListTypeTag_RoomPrice,
  // "出租方式"
  kRadioPopupListTypeTag_RentType
};



#pragma mark -
#pragma mark 内部方法群
- (void)dealloc {
  
  //
  [_roomSearchCriteriaDictionary release];
  
  //
  [_districtsNetRespondBean release];
  
  //
  [_dataSourceForDistrictNameList release];
  [_dataSourceForRentTypeList release];
  
  // UI
  [_titleBarPlaceholder release];
  [_layoutForFilterItems release];
  [_layoutForDistrictName release];
  [_layoutForRoomPrice release];
  [_layoutForRentType release];
  [_layoutForTamenities release];
  [_layoutForStreetTextFiled release];
  [_okButton release];
  [_districtNameButton release];
  [_roomPriceButton release];
  [_rentTypeButton release];
  [_tamenitiesButton release];
  [_streetTextField release];
  [_bodyLayout release];
  [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  if ([DeviceInformation isIPhone5]) {
    // 这里决不能设成 autorelease 的, 网上的代码就是 autorelease的, 4.3系统会崩溃, 因为被自动释放了
    self = [super initWithNibName:@"RoomFilterActivity_iphone5" bundle:nibBundleOrNil];
  } else {
    self = [super initWithNibName:@"RoomFilterActivity" bundle:nibBundleOrNil];
  }
  if (self) {
    // Custom initialization
    _isNearby = NO;
    //
    _roomSearchCriteriaDictionary = [[NSMutableDictionary alloc] initWithCapacity:30];
    
    _netRequestIndexForDictionary = IDLE_NETWORK_REQUEST_ID;
    _netRequestIndexForDistricts = IDLE_NETWORK_REQUEST_ID;
    
    //
    _dataSourceForDistrictNameList = [[OrderedDictionary alloc] init];
    _dataSourceForRentTypeList = [[OrderedDictionary alloc] init];
    _dataSourceForEquipmentList = [[OrderedDictionary alloc] init];
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  // Do any additional setup after loading the view from its nib.
  
  // 初始化UI
  [self initTitleBar];
  
  ///
  if (_isIncomingIntentValid) {
    
    // 如果是从附近界面进入的 "筛选界面", 就要隐藏 "房屋位置" 和 "地标输入框"
    if (_isNearby) {
      [self adjustUIForNearby];
    }
    
    if (!_isNearby) {
      
      // 请求 "区县信息"
      [self requestDistrictsWithCityId:[_roomSearchCriteriaDictionary objectForKey:kRoomSearch_RequestKey_cityId]];
    }
    
    // 如果 "数据字典" 本地没有缓存, 就直接从网络侧拉取.
    // 目前没有机会重新拉取 "数据字典", 所以这个只能做成是临时性缓存
    if ([GlobalDataCacheForMemorySingleton sharedInstance].dictionaryNetRespondBean == nil) {
      
      _netRequestIndexForDictionary = [self requestDictionary];
      
    } else {
      
      // 初始化 "出租方式" ListView 的数据源
      [self initRentTypeListViewDataSource];
      
      // 初始化 "设施设备" ListView 的数据源
      [self initEquipmentListViewDataSource];
    }
    
    // 复位之前的筛选项
    [self recoveryQueryHistory];
    
    // 记录 "地标输入框" 控件的位置坐标
    _layoutForStreetTextFiledFrame = _layoutForStreetTextFiled.frame;
    
    
    
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
  
  ///
  [self setTitleBarPlaceholder:nil];
  [self setLayoutForFilterItems:nil];
  [self setLayoutForDistrictName:nil];
  [self setLayoutForRoomPrice:nil];
  [self setLayoutForRentType:nil];
  [self setLayoutForTamenities:nil];
  [self setLayoutForStreetTextFiled:nil];
  [self setOkButton:nil];
  [self setDistrictNameButton:nil];
  [self setRoomPriceButton:nil];
  [self setRentTypeButton:nil];
  [self setTamenitiesButton:nil];
  [self setStreetTextField:nil];
  [self setBodyLayout:nil];
  [super viewDidUnload];
}

// "房屋位置"
- (IBAction)districtNameButtonOnClickListener:(id)sender {
  NSMutableArray *dataSource = [NSMutableArray array];
  [dataSource addObject:@"不限"];
  [dataSource addObjectsFromArray:[_dataSourceForDistrictNameList allKeys]];
  
  RadioPopupList *radioPopupList = [RadioPopupList radioPopupListWithTitle:@"房屋位置" dataSource:dataSource delegate:self];
  radioPopupList.tag = kRadioPopupListTypeTag_DistrictName;
  // 恢复上一次的选择结果
  NSString *lastValue = _districtNameButton.titleLabel.text;
  NSInteger defaultSelectedIndex = [dataSource indexOfObject:lastValue];
  [radioPopupList setDefaultSelectedIndex:defaultSelectedIndex];
  //
  [radioPopupList setFrame:CGRectMake(CGRectGetMinX(self.view.frame),
                                      CGRectGetMaxY(_titleBarPlaceholder.frame),
                                      CGRectGetWidth(self.view.frame),
                                      CGRectGetHeight(self.view.frame) - CGRectGetHeight(_titleBarPlaceholder.frame))];
  [radioPopupList showInView:self.view];
  
}

// "每晚价格"
- (IBAction)roomPriceButtonOnClickListener:(id)sender {
  NSMutableArray *dataSource = [NSMutableArray array];
  [dataSource addObject:@"不限"];
  [dataSource addObjectsFromArray:[[GlobalDataCacheForDataDictionary sharedInstance].dataSourceForPriceDifferenceList allKeys]];
  
  RadioPopupList *radioPopupList = [RadioPopupList radioPopupListWithTitle:@"房间价格" dataSource:dataSource delegate:self];
  radioPopupList.tag = kRadioPopupListTypeTag_RoomPrice;
  // 恢复上一次的选择结果
  NSString *lastValue = _roomPriceButton.titleLabel.text;
  NSInteger defaultSelectedIndex = [dataSource indexOfObject:lastValue];
  [radioPopupList setDefaultSelectedIndex:defaultSelectedIndex];
  //
  [radioPopupList setFrame:CGRectMake(CGRectGetMinX(self.view.frame),
                                      CGRectGetMaxY(_titleBarPlaceholder.frame),
                                      CGRectGetWidth(self.view.frame),
                                      CGRectGetHeight(self.view.frame) - CGRectGetHeight(_titleBarPlaceholder.frame))];
  [radioPopupList showInView:self.view];
}

// "出租方式"
- (IBAction)rentTypeButtonOnClickListener:(id)sender {
  NSMutableArray *dataSource = [NSMutableArray array];
  [dataSource addObject:@"不限"];
  [dataSource addObjectsFromArray:[_dataSourceForRentTypeList allKeys]];
  
  RadioPopupList *radioPopupList = [RadioPopupList radioPopupListWithTitle:@"出租方式" dataSource:dataSource delegate:self];
  radioPopupList.tag = kRadioPopupListTypeTag_RentType;
  // 恢复上一次的选择结果
  NSString *lastValue = _rentTypeButton.titleLabel.text;
  NSInteger defaultSelectedIndex = [dataSource indexOfObject:lastValue];
  [radioPopupList setDefaultSelectedIndex:defaultSelectedIndex];
  //
  [radioPopupList setFrame:CGRectMake(CGRectGetMinX(self.view.frame),
                                      CGRectGetMaxY(_titleBarPlaceholder.frame),
                                      CGRectGetWidth(self.view.frame),
                                      CGRectGetHeight(self.view.frame) - CGRectGetHeight(_titleBarPlaceholder.frame))];
  [radioPopupList showInView:self.view];
}

// "设施设备"
- (IBAction)tamenitiesButtonOnClickListener:(id)sender {
  NSMutableArray *dataSource = [NSMutableArray array];
  [dataSource addObject:@"不限"];
  [dataSource addObjectsFromArray:[_dataSourceForEquipmentList allKeys]];
  
  CheckBoxPopupList *checkBoxPopupList
  = [CheckBoxPopupList checkBoxPopupListWithTitle:@"设施设备"
                                       dataSource:dataSource delegate:self];
  NSString *oldData = [_tamenitiesButton titleForState:UIControlStateNormal];
  [checkBoxPopupList setSelectedCells:[oldData componentsSeparatedByString:@","]];
  
  //
  [checkBoxPopupList setFrame:CGRectMake(CGRectGetMinX(self.view.frame),
                                         CGRectGetMaxY(_titleBarPlaceholder.frame),
                                         CGRectGetWidth(self.view.frame),
                                         CGRectGetHeight(self.view.frame) - CGRectGetHeight(_titleBarPlaceholder.frame))];
  [checkBoxPopupList showInView:self.view];
  
}

// 设置 "房间位置"
/*
 业务说明 : 房间位置不是地标, 但是和地标有一定的互斥性
 */
-(void)setDistrict{
  
  NSString *districtName = nil;
  NSString *districtId = nil;
  
  do {
    if (_isNearby) {
      break;
    }
    
    districtName = [_districtNameButton titleForState:UIControlStateNormal];
    if ([NSString isEmpty:districtName] || [districtName isEqualToString:@"不限"]) {
      break;
    }
    districtId = [[_dataSourceForDistrictNameList objectForKey:districtName] stringValue];
    if ([NSString isEmpty:districtId]) {
      // 从数据源中没有取到有效数据
      break;
    }
    
    [_roomSearchCriteriaDictionary setObject:districtId forKey:kRoomSearch_RequestKey_districtId];
    [_roomSearchCriteriaDictionary setObject:districtName forKey:kRoomSearch_RequestKey_districtName];
    
    // "房间位置" 字段有效
    return;
  } while (NO);
  
  //
  [_roomSearchCriteriaDictionary removeObjectForKey:kRoomSearch_RequestKey_districtId];
  [_roomSearchCriteriaDictionary removeObjectForKey:kRoomSearch_RequestKey_districtName];
  return;
}

// 设置 "价格区间"
/*
 业务说明 : 只要设置了价格区间, 排序就一直使用 "按价格从低到高排序"
 */
-(void)setPriceDifference {
  
  NSString *priceDifferenceName = nil;
  NSString *priceDifferenceId = nil;
  
  do {
    priceDifferenceName = [_roomPriceButton titleForState:UIControlStateNormal];
    if ([NSString isEmpty:priceDifferenceName] || [priceDifferenceName isEqualToString:@"不限"]) {
      break;
    }
    priceDifferenceId
    = [[GlobalDataCacheForDataDictionary sharedInstance].dataSourceForPriceDifferenceList objectForKey:priceDifferenceName];
    if ([NSString isEmpty:priceDifferenceId]) {
      break;
    }
    
    [_roomSearchCriteriaDictionary setObject:priceDifferenceId forKey:kRoomSearch_RequestKey_priceDifference];
    return;
  } while (NO);
  
  [_roomSearchCriteriaDictionary removeObjectForKey:kRoomSearch_RequestKey_priceDifference];
  return;
}

// 设置 "出租方式"
-(void)setRentType {
  
  NSString *rentTypeName = nil;
  NSString *rentTypeId = nil;
  
  do {
    rentTypeName = [_rentTypeButton titleForState:UIControlStateNormal];
    if ([NSString isEmpty:rentTypeName] || [rentTypeName isEqualToString:@"不限"]) {
      break;
    }
    
    rentTypeId = [_dataSourceForRentTypeList objectForKey:rentTypeName];
    if ([NSString isEmpty:rentTypeId]) {
      break;
    }
    
    [_roomSearchCriteriaDictionary setObject:rentTypeId forKey:kRoomSearch_RequestKey_rentType];
    
    return;
  } while (NO);
  
  [_roomSearchCriteriaDictionary removeObjectForKey:kRoomSearch_RequestKey_rentType];
  return;
}

// 设置 "设施设备"
-(void)setTamenities {
  
  NSString *tamenitiesName = nil;
  NSString *tamenitiesId = nil;
  
  do {
    tamenitiesName = [_tamenitiesButton titleForState:UIControlStateNormal];
    if ([NSString isEmpty:tamenitiesName] || [tamenitiesName isEqualToString:@"不限"]) {
      break;
    }
    
    NSMutableArray *tamenitieIdArray = [NSMutableArray array];
    NSArray *tamenitieNameArray = [tamenitiesName componentsSeparatedByString:@","];
    for (NSString *name in tamenitieNameArray) {
      NSString *equipmentId = [_dataSourceForEquipmentList objectForKey:name];
      if (![NSString isEmpty:equipmentId]) {
        [tamenitieIdArray addObject:equipmentId];
      }
    }
    tamenitiesId = [tamenitieIdArray componentsJoinedByString:@","];
    [_roomSearchCriteriaDictionary setObject:tamenitiesId forKey:kRoomSearch_RequestKey_tamenities];
    
    return;
  } while (NO);
  
  [_roomSearchCriteriaDictionary removeObjectForKey:kRoomSearch_RequestKey_tamenities];
  return;
}

// 设置 "地标名称"
-(void)setStreetName {
  
  do {
    if (_isNearby) {
      break;
    }
    
    // 当前 "地标名称"
    NSString *newStreetName = [_streetTextField text];
    // 之前的 "地标名称"
    NSString *oldStreetName = [_roomSearchCriteriaDictionary objectForKey:kRoomSearch_RequestKey_streetName];
    if ([NSString isEmpty:newStreetName]) {
      break;
    }
    
    if (![newStreetName isEqualToString:oldStreetName]) {
      // 用户修改了地标名称
      [_roomSearchCriteriaDictionary setObject:newStreetName forKey:kRoomSearch_RequestKey_streetName];
      [_roomSearchCriteriaDictionary setObject:kRoomListOrderType_OrderByDistance forKey:kRoomSearch_RequestKey_order];
    }
    return;
  } while (NO);
  
  [_roomSearchCriteriaDictionary removeObjectForKey:kRoomSearch_RequestKey_streetName];
  [_roomSearchCriteriaDictionary removeObjectForKey:kRoomSearch_RequestKey_distance];
  return;
}

// "确定按钮"
- (IBAction)okButtonOnClickListener:(id)sender {
  
  // "房屋位置"
  [self setDistrict];
  
  // "每晚价格"
  [self setPriceDifference];
  
  // "出租方式"
  [self setRentType];
  
  // "设施设备"
  [self setTamenities];
  
  // "地标名称"
  [self setStreetName];
  
  //
  Intent *intent = [Intent intent];
  [intent.extras setObject:_roomSearchCriteriaDictionary forKey:kIntentExtraTagForRoomListActivity_RoomSearchCriteria];
  [self setResult:kActivityResultCode_RESULT_OK data:intent];
  
  [self finish];
}

#pragma mark -
#pragma mark Activity 生命周期

-(BOOL)parseIncomingIntent:(Intent *)intent {
  do {
    
    if (intent == nil) {
      break;
    }
    
    id roomSearchCriteriaTest
    = [intent.extras objectForKey:kIntentExtraTagForRoomFilterActivity_RoomSearchCriteria];
    if (![roomSearchCriteriaTest isKindOfClass:[NSDictionary class]]) {
      NSAssert(NO, @"外传传入的Intent中有错误参数 : RoomSearchCriteria");
      break;
    }
    [_roomSearchCriteriaDictionary addEntriesFromDictionary:roomSearchCriteriaTest];
    
    id isNearbyTest = [intent.extras objectForKey:kIntentExtraTagForRoomFilterActivity_IsNearby];
    if ([isNearbyTest isKindOfClass:[NSNumber class]]) {
      _isNearby = [isNearbyTest boolValue];
    } else {
      _isNearby = NO;
    }
    //
    
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
  
  [self closeKeyBord:nil];
  
  [SVProgressHUD dismiss];
  
  [[DomainProtocolNetHelperSingleton sharedInstance] cancelAllNetRequestWithThisNetRespondDelegate:self];
  _netRequestIndexForDictionary = IDLE_NETWORK_REQUEST_ID;
  _netRequestIndexForDistricts = IDLE_NETWORK_REQUEST_ID;
}

-(void)onResume {
  PRPLog(@"%@ --> onResume ", TAG);
}

#pragma mark -
#pragma mark 关闭输入框键盘
- (IBAction)closeKeyBord:(id)sender{
  [_streetTextField resignFirstResponder];
}

#pragma mark -
#pragma mark 实现 UITextFieldDelegate 代理

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
  [_streetTextField resignFirstResponder];
  return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
  _layoutForFilterItems.hidden = YES;
  _okButton.hidden = YES;
	[_layoutForStreetTextFiled setFrame:CGRectMake(10, CGRectGetMinY(_layoutForFilterItems.frame), CGRectGetWidth(_layoutForStreetTextFiled.frame), CGRectGetHeight(_layoutForStreetTextFiled.frame))];
	[_layoutForStreetTextFiled setNeedsDisplay];
	return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
	_layoutForFilterItems.hidden = NO;
  _okButton.hidden = NO;
	[_layoutForStreetTextFiled setFrame:CGRectMake(10, CGRectGetMinY(_layoutForStreetTextFiledFrame), CGRectGetWidth(_layoutForStreetTextFiled.frame), CGRectGetHeight(_layoutForStreetTextFiled.frame))];
	[_layoutForStreetTextFiled setNeedsDisplay];
	return YES;
}

#pragma mark -
#pragma mark 初始化UI
//
- (void) initTitleBar {
  TitleBar *titleBar = [TitleBar titleBar];
  titleBar.delegate = self;
  [titleBar setTitleByString:@"筛选"];
  [titleBar hideLeftButton:NO];
  [self.titleBarPlaceholder addSubview:titleBar];
  
  self.titleBar = titleBar;
}

// 如果是从附近界面进入的 "筛选界面", 就要隐藏 "房屋位置" 和 "地标输入框"
-(void)adjustUIForNearby{
  CGRect layoutForDistrictNameFrame = _layoutForDistrictName.frame;
  CGRect layoutForRoomPriceFrame = _layoutForRoomPrice.frame;
  CGRect layoutForRentTypeFrame = _layoutForRentType.frame;
  CGRect layoutForTamenitiesFrame = _layoutForTamenities.frame;
  
  CGRect layoutForStreetFrame = _layoutForStreetTextFiled.frame;
  CGRect okButtonFrame = _okButton.frame;
  
  _layoutForDistrictName.hidden = YES;
  _layoutForStreetTextFiled.hidden = YES;
  
  // "每晚价格"
  [_layoutForRoomPrice setFrame:CGRectMake(layoutForRoomPriceFrame.origin.x,
                                           layoutForDistrictNameFrame.origin.y,
                                           CGRectGetWidth(layoutForRoomPriceFrame),
                                           CGRectGetHeight(layoutForRoomPriceFrame))];
  UIImageView *bgImage = (UIImageView *)_layoutForRoomPrice.subviews[0];
  if ([bgImage isKindOfClass:[UIImageView class]]) {
    [bgImage setImage:[UIImage imageNamed:@"textfield_bg_up.png"]];
  }
  
  // "出租方式"
  [_layoutForRentType setFrame:CGRectMake(layoutForRentTypeFrame.origin.x,
                                          layoutForRentTypeFrame.origin.y - CGRectGetHeight(layoutForDistrictNameFrame),
                                          CGRectGetWidth(layoutForRentTypeFrame),
                                          CGRectGetHeight(layoutForRentTypeFrame))];
  // "设施设备"
  [_layoutForTamenities setFrame:CGRectMake(layoutForTamenitiesFrame.origin.x,
                                            layoutForTamenitiesFrame.origin.y - CGRectGetHeight(layoutForDistrictNameFrame),
                                            CGRectGetWidth(layoutForTamenitiesFrame),
                                            CGRectGetHeight(layoutForTamenitiesFrame))];
  // "确定按钮"
  [_okButton setFrame:CGRectMake(okButtonFrame.origin.x,
                                 layoutForStreetFrame.origin.y - CGRectGetHeight(layoutForDistrictNameFrame),
                                 CGRectGetWidth(okButtonFrame),
                                 CGRectGetHeight(okButtonFrame))];
}

/**
 * 复位 "房屋位置" 的查询条件
 *
 * @param oldData
 */
-(void)recoveryDistrictName:(NSString *)oldData {
  do {
    if ([NSString isEmpty:oldData]) {
      break;
    }
    
    [_districtNameButton setTitle:oldData forState:UIControlStateNormal];
  } while (NO);
}

/**
 * 复位 "每晚价格" 的查询条件
 *
 * @param oldData
 */
-(void)recoveryPriceDifference:(NSString *)oldData {
  do {
    if ([NSString isEmpty:oldData]) {
      break;
    }
    
    NSArray *keysForObject = [[GlobalDataCacheForDataDictionary sharedInstance].dataSourceForPriceDifferenceList allKeysForObject:oldData];
    if ([keysForObject count] <= 0) {
      break;
    }
    
    [_roomPriceButton setTitle:[keysForObject objectAtIndex:0] forState:UIControlStateNormal];
  } while (NO);
}

/**
 * 复位 "出租方式" 的查询条件
 *
 * @param oldData
 */
-(void)recoveryRentType:(NSString *)oldData {
  do {
    if ([NSString isEmpty:oldData]) {
      break;
    }
    
    if ([GlobalDataCacheForMemorySingleton sharedInstance].dictionaryNetRespondBean == nil) {
      break;
    }
    
    NSArray *rentManners = [GlobalDataCacheForMemorySingleton sharedInstance].dictionaryNetRespondBean.rentManners;
    if (rentManners == nil || rentManners.count <= 0) {
      break;
    }
    
    for (RentManner *rentManner in rentManners) {
      if ([rentManner.rentalWayId isEqualToString:oldData]) {
        [_rentTypeButton setTitle:rentManner.rentalWayName forState:UIControlStateNormal];
        break;
      }
    }
  } while (NO);
}

/**
 * 复位 "设施设备" 的查询条件
 *
 * @param oldData
 */
-(void)recoveryTamenities:(NSString *)oldData {
  do {
    if ([NSString isEmpty:oldData]) {
      break;
    }
    
    NSMutableArray *tamenitieNameArray = [NSMutableArray array];
    NSArray *tamenitieIdArray = [oldData componentsSeparatedByString:@","];
    for (NSString *tamenitieId in tamenitieIdArray) {
      NSArray *keys = [_dataSourceForEquipmentList allKeys];
      for (NSString *key in keys) {
        NSString *value = [_dataSourceForEquipmentList objectForKey:key];
        if ([tamenitieId isEqualToString:value]) {
          [tamenitieNameArray addObject:key];
          break;
        }
      }
    }
    NSString *titleForButton = [tamenitieNameArray componentsJoinedByString:@","];
    
    [_tamenitiesButton setTitle:titleForButton forState:UIControlStateNormal];
  } while (NO);
}

/**
 * 复位 "地标名称" 的查询条件
 *
 * @param oldData
 */
-(void)recoveryStreetName:(NSString *)oldData {
  do {
    if ([NSString isEmpty:oldData]) {
      break;
    }
    
    [_streetTextField setText:oldData];
  } while (false);
}

// 恢复之前的查询历史
-(void)recoveryQueryHistory {
  
  // "房屋位置"
  NSString *districtName = [_roomSearchCriteriaDictionary objectForKey:kRoomSearch_RequestKey_districtName];
  [self recoveryDistrictName:districtName];
  
  // "每晚价格"
  NSString *priceDifference = [_roomSearchCriteriaDictionary objectForKey:kRoomSearch_RequestKey_priceDifference];
  [self recoveryPriceDifference:priceDifference];
  
  // "出租方式"
  NSString *rentType = [_roomSearchCriteriaDictionary objectForKey:kRoomSearch_RequestKey_rentType];
  [self recoveryRentType:rentType];
  
  // "设施设备"
  NSString *tamenities = [_roomSearchCriteriaDictionary objectForKey:kRoomSearch_RequestKey_tamenities];
  [self recoveryTamenities:tamenities];
  
  // "地标名称"
  NSString *streetName = [_roomSearchCriteriaDictionary objectForKey:kRoomSearch_RequestKey_streetName];
  [self recoveryStreetName:streetName];
}

/**
 * 初始化 "房屋位置" ListView 的数据源
 */
-(void)initDistrictNameListViewDataSource {
  do {
    if (_districtsNetRespondBean == nil) {
      break;
    }
    
    NSArray *districtInfoList = _districtsNetRespondBean.districtInfoList;
    if (districtInfoList == nil || districtInfoList.count <= 0) {
      break;
    }
    
    NSInteger index = 0;
    for (DistrictInfo *districtInfo in districtInfoList) {
      [_dataSourceForDistrictNameList insertObject:districtInfo.ID forKey:districtInfo.name atIndex:index++];
    }
  } while (NO);
}

/**
 * 初始化 "出租方式" ListView 的数据源
 */
-(void)initRentTypeListViewDataSource {
  do {
    if ([GlobalDataCacheForMemorySingleton sharedInstance].dictionaryNetRespondBean == nil) {
      break;
    }
    
    NSArray *rentManners = [GlobalDataCacheForMemorySingleton sharedInstance].dictionaryNetRespondBean.rentManners;
    if (rentManners == nil || rentManners.count <= 0) {
      break;
    }
    
    NSInteger index = 0;
    for (RentManner *rentManner in rentManners) {
      [_dataSourceForRentTypeList insertObject:rentManner.rentalWayId forKey:rentManner.rentalWayName atIndex:index++];
    }
  } while (false);
}

// 初始化 "设施设备" ListView 的数据源
-(void)initEquipmentListViewDataSource {
  do {
    if ([GlobalDataCacheForMemorySingleton sharedInstance].dictionaryNetRespondBean == nil) {
      break;
    }
    
    NSArray *equipments = [GlobalDataCacheForMemorySingleton sharedInstance].dictionaryNetRespondBean.equipments;
    if (equipments == nil || equipments.count <= 0) {
      break;
    }
    
    NSInteger index = 0;
    for (Equipment *equipment in equipments) {
      [_dataSourceForEquipmentList insertObject:equipment.equipmentId forKey:equipment.equipmentName atIndex:index++];
    }
  } while (false);
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
#pragma mark 实现 RadioPopupListDelegate 接口
- (void)radioPopupList:(RadioPopupList *)radioPopupList didSelectRowAtIndex:(NSUInteger)index {
  NSString *value = [radioPopupList objectAtIndex:index];
  if ([NSString isEmpty:value]) {
    // 参数异常
    return;
  }
  
  switch (radioPopupList.tag) {
      
    case kRadioPopupListTypeTag_DistrictName:{// "房屋位置"
      [_districtNameButton setTitle:value forState:UIControlStateNormal];
      
      // 20130307 业务说明 : 如果用户更改了 "房屋位置" , 就要将 "地标" 字段置空
      if (![value isEqualToString:@"不限"]) {
        _streetTextField.text = nil;
      }
    }break;
      
    case kRadioPopupListTypeTag_RoomPrice:{// "每晚价格"
      [_roomPriceButton setTitle:value forState:UIControlStateNormal];
    }break;
      
    case kRadioPopupListTypeTag_RentType:{// "出租方式"
      [_rentTypeButton setTitle:value forState:UIControlStateNormal];
    }break;
      
    default:
      break;
  }
}

#pragma mark -
#pragma mark 实现 CheckBoxPopupListDelegate 接口
// 必须实现的协议
-(void)checkBoxPopupList:(CheckBoxPopupList *)checkBoxPopupList
    didSelectedCellTexts:(NSArray *)texts {
  
  NSString *tamenitiesString = nil;
  if ([texts isKindOfClass:[NSArray class]] && texts.count > 0) {
    tamenitiesString = [texts componentsJoinedByString:@","];
  } else {
    // 一定要做容错处理, 防止用户不选择任何选项.
    tamenitiesString = @"不限";
  }
  
  [_tamenitiesButton setTitle:tamenitiesString forState:UIControlStateNormal];
}

// 选择实现的协议
-(void)closeCheckBoxPopupList:(CheckBoxPopupList *)checkBoxPopupList {
  
}

#pragma mark -
#pragma mark 实现 IDomainNetRespondCallback 接口

-(NSInteger)requestDictionary {
  DictionaryNetRequestBean *requestBean = [DictionaryNetRequestBean dictionaryNetRequestBean];
  NSInteger netRequestIndex
  = [[DomainProtocolNetHelperSingleton sharedInstance] requestDomainProtocolWithContext:self
                                                                   andRequestDomainBean:requestBean
                                                                        andRequestEvent:kNetRequestTagEnum_Dictionary
                                                                     andRespondDelegate:self];
  return netRequestIndex;
}

-(void)requestDistrictsWithCityId:(NSString *)cityId {
  
  DistrictsNetRequestBean *requestBean = [DistrictsNetRequestBean districtsNetRequestBeanWithCityId:cityId];
  _netRequestIndexForDistricts
  = [[DomainProtocolNetHelperSingleton sharedInstance] requestDomainProtocolWithContext:self
                                                                   andRequestDomainBean:requestBean
                                                                        andRequestEvent:kNetRequestTagEnum_Districts
                                                                     andRespondDelegate:self];
  if (_netRequestIndexForDistricts != IDLE_NETWORK_REQUEST_ID) {
    [SVProgressHUD showWithStatus:@"获取区县信息中..."];
  }
}

typedef enum {
  // 显示网络访问错误时的提示信息
  kHandlerMsgTypeEnum_ShowNetErrorMessage = 0,
  // 获取 "字典" 数据成功
  kHandlerMsgTypeEnum_GetDictionarySuccessful,
  // 获取 "区县" 数据成功
  kHandlerMsgTypeEnum_GeDistrictsSuccessful
} HandlerMsgTypeEnum;

typedef enum {
  //
  kHandlerExtraDataTypeEnum_NetRequestTag = 0,
  //
  kHandlerExtraDataTypeEnum_NetErrorMessage,
  //
  kHandlerExtraDataTypeEnum_DictionaryNetRespondBean,
  //
  kHandlerExtraDataTypeEnum_DistrictsNetRespondBean
} HandlerExtraDataTypeEnum;

- (void) handleMessage:(Message *) msg {
  
  switch (msg.what) {
      
    case kHandlerMsgTypeEnum_ShowNetErrorMessage:{
      
      NSString *netErrorMessageString
      = [msg.data objectForKey:[NSNumber numberWithUnsignedInteger:kHandlerExtraDataTypeEnum_NetErrorMessage]];
      
      [SVProgressHUD showErrorWithStatus:netErrorMessageString];
      
    }break;
      
    case kHandlerMsgTypeEnum_GetDictionarySuccessful:{
      
      //
      //[SVProgressHUD dismiss];
      
      
    }break;
      
    case kHandlerMsgTypeEnum_GeDistrictsSuccessful:{
      
      //
      [SVProgressHUD dismiss];
      
      
    }break;
      
    default:
      break;
  }
}

//
- (void) clearNetRequestIndexByRequestEvent:(NSUInteger) requestEvent {
  if (kNetRequestTagEnum_Dictionary == requestEvent) {
    _netRequestIndexForDictionary = IDLE_NETWORK_REQUEST_ID;
  } else if (kNetRequestTagEnum_Districts == requestEvent) {
    _netRequestIndexForDistricts = IDLE_NETWORK_REQUEST_ID;
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
  
  if (requestEvent == kNetRequestTagEnum_Dictionary) {
    DictionaryNetRespondBean *dictionaryNetRespondBean = respondDomainBean;
    PRPLog(@"%@ -> %@", TAG, dictionaryNetRespondBean);
    
    // 缓存 "字典数据"
    [[GlobalDataCacheForMemorySingleton sharedInstance] setDictionaryNetRespondBean:dictionaryNetRespondBean];
    
    // 初始化 "出租方式" ListView 的数据源
    [self initRentTypeListViewDataSource];
    
    // 初始化 "设施设备" ListView 的数据源
    [self initEquipmentListViewDataSource];
    
    // 跳转到 "房间详情界面"
    Message *msg = [Message obtain];
    msg.what = kHandlerMsgTypeEnum_GetDictionarySuccessful;
    [self performSelectorOnMainThread:@selector(handleMessage:) withObject:msg waitUntilDone:NO];
    
    return;
    
  } else if (requestEvent == kNetRequestTagEnum_Districts) {// 2.7 根据城市获取区县
    
    DistrictsNetRespondBean *districtsNetRespondBean = respondDomainBean;
    PRPLog(@"%@ -> %@", TAG, districtsNetRespondBean);
    
    self.districtsNetRespondBean = districtsNetRespondBean;
    
    // 初始化 "房屋位置" ListView 的数据源
    [self initDistrictNameListViewDataSource];
    
    // 跳转到 "房间详情界面"
    Message *msg = [Message obtain];
    msg.what = kHandlerMsgTypeEnum_GeDistrictsSuccessful;
    [self performSelectorOnMainThread:@selector(handleMessage:) withObject:msg waitUntilDone:NO];
    
    return;
    
  }
}



@end
