//
//  RoomPhotoGalleryForRoomDetailBasicInfo.m
//  airizu
//
//  Created by 唐志华 on 13-1-28.
//
//

#import "RoomPhotoGalleryForRoomDetailBasicInfo.h"

#import "CustomControlDelegate.h"
#import "RoomDetailOfBasicInformationActivityContent.h"
#import "RoomDetailNetRespondBean.h"

#import "CustomPageControl.h"

@interface RoomPhotoGalleryForRoomDetailBasicInfo ()
@property (nonatomic, assign) NSArray *imageArray;

@property (nonatomic, assign) BOOL pageControlIsChangingPage;
@end

@implementation RoomPhotoGalleryForRoomDetailBasicInfo

- (void)dealloc {
  
  // UI
  [_scrollView release];
  [_pageControl release];
  [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    // Initialization code
  }
  return self;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

+ (NSString *) nibName {
  return NSStringFromClass([self class]);
}

+ (UINib *) nib {
  NSBundle *classBundle = [NSBundle bundleForClass:[self class]];
  return [UINib nibWithNibName:[self nibName] bundle:classBundle];
}

#pragma mark -
#pragma mark 加载子View
-(void)initUseRoomDetailNetRespondBean:(RoomDetailNetRespondBean *)roomDetailNetRespondBean{
  self.imageArray = [NSArray arrayWithArray:roomDetailNetRespondBean.imageS];
  if ([_imageArray count] <= 0) {
    // 当前房源没有照片
    _pageControl.hidden = YES;
    
  } else {
    
    // 设置 pageControll 参数
    CGSize sizeForPageControl = [_pageControl sizeForNumberOfPages:_imageArray.count];
    //[_pageControl addTarget:self action:@selector(pageControlClickedListener:) forControlEvents:UIControlEventTouchUpInside];
    _pageControl.numberOfPages = _imageArray.count;
    CGRect pageControlFrame = _pageControl.frame;
    [_pageControl setFrame:CGRectMake((pageControlFrame.size.width - sizeForPageControl.width)/2,
                                      pageControlFrame.origin.y,
                                      sizeForPageControl.width,
                                      CGRectGetHeight(pageControlFrame))];
    
    // 设置 scrollView
    CGRect scrollViewOriginalFrame = _scrollView.frame;
    _scrollView.contentSize = CGSizeMake(scrollViewOriginalFrame.size.width * _imageArray.count,
                                         scrollViewOriginalFrame.size.height);
    
    // 因为图片之间要有一定的间距, 所以在设置 IB中的 scrollView 时, 整体宽度一定要加上这个 偏移量
    // 图片之间的偏移量
    CGFloat widthOffset = 5;
    CGSize imageSize = CGSizeMake(scrollViewOriginalFrame.size.width - widthOffset, scrollViewOriginalFrame.size.height);
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
                         placeholderImage:[UIImage imageNamed:@"room_photo_placeholderImage_for_room_detail_basic_info_activity.png"]];
      [roomPhotoImageView setContentMode:UIViewContentModeScaleToFill];
      [_scrollView addSubview:roomPhotoImageView];
      [roomPhotoImageView release];
      
      // 一个手指点击一次
      UITapGestureRecognizer *oneFingerOneTaps
      = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                action:@selector(forgotPasswordLabelOnClickListener:)];
      [roomPhotoImageView addGestureRecognizer:oneFingerOneTaps];
      oneFingerOneTaps.view.tag = i;
      [oneFingerOneTaps release];
    }
  }
}

-(void)forgotPasswordLabelOnClickListener:(UITapGestureRecognizer *)sender{
	if ([_delegate conformsToProtocol:@protocol(CustomControlDelegate)]) {
    if ([_delegate respondsToSelector:@selector(customControl:onAction:)]) {
      [_delegate customControl:self onAction:kRoomDetailOfBasicInformationActivityContentActionEnum_RoomPhotoClicked];
    }
  }
}

#pragma mark -
#pragma mark 方便构造
+(id)roomPhotoGalleryForRoomDetailBasicInfoWithRoomDetailNetRespondBean:(RoomDetailNetRespondBean *)roomDetailNetRespondBean {
  NSArray *nibObjects = [[self nib] instantiateWithOwner:nil options:nil];
  RoomPhotoGalleryForRoomDetailBasicInfo *newControl = [nibObjects objectAtIndex:0];
  [newControl initUseRoomDetailNetRespondBean:roomDetailNetRespondBean];
  return newControl;
}

-(void)pageControlClickedListener:(UIPageControl *)sender {
	CGRect frame = _scrollView.frame;
  frame.origin.x = frame.size.width * _pageControl.currentPage;
  frame.origin.y = 0;
  
  // 调用 UIScrollView的 scrollRectToVisible方法实现画面切换
  [_scrollView scrollRectToVisible:frame animated:YES];
  
  // 设置滚动标志, 滚动(或称页面改变)完成时,会调用 scrollViewDidEndDecelerating 方法,其中会将其置为Off的)
  _pageControlIsChangingPage = YES;
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
