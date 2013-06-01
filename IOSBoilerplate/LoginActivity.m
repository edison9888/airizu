//
//  LoginActivity.h
//  airizu
//
//  Created by 唐志华 on 13-1-20.
//
//

#import "LoginActivity.h"

#import "TitleBar.h"

#import "LogonDatabaseFieldsConstant.h"
#import "LogonNetRequestBean.h"
#import "LogonNetRespondBean.h"

#import "RegisterActivity.h"
#import "PasswordForgetActivity.h"

#import "ToolsFunctionForThisProgect.h"
#import "NSString+Expand.h"
#import "NSDictionary+Helper.h"








static const NSString *const TAG = @"<LoginActivity>";


// 业务说明 : 可以从如下入口进入 "登录" 界面
// 1. 如果用户设置了 "自动登录", 那么在第一次进入 "账户"界面时, 将自动跳转 "登录"界面, 并且自动登录
// 2.
NSString *const kIntentExtraTagEnum_NeedAutoLogin = @"NeedAutoLogin";

// Session 已经过期
NSString *const kIntentExtraTagEnum_SessionHasExpired = @"SessionHasExpired";









@interface LoginActivity ()

/// 外部入参, 需要自动登录
@property (nonatomic, assign) BOOL isNeedAutoLogin;
@property (nonatomic, assign) BOOL isSessionHasExpired;

//
@property (nonatomic, assign) NSInteger netRequestIndexForUserLogon;

@property (nonatomic, copy) NSString *usernameTempBuf;
@property (nonatomic, copy) NSString *passwordTempBuf;

//
@property (nonatomic, assign) BOOL isLogging;
@end











@implementation LoginActivity

//
typedef NS_ENUM(NSInteger, NetRequestTagEnum) {
  //
  kNetRequestTagEnum_UserLogon = 0
};

typedef NS_ENUM(NSInteger, IntentRequestCodeEnum) {
  kIntentRequestCodeEnum_ToRegisterActivity = 0
};

- (void)dealloc {
  
  PRPLog(@"dealloc: %@ [0x%x]", TAG, [self hash]);
  
  [_usernameTempBuf release];
  [_passwordTempBuf release];
  
  
  /// UI
  [_titleBarPlaceholder release];
  [_userNameTextField release];
  [_passwordTextField release];
  [_autoLoginCheckbox release];
  [_forgetPasswordLabel release];
  [_loginControlsLayout release];
  [super dealloc];
}

- (void)viewDidUnload
{
  [self setTitleBarPlaceholder:nil];
  [self setUserNameTextField:nil];
  [self setPasswordTextField:nil];
  [self setAutoLoginCheckbox:nil];
  [self setForgetPasswordLabel:nil];
  [self setLoginControlsLayout:nil];
  [super viewDidUnload];
  // Release any retained subviews of the main view.
  // e.g. self.myOutlet = nil;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  if ([DeviceInformation isIPhone5]) {
    // 这里决不能设成 autorelease 的, 网上的代码就是 autorelease的, 4.3系统会崩溃, 因为被自动释放了
    self = [super initWithNibName:@"LoginActivity_iphone5" bundle:nibBundleOrNil];
  } else {
    self = [super initWithNibName:@"LoginActivity" bundle:nibBundleOrNil];
  }
  if (self) {
    // Custom initialization
    PRPLog(@"init %@ [0x%x]", TAG, [self hash]);
    
    ///
    _isNeedAutoLogin = NO;
    _isSessionHasExpired = NO;
    
    ///
    _netRequestIndexForUserLogon = IDLE_NETWORK_REQUEST_ID;
    
    _isLogging = NO;
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  // Do any additional setup after loading the view from its nib.
  
  // 初始化UI
  [self initTitleBar];
  
  //
  [self updateAutoLoginCheckboxSelectedState];
  
  //
  [self initForgetPasswordLabel];
  
  // 初始化用户最后一次成功登录的用户名和密码
  NSString *usernameForLastSuccessfulLogon = [GlobalDataCacheForMemorySingleton sharedInstance].usernameForLastSuccessfulLogon;
  if (![NSString isEmpty:usernameForLastSuccessfulLogon]) {
    [_userNameTextField setText:usernameForLastSuccessfulLogon];
  }
  
  NSString *passwordForLastSuccessfulLogon = [GlobalDataCacheForMemorySingleton sharedInstance].passwordForLastSuccessfulLogon;
  if (![NSString isEmpty:passwordForLastSuccessfulLogon]) {
    [_passwordTextField setText:passwordForLastSuccessfulLogon];
  }
  
  // 自动进行登录操作
  if (_isNeedAutoLogin) {
    [self requestLoginWithUsername:usernameForLastSuccessfulLogon password:passwordForLastSuccessfulLogon];
  } else if (_isSessionHasExpired) {
    [SVProgressHUD showErrorWithStatus:@"账号已经过期, 请重新登录."];
  }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)closeAllTextFieldKeyboard:(id)sender {
  
  [self resignFirstResponderForAllTextField];
}

