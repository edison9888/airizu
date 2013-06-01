//
//  UseRulesCell.h
//  airizu
//
//  Created by 唐志华 on 13-2-12.
//
//

#import <UIKit/UIKit.h>
#import "GCRetractableSectionController.h"

@class RoomDetailNetRespondBean;
@interface UseRulesCell : GCRetractableSectionController{
  
}

+(id)useRulesCellWithRoomDetailNetRespondBean:(RoomDetailNetRespondBean *)roomDetailNetRespondBean viewController:(UIViewController*)givenViewController;
@end
