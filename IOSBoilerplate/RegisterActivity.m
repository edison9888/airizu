//
//  RegisterActivity.m
//  gameqa
//
//  Created by user on 12-9-11.
//
//

#import "RegisterActivity.h"

#import "TitleBar.h"

#import "RegisterDatabaseFieldsConstant.h"
#import "RegisterNetResquestBean.h"
#import "RegisterNetRespondBean.h"

#import "LogonDatabaseFieldsConstant.h"
#import "LogonNetRequestBean.h"
#import "LogonNetRespondBean.h"












static const NSString *const TAG = @"<RegisterActivity>";













@interface RegisterActivity ()

//
@property (nonatomic, assign) NSInteger netRequestIndexForUserLogon;
@property (nonatomic, assign) NSInteger netRequestIndexForRegister;

// 用户手机号码作为登录名
@property (nonatomic, copy) NSString *phoneNumberString;
@property (nonatomic, copy) NSString *passwordString;

// 是否同意 "爱日租服务条款"
@property (nonatomic, assign) BOOL isAgreeProtocolForAirizu;

@property (nonatomic, retain) RegisterNetRespondBean *registerNetRespondBean;
@end













@implementation RegisterActivity

//
typedef NS_ENUM(NSInteger, NetRequestTagEnum) {
  // 2.1 用户注册
  kNetRequestTagEnum_UserRegister = 0,
  // 2.2 用户登录
  kNetRequestTagEnum_UserLogon
};