- (IBAction)autoLoginCheckboxOnClickListener:(id)sender {
  
  // 保存 "自动登录" 的用户设置
  BOOL isNeedAutologin = [GlobalDataCacheForMemorySingleton sharedInstance].isNeedAutologin;
  [[GlobalDataCacheForMemorySingleton sharedInstance] setNeedAutologin:!isNeedAutologin];
  
  // 更新UI
  [self updateAutoLoginCheckboxSelectedState];
}

// "登录按钮"
- (IBAction)loginButtonOnClickListener:(id)sender {
  if (_netRequestIndexForUserLogon != IDLE_NETWORK_REQUEST_ID) {
    // 正在联网中...
    return;
  }
  
  NSString *username = _userNameTextField.text;
  NSString *password = _passwordTextField.text;
  NSString *errorMessage = @"";
  do {
    if ([NSString isEmpty:username]) {
      errorMessage = @"用户名不能为空!";
      break;
    }
    
    if ([NSString isEmpty:password]) {
      errorMessage = @"密码不能为空!";
      break;
    }
    
    [self requestLoginWithUsername:username password:password];
    return;
  } while (NO);
  
  [SVProgressHUD showErrorWithStatus:errorMessage];
}

// "快速注册按钮"
- (IBAction)registerButtonOnClickListener:(id)sender {
  
  Intent *intent = [Intent intentWithSpecificComponentClass:[RegisterActivity class]];
  [self startActivityForResult:intent requestCode:kIntentRequestCodeEnum_ToRegisterActivity];
}

-(void)resignFirstResponderForAllTextField {
  _loginControlsLayout.hidden = NO;
  
  [_userNameTextField resignFirstResponder];
  [_passwordTextField resignFirstResponder];
}

//
- (IBAction)textFieldDidEndOnExit:(UITextField *)sender {
  
  [self resignFirstResponderForAllTextField];
  
  if (sender == _userNameTextField) {
    // 打开 "密码" 输入框
    [_passwordTextField becomeFirstResponder];
    
  } else if (sender == _passwordTextField) {
    
    [self loginButtonOnClickListener:nil];
    
  } else {
    
  }
}

#pragma mark -
#pragma mark Activity 生命周期

-(BOOL)parseIncomingIntent:(Intent *)intent {
  
  do {
    if (intent == nil) {
      break;
    }
    
    if ([intent.extras containsKey:kIntentExtraTagEnum_NeedAutoLogin]) {
      _isNeedAutoLogin = YES;
      break;
    }
    
    if ([intent.extras containsKey:kIntentExtraTagEnum_SessionHasExpired]) {
      _isSessionHasExpired = YES;
      break;
    }

    
  } while (false);
  
  return YES;
}

-(void)onCreate:(Intent *)intent {
  PRPLog(@"%@ --> onCreate ", TAG);
  
  [self parseIncomingIntent:intent];
}

-(void)onPause {
  PRPLog(@"%@ --> onPause ", TAG);
  
  [self closeAllTextFieldKeyboard:nil];
  
  [SVProgressHUD dismiss];
  
  [[DomainProtocolNetHelperSingleton sharedInstance] cancelNetRequestByRequestIndex:_netRequestIndexForUserLogon];
  _netRequestIndexForUserLogon = IDLE_NETWORK_REQUEST_ID;
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
    
    if (requestCode == kIntentRequestCodeEnum_ToRegisterActivity) {
      // 从 "注册界面" 返回到此的, 返回 "RESULT_OK"
      // 证明用户已经登录成功
      [self setResult:kActivityResultCode_RESULT_OK];
      [self finish];
    }
    
  } while (false);
}

#pragma mark -
#pragma mark 初始化UI
//
- (void) initTitleBar {
  TitleBar *titleBar = [TitleBar titleBar];
  titleBar.delegate = self;
  [titleBar setTitleByString:@"登录"];
  [titleBar hideLeftButton:NO];
  [self.titleBarPlaceholder addSubview:titleBar];
}

-(void)updateAutoLoginCheckboxSelectedState {
  BOOL isNeedAutologin = [GlobalDataCacheForMemorySingleton sharedInstance].isNeedAutologin;
  if (isNeedAutologin) {
    UIImage *imageForCheckboxSelected = [UIImage imageNamed:@"icon_selected_for_checkbox.png"];
    [_autoLoginCheckbox setImage:imageForCheckboxSelected forState:UIControlStateNormal];
  } else {
    UIImage *imageForCheckboxNoSelected = [UIImage imageNamed:@"icon_no_selected_for_checkbox.png"];
    [_autoLoginCheckbox setImage:imageForCheckboxNoSelected forState:UIControlStateNormal];
  }
}

