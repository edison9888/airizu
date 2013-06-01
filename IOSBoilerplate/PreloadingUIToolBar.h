//
//  PreloadingUIToolBar.h
//  airizu
//
//  Created by 唐志华 on 13-1-28.
//
//

#import <UIKit/UIKit.h>

#import "CustomControlDelegate.h"

typedef enum  {
  //
  kPreloadingUIToolBarActionEnum_RefreshButtonClicked = 0
} PreloadingUIToolBarActionEnum;

@interface PreloadingUIToolBar : UIView {
  
}

// UI
@property (retain, nonatomic) IBOutlet UIButton *refreshButton;
@property (retain, nonatomic) IBOutlet UILabel *hintLabel;

// delegate
@property (nonatomic, assign) id<CustomControlDelegate> delegate;

//
@property (nonatomic, readonly) BOOL isDismissed;


// 设置提示信息
-(void)setHintInfo:(NSString *)hintInfo;

// 显示 "刷新按钮", 如果不显示 刷新按钮, 就会显示 提示标签, 这两个是互斥的.
-(void)showRefreshButton:(BOOL)isShow;

-(void)showInView:(UIView*)superView;
-(void)dismiss;

#pragma mark -
#pragma mark 方便构造
+(id)preloadingUIToolBar;




@end
