

//
//  RoomMapActivityByBaiduLBS.m
//  airizu
//
//  Created by 唐志华 on 13-1-7.
//
//

#import "RoomMapActivityByBaiduLBS.h"

#import "RoomInfo.h"
#import "RoomDetailNetRequestBean.h"
#import "RoomDetailNetRespondBean.h"

#import "NSDictionary+Helper.h"

#import "TitleBar.h"
#import "FreebookToolBar.h"

#import "RoomDetailOfBasicInformationActivity.h"

#import "FreebookConfirmCheckinTimeActivity.h"
#import "LoginActivity.h"

#import "SimpleCallSingleton.h"



static const NSString *const TAG = @"<RoomMapActivityByBaiduLBS>";


// UI类型, 是从房源列表进入此界面的, 还是从房间详情进入此界面的
NSString *const kIntentExtraTagForRoomMapActivity_UiType = @"UI_TYPE";
// 传入的数据, 如果是从 "房源列表" 进入此界面, 那么传递的是List<RoomInfo>, 如果从 "房间详情" 进入的, 传过来就是 RoomDetailNetRespondBean
NSString *const kIntentExtraTagForRoomMapActivity_Data = @"DATA";
// title name
NSString *const kIntentExtraTagForRoomMapActivity_TitleName = @"TITLE_NAME";










@interface RoomMapActivityByBaiduLBS ()
///
@property (nonatomic, assign) BOOL isIncomingIntentValid;
@property (nonatomic, assign) TitleBar *titleBar;


/// 外部传入的数据
//
@property (nonatomic, assign) UiTypeEnumForRoomMapActivity uiTypeEnum;
//
@property (nonatomic, assign) RoomDetailNetRespondBean *dataForSingleRoom;
@property (nonatomic, assign) NSArray *dataForGroupRoom;
//
@property (nonatomic, copy) NSString *titleName;


@end








@implementation RoomMapActivityByBaiduLBS

typedef NS_ENUM(NSInteger, IntentRequestCodeEnum) {
  // 跳转到 "登录界面"
  kIntentRequestCodeEnum_ToLoginActivity = 0
};

