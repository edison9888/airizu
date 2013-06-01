//
//  TradingRulesCell.h
//  airizu
//
//  Created by 唐志华 on 13-2-12.
//
//

#import <UIKit/UIKit.h>
#import "GCRetractableSectionController.h"

@class RoomDetailNetRespondBean;
@interface TradingRulesCell : GCRetractableSectionController{
  
}

+(id)tradingRulesCellWithRoomDetailNetRespondBean:(RoomDetailNetRespondBean *)roomDetailNetRespondBean viewController:(UIViewController*)givenViewController;
@end
