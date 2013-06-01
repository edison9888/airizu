//
//  RoomListActivityViewController.h
//  airizu
//
//  Created by 唐志华 on 12-12-27.
//
//
//  修改记录:
//          1) 20130122 完成第一版本正式代码
//

#import <UIKit/UIKit.h>
#import "RadioPopupList.h"
#import "CustomControlDelegate.h"

// 房间搜索条件
UIKIT_EXTERN NSString *const kIntentExtraTagForRoomListActivity_RoomSearchCriteria;  
// 标志当前是否是 "附近" 界面
UIKIT_EXTERN NSString *const kIntentExtraTagForRoomListActivity_IsNearby;  

@interface RoomListActivity : ListActivity <UITableViewDelegate, UITableViewDataSource, IDomainNetRespondCallback, RadioPopupListDelegate, CustomControlDelegate, UIAlertViewDelegate, LocationDelegate, AddrInfoDelegate> {
  
}

@property (retain, nonatomic) IBOutlet UIView *titleBarPlaceholder;

@property (retain, nonatomic) IBOutlet UIView *bodyLayout;

@property (retain, nonatomic) IBOutlet UIView *dateBarPlaceholder;
@property (retain, nonatomic) IBOutlet UIView *toolBarPlaceholder;



@end
