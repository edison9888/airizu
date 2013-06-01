//
//  BasicInfoRetractableCell.h
//  airizu
//
//  Created by 唐志华 on 13-2-12.
//
//

#import <Foundation/Foundation.h>

#import "GCRetractableSectionController.h"

@class RoomDetailNetRespondBean;
@interface BasicInfoRetractableCell : GCRetractableSectionController {
  
}

+(id)basicInfoRetractableCellWithRoomDetailNetRespondBean:(RoomDetailNetRespondBean*)roomDetailNetRespondBean viewController:(UIViewController*)givenViewController;
@end
