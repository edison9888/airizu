//
//  RegisterActivity.h
//  gameqa
//
//  Created by user on 12-9-11.
//
//

#import <UIKit/UIKit.h>
#import "CustomControlDelegate.h"

@interface RegisterActivity : Activity <UITextFieldDelegate, IDomainNetRespondCallback, CustomControlDelegate, UIAlertViewDelegate>{
  
}

//
@property (retain, nonatomic) IBOutlet UIView *titleBarPlaceholder;
//
@property (retain, nonatomic) IBOutlet UITextField *userNameTextField;
@property (retain, nonatomic) IBOutlet UITextField *phoneNumberTextField;
@property (retain, nonatomic) IBOutlet UITextField *emailTextField;
@property (retain, nonatomic) IBOutlet UITextField *passwordTextField;
//
@property (retain, nonatomic) IBOutlet UIButton *protocolConfirmCheckbox;


@end
