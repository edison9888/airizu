//
//  CustomSegmentedControl.h
//  airizu
//
//  Created by 唐志华 on 13-2-1.
//
//

#import <UIKit/UIKit.h>

#import "CustomControlDelegate.h"

@interface OrderStateTabhostBar : UIView {
  
}

@property (retain, nonatomic) IBOutlet UIButton *waitConfirmButton;
@property (retain, nonatomic) IBOutlet UIButton *waitPayButton;
@property (retain, nonatomic) IBOutlet UIButton *waitLiveButton;
@property (retain, nonatomic) IBOutlet UIButton *waitCommentButton;
@property (retain, nonatomic) IBOutlet UIButton *hasEndedButton;

@property (nonatomic, assign) NSInteger selectedItem;

@property (nonatomic, assign) id<CustomControlDelegate> delegate;

+(id)orderStateTabhostBarWithDefaultOrderState:(OrderStateEnum)orderStateEnum;

@end
