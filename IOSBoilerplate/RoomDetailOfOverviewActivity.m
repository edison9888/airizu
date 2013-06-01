//
//  RoomDetailOfOverviewActivity.m
//  airizu
//
//  Created by 唐志华 on 13-2-11.
//
//

#import "RoomDetailOfOverviewActivity.h"

#import "TitleBar.h"
#import "FreebookToolBar.h"

#import "RoomDetailDatabaseFieldsConstant.h"
#import "RoomDetailNetRequestBean.h"
#import "RoomDetailNetRespondBean.h"

#import "FreebookConfirmCheckinTimeActivity.h"
#import "LoginActivity.h"
#import "RoomDetailPhotoActivity.h"

#import "GCRetractableSectionController.h"

#import "BasicInfoRetractableCell.h"
#import "SupportingFacilitiesCell.h"
#import "RoomOverviewCell.h"
#import "TradingRulesCell.h"
#import "UseRulesCell.h"











static const NSString *const TAG = @"<RoomDetailOfOverviewActivity>";

//
NSString *const kIntentExtraTagForRoomDetailOfOverviewActivity_RoomDetailNetRespondBean = @"RoomDetailNetRespondBean";












@interface RoomDetailOfOverviewActivity ()

///
@property (nonatomic, assign) BOOL isIncomingIntentValid;
@property (nonatomic, assign) TitleBar *titleBar;


/// 外部传入的数据
@property (nonatomic, assign) RoomDetailNetRespondBean *roomDetailNetRespondBean;

//
@property (nonatomic, retain) NSArray *retractableCells;
@end












@implementation RoomDetailOfOverviewActivity

typedef NS_ENUM(NSInteger, IntentRequestCodeEnum) {
  // 跳转到 "登录界面"
  kIntentRequestCodeEnum_ToLoginActivity = 0
};

- (void)dealloc {
  
  //
  [_retractableCells release];
  
  // UI
  [_titleBarPlaceholder release];
  [_freebookToolBarPlaceholder release];
  [_tableView release];
  [_bodyLayout release];
  [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  if ([DeviceInformation isIPhone5]) {
    // 这里决不能设成 autorelease 的, 网上的代码就是 autorelease的, 4.3系统会崩溃, 因为被自动释放了
    self = [super initWithNibName:@"RoomDetailOfOverviewActivity_iphone5" bundle:nibBundleOrNil];
  } else {
    self = [super initWithNibName:@"RoomDetailOfOverviewActivity" bundle:nibBundleOrNil];
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
  
  if (_isIncomingIntentValid) {
    [self initRetractableTableCells];
    [self initFreebookToolBar];
    
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
  
  ///
  self.titleBar = nil;
  
  /// UI
  [self setTitleBarPlaceholder:nil];
  [self setFreebookToolBarPlaceholder:nil];
  [self setTableView:nil];
  [self setBodyLayout:nil];
  [super viewDidUnload];
}

-(void)gotoLoginActivity {
  Intent *intent =[Intent intentWithSpecificComponentClass:[LoginActivity class]];
  [self startActivityForResult:intent requestCode:kIntentRequestCodeEnum_ToLoginActivity];
}

-(void)gotoFreebookConfirmCheckinTimeActivity {
  Intent *intent = [Intent intentWithSpecificComponentClass:[FreebookConfirmCheckinTimeActivity class]];
  [intent.extras setObject:_roomDetailNetRespondBean.number forKey:kIntentExtraTagForFreebookConfirmCheckinTimeActivity_RoomNumber];
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
    
    RoomDetailNetRespondBean *roomDetailNetRespondBeanTest
    = [intent.extras objectForKey:kIntentExtraTagForRoomDetailPhotoActivity_RoomDetailNetRespondBean];
    
    if (![roomDetailNetRespondBeanTest isKindOfClass:[RoomDetailNetRespondBean class]]) {
      break;
    }
    
    self.roomDetailNetRespondBean = roomDetailNetRespondBeanTest;
    
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
  TitleBar *titleBar = [TitleBar titleBar];
  titleBar.delegate = self;
  NSString *titleString = [NSString stringWithFormat:@"房间 : %@", _roomDetailNetRespondBean.number];
  [titleBar setTitleByString:titleString];
  // "返回按钮"
  [titleBar hideLeftButton:NO];
  // "预定电话按钮"
  [titleBar hideRightButton:NO];
  //
  [self.titleBarPlaceholder addSubview:titleBar];
  
  //
  self.titleBar = titleBar;
}

-(void)initRetractableTableCells {
  
  // 基本信息
  BasicInfoRetractableCell *cell1
  = [BasicInfoRetractableCell basicInfoRetractableCellWithRoomDetailNetRespondBean:_roomDetailNetRespondBean viewController:self];
  cell1.open = YES;
  
  // 配套设施
  SupportingFacilitiesCell *cell2
  = [SupportingFacilitiesCell supportingFacilitiesCellWithRoomDetailNetRespondBean:_roomDetailNetRespondBean viewController:self];
  cell2.open = YES;
  
  // 房间概况
  RoomOverviewCell *cell3
  = [RoomOverviewCell roomOverviewCellWithRoomDetailNetRespondBean:_roomDetailNetRespondBean viewController:self];
  
  // 交易规则
  TradingRulesCell *cell4
  = [TradingRulesCell tradingRulesCellWithRoomDetailNetRespondBean:_roomDetailNetRespondBean viewController:self];
  
  // 使用规则
  UseRulesCell *cell5
  = [UseRulesCell useRulesCellWithRoomDetailNetRespondBean:_roomDetailNetRespondBean viewController:self];
  
  ///
  self.retractableCells = [NSArray arrayWithObjects:cell1, cell2, cell3, cell4, cell5, nil];
  
}

//
- (void) initFreebookToolBar {
  FreebookToolBar *freebookToolBar = [FreebookToolBar freebookToolBar];
  freebookToolBar.delegate = self;
  [freebookToolBar setRoomPrice:_roomDetailNetRespondBean.price];
  //
  [self.freebookToolBarPlaceholder addSubview:freebookToolBar];
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
    
  }
}

#pragma mark -
#pragma mark 实现 TableView 接口

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return _retractableCells.count;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
  
  GCRetractableSectionController *sectionController
  = [_retractableCells objectAtIndex:section];
  return sectionController.numberOfRow;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  GCRetractableSectionController *sectionController
  = [_retractableCells objectAtIndex:indexPath.section];
  return [sectionController cellForRow:indexPath.row];
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  
  GCRetractableSectionController *sectionController
  = [_retractableCells objectAtIndex:indexPath.section];
  return [sectionController didSelectCellAtRow:indexPath.row];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  CGFloat cellHeight = 0;
  if (0 == indexPath.row) {
    cellHeight = 45;
  } else {
    GCRetractableSectionController *sectionController
    = [_retractableCells objectAtIndex:indexPath.section];
    
    cellHeight = CGRectGetHeight([sectionController contentCellForRow:0].contentView.frame) + 10;
  }
  
	return cellHeight;
}

@end
