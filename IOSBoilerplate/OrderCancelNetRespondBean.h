//
//  OrderCancelNetRespondBean.h
//  airizu
//
//  Created by 唐志华 on 13-1-1.
//
//

#import <Foundation/Foundation.h>

@interface OrderCancelNetRespondBean : NSObject {
  
}

@property (nonatomic, readonly) NSString *message;// 消息

#pragma mark -
#pragma mark 方便构造

+(id)orderCancelNetRespondBeanWithMessage:(NSString *)message;
@end
