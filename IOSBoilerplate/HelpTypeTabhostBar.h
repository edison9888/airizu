//
//  HelpTypeTabhostBar.h
//  airizu
//
//  Created by 唐志华 on 13-2-7.
//
//

#import <UIKit/UIKit.h>

@protocol CustomControlDelegate;
@class HelpNetRespondBean;
@interface HelpTypeTabhostBar : UIView {
  
}

@property (retain, nonatomic) IBOutlet UIButton *button1;
@property (retain, nonatomic) IBOutlet UIButton *button2;
@property (retain, nonatomic) IBOutlet UIButton *button3;
@property (retain, nonatomic) IBOutlet UIButton *button4;

@property (nonatomic, assign) NSInteger selectedItem;

@property (nonatomic, assign) id<CustomControlDelegate> delegate;

+(id)helpTypeTabhostBarWithHelpNetRespondBean:(HelpNetRespondBean *)helpNetRespondBean;
@end
