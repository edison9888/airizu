//
//  FreebookConfirmCheckinTimeActivity.h
//  airizu
//
//  Created by 唐志华 on 13-1-30.
//
//

#import "Activity.h"

#import "CustomControlDelegate.h"
#import "RadioPopupList.h"

// 房间编号(房间ID)
UIKIT_EXTERN NSString *const kIntentExtraTagForFreebookConfirmCheckinTimeActivity_RoomNumber;
// 当前房间最大入住人数
UIKIT_EXTERN NSString *const kIntentExtraTagForFreebookConfirmCheckinTimeActivity_Accommodates;

/**
 * 免费预订 - 确认入住时间界面
 *
 * @author zhihua.tang
 */
@interface FreebookConfirmCheckinTimeActivity : Activity <IDomainNetRespondCallback, CustomControlDelegate, RadioPopupListDelegate>{
  
}


// title bar
@property (retain, nonatomic) IBOutlet UIView *titleBarPlaceholder;

@property (retain, nonatomic) IBOutlet UIView *bodyLayout;

// 入住时间
@property (retain, nonatomic) IBOutlet UILabel *checkInDateLabel;
// 退房时间
@property (retain, nonatomic) IBOutlet UILabel *checkOutDateLabel;
// 入住人数
@property (retain, nonatomic) IBOutlet UILabel *occupancyLabel;

// 入住人数 背景图片(当订单总额 显现出来时, 要跟换这个背景图片)
@property (retain, nonatomic) IBOutlet UIImageView *occupancyBackgroundImageView;

// 订单总额
@property (retain, nonatomic) IBOutlet UIView *totalPriceLayout;
@property (retain, nonatomic) IBOutlet UILabel *totalPriceLabel;

// 确定按钮
@property (retain, nonatomic) IBOutlet UIButton *okButton;




@end
