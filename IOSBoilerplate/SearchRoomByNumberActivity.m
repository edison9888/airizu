//
//  SearchRoomByNumberActivityViewController.m
//  airizu
//
//  Created by 唐志华 on 13-1-15.
//
//

#import "SearchRoomByNumberActivity.h"

#import "TitleBar.h"

#import "RoomDetailDatabaseFieldsConstant.h"
#import "RoomDetailNetRequestBean.h"
#import "RoomDetailNetRespondBean.h"

#import "NSString+Expand.h"

#import "RoomDetailOfBasicInformationActivity.h"










static const NSString *const TAG = @"<SearchRoomByNumberActivity>";

@interface SearchRoomByNumberActivity ()
//
@property (nonatomic, assign) NSInteger netRequestIndexForRoomDetail;
@end











@implementation SearchRoomByNumberActivity

//
typedef NS_ENUM(NSInteger, NetRequestTagEnum) {
  //
  kNetRequestTagEnum_RoomDetail = 0
};

- (void)dealloc {
  PRPLog(@"dealloc: %@ [0x%x]", TAG, [self hash]);
  
  [_titleBarPlaceholder release];
  [_roomNumberTextField release];
  
  [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  if ([DeviceInformation isIPhone5]) {
    // 这里决不能设成 autorelease 的, 网上的代码就是 autorelease的, 4.3系统会崩溃, 因为被自动释放了
    self = [super initWithNibName:@"SearchRoomByNumberActivity_iphone5" bundle:nibBundleOrNil];
  } else {
    self = [super initWithNibName:@"SearchRoomByNumberActivity" bundle:nibBundleOrNil];
  }
  if (self) {
    // Custom initialization
    PRPLog(@"init %@ [0x%x]", TAG, [self hash]);
    
    _netRequestIndexForRoomDetail = IDLE_NETWORK_REQUEST_ID;
  }
  return self;
}

- (void)viewDidLoad
{
  PRPLog(@"%@ --> viewDidLoad ", TAG);
  
  [super viewDidLoad];
  // Do any additional setup after loading the view from its nib.
  
  [self initTitleBar];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
  PRPLog(@"%@ --> viewDidUnload ", TAG);
  
  [self setTitleBarPlaceholder:nil];
  [self setRoomNumberTextField:nil];

  [super viewDidUnload];
}

#pragma mark -
#pragma mark Activity 生命周期
-(void)onCreate:(Intent *)intent {
  PRPLog(@"%@ --> onCreate ", TAG);
}
-(void)onPause {
  PRPLog(@"%@ --> onPause ", TAG);
  
  [self closeKeyBord:nil];
  
  [SVProgressHUD dismiss];
  
  [[DomainProtocolNetHelperSingleton sharedInstance] cancelNetRequestByRequestIndex:_netRequestIndexForRoomDetail];
  _netRequestIndexForRoomDetail = IDLE_NETWORK_REQUEST_ID;
}

-(void)onResume {
  PRPLog(@"%@ --> onResume ", TAG);
}

#pragma mark -
#pragma mark 初始化UI
//
- (void) initTitleBar {
  TitleBar *titleBar = [TitleBar titleBar];
  titleBar.delegate = self;
  [titleBar setTitleByString:@"房间搜索"];
  [titleBar hideLeftButton:NO];
  [self.titleBarPlaceholder addSubview:titleBar];
}

- (IBAction)searchButtonOnClickListener:(id)sender {
  
  if (_netRequestIndexForRoomDetail != IDLE_NETWORK_REQUEST_ID) {
    // 正在联网中...
    return;
  }
  
  [self closeKeyBord:nil];
  
  do {
    NSString *roomNumber = [_roomNumberTextField text];
    if ([NSString isEmpty:roomNumber]) {
      break;
    }
    if ([roomNumber integerValue] <= 0) {
      // 订单编号不能全是数字 0
      break;
    }
    
    _netRequestIndexForRoomDetail = [self requestRoomDetailByRoomNumber:roomNumber];
    if (_netRequestIndexForRoomDetail != IDLE_NETWORK_REQUEST_ID) {
      [SVProgressHUD showWithStatus:@"联网中..."];
    }
    
    return;
  } while (NO);
  
  [SVProgressHUD showErrorWithStatus:@"房间编号有误, 请重新输入"];
}

#pragma mark -
#pragma mark 关闭输入框键盘
- (IBAction)closeKeyBord:(id)sender{
  [_roomNumberTextField resignFirstResponder];
}

#pragma mark -
#pragma mark 实现 UITextFieldDelegate 接口

// called when 'return' key pressed. return NO to ignore.
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  
  [self searchButtonOnClickListener:nil];
  return YES;
}

