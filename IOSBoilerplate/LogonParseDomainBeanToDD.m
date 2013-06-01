//
//  LogonParseDomainBeanToDD.m
//  airizu
//
//  Created by 唐志华 on 13-1-1.
//
//

#import "LogonParseDomainBeanToDD.h"

#import "LogonDatabaseFieldsConstant.h"
#import "LogonNetRequestBean.h"
#import "NSString+Expand.h"

static const NSString *const TAG = @"<LogonParseDomainBeanToDD>";

@implementation LogonParseDomainBeanToDD

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
    if (! [netRequestDomainBean isMemberOfClass:[LogonNetRequestBean class]]) {
      NSAssert(NO, @"传入的业务Bean的类型不符 !");
      break;
    }
    
    const LogonNetRequestBean *requestBean = netRequestDomainBean;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
		
		NSString *value = nil;
		
    // 必须参数
		value = requestBean.loginName;
		if ([NSString isEmpty:value]) {
      NSAssert(NO, @"丢失关键参数 : loginName");
      break;
		}
    [params setObject:value forKey:k_Login_RequestKey_loginName];
    
    value = requestBean.password;
		if ([NSString isEmpty:value]) {
      NSAssert(NO, @"丢失关键参数 : password");
      break;
		}
    [params setObject:value forKey:k_Login_RequestKey_password];
    
    // 可选参数
    value = requestBean.clientVersion;
		if (![NSString isEmpty:value]) {
      [params setObject:value forKey:k_Login_RequestKey_clientVersion];
		}
    value = requestBean.clientAVersion;
		if (![NSString isEmpty:value]) {
      [params setObject:value forKey:k_Login_RequestKey_clientAVersion];
		}
    value = requestBean.screenSize;
		if (![NSString isEmpty:value]) {
      [params setObject:value forKey:k_Login_RequestKey_screenSize];
		}
    
    return params;
  } while (NO);
  
  return nil;
}
@end