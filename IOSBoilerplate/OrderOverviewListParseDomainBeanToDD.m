//
//  OrderOverviewListParseDomainBeanToDD.m
//  airizu
//
//  Created by 唐志华 on 13-1-1.
//
//

#import "OrderOverviewListParseDomainBeanToDD.h"

#import "OrderOverviewDatabaseFieldsConstant.h"
#import "OrderOverviewListNetRequestBean.h"

#import "NSString+Expand.h"

static const NSString *const TAG = @"<OrderOverviewListParseDomainBeanToDD>";

@implementation OrderOverviewListParseDomainBeanToDD

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
    if (! [netRequestDomainBean isMemberOfClass:[OrderOverviewListNetRequestBean class]]) {
      NSAssert(NO, @"传入的业务Bean的类型不符 !");
      break;
    }
    
    const OrderOverviewListNetRequestBean *requestBean = netRequestDomainBean;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
		
		NSString *value = nil;
		
    // 
		value = requestBean.orderState;
		if ([NSString isEmpty:value]) {
      NSAssert(NO, @"关键字段丢失 : orderState");
      break;
		}
    [params setObject:value forKey:k_OrderList_RequestKey_orderState];
    
    return params;
  } while (NO);
  
  return nil;
}
@end