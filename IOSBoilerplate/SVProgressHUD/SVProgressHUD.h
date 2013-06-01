//
//  SVProgressHUD.h
//
//  Created by Sam Vermette on 27.03.11.
//  Copyright 2011 Sam Vermette. All rights reserved.
//
//  https://github.com/samvermette/SVProgressHUD
//

#import <UIKit/UIKit.h>
#import <AvailabilityMacros.h>

enum {
  SVProgressHUDMaskTypeNone = 1, // allow user interactions while HUD is displayed
                                 // 允许用户在HUD显示的同时和App进行交互, 就是说, HUD 不会抢占屏幕点击事件
  SVProgressHUDMaskTypeClear,    // don't allow
                                 // 会抢占屏幕点击事件, 不允许用户和App进行交互
  SVProgressHUDMaskTypeBlack,    // don't allow and dim the UI in the back of the HUD
                                 // 和 Clear 一样, 但是会灰度屏幕
  SVProgressHUDMaskTypeGradient  // don't allow and dim the UI with a a-la-alert-view bg gradient
                                 // 和 Clear 一样, 但是会亮灰屏幕
};

typedef NSUInteger SVProgressHUDMaskType;

@interface SVProgressHUD : UIView

+ (void)show;// 相当于 [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
+ (void)showWithMaskType:(SVProgressHUDMaskType)maskType;

+ (void)showWithStatus:(NSString*)status;
+ (void)showWithStatus:(NSString*)status maskType:(SVProgressHUDMaskType)maskType;

+ (void)setStatus:(NSString*)string; // change the HUD loading status while it's showing

// stops the activity indicator, shows a glyph + status, and dismisses HUD 1s later
#pragma mark -
#pragma mark 跟 Android 的 Toast 一样的方法
+ (void)showSuccessWithStatus:(NSString*)string;
+ (void)showErrorWithStatus:(NSString *)string;
+ (void)showImage:(UIImage*)image status:(NSString*)status; // use 28x28 white pngs

#pragma mark -
#pragma mark 统一关闭方法
+ (void)dismiss;

#pragma mark -
#pragma mark 
+ (BOOL)isVisible;



@end
