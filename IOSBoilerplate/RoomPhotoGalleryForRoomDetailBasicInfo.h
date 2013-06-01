//
//  RoomPhotoGalleryForRoomDetailBasicInfo.h
//  airizu
//
//  Created by 唐志华 on 13-1-28.
//
//

#import <UIKit/UIKit.h>

@protocol CustomControlDelegate;
@class RoomDetailNetRespondBean;
@class CustomPageControl;

@interface RoomPhotoGalleryForRoomDetailBasicInfo : UIView <UIScrollViewDelegate>{
  
}

@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;
@property (retain, nonatomic) IBOutlet CustomPageControl *pageControl;



//
@property (nonatomic, assign) id<CustomControlDelegate> delegate;

#pragma mark -
#pragma mark 方便构造
+(id)roomPhotoGalleryForRoomDetailBasicInfoWithRoomDetailNetRespondBean:(RoomDetailNetRespondBean *)roomDetailNetRespondBean;

@end
