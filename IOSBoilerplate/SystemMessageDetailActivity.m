//
//  SystemMessageDetailActivity.m
//  airizu
//
//  Created by 唐志华 on 13-2-8.
//
//

#import "SystemMessageDetailActivity.h"

// 独立控件
#import "TitleBar.h"

#import "SystemMessageDatabaseFieldsConstant.h"
#import "SystemMessage.h"












static const NSString *const TAG = @"<SystemMessageDetailActivity>";

@interface SystemMessageDetailActivity ()
@property (nonatomic, assign) SystemMessage *systemMessage;
@end











@implementation SystemMessageDetailActivity

- (void)dealloc {
  
  // UI
  [_titleBarPlaceholder release];
  [_dateLabel release];
  [_messageLabel release];
  [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  if ([DeviceInformation isIPhone5]) {
    // 这里决不能设成 autorelease 的, 网上的代码就是 autorelease的, 4.3系统会崩溃, 因为被自动释放了
    self = [super initWithNibName:@"SystemMessageDetailActivity_iphone5" bundle:nibBundleOrNil];
  } else {
    self = [super initWithNibName:@"SystemMessageDetailActivity" bundle:nibBundleOrNil];
  }
  if (self) {
    // Custom initialization
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  // Do any additional setup after loading the view from its nib.
  
  [self initTitleBar];
  
  [self initSystemMessage];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
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

- (void)viewDidUnload {
  [self setTitleBarPlaceholder:nil];
  [self setDateLabel:nil];
  [self setMessageLabel:nil];
  [super viewDidUnload];
}

#pragma mark -
#pragma mark Activity 生命周期
-(void)onCreate:(Intent *)intent{
  PRPLog(@"%@ --> onCreate ", TAG);
  
  ///
  self.systemMessage = [intent.extras objectForKey:kIntentExtraTagForSystemMessageDetailActivity_SystemMessageBean];
}

-(void)onResume {
  PRPLog(@"%@ --> onResume ", TAG);
  
}

-(void)onPause {
  PRPLog(@"%@ --> onPause ", TAG);
  
}

#pragma mark -
#pragma mark 初始化UI

//
- (void) initTitleBar {
  TitleBar *titleBar = [TitleBar titleBar];
  titleBar.delegate = self;
  [titleBar setTitleByString:@"系统消息"];
  [titleBar hideLeftButton:NO];
  [self.titleBarPlaceholder addSubview:titleBar];
}


-(void)initSystemMessage {
  if (![_systemMessage isKindOfClass:[SystemMessage class]]) {
    return;
  }
  
  _dateLabel.text = _systemMessage.date;
  _messageLabel.text = _systemMessage.message;
}
@end
