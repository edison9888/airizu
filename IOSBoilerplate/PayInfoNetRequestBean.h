//
//  PayInfoNetRequestBean.h
//  airizu
//
//  Created by 唐志华 on 13-1-1.
//
//

#import <Foundation/Foundation.h>

@interface PayInfoNetRequestBean : NSObject {
  
}

@property (nonatomic, readonly) NSString *orderId;// 订单ID

#pragma mark -
#pragma mark 方便构造

+(id)payInfoNetRequestBeanWithOrderId:(NSString *)orderId;
@end
