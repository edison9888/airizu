//
//  UserInformationActivity.m
//  airizu
//
//  Created by 唐志华 on 13-2-10.
//
//

#import "UserInformationActivity.h"

#import "TitleBar.h"
#import "PreloadingUIToolBar.h"

#import "AccountIndexDatabaseFieldsConstant.h"
#import "AccountIndexNetRequestBean.h"
#import "AccountIndexNetRespondBean.h"

#import "UIImage+ImageCompression.h"

#import "AFNetworking.h"

#import "UpdateAccountInfoDatabaseFieldsConstant.h"









static const NSString *const TAG = @"<UserInformationActivity>";









@interface UserInformationActivity ()

///
@property (nonatomic, assign) BOOL isIncomingIntentValid;
@property (nonatomic, assign) TitleBar *titleBar;

//
@property (nonatomic, assign) NSInteger netRequestIndexForGetAccountInfo;
@property (nonatomic, assign) NSInteger netRequestIndexForUpdateAccountInfo;

// 预加载UI工具条
@property (nonatomic, retain) PreloadingUIToolBar *preloadingUIToolBar;

// 用户头像
@property (nonatomic, retain) UIImage *userPhoto;

// 性别icon
@property (nonatomic, retain) UIImage *radioButtonIconSelected;
@property (nonatomic, retain) UIImage *radioButtonIconNormal;
//
@property (nonatomic, assign) BOOL isMan;

@end









@implementation UserInformationActivity

//
typedef NS_ENUM(NSInteger, NetRequestTagEnum) {
  // 2.15 获取账号首页信息
  kNetRequestTagEnum_GetAccountInfo = 0,
  // 更新用户信息
  kNetRequestTagEnum_UpdateAccountInfo
};

