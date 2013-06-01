//
//  RoomDetailOfBasicInformationActivity.m
//  airizu
//
//  Created by 唐志华 on 13-1-28.
//
//

#import "RoomDetailOfBasicInformationActivity.h"

#import "TitleBar.h"
#import "FreebookToolBar.h"
#import "PreloadingUIToolBar.h"

#import "RoomDetailDatabaseFieldsConstant.h"
#import "RoomDetailNetRequestBean.h"
#import "RoomDetailNetRespondBean.h"

#import "RoomDetailOfBasicInformationActivityContent.h"

#import "FreebookConfirmCheckinTimeActivity.h"
#import "LoginActivity.h"
#import "RoomDetailPhotoActivity.h"
#import "RoomDetailOfOverviewActivity.h"
#import "RoomDetailTenantReviewsActivity.h"

#import "RoomMapActivityByBaiduLBS.h"


#import "NSObject+Serialization.h"
#import "LocalCacheDataPathConstant.h"






static const NSString *const TAG = @"<RoomDetailOfBasicInformationActivity>";


// 房间编号(房间ID)
NSString *const kIntentExtraTagForRoomDetailOfBasicInfoActivity_RoomNumber = @"RoomNumber";
// 房间详情业务Bean(用于从 "按照房间编号搜索房间" 页面跳转来此, 此时不用再重复查询目标房间的详情信息了.)
NSString *const kIntentExtraTagForRoomDetailOfBasicInfoActivity_RoomDetailNetRespondBean = @"RoomDetailNetRespondBean";






///
@interface RoomDetailOfBasicInformationActivity ()

///
@property (nonatomic, assign) BOOL isIncomingIntentValid;
@property (nonatomic, assign) TitleBar *titleBar;

/// 外部传入的数据
@property (nonatomic, retain) RoomDetailNetRespondBean *roomDetailNetRespondBean;
@property (nonatomic, retain) NSNumber *roomNumber;

//
@property (nonatomic, assign) NSInteger netRequestIndexForRoomDetail;


// 预加载UI工具条
@property (nonatomic, retain) PreloadingUIToolBar *preloadingUIToolBar;

//
@property (nonatomic, assign) FreebookToolBar *freebookToolBar;

@end









///
@implementation RoomDetailOfBasicInformationActivity

//
typedef NS_ENUM(NSInteger, NetRequestTagEnum) {
  // 2.12 房间详情
  kNetRequestTagEnum_RoomDetail = 0
};

typedef NS_ENUM(NSInteger, IntentRequestCodeEnum) {
  // 跳转到 "登录界面"
  kIntentRequestCodeEnum_ToLoginActivity = 0
};

#pragma mark -
#pragma mark 内部方法群

