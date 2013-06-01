//
//  WriteReviewActivity.m
//  airizu
//
//  Created by 唐志华 on 13-2-26.
//
//

#import "WriteReviewActivity.h"

#import "TitleBar.h"
#import "PreloadingUIToolBar.h"

#import "ReviewItem.h"
#import "ReviewItemNetRequestBean.h"
#import "ReviewItemNetRespondBean.h"

#import "ReviewSubmitNetRequestBean.h"
#import "ReviewSubmitNetRespondBean.h"

#import "NSDictionary+Helper.h"

#import "ReviewBar.h"

static const NSString *const TAG = @"<WriteReviewActivity>";

//
NSString *const kIntentExtraTagForWriteReviewActivity_OrderID = @"OrderID";










@interface WriteReviewActivity ()
///
@property (nonatomic, assign) BOOL isIncomingIntentValid;
@property (nonatomic, assign) TitleBar *titleBar;


// 外部传入的数据
@property (nonatomic, copy) NSString *orderIdString;


///
@property (nonatomic, assign) NSInteger netRequestIndexForGetReviewItem;
@property (nonatomic, assign) NSInteger netRequestIndexForSubmitReview;

///
// 预加载UI工具条
@property (nonatomic, retain) PreloadingUIToolBar *preloadingUIToolBar;


///
@property (nonatomic, assign) CGRect writeReviewControlPlaceholderFrame;

//
@property (nonatomic, retain) UILabel *hintLabelForWriteReviewTextView;
//
@property (nonatomic, assign) ReviewBar *reviewBar;
@end











@implementation WriteReviewActivity

-(UILabel *)hintLabelForWriteReviewTextView {
  if (_hintLabelForWriteReviewTextView == nil) {
    UILabel *hintLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 150, 30)];
    [hintLabel setFont:[UIFont fontWithName:@"Arial" size:14]];
    [hintLabel setTextColor:[UIColor blackColor]];
    [hintLabel setText:@"评价房间，可获得积分"];
    self.hintLabelForWriteReviewTextView = hintLabel;
    [hintLabel release];
  }
  
  return _hintLabelForWriteReviewTextView;
}

//
typedef NS_ENUM(NSInteger, NetRequestTagEnum) {
  // 2.26 获取评论项
  kNetRequestTagEnum_GetReviewItem = 0,
  // 2.27 对房间进行评论
  kNetRequestTagEnum_SubmitReview
};

typedef NS_ENUM(NSInteger, AlertType) {
  // 提交评论成功
  kAlertType_SubmitReviewSuccessful = 0
};

- (void)dealloc {
  
  ///
  [_orderIdString release];
  //
  [_preloadingUIToolBar release];
  //
  [_hintLabelForWriteReviewTextView release];
  
  /// UI
  [_titleBarPlaceholder release];
  [_bodyScrollView release];
  [_reviewItemControlPlaceholder release];
  [_writeReviewControlPlaceholder release];
  [_writeReviewTextView release];
  [_submitButton release];
  [_bodyLayout release];
  [super dealloc];
}

