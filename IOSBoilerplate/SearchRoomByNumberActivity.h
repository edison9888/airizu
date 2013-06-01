//
//  SearchRoomByNumberActivityViewController.h
//  airizu
//
//  Created by 唐志华 on 13-1-15.
//
//

#import "Activity.h"
#import "CustomControlDelegate.h"

@interface SearchRoomByNumberActivity : Activity <UITextFieldDelegate, IDomainNetRespondCallback, CustomControlDelegate> {
  
}

@property (retain, nonatomic) IBOutlet UIView *titleBarPlaceholder;
@property (retain, nonatomic) IBOutlet UITextField *roomNumberTextField;

@end