#pragma mark -
#pragma mark 内部方法群
- (void)dealloc {
  PRPLog(@"dealloc: %@ [0x%x]", TAG, [self hash]);
  
  [_phoneNumberString release];
  [_passwordString release];
  
  //
  [_registerNetRespondBean release];
  
  // UI
  [_titleBarPlaceholder release];
  [_userNameTextField release];
  [_phoneNumberTextField release];
  [_emailTextField release];
  [_passwordTextField release];
  [_protocolConfirmCheckbox release];
  [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  if ([DeviceInformation isIPhone5]) {
    // 这里决不能设成 autorelease 的, 网上的代码就是 autorelease的, 4.3系统会崩溃, 因为被自动释放了
    self = [super initWithNibName:@"RegisterActivity_iphone5" bundle:nibBundleOrNil];
  } else {
    self = [super initWithNibName:@"RegisterActivity" bundle:nibBundleOrNil];
  }
  if (self) {
    // Custom initialization
    PRPLog(@"init %@ [0x%x]", TAG, [self hash]);
    
    _netRequestIndexForUserLogon = IDLE_NETWORK_REQUEST_ID;
    _netRequestIndexForRegister = IDLE_NETWORK_REQUEST_ID;
    
    _isAgreeProtocolForAirizu = YES;
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  // Do any additional setup after loading the view from its nib.
  
  // 初始化UI
  [self initTitleBar];
}

- (void)viewDidUnload
{
  
  [self setTitleBarPlaceholder:nil];
  [self setUserNameTextField:nil];
  [self setPhoneNumberTextField:nil];
  [self setEmailTextField:nil];
  [self setPasswordTextField:nil];
  [self setProtocolConfirmCheckbox:nil];
  [super viewDidUnload];
  // Release any retained subviews of the main view.
  // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)closeAllTextFieldKeyboard:(id)sender {
  [self resignFirstResponderForAllTextField];
  
}

- (IBAction)protocolConfirmCheckboxOnClickListener:(id)sender {
  
  // 保存 "自动登录" 的用户设置
  BOOL isNeedAutologin = [GlobalDataCacheForMemorySingleton sharedInstance].isNeedAutologin;
  [[GlobalDataCacheForMemorySingleton sharedInstance] setNeedAutologin:!isNeedAutologin];
  
  // 更新UI
  [self updateProtocolConfirmCheckboxSelectedState];
}

// "注册按钮"
- (IBAction)registerButtonOnClickListener:(id)sender {
  
  if (_netRequestIndexForRegister != IDLE_NETWORK_REQUEST_ID
      || _netRequestIndexForUserLogon != IDLE_NETWORK_REQUEST_ID) {
    // 不能重复发起网络请求
    return;
  }
  
  NSString *errorMessage = @"";
  do {
    if (!_isAgreeProtocolForAirizu) {
      errorMessage = @"请阅读并同意注册协议";
      break;
    }
    
    // "用户名"
    NSString *username = _userNameTextField.text;
    if ([NSString isEmpty:username]) {
      errorMessage = @"用户名不能为空";
      break;
    } else if (username.length < 2 || username.length > 16) {
      errorMessage = @"用户名长度为2-16位字符, 包括汉字、字母和数字";
      break;
    }
    
    // "手机号"
    NSString *phoneNumber = _phoneNumberTextField.text;
    if ([NSString isEmpty:phoneNumber]) {
      errorMessage = @"手机号码不能为空";
      break;
    }
    if (phoneNumber.length != 11) {
      errorMessage = @"手机号码位数不正确";
      break;
    }
    
    // "邮箱"
    NSString *email = _emailTextField.text;
    if ([NSString isEmpty:email]) {
      errorMessage = @"邮箱地址不能为空";
      break;
    }
    
    // "密码"
    NSString *password = _passwordTextField.text;
    if ([NSString isEmpty:password]) {
      errorMessage = @"密码不能为空";
      break;
    } else if (password.length < 6 || password.length > 20) {
      errorMessage = @"密码长度为6-20位英文或数字";
      break;
    }
    
    [self requestRegisterWithUsername:username phoneNumber:phoneNumber email:email password:password];
    return;
  } while (NO);
  
  [SVProgressHUD showErrorWithStatus:errorMessage];
}

-(void)resignFirstResponderForAllTextField {
  [_userNameTextField resignFirstResponder];
  [_phoneNumberTextField resignFirstResponder];
  [_emailTextField resignFirstResponder];
  [_passwordTextField resignFirstResponder];
}

//
- (IBAction)textFieldDidEndOnExit:(UITextField *)sender {
  
  [self resignFirstResponderForAllTextField];
  
  if (sender == _userNameTextField) {
    
    [_phoneNumberTextField becomeFirstResponder];
    
  } else if (sender == _phoneNumberTextField) {
    
    [_emailTextField becomeFirstResponder];
    
  } else if (sender == _emailTextField) {
    
    [_passwordTextField becomeFirstResponder];
    
  } else if (sender == _passwordTextField) {
    
    [self registerButtonOnClickListener:nil];
    
  } else {
    
  }
}

#pragma mark -
#pragma mark Activity 生命周期
-(void)onCreate:(Intent *)intent {
  PRPLog(@"%@ --> onCreate ", TAG);
}
-(void)onPause {
  PRPLog(@"%@ --> onPause ", TAG);
  
  [self closeAllTextFieldKeyboard:nil];
  
  [SVProgressHUD dismiss];
  
  [[DomainProtocolNetHelperSingleton sharedInstance] cancelAllNetRequestWithThisNetRespondDelegate:self];
  _netRequestIndexForUserLogon = IDLE_NETWORK_REQUEST_ID;
  _netRequestIndexForRegister = IDLE_NETWORK_REQUEST_ID;
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
  [titleBar setTitleByString:@"注册"];
  [titleBar hideLeftButton:NO];
  [self.titleBarPlaceholder addSubview:titleBar];
}

-(void)updateProtocolConfirmCheckboxSelectedState {
  
  _isAgreeProtocolForAirizu = !_isAgreeProtocolForAirizu;
  
  if (_isAgreeProtocolForAirizu) {
    UIImage *imageForCheckboxSelected = [UIImage imageNamed:@"icon_selected_for_checkbox.png"];
    [_protocolConfirmCheckbox setImage:imageForCheckboxSelected forState:UIControlStateNormal];
  } else {
    UIImage *imageForCheckboxNoSelected = [UIImage imageNamed:@"icon_no_selected_for_checkbox.png"];
    [_protocolConfirmCheckbox setImage:imageForCheckboxNoSelected forState:UIControlStateNormal];
  }
}

#pragma mark -
#pragma mark 实现 IDomainNetRespondCallback 接口

-(void)requestRegisterWithUsername:(NSString *)username phoneNumber:(NSString *)phoneNumber email:(NSString *)email password:(NSString *)password   {
  if ([NSString isEmpty:username] || [NSString isEmpty:phoneNumber] || [NSString isEmpty:email] || [NSString isEmpty:password]) {
    return;
  }
  
  // 发起业务接口 "2.1用户登注册" 的访问
  RegisterNetResquestBean *registerNetResquestBean = [RegisterNetResquestBean registerNetResquestBeanWithUserName:username phoneNumber:phoneNumber email:email password:password];
  
  _netRequestIndexForRegister
  = [[DomainProtocolNetHelperSingleton sharedInstance] requestDomainProtocolWithContext:self
                                                                   andRequestDomainBean:registerNetResquestBean
                                                                        andRequestEvent:kNetRequestTagEnum_UserRegister
                                                                     andRespondDelegate:self];
  if (_netRequestIndexForRegister != IDLE_NETWORK_REQUEST_ID) {
    
    // 保存用户注册时填写的 "手机号码" 和 "密码", 为登录时使用.
    self.phoneNumberString = phoneNumber;
    self.passwordString = password;
    
    [SVProgressHUD showWithStatus:@"注册中..."];
  }
}

-(void)requestLoginWithUsername:(NSString *)username password:(NSString *)password {
  if ([NSString isEmpty:username] || [NSString isEmpty:password]) {
    return;
  }
  
  // 发起业务接口 "2.2用户登录" 的访问
  LogonNetRequestBean *logonNetRequestBean = [LogonNetRequestBean logonNetRequestBeanWithLoginName:username password:password];
  logonNetRequestBean.screenSize = [GlobalDataCacheForMemorySingleton sharedInstance].screenSize;
  logonNetRequestBean.clientAVersion = [GlobalDataCacheForMemorySingleton sharedInstance].clientAVersion;
  logonNetRequestBean.clientVersion = [GlobalDataCacheForMemorySingleton sharedInstance].clientVersion;
  
  _netRequestIndexForUserLogon
  = [[DomainProtocolNetHelperSingleton sharedInstance] requestDomainProtocolWithContext:self
                                                                   andRequestDomainBean:logonNetRequestBean
                                                                        andRequestEvent:kNetRequestTagEnum_UserLogon
                                                                     andRespondDelegate:self];
  if (_netRequestIndexForUserLogon != IDLE_NETWORK_REQUEST_ID) {
    [SVProgressHUD showWithStatus:@"登录中..."];
  }
}

typedef enum {
  // 显示网络访问错误时的提示信息
  kHandlerMsgTypeEnum_ShowNetErrorMessage = 0,
  // 用户注册成功
  kHandlerMsgTypeEnum_UserRegisterSuccessfully,
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
      
    case kHandlerMsgTypeEnum_UserRegisterSuccessfully:{// "用户注册成功"
      
      // 用户注册成功后, 自动帮用户进行登录操作
      [self requestLoginWithUsername:_phoneNumberString password:_passwordString];
    }break;
      
    case kHandlerMsgTypeEnum_UserLoginSuccessfully:{// "用户登录成功"
      
      [SVProgressHUD dismiss];
      
      UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:nil
                                                           message:_registerNetRespondBean.message
                                                          delegate:self
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil];
      [alertView show];
      [alertView release];
      
    }break;
      
    default:
      break;
  }
}

