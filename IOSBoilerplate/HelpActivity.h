//
//  HelpActivity.h
//  airizu
//
//  Created by 唐志华 on 13-2-7.
//
//

#import "Activity.h"

#import "CustomControlDelegate.h"

@interface HelpActivity : Activity <IDomainNetRespondCallback, CustomControlDelegate>{
  
}

//
@property (retain, nonatomic) IBOutlet UIView *titleBarPlaceholder;
//
@property (retain, nonatomic) IBOutlet UIView *bodyLayout;
//
@property (retain, nonatomic) IBOutlet UILabel *helpTitleLabel;
//
@property (retain, nonatomic) IBOutlet UIView *helpTypeTabhostBarPlaceholder;
//
@property (retain, nonatomic) IBOutlet UIScrollView *helpContentScrollView;
//
@property (retain, nonatomic) IBOutlet UILabel *helpContentLabel;





@end
