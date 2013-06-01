//
//  RoomDetailPhotoActivity.h
//  airizu
//
//  Created by 唐志华 on 13-2-8.
//
//

#import "Activity.h"
#import "CustomControlDelegate.h"

// 房间详情业务Bean
UIKIT_EXTERN NSString *const kIntentExtraTagForRoomDetailPhotoActivity_RoomDetailNetRespondBean;

@class CustomPageControl;
@interface RoomDetailPhotoActivity : Activity <CustomControlDelegate> {
  
}


@property (retain, nonatomic) IBOutlet UIView *titleBarPlaceholder;
@property (retain, nonatomic) IBOutlet UIView *bodyLayout;
@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;
@property (retain, nonatomic) IBOutlet CustomPageControl *pageControl;
@property (retain, nonatomic) IBOutlet UIView *freebookToolBarPlaceholder;

@end
