//
//  LoginActivity.h
//  airizu
//
//  Created by 唐志华 on 13-1-20.
//
//

#import <UIKit/UIKit.h>

#import "CustomControlDelegate.h"


/*
 注意 : 目前设计, NeedAutoLogin 和 SessionHasExpired 是不能同时使用的, 有互斥性, NeedAutoLogin 优先.
 */

// 业务说明 : 可以从如下入口进入 "登录" 界面
// 1. 如果用户设置了 "自动登录", 那么在第一次进入 "账户"界面时, 将自动跳转 "登录"界面, 并且自动登录
UIKIT_EXTERN NSString *const kIntentExtraTagEnum_NeedAutoLogin;

// Session 已经过期
UIKIT_EXTERN NSString *const kIntentExtraTagEnum_SessionHasExpired;


@interface LoginActivity : Activity <UITextFieldDelegate, IDomainNetRespondCallback, CustomControlDelegate>{
  
}

//
@property (retain, nonatomic) IBOutlet UIView *titleBarPlaceholder;
//
@property (retain, nonatomic) IBOutlet UIView *loginControlsLayout;
//
@property (retain, nonatomic) IBOutlet UITextField *userNameTextField;
@property (retain, nonatomic) IBOutlet UITextField *passwordTextField;
@property (retain, nonatomic) IBOutlet UIButton *autoLoginCheckbox;
@property (retain, nonatomic) IBOutlet UILabel *forgetPasswordLabel;


@end
