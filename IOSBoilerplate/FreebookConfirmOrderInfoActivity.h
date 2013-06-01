//
//  FreebookConfirmOrderInfoActivity.h
//  airizu
//
//  Created by 唐志华 on 13-1-31.
//
//

#import "Activity.h"
#import "CustomControlDelegate.h"

// 
UIKIT_EXTERN NSString *const kIntentExtraTagForFreebookConfirmOrderInfoActivity_FreeBookNetRequestBean;
//
UIKIT_EXTERN NSString *const kIntentExtraTagForFreebookConfirmOrderInfoActivity_FreeBookNetRespondBean; 

@interface FreebookConfirmOrderInfoActivity : Activity <IDomainNetRespondCallback, CustomControlDelegate, UIAlertViewDelegate>{
  
}


@property (retain, nonatomic) IBOutlet UIView *titleBarPlaceholder;


@property (retain, nonatomic) IBOutlet UIView *bodyLayout;


// "入住时间"
@property (retain, nonatomic) IBOutlet UILabel *checkInDateLabel;
// "退房时间"
@property (retain, nonatomic) IBOutlet UILabel *checkOutDateLabel;
// "入住人数"
@property (retain, nonatomic) IBOutlet UILabel *occupancyLabel;

// "订单总额"
@property (retain, nonatomic) IBOutlet UILabel *totalPriceLabel;
// "预付定金"
@property (retain, nonatomic) IBOutlet UILabel *advancedDepositLabel;
// "线下支付"
@property (retain, nonatomic) IBOutlet UILabel *underLinePaidLabel;

// 使用了优惠之后的标志icon
@property (retain, nonatomic) IBOutlet UIImageView *promotionMarkIconImageView;
// 使用优惠按钮
@property (retain, nonatomic) IBOutlet UIButton *usePromotionButton;


// "租客姓名"
@property (retain, nonatomic) IBOutlet UILabel *tenantNameLabel;
// "手机号码"
@property (retain, nonatomic) IBOutlet UILabel *tenantPhoneLabel;

//
@property (retain, nonatomic) IBOutlet UIButton *orderInfoConfirmCheckbox;


@end
