//
//  OrderOverview.m
//  airizu
//
//  Created by 唐志华 on 13-1-1.
//
//

#import "OrderOverview.h"

static const NSString *const TAG = @"<OrderOverview>";

@implementation OrderOverview

- (void) dealloc {
	PRPLog(@"dealloc: %@ [0x%x]", TAG, [self hash]);
	
  [_orderId release];
  [_roomTitle release];
  [_checkInDate release];
  [_checkOutDate release];
  [_statusCode release];
  [_orderTotalPrice release];
  [_roomImage release];
  [_roomId release];
  
	[super dealloc];
}

- (id) initWithOrderId:(NSNumber *)orderId
             roomTitle:(NSString *)roomTitle
           checkInDate:(NSString *)checkInDate
          checkOutDate:(NSString *)checkOutDate
            statusCode:(NSNumber *)statusCode
       orderTotalPrice:(NSNumber *)orderTotalPrice
             roomImage:(NSString *)roomImage
                roomId:(NSNumber *)roomId
         statusContent:(NSString *)statusContent{
  
  if ((self = [super init])) {
		PRPLog(@"init %@ [0x%x]", TAG, [self hash]);
    
    _orderId = [orderId copy];
    _roomTitle = [roomTitle copy];
    _checkInDate = [checkInDate copy];
    _checkOutDate = [checkOutDate copy];
    _statusCode = [statusCode copy];
    _orderTotalPrice = [orderTotalPrice copy];
    _roomImage = [roomImage copy];
    _roomId = [roomId copy];
    _statusContent = [statusContent copy];
  }
  
  return self;
}

#pragma mark -
#pragma mark 方便构造

+(id)orderOverviewWithOrderId:(NSNumber *)orderId
                    roomTitle:(NSString *)roomTitle
                  checkInDate:(NSString *)checkInDate
                 checkOutDate:(NSString *)checkOutDate
                   statusCode:(NSNumber *)statusCode
              orderTotalPrice:(NSNumber *)orderTotalPrice
                    roomImage:(NSString *)roomImage
                       roomId:(NSNumber *)roomId
                statusContent:(NSString *)statusContent{
  
  return [[[OrderOverview alloc] initWithOrderId:orderId
                                       roomTitle:roomTitle
                                     checkInDate:checkInDate
                                    checkOutDate:checkOutDate
                                      statusCode:statusCode
                                 orderTotalPrice:orderTotalPrice
                                       roomImage:roomImage
                                          roomId:roomId
                                   statusContent:statusContent] autorelease];
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