//
//  RoomTitleForRoomDetailBasicInfo.h
//  airizu
//
//  Created by 唐志华 on 13-1-28.
//
//

#import <UIKit/UIKit.h>

@protocol CustomControlDelegate;
@class RoomDetailNetRespondBean;

@interface RoomTitleForRoomDetailBasicInfo : UIView {
  
}

//
@property (retain, nonatomic) IBOutlet UILabel *roomTitleLabel;
@property (retain, nonatomic) IBOutlet UILabel *roomAddressLabel;
@property (retain, nonatomic) IBOutlet UILabel *roomNumberLabel;
@property (retain, nonatomic) IBOutlet UILabel *roomScheduledCountLabel;


//
@property (nonatomic, assign) id<CustomControlDelegate> delegate;

#pragma mark -
#pragma mark 方便构造
+(id)roomTitleForRoomDetailBasicInfoWithRoomDetailNetRespondBean:(RoomDetailNetRespondBean *)roomDetailNetRespondBean;

@end
