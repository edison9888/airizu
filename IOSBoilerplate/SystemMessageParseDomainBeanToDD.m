//
//  SystemMessageParseDomainBeanToDD.m
//  airizu
//
//  Created by 唐志华 on 13-1-1.
//
//

#import "SystemMessageParseDomainBeanToDD.h"

#import "SystemMessageDatabaseFieldsConstant.h"
#import "SystemMessagesNetRequestBean.h"

#import "NSString+Expand.h"

static const NSString *const TAG = @"<SystemMessageParseDomainBeanToDD>";

@implementation SystemMessageParseDomainBeanToDD

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
    if (! [netRequestDomainBean isMemberOfClass:[SystemMessagesNetRequestBean class]]) {
      NSAssert(NO, @"传入的业务Bean的类型不符 !");
      break;
    }
    
    const SystemMessagesNetRequestBean *requestBean = netRequestDomainBean;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
		
		NSString *value = nil;
		
    //
		value = [requestBean.pageNum stringValue];
		if ([NSString isEmpty:value]) {
      NSAssert(NO, @"丢失关键字段 : pageNum");
      break;
		}
    [params setObject:value forKey:k_SystemMessage_RequestKey_pageNum];
    
    return params;
  } while (NO);
  
  return nil;
}
@end