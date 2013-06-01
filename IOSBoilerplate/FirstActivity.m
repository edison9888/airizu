//
//  FirstActivity.m
//  airizu
//
//  Created by 唐志华 on 12-12-22.
//
//

#import "FirstActivity.h"

#import "BeginnerGuideActivity.h"
#import "MainNavigationActivity.h"

static const NSString *const TAG = @"<FirstActivity>";

@interface FirstActivity ()

@end

@implementation FirstActivity


- (void)dealloc {
  
  PRPLog(@"dealloc: %@ [0x%x]", TAG, [self hash]);
  
  [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  if ([DeviceInformation isIPhone5]) {
    // 这里决不能设成 autorelease 的, 网上的代码就是 autorelease的, 4.3系统会崩溃, 因为被自动释放了
    self = [super initWithNibName:@"FirstActivity_iphone5" bundle:nibBundleOrNil];
  } else {
    self = [super initWithNibName:@"FirstActivity" bundle:nibBundleOrNil];
  }
  
  return self;
}

- (void)viewDidLoad
{
  PRPLog(@"%@ --> viewDidLoad ", TAG);
  
  [super viewDidLoad];
  
  // 20130312 : 决不能在 viewDidLoad 中关闭自己或者启动新的Activity, 必须要使用异步机制.
  [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:1.0];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
  
  [super viewDidUnload];
}

#pragma mark -
#pragma mark Activity 生命周期
-(void)onCreate:(Intent *)intent {
  PRPLog(@"%@ --> onCreate ", TAG);

}
-(void)onPause {
  PRPLog(@"%@ --> onPause ", TAG);

}
-(void)onResume {
  PRPLog(@"%@ --> onResume ", TAG);

}

#pragma mark -
#pragma mark 
-(Intent *)intentForGotoBeginnerGuideActivity {
  return [Intent intentWithSpecificComponentClass:[BeginnerGuideActivity class]];
}

-(Intent *)intentForGotoMainActivity {
  return [Intent intentWithSpecificComponentClass:[MainNavigationActivity class]];
}

-(void)doneLoadingTableViewData{

  Intent *intent = nil;
  //if ([GlobalDataCacheForMemorySingleton sharedInstance].isNeedShowBeginnerGuide) {
    //intent = [self intentForGotoBeginnerGuideActivity];
  //} else {
    intent = [self intentForGotoMainActivity];
  //}
  
  [self finishSelfAndStartNewActivity:intent];
}
@end