#pragma mark -
#pragma mark 实现 IDomainNetRespondCallback 接口

/**
 * 请求房源列表信息
 *
 * @param data 查询条件
 * @return
 */
-(NSInteger)requestRoomDetailByRoomNumber:(NSString *)roomNumber {
  
  RoomDetailNetRequestBean *roomDetailNetRequestBean = [RoomDetailNetRequestBean roomDetailNetRequestBeanWithRoomId:roomNumber];
  NSInteger netRequestIndex = [[DomainProtocolNetHelperSingleton sharedInstance] requestDomainProtocolWithContext:self
                                                                                             andRequestDomainBean:roomDetailNetRequestBean
                                                                                                  andRequestEvent:kNetRequestTagEnum_RoomDetail
                                                                                               andRespondDelegate:self];
  return netRequestIndex;
}

typedef enum {
  // 显示网络访问错误时的提示信息
  kHandlerMsgTypeEnum_ShowNetErrorMessage = 0,
  // 跳转到 "房间详情" 界面
  kHandlerMsgTypeEnum_GotoRoomDetailActivity
} HandlerMsgTypeEnum;

typedef enum {
  //
  kHandlerExtraDataTypeEnum_NetRequestTag = 0,
  //
  kHandlerExtraDataTypeEnum_NetErrorMessage,
  //
  kHandlerExtraDataTypeEnum_RoomDetailNetRespondBean
} HandlerExtraDataTypeEnum;

- (void) handleMessage:(Message *) msg {
  
  switch (msg.what) {
      
    case kHandlerMsgTypeEnum_ShowNetErrorMessage:{
      
      NSString *netErrorMessageString
      = [msg.data objectForKey:[NSNumber numberWithUnsignedInteger:kHandlerExtraDataTypeEnum_NetErrorMessage]];
      
      [SVProgressHUD showErrorWithStatus:netErrorMessageString];
      
    }break;
      
    case kHandlerMsgTypeEnum_GotoRoomDetailActivity:{
      
      [SVProgressHUD dismiss];
      
      RoomDetailNetRespondBean *roomDetailNetRespondBean
      = [msg.data objectForKey:[NSNumber numberWithUnsignedInteger:kHandlerExtraDataTypeEnum_RoomDetailNetRespondBean]];
      
      Intent *intent = [Intent intentWithSpecificComponentClass:[RoomDetailOfBasicInformationActivity class]];
      [intent.extras setObject:roomDetailNetRespondBean forKey:kIntentExtraTagForRoomDetailOfBasicInfoActivity_RoomDetailNetRespondBean];
      [self startActivity:intent];
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
  
  if (requestEvent == kNetRequestTagEnum_RoomDetail) {
    RoomDetailNetRespondBean *roomDetailNetRespondBean = respondDomainBean;
    PRPLog(@"%@ -> %@", TAG, roomDetailNetRespondBean);
    
    // 跳转到 "房间详情界面"
    Message *msg = [Message obtain];
    msg.what = kHandlerMsgTypeEnum_GotoRoomDetailActivity;
    [msg.data setObject:roomDetailNetRespondBean
                 forKey:[NSNumber numberWithUnsignedInteger:kHandlerExtraDataTypeEnum_RoomDetailNetRespondBean]];
    [self performSelectorOnMainThread:@selector(handleMessage:) withObject:msg waitUntilDone:NO];
    
    return;
  }
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
