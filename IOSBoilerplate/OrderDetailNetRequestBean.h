//
//  OrderDetailNetRequestBean.h
//  airizu
//
//  Created by 唐志华 on 13-1-1.
//
//

#import <Foundation/Foundation.h>

@interface OrderDetailNetRequestBean : NSObject {
  
}

@property (nonatomic, readonly) NSString *orderId;// 订单编号


#pragma mark -
#pragma mark 方便构造

+(id)orderDetailNetRequestBeanWithOrderId:(NSString *)orderId;
@end
