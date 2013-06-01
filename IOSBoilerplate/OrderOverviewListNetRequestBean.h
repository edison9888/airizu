//
//  OrderOverviewListNetRequestBean.h
//  airizu
//
//  Created by 唐志华 on 13-1-1.
//
//

#import <Foundation/Foundation.h>

@interface OrderOverviewListNetRequestBean : NSObject {
  
}

// 订单状态(1,待确定，2待支付，3待入住，4待评价5已完成)
@property (nonatomic, readonly) NSString *orderState;

#pragma mark -
#pragma mark 方便构造

+(id)orderOverviewListNetRequestBeanWithOrderState:(NSString *)orderState;
@end
