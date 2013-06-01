//
//  RoomDetailOfBasicInformationActivity.h
//  airizu
//
//  Created by 唐志华 on 13-1-28.
//
//

#import "Activity.h"
#import "CustomControlDelegate.h"

// 业务说明 : 可以从如下入口进入 订单详情-基础信息 界面
// 1. 从房源列表页面, 选中一个房间时              ------- 传递过来 RoomNumber
// 2. 从 "直接搜索房间编号" 界面, 进行房间编号查询时 ------- 传递过来 RoomDetailNetRespondBean 
// 3. 从 "订单详情界面"                        ------- 传递过来 RoomNumber 
// 4. 从 "房源列表 - 地图界面"                  ------- 传递过来 RoomNumber

// 房间编号(房间ID)
UIKIT_EXTERN NSString *const kIntentExtraTagForRoomDetailOfBasicInfoActivity_RoomNumber;
// 房间详情业务Bean(用于从 "按照房间编号搜索房间" 页面跳转来此, 此时不用再重复查询目标房间的详情信息了.)
UIKIT_EXTERN NSString *const kIntentExtraTagForRoomDetailOfBasicInfoActivity_RoomDetailNetRespondBean;

@interface RoomDetailOfBasicInformationActivity : Activity <IDomainNetRespondCallback, CustomControlDelegate>{
  
}

// title bar
@property (retain, nonatomic) IBOutlet UIView *titleBarPlaceholder;
@property (retain, nonatomic) IBOutlet UIView *bodyLayout;

// 中间的内容区域
@property (retain, nonatomic) IBOutlet UIScrollView *contentPlaceholder;
// freebook bar
@property (retain, nonatomic) IBOutlet UIView *freebookToolBarPlaceholder;

@end
