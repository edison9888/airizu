//
//  UserOrderMainActivity.h
//  airizu
//
//  Created by 唐志华 on 13-2-1.
//
//

#import "Activity.h"

#import "CustomControlDelegate.h"

// 订单状态(从 "账户首页信息" 界面跳转到此
UIKIT_EXTERN NSString *const kIntentExtraTagForUserOrderCenterActivity_OrderState;

@interface UserOrderCenterActivity : ListActivity <UITableViewDelegate, UITableViewDataSource, IDomainNetRespondCallback, CustomControlDelegate>{
  
}


@property (retain, nonatomic) IBOutlet UIView *titleBarPlaceholder;
@property (retain, nonatomic) IBOutlet UIView *bodyLayout;

@property (retain, nonatomic) IBOutlet UIView *orderStateTabhostBarPlaceholder;




@end