- (void)viewDidUnload {
  
  ///
  self.titleBar = nil;
  self.preloadingUIToolBar = nil;
  self.reviewBar = nil;
  
  ///
  [self setTitleBarPlaceholder:nil];
  [self setBodyScrollView:nil];
  [self setReviewItemControlPlaceholder:nil];
  [self setWriteReviewControlPlaceholder:nil];
  [self setWriteReviewTextView:nil];
  [self setSubmitButton:nil];
  [self setBodyLayout:nil];
  [super viewDidUnload];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  if ([DeviceInformation isIPhone5]) {
    // 这里决不能设成 autorelease 的, 网上的代码就是 autorelease的, 4.3系统会崩溃, 因为被自动释放了
    self = [super initWithNibName:@"WriteReviewActivity_iphone5" bundle:nibBundleOrNil];
  } else {
    self = [super initWithNibName:@"WriteReviewActivity" bundle:nibBundleOrNil];
  }
  if (self) {
    // Custom initialization
    
    _netRequestIndexForGetReviewItem = IDLE_NETWORK_REQUEST_ID;
    _netRequestIndexForSubmitReview = IDLE_NETWORK_REQUEST_ID;
    
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
    
    // 初始化 "预加载UI等待工具条"
    [self initPreloadingUIToolBar];
    
    // 首先检查是否有城市信息列表的缓存, 如果没有, 就从网络中拉取数据
    ReviewItemNetRespondBean *reviewItemNetRespondBean = [GlobalDataCacheForMemorySingleton sharedInstance].reviewItemNetRespondBean;
    if (reviewItemNetRespondBean == nil || reviewItemNetRespondBean.itemList == nil) {
      
      [GlobalDataCacheForMemorySingleton sharedInstance].reviewItemNetRespondBean = nil;
      
      // 显示 "预加载UI等待工具条"
      [_preloadingUIToolBar showInView:self.view];
      
      // 请求 评论项
      _netRequestIndexForGetReviewItem = [self requestReviewItems];
      
    } else {
      
      // 加载 "本界面真正的UI, 并且使用 ReviewItemNetRespondBean 初始化"
      [self loadRealUIAndUseReviewItemNetRespondBeanInitialize];
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

- (IBAction)submitButtonOnClickListener:(id)sender {
  
  if (_netRequestIndexForSubmitReview != IDLE_NETWORK_REQUEST_ID) {
    return;
  }
  
  do {
    NSString *reviewContent = _writeReviewTextView.text;
    if ([NSString isEmpty:reviewContent]) {
      break;
    }
    
    NSDictionary *reviewItemScoreDictionary = _reviewBar.reviewItemValueDictionary;
    _netRequestIndexForSubmitReview = [self requestSubmitReviewWithOrderId:_orderIdString reviewContent:reviewContent reviewItemScoreDictionary:reviewItemScoreDictionary];
    if (_netRequestIndexForSubmitReview != IDLE_NETWORK_REQUEST_ID) {
      [SVProgressHUD showWithStatus:@"评论提交中..." maskType:SVProgressHUDMaskTypeBlack];
    }
    
    return;
  } while (NO);
  
  [SVProgressHUD showErrorWithStatus:@"评论内容不能为空."];
}

#pragma mark -
#pragma mark Activity 生命周期

-(BOOL)parseIncomingIntent:(Intent *)intent {
  do {
    if (intent == nil) {
      break;
    }
    
    if (![intent.extras containsKey:kIntentExtraTagForWriteReviewActivity_OrderID]) {
      NSAssert(NO, @"has not OrderID in incoming ! ");
      break;
    }
    
    // 订单ID
    NSString *orderIdStringTest
    = [intent.extras objectForKey:kIntentExtraTagForWriteReviewActivity_OrderID];
    if (![orderIdStringTest isKindOfClass:[NSString class]] || [NSString isEmpty:orderIdStringTest]) {
      break;
    }
    
    self.orderIdString = orderIdStringTest;
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
  
  [[DomainProtocolNetHelperSingleton sharedInstance] cancelAllNetRequestWithThisNetRespondDelegate:self];
  _netRequestIndexForGetReviewItem = IDLE_NETWORK_REQUEST_ID;
  _netRequestIndexForSubmitReview = IDLE_NETWORK_REQUEST_ID;
  
}

-(void)onResume {
  PRPLog(@"%@ --> onResume ", TAG);
  
  
}

#pragma mark -
#pragma mark 初始化UI
//
-(void)initTitleBar {
  TitleBar *titleBar = [TitleBar titleBar];
  titleBar.delegate = self;
  [titleBar setTitleByString:@"写评论"];
  [titleBar hideLeftButton:NO];
  [self.titleBarPlaceholder addSubview:titleBar];
  
  self.titleBar = titleBar;
}

// 初始化 "预加载UI工具条"
-(void)initPreloadingUIToolBar {
  self.preloadingUIToolBar = [PreloadingUIToolBar preloadingUIToolBar];
  _preloadingUIToolBar.delegate = self;
  
}

-(void)loadRealUIAndUseReviewItemNetRespondBeanInitialize{
  _bodyScrollView.hidden = NO;
  
  ReviewItemNetRespondBean *reviewItemNetRespondBean
  = [GlobalDataCacheForMemorySingleton sharedInstance].reviewItemNetRespondBean;
  
  ReviewBar *reviewBar
  = [ReviewBar reviewBarWithFrame:CGRectMake(0, 0, CGRectGetWidth(_reviewItemControlPlaceholder.frame), CGRectGetHeight(_reviewItemControlPlaceholder.frame))
         reviewItemNetRespondBean:reviewItemNetRespondBean];
  
  _reviewItemControlPlaceholder.frame
  = CGRectMake(0,
               CGRectGetMinY(_reviewItemControlPlaceholder.frame),
               CGRectGetWidth(reviewBar.frame),
               CGRectGetHeight(reviewBar.frame));
  [_reviewItemControlPlaceholder addSubview:reviewBar];
  self.reviewBar = reviewBar;
  
  _writeReviewControlPlaceholder.frame
  = CGRectMake(CGRectGetMinX(_writeReviewControlPlaceholder.frame),
               CGRectGetMaxY(_reviewItemControlPlaceholder.frame),
               CGRectGetWidth(_writeReviewControlPlaceholder.frame),
               CGRectGetHeight(_writeReviewControlPlaceholder.frame));
  _writeReviewControlPlaceholderFrame = _writeReviewControlPlaceholder.frame;
  
  //
  _bodyScrollView.contentSize = CGSizeMake(CGRectGetWidth(_bodyScrollView.frame), CGRectGetMaxY(_writeReviewControlPlaceholder.frame));
  
  //
  _writeReviewTextView.layer.borderColor = [UIColor grayColor].CGColor;
	_writeReviewTextView.layer.borderWidth = 1;
	_writeReviewTextView.layer.cornerRadius = 5;
  // 提示信息
  [_writeReviewTextView addSubview:self.hintLabelForWriteReviewTextView];
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
      
      if (_netRequestIndexForGetReviewItem == IDLE_NETWORK_REQUEST_ID) {
        _netRequestIndexForGetReviewItem = [self requestReviewItems];
        if (_netRequestIndexForGetReviewItem != IDLE_NETWORK_REQUEST_ID) {
          [_preloadingUIToolBar showRefreshButton:NO];
        }
      }
    }
  }
}

#pragma mark -
#pragma mark 网络请求相关方法群

-(NSInteger)requestReviewItems{
  ReviewItemNetRequestBean *netRequestBean
  = [ReviewItemNetRequestBean reviewItemNetRequestBean];
  NSInteger netRequestIndex
  = [[DomainProtocolNetHelperSingleton sharedInstance] requestDomainProtocolWithContext:self
                                                                   andRequestDomainBean:netRequestBean
                                                                        andRequestEvent:kNetRequestTagEnum_GetReviewItem
                                                                     andRespondDelegate:self];
  return netRequestIndex;
}

-(NSInteger)requestSubmitReviewWithOrderId:(NSString *)orderId
                             reviewContent:(NSString *)reviewContent
                 reviewItemScoreDictionary:(NSDictionary *)reviewItemScoreDictionary {
  ReviewSubmitNetRequestBean *netRequestBean
  = [ReviewSubmitNetRequestBean reviewSubmitNetRequestBeanWithOrderId:orderId
                                                        reviewContent:reviewContent
                                                  reviewItemScoreList:reviewItemScoreDictionary];
  NSInteger netRequestIndex
  = [[DomainProtocolNetHelperSingleton sharedInstance] requestDomainProtocolWithContext:self
                                                                   andRequestDomainBean:netRequestBean
                                                                        andRequestEvent:kNetRequestTagEnum_SubmitReview
                                                                     andRespondDelegate:self];
  return netRequestIndex;
  
}

typedef enum {
  //
  kHandlerMsgTypeEnum_ShowNetErrorMessage = 0,
  //
  kHandlerMsgTypeEnum_GetReviewItemSuccessful,
  //
  kHandlerMsgTypeEnum_SubmitReviewSuccessful
} HandlerMsgTypeEnum;

typedef enum {
  //
  kHandlerExtraDataTypeEnum_NetRequestTag = 0,
  //
  kHandlerExtraDataTypeEnum_NetErrorMessage
} HandlerExtraDataTypeEnum;

- (void) handleMessage:(Message *) msg {
  PRPLog(@"%@ -> handleMessage --- start ! ", TAG);
  
  switch (msg.what) {
      
    case kHandlerMsgTypeEnum_ShowNetErrorMessage:{
      
      NSString *netErrorMessageString
      = [msg.data objectForKey:[NSNumber numberWithUnsignedInteger:kHandlerExtraDataTypeEnum_NetErrorMessage]];
      
      [SVProgressHUD showErrorWithStatus:netErrorMessageString];
      
      if (!_preloadingUIToolBar.isDismissed) {
        [_preloadingUIToolBar showRefreshButton:YES];
      }
      
    }break;
      
    case kHandlerMsgTypeEnum_GetReviewItemSuccessful:{
      
      // 隐藏 "界面预加载UI"
      if (!_preloadingUIToolBar.isDismissed) {
        [_preloadingUIToolBar dismiss];
      }
      
      // 显示真正的UI
      [self loadRealUIAndUseReviewItemNetRespondBeanInitialize];
      
      
    }break;
      
    case kHandlerMsgTypeEnum_SubmitReviewSuccessful:{
      [SVProgressHUD dismiss];
      
      UIAlertView *alert
      = [[UIAlertView alloc] initWithTitle:nil
                                   message:@"提交评论成功"
                                  delegate:self
                         cancelButtonTitle:nil
                         otherButtonTitles:@"确定", nil];
      alert.tag = kAlertType_SubmitReviewSuccessful;
      [alert show];
      [alert release];
    }break;
      
    default:
      break;
  }
}

- (void) clearNetRequestIndexByRequestEvent:(NSUInteger) requestEvent {
  if (kNetRequestTagEnum_GetReviewItem == requestEvent) {
    _netRequestIndexForGetReviewItem = IDLE_NETWORK_REQUEST_ID;
  } else if (kNetRequestTagEnum_SubmitReview == requestEvent) {
    _netRequestIndexForSubmitReview = IDLE_NETWORK_REQUEST_ID;
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
  
  if (requestEvent == kNetRequestTagEnum_GetReviewItem) {// 2.25 获得房间评论
    ReviewItemNetRespondBean *reviewItemNetRespondBean = respondDomainBean;
    
    // 缓存评论项
    [GlobalDataCacheForMemorySingleton sharedInstance].reviewItemNetRespondBean = reviewItemNetRespondBean;
    
    //
    Message *msg = [Message obtain];
    msg.what = kHandlerMsgTypeEnum_GetReviewItemSuccessful;
    [self performSelectorOnMainThread:@selector(handleMessage:) withObject:msg waitUntilDone:NO];
    
  } else if (requestEvent == kNetRequestTagEnum_SubmitReview) {// 2.27 对房间进行评论
    
    //
    Message *msg = [Message obtain];
    msg.what = kHandlerMsgTypeEnum_SubmitReviewSuccessful;
    [self performSelectorOnMainThread:@selector(handleMessage:) withObject:msg waitUntilDone:NO];
  }
}

#pragma mark -
#pragma mark 实现 UIAlertViewDelegate 接口
// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
  
  switch (alertView.tag) {
    case kAlertType_SubmitReviewSuccessful:{// "提交评论成功"
      [self setResult:kActivityResultCode_RESULT_OK];
      [self finish];
    }break;
      
    default:
      break;
  }
}

#pragma mark -
#pragma mark 实现 UITextViewDelegate 协议

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
  
	_writeReviewControlPlaceholder.frame
  = CGRectMake(CGRectGetMinX(_writeReviewControlPlaceholder.frame),
               CGRectGetMinY(_reviewItemControlPlaceholder.frame),
               CGRectGetWidth(_writeReviewControlPlaceholder.frame),
               CGRectGetHeight(_writeReviewControlPlaceholder.frame));
	[_writeReviewControlPlaceholder setNeedsDisplay];
  
  _submitButton.hidden = YES;
	return YES;
}


-(BOOL)textViewShouldEndEditing:(UITextView *)textView{
	
  _writeReviewControlPlaceholder.frame = _writeReviewControlPlaceholderFrame;
	[_writeReviewControlPlaceholder setNeedsDisplay];
  
  _submitButton.hidden = NO;
  
	return YES;
}

-(void)textViewDidBeginEditing:(UITextView *)textView{
	[_hintLabelForWriteReviewTextView removeFromSuperview];
}


- (void)textViewDidEndEditing:(UITextView *)textView{
	NSString *text = textView.text;
  if (!text || text.length <=0) {
    [_writeReviewTextView addSubview:self.hintLabelForWriteReviewTextView];
  }
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
	
	NSCharacterSet *characterSet = [NSCharacterSet newlineCharacterSet];
	NSRange replacementTextRange = [text rangeOfCharacterFromSet:characterSet];
	NSUInteger location = replacementTextRange.location;
	if (textView.text.length + text.length > 140) {
		if (location != NSNotFound) {
			[textView resignFirstResponder];
		}
		return NO;
	} else if (location != NSNotFound) {
		[textView resignFirstResponder];
		return NO;
	}
	return YES;
}

@end
