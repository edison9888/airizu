//
//  UserOrderDetailActivity.h
//  airizu
//
//  Created by 唐志华 on 13-2-3.
//
//

#import "Activity.h"

#import "CustomControlDelegate.h"

// 业务说明: 会有2个入口进入 "订单详情界面"
// 1. 提交一个新订单, 并且下单成功时, 会进入此界面, 此时传递过来的是 ORDER_DETAIL_FROM_SUBMIT_ORDER, 此时不需要再联网获取订单详情了.
// 2. 从 "我的订单" 页面, 选择一个已经存在的订单后, 进入此界面, 此时传递过来的是 ORDER_ID, 此时需要联网获取订单详情.

// 订单ID
UIKIT_EXTERN NSString *const kIntentExtraTagForUserOrderDetailActivity_OrderID;
// 提交订单后返回的订单详情数据
UIKIT_EXTERN NSString *const kIntentExtraTagForUserOrderDetailActivity_OrderDetailFromSubmitOrder;
// 从订单中心跳转到订单详情界面时, 订单的状态(因为订单的状态可能在用户处理完后, 发生了变化, 所以需要再返回订单中心时, 重刷旧的订单列表)
UIKIT_EXTERN NSString *const kIntentExtraTagForUserOrderDetailActivity_OrderStateFromOrderCenter;

/**
 * 订单详情(包括订单详情的5个界面)
 *
 * @author zhihua.tang
 */
@interface UserOrderDetailActivity : Activity <IDomainNetRespondCallback, CustomControlDelegate, UIAlertViewDelegate>{
  
}


@property (retain, nonatomic) IBOutlet UIView *titleBarPlaceholder;
@property (retain, nonatomic) IBOutlet UIView *bodyLayout;

@property (retain, nonatomic) IBOutlet UIView *orderStateTitleBarPlaceholder;
@property (retain, nonatomic) IBOutlet UIScrollView *bodyScrollView;



@end
