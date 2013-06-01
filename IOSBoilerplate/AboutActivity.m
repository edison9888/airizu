//
//  AboutActivity.m
//  airizu
//
//  Created by 唐志华 on 13-1-24.
//
//

#import "AboutActivity.h"

#import "TitleBar.h"









static const NSString *const TAG = @"<AboutActivity>";










@interface AboutActivity ()

@end









@implementation AboutActivity

- (void)dealloc {
  
  // UI
  [_titleBarPlaceholder release];
  [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  
  if ([DeviceInformation isIPhone5]) {
    // 这里决不能设成 autorelease 的, 网上的代码就是 autorelease的, 4.3系统会崩溃, 因为被自动释放了
    self = [super initWithNibName:@"AboutActivity_iphone5" bundle:nibBundleOrNil];
  } else {
    self = [super initWithNibName:@"AboutActivity" bundle:nibBundleOrNil];
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
  
  [self initQuadCurveMenu];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
  [self setTitleBarPlaceholder:nil];
  [super viewDidUnload];
}

#pragma mark -
#pragma mark 初始化UI
//
- (void) initTitleBar {
  TitleBar *titleBar = [TitleBar titleBar];
  titleBar.delegate = self;
  [titleBar setTitleByString:@"关于"];
  [titleBar hideLeftButton:NO];
  [self.titleBarPlaceholder addSubview:titleBar];
}

-(void)initQuadCurveMenu {
  //
  UIImage *storyMenuItemImage = [UIImage imageNamed:@"bg-menuitem.png"];
  UIImage *storyMenuItemImagePressed = [UIImage imageNamed:@"bg-menuitem-highlighted.png"];
  //
  UIImage *starImage = [UIImage imageNamed:@"icon-star.png"];
  
  QuadCurveMenuItem *starMenuItem1
  = [[QuadCurveMenuItem alloc] initWithImage:storyMenuItemImage
                            highlightedImage:storyMenuItemImagePressed
                                ContentImage:starImage
                     highlightedContentImage:nil];
  QuadCurveMenuItem *starMenuItem2
  = [[QuadCurveMenuItem alloc] initWithImage:storyMenuItemImage
                            highlightedImage:storyMenuItemImagePressed
                                ContentImage:starImage
                     highlightedContentImage:nil];
  QuadCurveMenuItem *starMenuItem3
  = [[QuadCurveMenuItem alloc] initWithImage:storyMenuItemImage
                            highlightedImage:storyMenuItemImagePressed
                                ContentImage:starImage
                     highlightedContentImage:nil];
  QuadCurveMenuItem *starMenuItem4
  = [[QuadCurveMenuItem alloc] initWithImage:storyMenuItemImage
                            highlightedImage:storyMenuItemImagePressed
                                ContentImage:starImage
                     highlightedContentImage:nil];
  QuadCurveMenuItem *starMenuItem5
  = [[QuadCurveMenuItem alloc] initWithImage:storyMenuItemImage
                            highlightedImage:storyMenuItemImagePressed
                                ContentImage:starImage
                     highlightedContentImage:nil];
  QuadCurveMenuItem *starMenuItem6
  = [[QuadCurveMenuItem alloc] initWithImage:storyMenuItemImage
                            highlightedImage:storyMenuItemImagePressed
                                ContentImage:starImage
                     highlightedContentImage:nil];
  NSArray *menus = [NSArray arrayWithObjects:starMenuItem1, starMenuItem2, starMenuItem3, starMenuItem4, starMenuItem5, starMenuItem6, nil];
  [starMenuItem1 release];
  [starMenuItem2 release];
  [starMenuItem3 release];
  [starMenuItem4 release];
  [starMenuItem5 release];
  [starMenuItem6 release];
  
  
  QuadCurveMenu *menu = [[QuadCurveMenu alloc] initWithFrame:CGRectMake(20, -20, 200, 200) menus:menus];
  menu.delegate = self;
  [self.view addSubview:menu];
  [menu release];
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

#pragma mark -
#pragma mark 实现 QuadCurveMenuDelegate 接口
-(void)quadCurveMenu:(QuadCurveMenu *)menu didSelectIndex:(NSInteger)idx {
  NSLog(@"Select the index : %d",idx);
}
@end
