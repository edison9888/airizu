//
//  AdForRoomDetailBasicInfo.h
//  airizu
//
//  Created by 唐志华 on 13-1-28.
//
//

#import <UIKit/UIKit.h>

@protocol CustomControlDelegate;
@class RoomDetailNetRespondBean;

@interface IntroductionForRoomDetailBasicInfo : UIView {
  
}

// 介绍
@property (retain, nonatomic) IBOutlet UILabel *introductionLabel;
 

//
@property (nonatomic, assign) id<CustomControlDelegate> delegate;

#pragma mark -
#pragma mark 方便构造
+(id)introductionForRoomDetailBasicInfoWithRoomDetailNetRespondBean:(RoomDetailNetRespondBean *)roomDetailNetRespondBean;

@end