- (void)dealloc {
  
  //
  [_titleName release];
  
  /// UI
  [_titleBarPlaceholder release];
  [_mapView release];
  [_freebookToolBarPlaceholder release];
  [_bodyLayout release];
  [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  if ([DeviceInformation isIPhone5]) {
    // 这里决不能设成 autorelease 的, 网上的代码就是 autorelease的, 4.3系统会崩溃, 因为被自动释放了
    self = [super initWithNibName:@"RoomMapActivityByBaiduLBS_iphone5" bundle:nibBundleOrNil];
  } else {
    self = [super initWithNibName:@"RoomMapActivityByBaiduLBS" bundle:nibBundleOrNil];
  }
  if (self) {
    // Custom initialization
    
    //
    _isIncomingIntentValid = NO;
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
	// Do any additional setup after loading the view.
  
  /// 初始化UI
  [self initTitleBar];
  
  ///
  if (_isIncomingIntentValid) {
    
    //
    [self configLBSByUiType:_uiTypeEnum];
		//
		[self configActivityUIByUiType:_uiTypeEnum];
    
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
  self.titleBar = nil;
  
  /// UI
  [self setTitleBarPlaceholder:nil];
  [self setMapView:nil];
  [self setFreebookToolBarPlaceholder:nil];
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
    
    id uiTypeEnumTest = [intent.extras objectForKey:kIntentExtraTagForRoomMapActivity_UiType];
    if (![uiTypeEnumTest isKindOfClass:[NSNumber class]]) {
      NSAssert(NO, @"外传传入的Intent中有错误参数 : UiType");
      break;
    }
    self.uiTypeEnum = [uiTypeEnumTest integerValue];
    if (_uiTypeEnum <= kUiTypeEnumForRoomMapActivity_NONE || _uiTypeEnum >= kUiTypeEnumForRoomMapActivity_MAX) {
      NSAssert(NO, @"外传传入的Intent中有错误参数 : UiType");
      break;
    }
    
    id dataTest = [intent.extras objectForKey:kIntentExtraTagForRoomMapActivity_Data];
    BOOL isDataValid = YES;// 数据有效
    switch (self.uiTypeEnum) {
      case kUiTypeEnumForRoomMapActivity_GroupRoomForCity:
      case kUiTypeEnumForRoomMapActivity_GroupRoomForNearby:{
        if (![dataTest isKindOfClass:[NSArray class]]) {
          isDataValid = NO;
          break;
        }
        self.dataForGroupRoom = dataTest;
      }break;
        
      case kUiTypeEnumForRoomMapActivity_SingleRoom:{
        if (![dataTest isKindOfClass:[RoomDetailNetRespondBean class]]) {
          isDataValid = NO;
          break;
        }
        self.dataForSingleRoom = dataTest;
      }break;
      default:
        break;
    }
    if (!isDataValid) {
      NSAssert(NO, @"外传传入的Intent中有错误参数 : Data");
      break;
    }
    
    id titleNameTest = [intent.extras objectForKey:kIntentExtraTagForRoomMapActivity_TitleName];
    if ([titleNameTest isKindOfClass:[NSString class]]) {
      self.titleName = titleNameTest;
    }
    
    // 一切OK
    return YES;
  } while (false);
  
  // 出现问题
  self.titleName = nil;
  self.uiTypeEnum = kUiTypeEnumForRoomMapActivity_NONE;
  self.dataForGroupRoom = nil;
  self.dataForSingleRoom = nil;
  return NO;
}

-(void)onCreate:(Intent *)intent{
  PRPLog(@"%@ --> onCreate ", TAG);
  
  self.isIncomingIntentValid = [self parseIncomingIntent:intent];
}

-(void)onResume {
  PRPLog(@"%@ --> onResume ", TAG);
  _mapView.delegate = self;
}

-(void)onPause {
  PRPLog(@"%@ --> onPause ", TAG);
  
  // 20130222 tangzhihua : 一定要在这里设置代理为nil, 发现如果本activity有两个对象存在, 点击标签代理会固定跳去第一个对象那里.
  _mapView.delegate = nil;
}

#pragma mark -
#pragma mark 初始化UI

//
- (void) initTitleBar {
  self.titleBar = [TitleBar titleBar];
  _titleBar.delegate = self;
  [_titleBar hideLeftButton:NO];
  [_titleBar setTitleByString:_titleName];
  [self.titleBarPlaceholder addSubview:_titleBar];
}

//
- (void) initFreebookToolBar {
  FreebookToolBar *freebookToolBar = [FreebookToolBar freebookToolBar];
  freebookToolBar.delegate = self;
  [freebookToolBar setRoomPrice:_dataForSingleRoom.price];
  //
  _freebookToolBarPlaceholder.hidden = NO;
  [self.freebookToolBarPlaceholder addSubview:freebookToolBar];
}

-(void)configActivityUIByUiType:(UiTypeEnumForRoomMapActivity)uiTypeEnum {
  
  switch (_uiTypeEnum) {
    case kUiTypeEnumForRoomMapActivity_GroupRoomForCity:
    case kUiTypeEnumForRoomMapActivity_GroupRoomForNearby: {
      
      [_titleBar hideRightButton:NO];
      [_titleBar.rightButton setImage:[UIImage imageNamed:@"back_to_room_list_button.png"] forState:UIControlStateNormal];
      [_titleBar.rightButton setImage:[UIImage imageNamed:@"back_to_room_list_button_focus.png"] forState:UIControlStateHighlighted];
      
    }break;
      
    case kUiTypeEnumForRoomMapActivity_SingleRoom:{
      _titleBar.rightButton.hidden = NO;
      
      [self initFreebookToolBar];
      /// 20130222 tangzhihua : 不能在这里改变 mapView.frame, 否则界面错乱
    }break;
      
    default:
      break;
  }
  
}

-(void)gotoRoomDetailActivityWithRoomInfo:(RoomInfo *)roomInfo {
  if (roomInfo == nil || roomInfo.roomId == nil) {
    return;
  }
  
  Intent *intent = [Intent intentWithSpecificComponentClass:[RoomDetailOfBasicInformationActivity class]];
  [intent.extras setObject:roomInfo.roomId forKey:kIntentExtraTagForRoomDetailOfBasicInfoActivity_RoomNumber];
  [self startActivity:intent];
}

-(void)gotoLoginActivity {
  Intent *intent =[Intent intentWithSpecificComponentClass:[LoginActivity class]];
  [self startActivityForResult:intent requestCode:kIntentRequestCodeEnum_ToLoginActivity];
}

-(void)gotoFreebookConfirmCheckinTimeActivity {
  Intent *intent = [Intent intentWithSpecificComponentClass:[FreebookConfirmCheckinTimeActivity class]];
  [intent.extras setObject:_dataForSingleRoom.number forKey:kIntentExtraTagForFreebookConfirmCheckinTimeActivity_RoomNumber];
  if (_dataForSingleRoom != nil) {
    [intent.extras setObject:_dataForSingleRoom.accommodates forKey:kIntentExtraTagForFreebookConfirmCheckinTimeActivity_Accommodates];
  }
  
  [self startActivity:intent];
}

#pragma mark -
#pragma mark 实现 CustomControlDelegate 接口
-(void)customControl:(id)control onAction:(NSUInteger)action {
  
  if ([control isKindOfClass:[TitleBar class]]) {
    switch (action) {
        
      case kTitleBarActionEnum_LeftButtonClicked:{
        [self finish];
      }break;
        
      case kTitleBarActionEnum_RightButtonClicked:{
        
        switch (_uiTypeEnum) {
          case kUiTypeEnumForRoomMapActivity_GroupRoomForCity:
          case kUiTypeEnumForRoomMapActivity_GroupRoomForNearby: {
            [self finish];
          }break;
            
          case kUiTypeEnumForRoomMapActivity_SingleRoom:{
            [[SimpleCallSingleton sharedInstance] callCustomerServicePhoneAndShowInThisView:self.view];
          }break;
            
          default:
            break;
        }
        
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
    
  }
  
  
}

#pragma mark -
#pragma mark 配置 LBS 接口

-(void)configLBSByUiType:(UiTypeEnumForRoomMapActivity)uiTypeEnum {
  
  //
  _mapView.delegate = self;
  _mapView.mapType = BMKMapTypeStandard;
  /// 地图比例尺级别，在手机上当前可使用的级别为3-18级
  _mapView.zoomLevel = 11;
  
  //
  switch (_uiTypeEnum) {
      
      
    case kUiTypeEnumForRoomMapActivity_GroupRoomForNearby: {
      // 显示用户当前位置
      _mapView.showsUserLocation = YES;
    };
    case kUiTypeEnumForRoomMapActivity_GroupRoomForCity: {
      
      double maxlen = 116.404;
      double minlen = 116.404;
      double maxlat = 39.915;
      double minlat = 39.915;
      
      for (int i=0; i<_dataForGroupRoom.count; i++) {
        RoomInfo *roomInfo = [_dataForGroupRoom objectAtIndex:i];
        if (roomInfo == nil
            || ![roomInfo.len isKindOfClass:[NSNumber class]]
            || ![roomInfo.lat isKindOfClass:[NSNumber class]]) {
          
          continue;
        }
        
        // 经度
        double len = [roomInfo.len doubleValue];
        // 纬度
        double lat = [roomInfo.lat doubleValue];
        
        if (i == 0) {
          
          maxlen=len;
          minlen=len;
          maxlat=lat;
          minlat=lat;
          
        } else {
          
          maxlen = (maxlen < len) ? (len) : (maxlen);
          minlen = (minlen > len) ? (len) : (minlen);
          maxlat = (maxlat < lat) ? (lat) : (maxlat);
          minlat = (minlat > lat) ? (lat) : (minlat);
        }
        
        // 增加标注
        BMKPointAnnotation *annotation = [[BMKPointAnnotation alloc] init];
        annotation.coordinate = CLLocationCoordinate2DMake(lat, len);
        annotation.title = [NSString stringWithFormat:@"%d", i];
        /**
         *向地图窗口添加标注，需要实现BMKMapViewDelegate的-mapView:viewForAnnotation:函数来生成标注对应的View
         *@param annotation 要添加的标注
         */
        [_mapView addAnnotation:annotation];
        [annotation release];
      }
      
      // 必须设置显示范围
      CLLocationCoordinate2D centerCoor;
      centerCoor.latitude = (maxlat+minlat)/2;
      centerCoor.longitude = (maxlen+minlen)/2;
      BMKCoordinateSpan span = BMKCoordinateSpanMake((maxlat - minlat) / 2 + 0.1, (maxlen - minlen) / 2 + 0.1);
      BMKCoordinateRegion viewRegion
      = BMKCoordinateRegionMake(centerCoor, span);
      BMKCoordinateRegion adjustedRegion = [_mapView regionThatFits:viewRegion];
      [_mapView setRegion:adjustedRegion animated:YES];
      
    }break;
      
    case kUiTypeEnumForRoomMapActivity_SingleRoom:{
      
      /// 增加标注
      BMKPointAnnotation *annotation = [[BMKPointAnnotation alloc] init];
      CLLocationCoordinate2D locationCoordinate2D;
      locationCoordinate2D.latitude = [_dataForSingleRoom.lat doubleValue];
      locationCoordinate2D.longitude = [_dataForSingleRoom.len doubleValue];
      //
      annotation.coordinate = locationCoordinate2D;
      annotation.title = _dataForSingleRoom.title;
      //annotation.subtitle = ;
      [_mapView addAnnotation:annotation];
      [annotation release];
      
      
      /// 设置 当前地图显示范围 (目前设置显示房源周围2000米的地图)
      // 根据中心点和距离生成BMKCoordinateRegion
      BMKCoordinateRegion viewRegion = BMKCoordinateRegionMakeWithDistance(locationCoordinate2D, 2000,  2000);
      // 根据当前地图View的窗口大小调整传入的region，返回适合当前地图窗口显示的region，调整过程会保证中心点不改变
      BMKCoordinateRegion adjustedRegion = [_mapView regionThatFits:viewRegion];
      // 设定当前地图的显示范围
      [_mapView setRegion:adjustedRegion animated:YES];
      
      
      /// 添加覆盖物
      BMKCircle *circle = [BMKCircle circleWithCenterCoordinate:locationCoordinate2D radius:1000];
      [_mapView addOverlay:circle];
      
    }break;
      
    default:
      break;
  }
  
  
}

#pragma mark -
#pragma mark 实现 BMKMapViewDelegate 接口

-(BMKPinAnnotationView *)annotationDelegateForSingleRoom:(id <BMKAnnotation>)annotation{
  BMKPinAnnotationView *newAnnotation
  = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnimation"];
  newAnnotation.pinColor = BMKPinAnnotationColorPurple;
  newAnnotation.animatesDrop = YES;
  return [newAnnotation autorelease];
}

-(BMKPinAnnotationView *)annotationDelegateForGroupRoom:(id <BMKAnnotation>)annotation{
  int index = [annotation.title intValue];
  if (index >= 0 && index < _dataForGroupRoom.count) {
    RoomInfo *roomInfo = [_dataForGroupRoom objectAtIndex:index];
    
    BMKPinAnnotationView *newAnnotation
    = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnimation"];
    newAnnotation.pinColor = BMKPinAnnotationColorPurple;
    newAnnotation.animatesDrop = YES;
    ///默认情况下, annotation view的中心位于annotation的坐标位置，
    // 可以设置centerOffset改变view的位置，正的偏移使view朝右下方移动，负的朝左上方，单位是像素
    newAnnotation.centerOffset = CGPointMake(20, -10);
    newAnnotation.canShowCallout = NO;
    newAnnotation.image = [UIImage imageNamed:@"biao.png"];
    CGSize sizeForAnnotation = newAnnotation.frame.size;
    
    UILabel *titleLabel
    = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                2,
                                                sizeForAnnotation.width,
                                                sizeForAnnotation.height/2)];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
    [titleLabel setTextAlignment:UITextAlignmentCenter];
    [titleLabel setText:[NSString stringWithFormat:@"¥%d", [roomInfo.price integerValue]]];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [newAnnotation addSubview:titleLabel];
    [titleLabel release];
    
    return [newAnnotation autorelease];
  } else {
    return nil;
  }
}

/**
 *根据anntation生成对应的View
 *@param mapView 地图View
 *@param annotation 指定的标注
 *@return 生成的标注View
 */
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView
             viewForAnnotation:(id <BMKAnnotation>)annotation {
  
	if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
		if (kUiTypeEnumForRoomMapActivity_SingleRoom == _uiTypeEnum) {
      return [self annotationDelegateForSingleRoom:annotation];
    } else {
      return [self annotationDelegateForGroupRoom:annotation];
    }
	}
  
  return nil;
}

/**
 *根据overlay生成对应的View
 *@param mapView 地图View
 *@param overlay 指定的overlay
 *@return 生成的覆盖物View
 */
- (BMKOverlayView *)mapView:(BMKMapView *)mapView
             viewForOverlay:(id <BMKOverlay>)overlay {
  
	if ([overlay isKindOfClass:[BMKCircle class]]) {
    BMKCircleView *circleView = [[[BMKCircleView alloc] initWithOverlay:overlay] autorelease];
    circleView.fillColor = [[UIColor cyanColor] colorWithAlphaComponent:0.5];
    circleView.strokeColor = [[UIColor blueColor] colorWithAlphaComponent:0.5];
    circleView.lineWidth = 10.0;
		return circleView;
  } else {
    return nil;
  }
	
}


-(void)didSelectAnnotationView:(BMKAnnotationView *)view{
  
  int index = [view.annotation.title intValue];
  if (index >=0 && index < _dataForGroupRoom.count) {
    
    RoomInfo *roomInfo = [_dataForGroupRoom objectAtIndex:index];
    [self gotoRoomDetailActivityWithRoomInfo:roomInfo];
  }
}

/**
 *当选中一个annotation views时，调用此接口
 *@param mapView 地图View
 *@param views 选中的annotation views
 */
- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view {
  
  switch (_uiTypeEnum) {
    case kUiTypeEnumForRoomMapActivity_GroupRoomForCity:
    case kUiTypeEnumForRoomMapActivity_GroupRoomForNearby:{
      [self didSelectAnnotationView:view];
      // 每次点击完 "标注" 后, 一定要 重置当前 "标注"对象的点击状态, 否则将不响应点击事件, 除非先点击 "标注"icon之外的区域
      [view setSelected:NO animated:NO];
    }break;
      
    case kUiTypeEnumForRoomMapActivity_SingleRoom:{
      
    }break;
    default:
      break;
  }
}



@end
