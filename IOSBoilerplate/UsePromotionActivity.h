//
//  UsePromotionActivity.h
//  airizu
//
//  Created by 唐志华 on 13-2-11.
//
//

#import "Activity.h"
#import "CustomControlDelegate.h"
#import "PointsToOffsetControl.h"

// 
UIKIT_EXTERN NSString *const kIntentExtraTagForUsePromotionActivity_FreeBookNetRequestBeanForUnusedPromotions;
UIKIT_EXTERN NSString *const kIntentExtraTagForUsePromotionActivity_FreeBookNetRespondBeanForUnusedPromotions;

UIKIT_EXTERN NSString *const kIntentExtraTagForUsePromotionActivity_FreeBookNetRequestBeanForLatest;
UIKIT_EXTERN NSString *const kIntentExtraTagForUsePromotionActivity_FreeBookNetRespondBeanForLatest;


// 用户不想使用优惠
UIKIT_EXTERN NSString *const kUsePromotionActivity_NotUsePromotions;

@interface UsePromotionActivity : Activity <IDomainNetRespondCallback, CustomControlDelegate, PointsToOffsetControlDelegate, UIAlertViewDelegate, UIActionSheetDelegate> {
  
}

// TitleBar
@property (retain, nonatomic) IBOutlet UIView *titleBarPlaceholder;

@property (retain, nonatomic) IBOutlet UIView *bodyLayout;

// 订单总额
@property (retain, nonatomic) IBOutlet UILabel *orderTotalPriceLabel;
// 预付定金
@property (retain, nonatomic) IBOutlet UILabel *downPaymentLabel;
// 线下支付
@property (retain, nonatomic) IBOutlet UILabel *linePaymentLabel;

// 优惠控件布局(具体的优惠控件会在这个布局中, 目前优惠方式是互斥的)
@property (retain, nonatomic) IBOutlet UIView *promotionControlLayout;

// 确定按钮
@property (retain, nonatomic) IBOutlet UIButton *okButton;

@end
