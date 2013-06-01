//
//  OrderSubmitNetRespondBean.m
//  airizu
//
//  Created by 唐志华 on 13-1-1.
//
//

#import "OrderSubmitNetRespondBean.h"
#import "OrderDetailNetRespondBean.h"

static const NSString *const TAG = @"<OrderSubmitNetRespondBean>";

@implementation OrderSubmitNetRespondBean

- (void) dealloc {
	PRPLog(@"dealloc: %@ [0x%x]", TAG, [self hash]);
	
  [_orderDetailNetRespondBean release];
  
	[super dealloc];
}

- (id) initWithOrderId:(NSNumber *)orderId
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

            orderState:(OrderStateEnum)orderStateEnum
{
  
  if ((self = [super init])) {
		PRPLog(@"init %@ [0x%x]", TAG, [self hash]);
    
    _orderDetailNetRespondBean
    = [[OrderDetailNetRespondBean orderDetailNetRespondBeanWithOrderId:orderId
                                                            orderState:orderState
                                                               message:message
                                                          chenckInDate:chenckInDate
                                                         chenckOutDate:chenckOutDate
                                                              guestNum:guestNum
                                                         pricePerNight:pricePerNight
                                                               linePay:linePay
                                                              subPrice:subPrice
                                                             orderType:orderTypeEnum
                                                         statusContent:statusContent
        
                                                                number:number
                                                                 image:image
                                                                 title:title
                                                               address:address
        
                                                            ifShowHost:NO
                                                              hostName:nil
                                                             hostPhone:nil
                                                       hostBackupPhone:nil
                                                            orderState:orderStateEnum] retain];
    
  }
  
  return self;
}

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

                               orderState:(OrderStateEnum)orderStateEnum {
  
  return [[[OrderSubmitNetRespondBean alloc] initWithOrderId:orderId
                                                  orderState:orderState
                                                     message:message
                                                chenckInDate:chenckInDate
                                               chenckOutDate:chenckOutDate
                                                    guestNum:guestNum
                                               pricePerNight:pricePerNight
                                                     linePay:linePay
                                                    subPrice:subPrice
                                                   orderType:orderTypeEnum
                                               statusContent:statusContent
           
                                                      number:number
                                                       image:image
                                                       title:title
                                                     address:address
           
                                                  orderState:orderStateEnum] autorelease];
}

#pragma mark
#pragma mark 不能使用默认的init方法初始化对象, 而必须使用当前类特定的 "初始化方法" 初始化所有参数
- (id) init {
  NSAssert(NO, @"Can not use the default init method!");
  
  return nil;
}

- (NSString *)description {
	return descriptionForDebug(self);
}
@end