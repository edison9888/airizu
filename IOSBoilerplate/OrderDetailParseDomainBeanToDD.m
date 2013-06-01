//
//  OrderDetailParseDomainBeanToDD.m
//  airizu
//
//  Created by 唐志华 on 13-1-1.
//
//

#import "OrderDetailParseDomainBeanToDD.h"

#import "OrderDetailDatabaseFieldsConstant.h"
#import "OrderDetailNetRequestBean.h"

#import "NSString+Expand.h"

static const NSString *const TAG = @"<OrderDetailParseDomainBeanToDD>";

@implementation OrderDetailParseDomainBeanToDD

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
    if (! [netRequestDomainBean isMemberOfClass:[OrderDetailNetRequestBean class]]) {
      NSAssert(NO, @"传入的业务Bean的类型不符 !");
      break;
    }
    
    const OrderDetailNetRequestBean *requestBean = netRequestDomainBean;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
		
		NSString *value = nil;
		
    // 订单id
		value = requestBean.orderId;
		if ([NSString isEmpty:value]) {
      NSAssert(NO, @"丢失关键字段 : orderId");
      break;
		}
    [params setObject:value forKey:k_OrderDetail_RequestKey_orderId];

    return params;
  } while (NO);
  
  return nil;
}
@end