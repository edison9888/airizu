//
//  SystemMessagesDomainBeanToolsFactory.m
//  airizu
//
//  Created by 唐志华 on 13-1-1.
//
//

#import "SystemMessagesDomainBeanToolsFactory.h"
#import "SystemMessageParseDomainBeanToDD.h"
#import "SystemMessagesParseNetRespondStringToDomainBean.h"

static const NSString *const TAG = @"<SystemMessagesDomainBeanToolsFactory>";

@implementation SystemMessagesDomainBeanToolsFactory
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

/**
 * 将当前业务Bean, 解析成跟后台数据接口对应的数据字典
 * @return
 */
- (id<IParseDomainBeanToDataDictionary>) getParseDomainBeanToDDStrategy {
  return [[[SystemMessageParseDomainBeanToDD alloc] init] autorelease];
}

/**
 * 将网络返回的数据字符串, 解析成当前业务Bean
 * @return
 */
- (id<IParseNetRespondStringToDomainBean>) getParseNetRespondStringToDomainBeanStrategy {
  return [[[SystemMessagesParseNetRespondStringToDomainBean alloc] init] autorelease];
}

/**
 * 当前业务Bean, 对应的URL地址.
 * @return
 */
- (NSString *) getURL {
  return kUrlConstant_SpecialPath_account_systemMessage;//@"http://124.65.163.102:819/app/account/systemMessage";
}

@end