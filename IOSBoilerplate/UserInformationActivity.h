//
//  UserInformationActivity.h
//  airizu
//
//  Created by 唐志华 on 13-2-10.
//
//

#import "Activity.h"
#import "CustomControlDelegate.h"

@interface UserInformationActivity : Activity <IDomainNetRespondCallback, CustomControlDelegate, UITextFieldDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
  
}

// TitleBar
@property (retain, nonatomic) IBOutlet UIView *titleBarPlaceholder;
// 
@property (retain, nonatomic) IBOutlet UIView *bodyLayout;

// 用户头像
@property (retain, nonatomic) IBOutlet UIImageView *userPhotoImageView;
// 用户名输入框
@property (retain, nonatomic) IBOutlet UITextField *userNameTextField;


// 手机号码
@property (retain, nonatomic) IBOutlet UILabel *userMobileNumberLabel;
// 邮箱
@property (retain, nonatomic) IBOutlet UILabel *userEmailLabel;

// 用户手机已验证标志
@property (retain, nonatomic) IBOutlet UIImageView *iconForMobileVerified;
// 用户邮箱已验证标志
@property (retain, nonatomic) IBOutlet UIImageView *iconForEmailVerified;


@property (retain, nonatomic) IBOutlet UIButton *manRadioButton;

@property (retain, nonatomic) IBOutlet UIButton *womanRadioButton;





@end