- (void)dealloc {
  
  //
  [_preloadingUIToolBar release];
  //
  [_userPhoto release];
  
  //
  [_radioButtonIconSelected release];
  [_radioButtonIconNormal release];
  
  
  /// UI
  [_titleBarPlaceholder release];
  [_userPhotoImageView release];
  [_userNameTextField release];
  [_userMobileNumberLabel release];
  [_userEmailLabel release];
  [_iconForMobileVerified release];
  [_iconForEmailVerified release];
  [_bodyLayout release];
  [_manRadioButton release];
  [_womanRadioButton release];
  [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  if ([DeviceInformation isIPhone5]) {
    // 这里决不能设成 autorelease 的, 网上的代码就是 autorelease的, 4.3系统会崩溃, 因为被自动释放了
    self = [super initWithNibName:@"UserInformationActivity_iphone5" bundle:nibBundleOrNil];
  } else {
    self = [super initWithNibName:@"UserInformationActivity" bundle:nibBundleOrNil];
  }
  if (self) {
    // Custom initialization
    
    _netRequestIndexForGetAccountInfo = IDLE_NETWORK_REQUEST_ID;
    _netRequestIndexForUpdateAccountInfo = IDLE_NETWORK_REQUEST_ID;
    
    self.radioButtonIconNormal = [UIImage imageNamed:@"radio_button.png"];
    self.radioButtonIconSelected = [UIImage imageNamed:@"radio_button_selected.png"];
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  // Do any additional setup after loading the view from its nib.
  
  // 初始化UI
  [self initTitleBar];
  
  // 加载 页面预加载UI
  [self initPreloadingUIToolBar];
  //
  [_preloadingUIToolBar showInView:self.view];
  
  // 获取账号首页信息
  _netRequestIndexForGetAccountInfo = [self requestUserAccountIndexInfo];
  
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
  [self setUserPhotoImageView:nil];
  [self setUserNameTextField:nil];
  [self setUserMobileNumberLabel:nil];
  [self setUserEmailLabel:nil];
  [self setIconForMobileVerified:nil];
  [self setIconForEmailVerified:nil];
  [self setBodyLayout:nil];
  [self setManRadioButton:nil];
  [self setWomanRadioButton:nil];
  [super viewDidUnload];
}

//

// 加载用户头像 按钮
- (IBAction)loadUserPhotoButtonOnClickListener:(id)sender {
  UIActionSheet *actionSheet
  = [[UIActionSheet alloc] initWithTitle:@"上传头像"
                                delegate:self
                       cancelButtonTitle:@"取消"
                  destructiveButtonTitle:@"拍照"
                       otherButtonTitles:@"从相册上传",nil];
	actionSheet.delegate = self;
	[actionSheet showInView:self.view];
	[actionSheet release];
}

// 确定 按钮
- (IBAction)okButtonOnClickListener:(id)sender {
  NSString *userNameString = _userNameTextField.text;
  if ([NSString isEmpty:userNameString]) {
    [SVProgressHUD showErrorWithStatus:@"用户名不能为空!"];
    return;
  }
  
  NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:10];
  [parameters setObject:userNameString forKey:k_AccountUpdate_RequestKey_userName];
  NSString *genderString;
  if (_isMan) {
    genderString = @"1";
  } else {
    genderString = @"0";
  }
  [parameters setObject:genderString forKey:k_AccountUpdate_RequestKey_sex];
  
  /*
   // 之前发现上传图片失败的原因已经找到, 在appendPartWithFileData方法中
   // 20130220 tangzhihua : 之前这里是 file 字段, 现在 改成 form-data, 才能保证 爱日租项目没有问题
   [mutableHeaders setValue:[NSString stringWithFormat:@"form-data; name=\"%@\"; filename=\"%@\"", name, fileName] forKey:@"Content-Disposition"];
   */
  NSURL *url = [NSURL URLWithString:kUrlConstant_MainUrl];
  AFHTTPClient *httpClient = [AFHTTPClient clientWithBaseURL:url];
  
  NSMutableURLRequest *request
  = [httpClient multipartFormRequestWithMethod:@"POST"
                                          path:[NSString stringWithFormat:@"%@%@", kUrlConstant_MainPtah, kUrlConstant_SpecialPath_account_update]
                                    parameters:parameters
                     constructingBodyWithBlock: ^(id formData) {
                       
                       if (_userPhoto != nil) {
                         NSData *imageData = UIImageJPEGRepresentation(_userPhoto, 0.6);
                         [formData appendPartWithFileData:imageData mimeType:@"image/jpeg" name:@"image"];
                       }
                     }];
  
  AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
  [operation setUploadProgressBlock:^(NSInteger bytesWritten, NSInteger totalBytesWritten, NSInteger totalBytesExpectedToWrite) {
    PRPLog(@"Sent %d of %d bytes", totalBytesWritten, totalBytesExpectedToWrite);
    if (totalBytesWritten == totalBytesExpectedToWrite) {
      [SVProgressHUD dismiss];
      [self setResult:kActivityResultCode_RESULT_OK];
      [self finish];
    }
  }];
  [operation start];
  
  [SVProgressHUD showWithStatus:@"图片上传中..." maskType:SVProgressHUDMaskTypeBlack];
}

-(void)resignFirstResponderForAllTextField {
  [_userNameTextField resignFirstResponder];
}

- (IBAction)closeAllTextFieldKeyboard:(id)sender {
  [self resignFirstResponderForAllTextField];
}

//
- (IBAction)textFieldDidEndOnExit:(UITextField *)sender {
  
  [self resignFirstResponderForAllTextField];
  
  if (sender == _userNameTextField) {
    
    
    
  }
}

- (IBAction)genderRadioButtonOnClickListener:(UIButton *)sender {
  if (_manRadioButton == sender) {// "男"
    [_manRadioButton setImage:_radioButtonIconSelected forState:UIControlStateNormal];
    [_womanRadioButton setImage:_radioButtonIconNormal forState:UIControlStateNormal];
    
    _isMan = YES;
    
  } else {// "女"
    
    [_manRadioButton setImage:_radioButtonIconNormal forState:UIControlStateNormal];
    [_womanRadioButton setImage:_radioButtonIconSelected forState:UIControlStateNormal];
    
    _isMan = NO;
  }
}





#pragma mark -
#pragma mark Activity 生命周期
-(void)onCreate:(Intent *)intent {
  PRPLog(@"%@ --> onCreate ", TAG);
  
  
}

-(void)onPause {
  PRPLog(@"%@ --> onPause ", TAG);
  
  [SVProgressHUD dismiss];
  
  [[DomainProtocolNetHelperSingleton sharedInstance] cancelNetRequestByRequestIndex:_netRequestIndexForGetAccountInfo];
  _netRequestIndexForGetAccountInfo = IDLE_NETWORK_REQUEST_ID;
}

-(void)onResume {
  PRPLog(@"%@ --> onResume ", TAG);
  
  
}

#pragma mark -
#pragma mark 实现 UIActionSheetDelegate 接口
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 0) { // "拍照"
		if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
      
			UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
			imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
			imagePickerController.delegate = self;
			[self presentModalViewController:imagePickerController animated:YES];
			[imagePickerController release];
		}
    
	} else if (buttonIndex == 1) {// "从相册上传"
    
		if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
      
			UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
			imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
			imagePickerController.delegate = self;
			imagePickerController.allowsEditing = YES;
			[self presentModalViewController:imagePickerController animated:YES];
			[imagePickerController release];
		}
	}
}

