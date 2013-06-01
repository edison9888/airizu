//
//  PreloadingUIToolBar.m
//  airizu
//
//  Created by 唐志华 on 13-1-28.
//
//

#import "PreloadingUIToolBar.h"



@interface PreloadingUIToolBar ()
//
@property (nonatomic, assign) BOOL isDismissed;
@end



@implementation PreloadingUIToolBar

- (void)dealloc {
  [_refreshButton release];
  [_hintLabel release];
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

- (IBAction)refreshButtonOnClickListener:(id)sender {
  if ([_delegate conformsToProtocol:@protocol(CustomControlDelegate)]) {
    if ([_delegate respondsToSelector:@selector(customControl:onAction:)]) {
      [_delegate customControl:self onAction:kPreloadingUIToolBarActionEnum_RefreshButtonClicked];
    }
  }
}

+ (NSString *) nibName {
  return NSStringFromClass([self class]);
}

+ (UINib *) nib {
  NSBundle *classBundle = [NSBundle bundleForClass:[self class]];
  return [UINib nibWithNibName:[self nibName] bundle:classBundle];
}

+(id)preloadingUIToolBar {
  NSArray *nibObjects = [[self nib] instantiateWithOwner:nil options:nil];
  PreloadingUIToolBar *preloadingUIToolBar = [nibObjects objectAtIndex:0];
  preloadingUIToolBar.isDismissed = YES;
  return preloadingUIToolBar;
  
}

// 设置提示信息
-(void)setHintInfo:(NSString *)hintInfo {
  self.hintLabel.text = hintInfo;
}

// 显示 "刷新按钮", 如果不显示 "刷新按钮" 就显示 "提示信息 --> 页面加载中..."
-(void)showRefreshButton:(BOOL)isShow {
  if (isShow) {
    _hintLabel.hidden = YES;
    _refreshButton.hidden = NO;
  } else {
    _hintLabel.hidden = NO;
    _refreshButton.hidden = YES;
  }
}

-(void)showInView:(UIView*)superView{
  if (![superView isKindOfClass:[UIView class]]) {
    return;
  }
  
  // 校正 "预加载UI工具条" 的坐标, 要居中显示
  CGFloat newY = (CGRectGetHeight(superView.frame) - CGRectGetHeight(self.frame)) / 2;
  self.frame = CGRectMake(self.frame.origin.x,
                          newY,
                          CGRectGetWidth(self.frame),
                          CGRectGetHeight(self.frame));
  
  [superView addSubview:self];
  
  _isDismissed = NO;
}

-(void)dismiss {
  [self removeFromSuperview];
  _isDismissed = YES;
}

@end
