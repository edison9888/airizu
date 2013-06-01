//
//  OrderCancelNetRequestBean.h
//  airizu
//
//  Created by 唐志华 on 13-1-1.
//
//

#import <Foundation/Foundation.h>

@interface OrderCancelNetRequestBean : NSObject {
  
}

@property (nonatomic, readonly) NSString *orderId;// 订单编号

#pragma mark -
#pragma mark 方便构造

+(id)orderCancelNetRequestBeanWithOrderId:(NSString *)orderId;

@end