- (void)dealloc {
  
  //
  [_roomNumber release];
  //
  [_roomDetailNetRespondBean release];
  //
  [_preloadingUIToolBar release];
  
  
  /// UI相关
  [_titleBarPlaceholder release];
  [_contentPlaceholder release];
  [_freebookToolBarPlaceholder release];
  [_bodyLayout release];
  [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  if ([DeviceInformation isIPhone5]) {
    // 这里决不能设成 autorelease 的, 网上的代码就是 autorelease的, 4.3系统会崩溃, 因为被自动释放了
    self = [super initWithNibName:@"RoomDetailOfBasicInformationActivity_iphone5" bundle:nibBundleOrNil];
  } else {
    self = [super initWithNibName:@"RoomDetailOfBasicInformationActivity" bundle:nibBundleOrNil];
  }
  if (self) {
    // Custom initialization
    
    //
    _netRequestIndexForRoomDetail = IDLE_NETWORK_REQUEST_ID;
    
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  // Do any additional setup after loading the view from its nib.
  
  [self initTitleBar];
  
  if (_isIncomingIntentValid) {
    
    // 初始化 "预加载UI等待工具条"
    [self initPreloadingUIToolBar];
    
    [self initFreebookToolBar];
    
    if (_roomDetailNetRespondBean == nil) {// 需要从网络请求 房间详情
      // 显示 "预加载UI等待工具条"
      [_preloadingUIToolBar showInView:self.view];
      
      // 请求房源信息
      _netRequestIndexForRoomDetail = [self requestRoomDetailByRoomNumber:_roomNumber];
      
    } else {
      
      // 加载 "本界面真正的UI, 并且使用 RoomDetailNetRespondBean 初始化"
      [self loadRealUIAndUseRoomDetailNetRespondBeanInitialize];
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

- (void)viewDidUnload {
  
  self.titleBar = nil;
  [self setTitleBarPlaceholder:nil];
  [self setContentPlaceholder:nil];
  self.freebookToolBar = nil;
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
  [intent.extras setObject:_roomNumber forKey:kIntentExtraTagForFreebookConfirmCheckinTimeActivity_RoomNumber];
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
    
    // 如果有 RoomDetailNetRespondBean 传递过来, 就不用重新查询目标房间的详情了
    RoomDetailNetRespondBean *roomDetailNetRespondBeanTest
    = [intent.extras objectForKey:kIntentExtraTagForRoomDetailOfBasicInfoActivity_RoomDetailNetRespondBean];
    
    if ([roomDetailNetRespondBeanTest isKindOfClass:[RoomDetailNetRespondBean class]]) {
      self.roomDetailNetRespondBean = roomDetailNetRespondBeanTest;
      
      self.roomNumber = roomDetailNetRespondBeanTest.number;
      
    } else {
      
      NSNumber *roomNumberTest = [intent.extras objectForKey:kIntentExtraTagForRoomDetailOfBasicInfoActivity_RoomNumber];
      if (![roomNumberTest isKindOfClass:[NSNumber class]]) {
        break;
      }
      self.roomNumber = roomNumberTest;
      
      // 检查本地是否有当前房间详情的缓存
      self.roomDetailNetRespondBean = [NSObject deserializeObjectFromFileWithFileName:[_roomNumber stringValue] directoryPath:[LocalCacheDataPathConstant roomDetailCachePath]];
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
  
  [[DomainProtocolNetHelperSingleton sharedInstance] cancelNetRequestByRequestIndex:_netRequestIndexForRoomDetail];
  _netRequestIndexForRoomDetail = IDLE_NETWORK_REQUEST_ID;
  
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
  self.titleBar = [TitleBar titleBar];
  _titleBar.delegate = self;
  NSString *titleString = [NSString stringWithFormat:@"房间 : %@", [_roomNumber stringValue]];
  [_titleBar setTitleByString:titleString];
  // "返回按钮"
  [_titleBar hideLeftButton:NO];
  // "预定电话按钮"
  [_titleBar hideRightButton:NO];
  //
  [self.titleBarPlaceholder addSubview:_titleBar];
}

//
- (void) initFreebookToolBar {
  self.freebookToolBar = [FreebookToolBar freebookToolBar];
  _freebookToolBar.delegate = self;
  if (_roomDetailNetRespondBean != nil) {
    [_freebookToolBar setRoomPrice:_roomDetailNetRespondBean.price];
  } else {
    // 设置默认值
    [_freebookToolBar setRoomPrice:[NSNumber numberWithInteger:0]];
  }
  //
  [self.freebookToolBarPlaceholder addSubview:_freebookToolBar];
}

// 初始化 "预加载UI工具条"
-(void)initPreloadingUIToolBar {
  self.preloadingUIToolBar = [PreloadingUIToolBar preloadingUIToolBar];
  _preloadingUIToolBar.delegate = self;
}

// 加载本界面真正的UI
-(void)loadRealUIAndUseRoomDetailNetRespondBeanInitialize {
  
  //
  RoomDetailOfBasicInformationActivityContent *roomDetailOfBasicInformationActivityContent
  = [RoomDetailOfBasicInformationActivityContent roomDetailOfBasicInformationActivityContentWithRoomDetailNetRespondBean:_roomDetailNetRespondBean];
  roomDetailOfBasicInformationActivityContent.delegate = self;
  [_contentPlaceholder addSubview:roomDetailOfBasicInformationActivityContent];
  // 一定要重新设置 "UIScrollView" 的 contentSize
  CGSize contentSize = roomDetailOfBasicInformationActivityContent.frame.size;
  [_contentPlaceholder setContentSize:contentSize];
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
      if (_netRequestIndexForRoomDetail == IDLE_NETWORK_REQUEST_ID) {
        _netRequestIndexForRoomDetail = [self requestRoomDetailByRoomNumber:_roomNumber];
        if (_netRequestIndexForRoomDetail != IDLE_NETWORK_REQUEST_ID) {
          [_preloadingUIToolBar showRefreshButton:NO];
        }
      }
    }
    
  } else if ([control isKindOfClass:[RoomDetailOfBasicInformationActivityContent class]]) {
    
    switch (action) {
        
      case kRoomDetailOfBasicInformationActivityContentActionEnum_RoomPhotoClicked:{// 房间图片点击事件
        Intent *intent = [Intent intentWithSpecificComponentClass:[RoomDetailPhotoActivity class]];
        [intent.extras setObject:_roomDetailNetRespondBean forKey:kIntentExtraTagForRoomDetailPhotoActivity_RoomDetailNetRespondBean];
        [self startActivity:intent];
      }break;
        
      case kRoomDetailOfBasicInformationActivityContentActionEnum_MapButtonClicked:{// 房间交通地图按钮点击事件
        Intent *intent = [Intent intentWithSpecificComponentClass:[RoomMapActivityByBaiduLBS class]];
        NSString *titleNameForRoomMapActivity = _titleBar.titleLabel.text;
        
        ///
        [intent.extras setObject:[NSNumber numberWithUnsignedInteger:kUiTypeEnumForRoomMapActivity_SingleRoom] forKey:kIntentExtraTagForRoomMapActivity_UiType];
        [intent.extras setObject:_roomDetailNetRespondBean forKey:kIntentExtraTagForRoomMapActivity_Data];
        [intent.extras setObject:titleNameForRoomMapActivity forKey:kIntentExtraTagForRoomMapActivity_TitleName];
        
        [self startActivity:intent];
      }break;
        
      case kRoomDetailOfBasicInformationActivityContentActionEnum_RoomDetailButtonClicked:{// 房间详情按钮点击事件
        Intent *intent = [Intent intentWithSpecificComponentClass:[RoomDetailOfOverviewActivity class]];
        [intent.extras setObject:_roomDetailNetRespondBean forKey:kIntentExtraTagForRoomDetailOfOverviewActivity_RoomDetailNetRespondBean];
        [self startActivity:intent];
      }break;
        
      case kRoomDetailOfBasicInformationActivityContentActionEnum_TenantReviewsButtonClicked:{// 租客点评按钮点击事件
        Intent *intent = [Intent intentWithSpecificComponentClass:[RoomDetailTenantReviewsActivity class]];
        [intent.extras setObject:_roomDetailNetRespondBean forKey:kIntentExtraTagForRoomDetailTenantReviewsActivity_RoomDetailNetRespondBean];
        [self startActivity:intent];
      }break;
        
      case kRoomDetailOfBasicInformationActivityContentActionEnum_CustomerServicePhoneButtonClicked:{// 客服电话按钮点击事件
        [[SimpleCallSingleton sharedInstance] callCustomerServicePhoneAndShowInThisView:self.view.window];
      }break;
        
      default:
        break;
    }
    
    
  }
  
}

#pragma mark -
#pragma mark 网络方法群

-(NSInteger)requestRoomDetailByRoomNumber:(NSNumber *)roomNumber {
  if ([NSString isEmpty:[roomNumber stringValue]]) {
    return IDLE_NETWORK_REQUEST_ID;
  }
  
  RoomDetailNetRequestBean *netRequestBean = [RoomDetailNetRequestBean roomDetailNetRequestBeanWithRoomId:[roomNumber stringValue]];
  NSInteger netRequestIndex
  = [[DomainProtocolNetHelperSingleton sharedInstance] requestDomainProtocolWithContext:self
                                                                   andRequestDomainBean:netRequestBean
                                                                        andRequestEvent:kNetRequestTagEnum_RoomDetail
                                                                     andRespondDelegate:self];
  return netRequestIndex;
}


typedef enum {
  // 显示网络访问错误时的提示信息
  kHandlerMsgTypeEnum_ShowNetErrorMessage = 0,
  // 获取 "房间详情" 数据成功
  kHandlerMsgTypeEnum_GetRoomDetailSuccessful
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
      
      [_preloadingUIToolBar showRefreshButton:YES];
      
    }break;
      
    case kHandlerMsgTypeEnum_GetRoomDetailSuccessful:{
      
      // 隐藏 "预加载UI"
      [_preloadingUIToolBar dismiss];
      
      // 加载 "真正的UI"
      [self loadRealUIAndUseRoomDetailNetRespondBeanInitialize];
      
      // 更新 免费预定工具条中的房间单价
      [_freebookToolBar setRoomPrice:_roomDetailNetRespondBean.price];
    }break;
      
    default:
      break;
  }
}

//
- (void) clearNetRequestIndexByRequestEvent:(NSUInteger) requestEvent {
  if (kNetRequestTagEnum_RoomDetail == requestEvent) {
    _netRequestIndexForRoomDetail = IDLE_NETWORK_REQUEST_ID;
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
  
  if (requestEvent == kNetRequestTagEnum_RoomDetail) {// 2.12 房间详情
    RoomDetailNetRespondBean *roomDetailNetRespondBean = respondDomainBean;
    
    self.roomDetailNetRespondBean = roomDetailNetRespondBean;
    [roomDetailNetRespondBean serializeObjectToFileWithFileName:[_roomNumber stringValue] directoryPath:[LocalCacheDataPathConstant roomDetailCachePath]];
    
    // 跳转到 "房间详情界面"
    Message *msg = [Message obtain];
    msg.what = kHandlerMsgTypeEnum_GetRoomDetailSuccessful;
    [self performSelectorOnMainThread:@selector(handleMessage:) withObject:msg waitUntilDone:NO];
    
    return;
    
  }
}

@end
