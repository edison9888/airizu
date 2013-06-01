//
//  RoomDetailPhotoActivity.m
//  airizu
//
//  Created by 唐志华 on 13-2-8.
//
//

#import "RoomDetailPhotoActivity.h"

#import "TitleBar.h"
#import "CustomPageControl.h"
#import "FreebookToolBar.h"

#import "RoomDetailDatabaseFieldsConstant.h"
#import "RoomDetailNetRequestBean.h"
#import "RoomDetailNetRespondBean.h"

#import "FreebookConfirmCheckinTimeActivity.h"
#import "LoginActivity.h"













static const NSString *const TAG = @"<RoomDetailPhotoActivity>";

//
NSString *const kIntentExtraTagForRoomDetailPhotoActivity_RoomDetailNetRespondBean = @"RoomDetailNetRespondBean";















@interface RoomDetailPhotoActivity ()

///
@property (nonatomic, assign) BOOL isIncomingIntentValid;
@property (nonatomic, assign) TitleBar *titleBar;

/// 外部传入的数据
@property (nonatomic, assign) RoomDetailNetRespondBean *roomDetailNetRespondBean;
@property (nonatomic, assign) NSArray *imageArray;
@property (nonatomic, assign) BOOL pageControlIsChangingPage;
@end













@implementation RoomDetailPhotoActivity

typedef NS_ENUM(NSInteger, IntentRequestCodeEnum) {
  // 跳转到 "登录界面"
  kIntentRequestCodeEnum_ToLoginActivity = 0
};

- (void)dealloc {
  
  // UI
  [_titleBarPlaceholder release];
  [_freebookToolBarPlaceholder release];
  [_scrollView release];
  [_pageControl release];
  [_bodyLayout release];
  [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  if ([DeviceInformation isIPhone5]) {
    // 这里决不能设成 autorelease 的, 网上的代码就是 autorelease的, 4.3系统会崩溃, 因为被自动释放了
    self = [super initWithNibName:@"RoomDetailPhotoActivity_iphone5" bundle:nibBundleOrNil];
  } else {
    self = [super initWithNibName:@"RoomDetailPhotoActivity" bundle:nibBundleOrNil];
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
    
    [self initRoomPhotoGallery];
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
  [self setScrollView:nil];
  [self setPageControl:nil];
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
    
    // 如果有 RoomDetailNetRespondBean 传递过来, 就不用重新查询目标房间的详情了
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
  
  self.titleBar = titleBar;
}

-(void)initRoomPhotoGallery {
  
  self.imageArray = [NSArray arrayWithArray:_roomDetailNetRespondBean.imageM];
  if ([_imageArray count] <= 0) {
    // 当前房源没有照片
    _pageControl.hidden = YES;
    
  } else {
    
    // 设置 pageControll 参数
    CGSize sizeForPageControl = [_pageControl sizeForNumberOfPages:_imageArray.count];
    _pageControl.numberOfPages = _imageArray.count;
    CGRect pageControlFrame = _pageControl.frame;
    [_pageControl setFrame:CGRectMake((pageControlFrame.size.width - sizeForPageControl.width)/2,
                                      pageControlFrame.origin.y,
                                      sizeForPageControl.width,
                                      CGRectGetHeight(pageControlFrame))];
    
    // 设置 scrollView
    CGRect scrollViewOriginalFrame = _scrollView.frame;
    
    _scrollView.contentSize
    = CGSizeMake(scrollViewOriginalFrame.size.width * _imageArray.count,
                 scrollViewOriginalFrame.size.height);
    
    CGSize imageSize
    = CGSizeMake(scrollViewOriginalFrame.size.width - 5,
                 scrollViewOriginalFrame.size.height);
    
    for (int i=0; i<_imageArray.count; i++) {
      NSString *imageUrlString = [_imageArray objectAtIndex:i];
      UIImageView *roomPhotoImageView
      = [[UIImageView alloc] initWithFrame:CGRectMake(i*scrollViewOriginalFrame.size.width,
                                                      0,
                                                      imageSize.width,
                                                      imageSize.height)];
      // 设置 图片圆角效果
      roomPhotoImageView.layer.cornerRadius = 5;
			roomPhotoImageView.layer.masksToBounds = YES;
      //
      [roomPhotoImageView setUserInteractionEnabled:YES];
      //
      [roomPhotoImageView setImageWithURL:[NSURL URLWithString:imageUrlString]
                         placeholderImage:[UIImage imageNamed:@"main_background_image.png"]];
      [roomPhotoImageView setContentMode:UIViewContentModeScaleToFill];
      [_scrollView addSubview:roomPhotoImageView];
      [roomPhotoImageView release];
    }
  }
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
#pragma mark 实现 UIScrollViewDelegate 接口

//只要滚动了就会触发
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
  if (_pageControlIsChangingPage) {
    return;
  }
  
  CGFloat pageWidth = _scrollView.frame.size.width;
  int page = floor((_scrollView.contentOffset.x - pageWidth/2) / pageWidth) + 1;
  _pageControl.currentPage = page;
}
//开始拖拽视图
//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView;

//完成拖拽
//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;

//将开始降速时
//- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView;

//减速停止了时执行，手触摸时执行执行
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
  _pageControlIsChangingPage = NO;
  
  CGFloat pageWidth = _scrollView.frame.size.width;
  int page = floor((_scrollView.contentOffset.x - pageWidth/2) / pageWidth) + 1;
  _pageControl.currentPage = page;
}
//滚动动画停止时执行,代码改变时出发,也就是setContentOffset改变时
//- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView;

//设置放大缩小的视图，要是uiscrollview的subview
//- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView;

//完成放大缩小时调用
//- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale;

//如果你不是完全滚动到滚轴视图的顶部，你可以轻点状态栏，那个可视的滚轴视图会一直滚动到顶部，那是默认行为，你可以通过该方法返回NO来关闭它
//- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView;

//- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView;




@end
