//
//  OrderSubmitNetRespondBean.h
//  airizu
//
//  Created by 唐志华 on 13-1-1.
//
//

#import <Foundation/Foundation.h>

@class OrderDetailNetRespondBean;
@interface OrderSubmitNetRespondBean : NSObject {
  
}

// 订单详情
@property(nonatomic, readonly) OrderDetailNetRespondBean *orderDetailNetRespondBean;

#pragma mark -
#pragma mark 方便构造

+(id)orderSubmitNetRespondBeanWithOrderId:(NSNumber *)orderId
                               orderState:(NSNumber *)orderState
                                  message:(NSString *)message
                             chenckInDate:(NSString *)chenckInDate
                            chenckOutDate:(NSString *)chenckOutDate
                                 guestNum:(NSNumber *)guestNum
                            pricePerNight:(NSNumber *)pricePerNight
                                  linePay:(NSNumber *)linePay
                                 subPrice:(NSNumber *)subPrice
                                orderType:(OrderTypeEnum)orderTypeEnum
                            statusContent:(NSString *)statusContent

                                   number:(NSNumber *)number
                                    image:(NSString *)image
                                    title:(NSString *)title
                                  address:(NSString *)address

                               orderState:(OrderStateEnum)orderStateEnum;
@end
