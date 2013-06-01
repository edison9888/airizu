//
//  OrderCancelParseDomainBeanToDD.m
//  airizu
//
//  Created by 唐志华 on 13-1-1.
//
//

#import "OrderCancelParseDomainBeanToDD.h"

#import "OrderCancelDatabaseFieldsConstant.h"
#import "OrderCancelNetRequestBean.h"

#import "NSString+Expand.h"

static const NSString *const TAG = @"<OrderCancelParseDomainBeanToDD>";

@implementation OrderCancelParseDomainBeanToDD

- (id) init {
	
	if ((self = [super init])) {
		PRPLog(@"init %@ [0x%x]", TAG, [self hash]);
    
	}
	
	return self;
}

- (void) dealloc {
	PRPLog(@"dealloc: %@ [0x%x]", TAG, [self hash]);
	
	[super dealloc];
}

- (NSDictionary *) parseDomainBeanToDataDictionary:(in id) netRequestDomainBean {
  NSAssert(netRequestDomainBean != nil, @"入参为空 !");
  
  do {
    if (! [netRequestDomainBean isMemberOfClass:[OrderCancelNetRequestBean class]]) {
      NSAssert(NO, @"传入的业务Bean的类型不符 !");
      break;
    }
    
    const OrderCancelNetRequestBean *requestBean = netRequestDomainBean;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
		
		NSString *value = nil;
		
    // 订单ID
		value = requestBean.orderId;
		if (![NSString isEmpty:value]) {
      [params setObject:value forKey:k_OrderCancel_RequestKey_orderId];
		}
    
    return params;
  } while (NO);
  
  return nil;
}
@end