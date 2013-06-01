//
//  OrderStateTitleBar.h
//  airizu
//
//  Created by 唐志华 on 13-2-3.
//
//

#import <UIKit/UIKit.h>

@interface OrderStateTitleBar : UIView {
  
}


@property (retain, nonatomic) IBOutlet UILabel *waitConfirmLabel;
@property (retain, nonatomic) IBOutlet UILabel *waitPayLabel;
@property (retain, nonatomic) IBOutlet UILabel *waitLiveLabel;
@property (retain, nonatomic) IBOutlet UILabel *waitCommentLabel;


+(id)orderStateTitleBar;

-(void)setOrderStateFocusItemByOrderState:(OrderStateEnum)orderStateEnum;

@end
