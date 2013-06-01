//
//  HelpActivity.m
//  airizu
//
//  Created by 唐志华 on 13-2-7.
//
//

#import "HelpActivity.h"

#import "TitleBar.h"
#import "HelpTypeTabhostBar.h"

#import "PreloadingUIToolBar.h"

#import "HelpInfo.h"
#import "HelpNetRequestBean.h"
#import "HelpNetRespondBean.h"









@interface HelpActivity ()
@property (nonatomic, assign) NSInteger netRequestIndexForHelp;

// 预加载UI工具条
@property (nonatomic, retain) PreloadingUIToolBar *preloadingUIToolBar;

@property (nonatomic, retain) HelpNetRespondBean *helpNetRespondBean;
@end











@implementation HelpActivity

//
typedef NS_ENUM(NSInteger, NetRequestTagEnum) {
  //
  kNetRequestTagEnum_Help
};


- (void)dealloc {
  
  //
  [_preloadingUIToolBar release];
  //
  [_helpNetRespondBean release];
  
  
  /// UI
  [_titleBarPlaceholder release];
  [_helpTitleLabel release];
  [_helpTypeTabhostBarPlaceholder release];
  [_helpContentScrollView release];
  [_helpContentLabel release];
  [_bodyLayout release];
  [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  if ([DeviceInformation isIPhone5]) {
    // 这里决不能设成 autorelease 的, 网上的代码就是 autorelease的, 4.3系统会崩溃, 因为被自动释放了
    self = [super initWithNibName:@"HelpActivity_iphone5" bundle:nibBundleOrNil];
  } else {
    self = [super initWithNibName:@"HelpActivity" bundle:nibBundleOrNil];
  }
  
  if (self) {
    // Custom initialization
    _netRequestIndexForHelp = IDLE_NETWORK_REQUEST_ID;
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  // Do any additional setup after loading the view from its nib.
  
  // 初始化UI
  [self initTitleBar];
  // 加载 "预加载UI等待工具条"
  [self initPreloadingUIToolBar];
  
  // 先从本地缓存加载数据, 如果没有, 就从网络重新加载
  self.helpNetRespondBean = [GlobalDataCacheForMemorySingleton sharedInstance].helpNetRespondBean;
  
  if (_helpNetRespondBean != nil) {
    
    [self initHelpTypeTabhostBarWithHelpNetRespondBean:_helpNetRespondBean];
    
  } else {
    
    // 显示 "预加载UI"
    [_preloadingUIToolBar showInView:self.view];
    
    // 请求房源信息
    _netRequestIndexForHelp = [self requestHelp];
  }
  
  
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
  [self setTitleBarPlaceholder:nil];
  [self setHelpTitleLabel:nil];
  [self setHelpTypeTabhostBarPlaceholder:nil];
  [self setHelpContentScrollView:nil];
  [self setHelpContentLabel:nil];
  [self setBodyLayout:nil];
  [super viewDidUnload];
}

#pragma mark -
#pragma mark 初始化UI
//
-(void)initTitleBar {
  TitleBar *titleBar = [TitleBar titleBar];
  titleBar.delegate = self;
  [titleBar setTitleByString:@"帮助"];
  [titleBar hideLeftButton:NO];
  [self.titleBarPlaceholder addSubview:titleBar];
}

//
-(void)initHelpTypeTabhostBarWithHelpNetRespondBean:(HelpNetRespondBean *)helpNetRespondBean {
  // 显示 内容区域
  _bodyLayout.hidden = NO;
  
  HelpTypeTabhostBar *helpTypeTabhostBar
  = [HelpTypeTabhostBar helpTypeTabhostBarWithHelpNetRespondBean:helpNetRespondBean];
  helpTypeTabhostBar.delegate = self;
  [self customControl:helpTypeTabhostBar onAction:0];
  [_helpTypeTabhostBarPlaceholder addSubview:helpTypeTabhostBar];
}

// 加载 "预加载UI等待工具条"
-(void)initPreloadingUIToolBar {
  self.preloadingUIToolBar = [PreloadingUIToolBar preloadingUIToolBar];
  _preloadingUIToolBar.delegate = self;
}
#pragma mark -
#pragma mark 实现 CustomControlDelegate 接口
-(void)customControl:(id)control onAction:(NSUInteger)action {
  
  if ([control isKindOfClass:[TitleBar class]]) {
    
    switch (action) {
        
      case kTitleBarActionEnum_LeftButtonClicked:{
        [self finish];
      }break;
        
      default:
        break;
    }
    
  } else if ([control isKindOfClass:[HelpTypeTabhostBar class]]) {
    
    _helpTitleLabel.text = nil;
    _helpContentLabel.text = nil;
    
    do {
      if (_helpNetRespondBean == nil || _helpNetRespondBean.helpInfoList == nil) {
        break;
      }
      // action 是tab item 索引
      if (action >= _helpNetRespondBean.helpInfoList.count) {
        break;
      }
      HelpInfo *helpInfo = [_helpNetRespondBean.helpInfoList objectAtIndex:action];
      if (helpInfo == nil) {
        break;
      }
      
      // 帮助标题
      _helpTitleLabel.text = helpInfo.title;
      
      // 帮助内容
      if (![NSString isEmpty:helpInfo.content]) {
        CGSize contentSize
        = [helpInfo.content sizeWithFont:[UIFont systemFontOfSize:14]
                       constrainedToSize:CGSizeMake(CGRectGetWidth(_helpContentScrollView.frame),
                                                    CGRectGetHeight(_helpContentScrollView.frame))
                           lineBreakMode:UILineBreakModeCharacterWrap];
        _helpContentLabel.frame
        = CGRectMake(CGRectGetMinX(_helpContentLabel.frame),
                     CGRectGetMinY(_helpContentLabel.frame),
                     contentSize.width,
                     contentSize.height);
        
        //
        _helpContentLabel.text = helpInfo.content;
        //
        _helpContentScrollView.contentSize = contentSize;
      }
      
      
    } while (NO);
    
  } else if ([control isKindOfClass:[PreloadingUIToolBar class]]) {
    
    if (kPreloadingUIToolBarActionEnum_RefreshButtonClicked == action) {
      if (_netRequestIndexForHelp == IDLE_NETWORK_REQUEST_ID) {
        _netRequestIndexForHelp = [self requestHelp];
        if (_netRequestIndexForHelp != IDLE_NETWORK_REQUEST_ID) {
          [_preloadingUIToolBar showRefreshButton:NO];
        }
      }
    }
  }
}

#pragma mark -
#pragma mark Activity 生命周期
-(void)onCreate:(Intent *)intent {
  PRPLog(@"--> onCreate");
  
}

-(void)onPause {
  PRPLog(@"--> onPause");
  
  [SVProgressHUD dismiss];
  
  [[DomainProtocolNetHelperSingleton sharedInstance] cancelNetRequestByRequestIndex:_netRequestIndexForHelp];
  _netRequestIndexForHelp = IDLE_NETWORK_REQUEST_ID;
  
}

-(void)onResume {
  PRPLog(@"--> onResume");
  
}

#pragma mark -
#pragma mark 实现 IDomainNetRespondCallback 接口

-(NSInteger)requestHelp{
  
  HelpNetRequestBean *netRequestBean = [HelpNetRequestBean helpNetRequestBean];
  NSInteger netRequestIndex
  = [[DomainProtocolNetHelperSingleton sharedInstance] requestDomainProtocolWithContext:self
                                                                   andRequestDomainBean:netRequestBean
                                                                        andRequestEvent:kNetRequestTagEnum_Help
                                                                     andRespondDelegate:self];
  return netRequestIndex;
}

typedef enum {
  // 显示网络访问错误时的提示信息
  kHandlerMsgTypeEnum_ShowNetErrorMessage = 0,
  // 获取用户帮助成功
  kHandlerMsgTypeEnum_GetHelpSuccessfully
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
      
      // 显示 "刷新" 按钮
      [_preloadingUIToolBar showRefreshButton:YES];
      
    }break;
      
    case kHandlerMsgTypeEnum_GetHelpSuccessfully:{
      
      // 隐藏 "预加载UI"
      [_preloadingUIToolBar dismiss];
      
      //
      [self initHelpTypeTabhostBarWithHelpNetRespondBean:_helpNetRespondBean];
    }break;
      
    default:
      break;
  }
}

//
- (void) clearNetRequestIndexByRequestEvent:(NSUInteger) requestEvent {
  if (kNetRequestTagEnum_Help == requestEvent) {
    _netRequestIndexForHelp = IDLE_NETWORK_REQUEST_ID;
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
  
  PRPLog(@"-> domainNetRespondHandleInNonUIThread --- start ! ");
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
  
  if (requestEvent == kNetRequestTagEnum_Help) {
    HelpNetRespondBean *helpNetRespondBean = respondDomainBean;
    //PRPLog(@"%@ -> %@", TAG, logonNetRespondBean);
    
    // 缓存帮助信息
    [GlobalDataCacheForMemorySingleton sharedInstance].helpNetRespondBean = helpNetRespondBean;
    self.helpNetRespondBean = helpNetRespondBean;
    
    //
    Message *msg = [Message obtain];
    msg.what = kHandlerMsgTypeEnum_GetHelpSuccessfully;
    [self performSelectorOnMainThread:@selector(handleMessage:) withObject:msg waitUntilDone:NO];
    
    return;
  }
  
}

@end
