//
//  PasswordForgetActivity.h
//  airizu
//
//  Created by 唐志华 on 13-1-21.
//
//

#import "Activity.h"

#import "CustomControlDelegate.h"

@interface PasswordForgetActivity : Activity <UITextFieldDelegate, IDomainNetRespondCallback, CustomControlDelegate>{
  
}

//
@property (retain, nonatomic) IBOutlet UIView *titleBarPlaceholder;
//
@property (retain, nonatomic) IBOutlet UITextField *phoneNumberTextField;



@end
