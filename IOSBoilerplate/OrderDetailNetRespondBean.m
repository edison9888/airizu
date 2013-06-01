//
//  OrderDetailNetRespondBean.m
//  airizu
//
//  Created by 唐志华 on 13-1-1.
//
//

#import "OrderDetailNetRespondBean.h"

static const NSString *const TAG = @"<OrderDetailNetRespondBean>";

@implementation OrderDetailNetRespondBean

- (void) dealloc {
	PRPLog(@"dealloc: %@ [0x%x]", TAG, [self hash]);
	
  [_orderId release];
  [_orderState release];
  [_message release];
  [_chenckInDate release];
  [_chenckOutDate release];
  [_guestNum release];
  [_pricePerNight release];
  [_linePay release];
  [_subPrice release];
  //[_orderType release];
  [_statusContent release];
  
  [_number release];
  [_image release];
  [_title release];
  [_address release];
  
  //[_ifShowHost release];
  [_hostName release];
  [_hostPhone release];
  [_hostBackupPhone release];
  
  //[_orderStateEnum release];
	
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

            ifShowHost:(BOOL)ifShowHost
              hostName:(NSString *)hostName
             hostPhone:(NSString *)hostPhone
       hostBackupPhone:(NSString *)hostBackupPhone

            orderState:(OrderStateEnum)orderStateEnum {
  
  if ((self = [super init])) {
		PRPLog(@"init %@ [0x%x]", TAG, [self hash]);
    
    _orderId = [orderId copy];
    _orderState = [orderState copy];
    _message = [message copy];
    _chenckInDate = [chenckInDate copy];
    _chenckOutDate = [chenckOutDate copy];
    _guestNum = [guestNum copy];
    _pricePerNight = [pricePerNight copy];
    _linePay = [linePay copy];
    _subPrice = [subPrice copy];
    _orderTypeEnum = orderTypeEnum;
    _statusContent = [statusContent copy];
    
    _number = [number copy];
    _image = [image copy];
    _title = [title copy];
    _address = [address copy];
    
    _ifShowHost = ifShowHost;
    _hostName = [hostName copy];
    _hostPhone = [hostPhone copy];
    _hostBackupPhone = [hostBackupPhone copy];
    
    _orderStateEnum = orderStateEnum;
    
  }
  
  return self;
}

#pragma mark -
#pragma mark 方便构造

+(id)orderDetailNetRespondBeanWithOrderId:(NSNumber *)orderId
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

                               ifShowHost:(BOOL)ifShowHost
                                 hostName:(NSString *)hostName
                                hostPhone:(NSString *)hostPhone
                          hostBackupPhone:(NSString *)hostBackupPhone

                               orderState:(OrderStateEnum)orderStateEnum {
  
  return [[[OrderDetailNetRespondBean alloc] initWithOrderId:orderId
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
           
                                                  ifShowHost:ifShowHost
                                                    hostName:hostName
                                                   hostPhone:hostPhone
                                             hostBackupPhone:hostBackupPhone
           
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