-(void)initForgetPasswordLabel{
  // 一个手指点击一次
  UITapGestureRecognizer *oneFingerOneTaps = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(forgotPasswordLabelOnClickListener)];
  [_forgetPasswordLabel addGestureRecognizer:oneFingerOneTaps];
  [oneFingerOneTaps release];
}
-(void)forgotPasswordLabelOnClickListener{
	Intent *intent = [Intent intentWithSpecificComponentClass:[PasswordForgetActivity class]];
  [self startActivity:intent];
}

#pragma mark -
#pragma mark 实现 UITextFieldDelegate 代理

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
  
  _loginControlsLayout.hidden = YES;
	
	return YES;
}

#pragma mark -
#pragma mark 实现 IDomainNetRespondCallback 接口

-(void)requestLoginWithUsername:(NSString *)username password:(NSString *)password {
  if ([NSString isEmpty:username] || [NSString isEmpty:password]) {
    return;
  }
  
  // 发起业务接口 "2.2用户登录" 的访问
  LogonNetRequestBean *logonNetRequestBean
  = [LogonNetRequestBean logonNetRequestBeanWithLoginName:username password:password];
  logonNetRequestBean.screenSize = [GlobalDataCacheForMemorySingleton sharedInstance].screenSize;
  logonNetRequestBean.clientAVersion = [GlobalDataCacheForMemorySingleton sharedInstance].clientAVersion;
  logonNetRequestBean.clientVersion = [GlobalDataCacheForMemorySingleton sharedInstance].clientVersion;
  
  _netRequestIndexForUserLogon
  = [[DomainProtocolNetHelperSingleton sharedInstance] requestDomainProtocolWithContext:self
                                                                   andRequestDomainBean:logonNetRequestBean
                                                                        andRequestEvent:kNetRequestTagEnum_UserLogon
                                                                     andRespondDelegate:self];
  if (_netRequestIndexForUserLogon != IDLE_NETWORK_REQUEST_ID) {
    self.usernameTempBuf = username;
    self.passwordTempBuf = password;
    
    [SVProgressHUD showWithStatus:@"登录中..."];
  }
}

typedef enum {
  // 显示网络访问错误时的提示信息
  kHandlerMsgTypeEnum_ShowNetErrorMessage = 0,
  // 用户登录成功
  kHandlerMsgTypeEnum_UserLoginSuccessfully
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
      
    }break;
      
    case kHandlerMsgTypeEnum_UserLoginSuccessfully:{
      
      [SVProgressHUD dismiss];
      
      [self setResult:kActivityResultCode_RESULT_OK];
      [self finish];
    }break;
      
    default:
      break;
  }
}

//
- (void) clearNetRequestIndexByRequestEvent:(NSUInteger) requestEvent {
  if (kNetRequestTagEnum_UserLogon == requestEvent) {
    _netRequestIndexForUserLogon = IDLE_NETWORK_REQUEST_ID;
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
  
  if (requestEvent == kNetRequestTagEnum_UserLogon) {
    LogonNetRespondBean *logonNetRespondBean = respondDomainBean;
    PRPLog(@"%@ -> %@", TAG, logonNetRespondBean);
    
    // 保存用户成功登录后的信息
    [ToolsFunctionForThisProgect noteLogonSuccessfulInfoWithLogonNetRespondBean:logonNetRespondBean
                                                 usernameForLastSuccessfulLogon:_usernameTempBuf
                                                 passwordForLastSuccessfulLogon:_passwordTempBuf];
    
    // 发送用户成功登录的广播消息
    Intent *intent = [Intent intent];
    [intent setAction:[[NSNumber numberWithUnsignedInteger:kUserNotificationEnum_UserLogonSuccess] stringValue]];
    [self sendBroadcast:intent];
    
    // 用户成功登录
    Message *msg = [Message obtain];
    msg.what = kHandlerMsgTypeEnum_UserLoginSuccessfully;
    [self performSelectorOnMainThread:@selector(handleMessage:) withObject:msg waitUntilDone:NO];
    
    return;
  }
  
}

#pragma mark -
#pragma mark 实现 CustomControlDelegate 接口
-(void)customControl:(id)control onAction:(NSUInteger)action {
  switch (action) {
      
    case kTitleBarActionEnum_LeftButtonClicked:{
      [self setResult:kActivityResultCode_RESULT_CANCELED];
      [self finish];
    }break;
      
    default:
      break;
  }
}

@end
