//
//  RoomOverviewCell.h
//  airizu
//
//  Created by 唐志华 on 13-2-12.
//
//

#import <UIKit/UIKit.h>
#import "GCRetractableSectionController.h"

@class RoomDetailNetRespondBean;
@interface RoomOverviewCell : GCRetractableSectionController{
  
}

+(id)roomOverviewCellWithRoomDetailNetRespondBean:(RoomDetailNetRespondBean *)roomDetailNetRespondBean viewController:(UIViewController*)givenViewController;

@end
