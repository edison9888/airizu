//
//  RoomFilter.h
//  airizu
//
//  Created by 唐志华 on 13-1-26.
//
//

#import "Activity.h"
#import "RadioPopupList.h"
#import "CheckBoxPopupList.h"
#import "CustomControlDelegate.h"

// 房间搜索条件
UIKIT_EXTERN NSString *const kIntentExtraTagForRoomFilterActivity_RoomSearchCriteria;
// 标志当前是否是 "附近" 界面
UIKIT_EXTERN NSString *const kIntentExtraTagForRoomFilterActivity_IsNearby;

@interface RoomFilterActivity : Activity <IDomainNetRespondCallback, RadioPopupListDelegate, CheckBoxPopupListDelegate, CustomControlDelegate, UITextFieldDelegate> {
  
}

// 
@property (retain, nonatomic) IBOutlet UIView *titleBarPlaceholder;


@property (retain, nonatomic) IBOutlet UIControl *bodyLayout;


// 筛选项群组 布局
@property (retain, nonatomic) IBOutlet UIView *layoutForFilterItems;
//
@property (retain, nonatomic) IBOutlet UIView *layoutForDistrictName;// "房屋位置"
@property (retain, nonatomic) IBOutlet UIView *layoutForRoomPrice;// "每晚价格"
@property (retain, nonatomic) IBOutlet UIView *layoutForRentType;// "出租方式"
@property (retain, nonatomic) IBOutlet UIView *layoutForTamenities;// "设施设备"

@property (retain, nonatomic) IBOutlet UIButton *districtNameButton;// "房屋位置"
@property (retain, nonatomic) IBOutlet UIButton *roomPriceButton;// "每晚价格"
@property (retain, nonatomic) IBOutlet UIButton *rentTypeButton;// "出租方式"
@property (retain, nonatomic) IBOutlet UIButton *tamenitiesButton;// "设施设备"


// 地标输入框 布局
@property (retain, nonatomic) IBOutlet UIView *layoutForStreetTextFiled;
@property (retain, nonatomic) IBOutlet UITextField *streetTextField;

// 确定按钮
@property (retain, nonatomic) IBOutlet UIButton *okButton;

@end
