//
//  PasswordForgetActivity.m
//  airizu
//
//  Created by 唐志华 on 13-1-21.
//
//

#import "PasswordForgetActivity.h"

#import "TitleBar.h"

#import "ForgetPasswordDatabaseFieldsConstant.h"
#import "ForgetPasswordNetRequestBean.h"
#import "ForgetPasswordNetRespondBean.h"

#import "NSString+Expand.h"













static const NSString *const TAG = @"<PasswordForgetActivity>";

@interface PasswordForgetActivity ()
//
@property (nonatomic, assign) NSInteger netRequestIndexForPasswordForget;
@end













@implementation PasswordForgetActivity

//
typedef NS_ENUM(NSInteger, NetRequestTagEnum) {
  //
  kNetRequestTagEnum_PasswordForget = 0
};

- (void)dealloc {
  
  PRPLog(@"dealloc: %@ [0x%x]", TAG, [self hash]);
  
  
  [_titleBarPlaceholder release];
  [_phoneNumberTextField release];
  [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  if ([DeviceInformation isIPhone5]) {
    // 这里决不能设成 autorelease 的, 网上的代码就是 autorelease的, 4.3系统会崩溃, 因为被自动释放了
    self = [super initWithNibName:@"PasswordForgetActivity_iphone5" bundle:nibBundleOrNil];
  } else {
    self = [super initWithNibName:@"PasswordForgetActivity" bundle:nibBundleOrNil];
  }
  if (self) {
    // Custom initialization
    _netRequestIndexForPasswordForget = IDLE_NETWORK_REQUEST_ID;
  }
  return self;
}

- (void)viewDidLoad
{
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
  [self setTitleBarPlaceholder:nil];
  [self setPhoneNumberTextField:nil];
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
  
  // 因为在返回 登录界面时, 还要保持提示信息, 所以不能在这里隐藏 SVProgressHUD
  //[SVProgressHUD dismiss];
  
  [[DomainProtocolNetHelperSingleton sharedInstance] cancelNetRequestByRequestIndex:_netRequestIndexForPasswordForget];
  _netRequestIndexForPasswordForget = IDLE_NETWORK_REQUEST_ID;
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
  [titleBar setTitleByString:@"密码找回"];
  [titleBar hideLeftButton:NO];
  
  [self.titleBarPlaceholder addSubview:titleBar];
}

- (IBAction)sendPhoneNumberButtonOnClickListener:(id)sender {
  
  if (_netRequestIndexForPasswordForget != IDLE_NETWORK_REQUEST_ID) {
    // 不能重复发起网络请求
    return;
  }
  
  [self closeKeyBord:nil];
  
  NSString *errorMessage = @"";
  do {
    NSString *phoneNumber = [_phoneNumberTextField text];
    if ([NSString isEmpty:phoneNumber]) {
      errorMessage = @"手机号不能为空";
      break;
    }
    if (phoneNumber.length != 11) {
      errorMessage = @"手机号位数不足11位.";
      break;
    }
    
    [self requestForgetPasswordByPhoneNumber:phoneNumber];
    
    return;
  } while (NO);
  
  [SVProgressHUD showErrorWithStatus:errorMessage];
  
}

#pragma mark -
#pragma mark 关闭输入框键盘
- (IBAction)closeKeyBord:(id)sender{
  [_phoneNumberTextField resignFirstResponder];
}

#pragma mark -
#pragma mark 实现 UITextFieldDelegate 接口

// called when 'return' key pressed. return NO to ignore.
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  
  [self sendPhoneNumberButtonOnClickListener:nil];
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
-(void)requestForgetPasswordByPhoneNumber:(NSString *)phoneNumber {
  
  ForgetPasswordNetRequestBean *forgetPasswordNetRequestBean = [ForgetPasswordNetRequestBean forgetPasswordNetRequestBeanWithPhoneNumber:phoneNumber];
  _netRequestIndexForPasswordForget
  = [[DomainProtocolNetHelperSingleton sharedInstance] requestDomainProtocolWithContext:self
                                                                   andRequestDomainBean:forgetPasswordNetRequestBean
                                                                        andRequestEvent:kNetRequestTagEnum_PasswordForget
                                                                     andRespondDelegate:self];
  if (_netRequestIndexForPasswordForget != IDLE_NETWORK_REQUEST_ID) {
    [SVProgressHUD show];
  }
}

typedef enum {
  // 显示网络访问错误时的提示信息
  kHandlerMsgTypeEnum_ShowNetErrorMessage = 0,
  // 找回密码成功
  kHandlerMsgTypeEnum_ForgetPasswordSuccess
} HandlerMsgTypeEnum;

typedef enum {
  //
  kHandlerExtraDataTypeEnum_NetRequestTag = 0,
  //
  kHandlerExtraDataTypeEnum_NetErrorMessage,
  //
  kHandlerExtraDataTypeEnum_PasswordForgetMessage
} HandlerExtraDataTypeEnum;

- (void) handleMessage:(Message *) msg {
  
  switch (msg.what) {
      
    case kHandlerMsgTypeEnum_ShowNetErrorMessage:{
      
      NSString *netErrorMessageString
      = [msg.data objectForKey:[NSNumber numberWithUnsignedInteger:kHandlerExtraDataTypeEnum_NetErrorMessage]];
      
      [SVProgressHUD showErrorWithStatus:netErrorMessageString];
      
    }break;
      
    case kHandlerMsgTypeEnum_ForgetPasswordSuccess:{
      
      NSString *message
      = [msg.data objectForKey:[NSNumber numberWithUnsignedInteger:kHandlerExtraDataTypeEnum_PasswordForgetMessage]];
      [SVProgressHUD showSuccessWithStatus:message];
      
      // 返回上一界面
      [self finish];
    }break;
      
    default:
      break;
  }
}

//
- (void) clearNetRequestIndexByRequestEvent:(NSUInteger) requestEvent {
  if (kNetRequestTagEnum_PasswordForget == requestEvent) {
    _netRequestIndexForPasswordForget = IDLE_NETWORK_REQUEST_ID;
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
  
  if (requestEvent == kNetRequestTagEnum_PasswordForget) {
    ForgetPasswordNetRespondBean *forgetPasswordNetRespondBean = respondDomainBean;
    PRPLog(@"%@ -> %@", TAG, forgetPasswordNetRespondBean);
    
    //
    Message *msg = [Message obtain];
    msg.what = kHandlerMsgTypeEnum_ForgetPasswordSuccess;
    [msg.data setObject:forgetPasswordNetRespondBean.message
                 forKey:[NSNumber numberWithUnsignedInteger:kHandlerExtraDataTypeEnum_PasswordForgetMessage]];
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