#pragma mark -
#pragma mark 实现 UIPickerViewDelegate 接口
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo NS_DEPRECATED_IOS(2_0, 3_0) {
  
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
	if (picker.sourceType == UIImagePickerControllerSourceTypeCamera
      || picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary) {
    
		self.userPhoto = [[info objectForKey:UIImagePickerControllerOriginalImage] imageByScalingForSize:CGSizeMake(85, 85)];
		_userPhotoImageView.image = _userPhoto;
	}
	[picker dismissModalViewControllerAnimated:YES];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
	[picker dismissModalViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark 实现 UITextFieldDelegate 接口
// return NO to not change text
- (BOOL)textField:(UITextField *)textField
shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string {
  
  do {
    
    if (textField == _userNameTextField) {// 必填项，2-16位字符，包括汉字、字母和数字
      
    }
    return YES;
  } while (NO);
  
  return NO; // return NO to not change text
}

#pragma mark -
#pragma mark 初始化UI

//
// 初始化 "预加载UI工具条"
-(void)initPreloadingUIToolBar {
  self.preloadingUIToolBar = [PreloadingUIToolBar preloadingUIToolBar];
  _preloadingUIToolBar.delegate = self;
  
}

//
-(void)initTitleBar {
  TitleBar *titleBar = [TitleBar titleBar];
  titleBar.delegate = self;
  [titleBar setTitleByString:@"个人信息"];
  [titleBar hideLeftButton:NO];
  [self.titleBarPlaceholder addSubview:titleBar];
  
  self.titleBar = titleBar;
}

//
-(void)loadRealUIAndUseAccountIndexNetRespondBeanInitialize:(AccountIndexNetRespondBean *)accountIndexNetRespondBean{
  if (![accountIndexNetRespondBean isKindOfClass:[AccountIndexNetRespondBean class]]) {
    // 入参错误
    return;
  }
  
  //
  [_preloadingUIToolBar removeFromSuperview];
  self.preloadingUIToolBar = nil;
  
  _bodyLayout.hidden = NO;
  
  // "用户头像"
  NSURL *urlForUserPhoto = [NSURL URLWithString:accountIndexNetRespondBean.userImageURL];
  UIImage *placeholderImage = [UIImage imageNamed:@"user_avatar_background"];
  [_userPhotoImageView setImageWithURL:urlForUserPhoto placeholderImage:placeholderImage];
  
  // 用户名
  _userNameTextField.text = accountIndexNetRespondBean.userName;
  
  // 性别
  if (kSexEnum_Man == accountIndexNetRespondBean.sex) {
    [self genderRadioButtonOnClickListener:_manRadioButton];
  } else {
    [self genderRadioButtonOnClickListener:_womanRadioButton];
  }
  
  //
  _userMobileNumberLabel.text = accountIndexNetRespondBean.phoneNumber;
  
  //
  _userEmailLabel.text = accountIndexNetRespondBean.email;
  
  //
  if (accountIndexNetRespondBean.isValidatePhone) {
    _iconForMobileVerified.hidden = NO;
  }
  
  //
  if (accountIndexNetRespondBean.isValidateEmail) {
    _iconForEmailVerified.hidden = NO;
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
      // 重新请求用户首页信息
      if (_netRequestIndexForGetAccountInfo == IDLE_NETWORK_REQUEST_ID) {
        _netRequestIndexForGetAccountInfo = [self requestUserAccountIndexInfo];
        if (_netRequestIndexForGetAccountInfo != IDLE_NETWORK_REQUEST_ID) {
          [_preloadingUIToolBar showRefreshButton:NO];
        }
      }
    }
    
  }
  
}

#pragma mark -
#pragma mark 实现 IDomainNetRespondCallback 接口

// 开始请求, 2.15 获取账号首页信息
-(NSInteger)requestUserAccountIndexInfo {
  AccountIndexNetRequestBean *netRequestBean = [AccountIndexNetRequestBean accountIndexNetRequestBean];
  NSInteger netRequestIndex
  = [[DomainProtocolNetHelperSingleton sharedInstance] requestDomainProtocolWithContext:self
                                                                   andRequestDomainBean:netRequestBean
                                                                        andRequestEvent:kNetRequestTagEnum_GetAccountInfo
                                                                     andRespondDelegate:self];
  return netRequestIndex;
}

typedef enum {
  // 显示网络访问错误时的提示信息
  kHandlerMsgTypeEnum_ShowNetErrorMessage = 0,
  // 获取 "用户账户信息" 数据成功
  kHandlerMsgTypeEnum_GetAccountInfoSuccessful
} HandlerMsgTypeEnum;

typedef enum {
  //
  kHandlerExtraDataTypeEnum_NetRequestTag = 0,
  //
  kHandlerExtraDataTypeEnum_NetErrorMessage,
  //
  kHandlerExtraDataTypeEnum_AccountIndexNetRespondBean
} HandlerExtraDataTypeEnum;

- (void) handleMessage:(Message *) msg {
  
  switch (msg.what) {
      
    case kHandlerMsgTypeEnum_ShowNetErrorMessage:{
      
      NSString *netErrorMessageString
      = [msg.data objectForKey:[NSNumber numberWithUnsignedInteger:kHandlerExtraDataTypeEnum_NetErrorMessage]];
      NSNumber *netRequestTag
      = [msg.data objectForKey:[NSNumber numberWithUnsignedInteger:kHandlerExtraDataTypeEnum_NetRequestTag]];
      
      if ([netRequestTag integerValue] == kNetRequestTagEnum_GetAccountInfo) {
        [_preloadingUIToolBar showRefreshButton:YES];
      }
      
      [SVProgressHUD showErrorWithStatus:netErrorMessageString];
      
    }break;
      
    case kHandlerMsgTypeEnum_GetAccountInfoSuccessful:{
      
      // 隐藏 预加载UI
      [_preloadingUIToolBar dismiss];
      
      //
      AccountIndexNetRespondBean *accountIndexNetRespondBean = [msg.data objectForKey:[NSNumber numberWithUnsignedInteger:kHandlerExtraDataTypeEnum_AccountIndexNetRespondBean]];
      [self loadRealUIAndUseAccountIndexNetRespondBeanInitialize:accountIndexNetRespondBean];
      
      [SVProgressHUD dismiss];
    }break;
      
    default:
      break;
  }
}

//
- (void) clearNetRequestIndexByRequestEvent:(NSUInteger) requestEvent {
  if (kNetRequestTagEnum_GetAccountInfo == requestEvent) {
    _netRequestIndexForGetAccountInfo = IDLE_NETWORK_REQUEST_ID;
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
  
  if (requestEvent == kNetRequestTagEnum_GetAccountInfo) {// 2.15 获取账号首页信息
    AccountIndexNetRespondBean *accountIndexNetRespondBean = (AccountIndexNetRespondBean *)respondDomainBean;
    
    // 初始化用户账号信息
    Message *msg = [Message obtain];
    msg.what = kHandlerMsgTypeEnum_GetAccountInfoSuccessful;
    [msg.data setObject:accountIndexNetRespondBean forKey:[NSNumber numberWithUnsignedInteger:kHandlerExtraDataTypeEnum_AccountIndexNetRespondBean]];
    [self performSelectorOnMainThread:@selector(handleMessage:) withObject:msg waitUntilDone:NO];
    
    return;
    
  }
}


@end
