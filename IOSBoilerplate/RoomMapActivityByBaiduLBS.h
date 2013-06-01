//
//  RoomMapActivityByBaiduLBS.h
//  airizu
//
//  Created by 唐志华 on 13-2-21.
//
//

#import <UIKit/UIKit.h>
#import "CustomControlDelegate.h"
#import "BMapKit.h"

// UI类型, 是从房源列表进入此界面的, 还是从房间详情进入此界面的
UIKIT_EXTERN NSString *const kIntentExtraTagForRoomMapActivity_UiType;
// 传入的数据, 如果是从 "房源列表" 进入此界面, 那么传递的是List<RoomInfo>, 如果从 "房间详情" 进入的, 传过来就是 RoomDetailNetRespondBean
UIKIT_EXTERN NSString *const kIntentExtraTagForRoomMapActivity_Data;
// title name
UIKIT_EXTERN NSString *const kIntentExtraTagForRoomMapActivity_TitleName;

typedef NS_ENUM(NSInteger, UiTypeEnumForRoomMapActivity) {
  kUiTypeEnumForRoomMapActivity_NONE = 0,
  
  // 一组房间(推荐城市)
  kUiTypeEnumForRoomMapActivity_GroupRoomForCity,
  // 一组房间(用户附近)
  kUiTypeEnumForRoomMapActivity_GroupRoomForNearby,
  // 一个房间(房间详情)
  kUiTypeEnumForRoomMapActivity_SingleRoom,
  
  kUiTypeEnumForRoomMapActivity_MAX
};

@interface RoomMapActivityByBaiduLBS : Activity <BMKMapViewDelegate, CustomControlDelegate> {
  
}

// title bar
@property (retain, nonatomic) IBOutlet UIView *titleBarPlaceholder;
@property (retain, nonatomic) IBOutlet UIView *bodyLayout;

// freebook bar
@property (retain, nonatomic) IBOutlet UIView *freebookToolBarPlaceholder;
// 百度 map view
@property (retain, nonatomic) IBOutlet BMKMapView *mapView;

@end