//
- (void) clearNetRequestIndexByRequestEvent:(NSUInteger) requestEvent {
  if (kNetRequestTagEnum_UserLogon == requestEvent) {
    _netRequestIndexForUserLogon = IDLE_NETWORK_REQUEST_ID;
  } else if (kNetRequestTagEnum_UserRegister == requestEvent) {
    _netRequestIndexForRegister = IDLE_NETWORK_REQUEST_ID;
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
  
  if (requestEvent == kNetRequestTagEnum_UserRegister) {// 2.1 用户注册
    
    self.registerNetRespondBean = respondDomainBean;
    
    // 用户注册成功
    Message *msg = [Message obtain];
    msg.what = kHandlerMsgTypeEnum_UserRegisterSuccessfully;
    [self performSelectorOnMainThread:@selector(handleMessage:) withObject:msg waitUntilDone:NO];
    
  } else if (requestEvent == kNetRequestTagEnum_UserLogon) {// 2.2 用户登录
    
    LogonNetRespondBean *logonNetRespondBean = respondDomainBean;
    PRPLog(@"%@ -> %@", TAG, logonNetRespondBean);
    
    // 保存用户成功登录后的信息
    [ToolsFunctionForThisProgect noteLogonSuccessfulInfoWithLogonNetRespondBean:logonNetRespondBean
                                                 usernameForLastSuccessfulLogon:_phoneNumberString
                                                 passwordForLastSuccessfulLogon:_passwordString];
    
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

#pragma mark -
#pragma mark 实现 UIAlertViewDelegate 接口
// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
  // 告知登录界面, 用户已经成功登录
  [self setResult:kActivityResultCode_RESULT_OK];
  [self finish];
}

#pragma mark -
#pragma mark 实现 UITextFieldDelegate 接口
// return NO to not change text
- (BOOL)textField:(UITextField *)textField
shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string {
  
  do {
    
    if (textField == _userNameTextField) {// 必填项，2-16位字符，包括汉字、字母和数字
      
    } else if (textField == _phoneNumberTextField) {// 必填项，需要校验手机格式是否正确
      
    } else if (textField == _emailTextField) {// 必填项，需要校验手机格式是否正确
      
    } else if (textField == _passwordTextField) {// 必填项，6-20位英文或数字
      
    }
    
    return YES;
  } while (NO);
  
  return NO; // return NO to not change text
}
@end
