//
//  SystemMessageDetailActivity.h
//  airizu
//
//  Created by 唐志华 on 13-2-8.
//
//

#import "Activity.h"
#import "CustomControlDelegate.h"

#define kIntentExtraTagForSystemMessageDetailActivity_SystemMessageBean @"SystemMessageBean"

@interface SystemMessageDetailActivity : Activity <CustomControlDelegate> {
  
}

@property (retain, nonatomic) IBOutlet UIView *titleBarPlaceholder;

@property (retain, nonatomic) IBOutlet UILabel *dateLabel;
@property (retain, nonatomic) IBOutlet UILabel *messageLabel;



@end
