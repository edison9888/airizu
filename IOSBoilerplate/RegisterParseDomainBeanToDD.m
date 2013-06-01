//
//  RegisterParseDomainBeanToDD.m
//  airizu
//
//  Created by 唐志华 on 13-1-1.
//
//

#import "RegisterParseDomainBeanToDD.h"

#import "RegisterDatabaseFieldsConstant.h"
#import "RegisterNetResquestBean.h"

#import "NSString+Expand.h"

static const NSString *const TAG = @"<RegisterParseDomainBeanToDD>";

@implementation RegisterParseDomainBeanToDD

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
    if (! [netRequestDomainBean isMemberOfClass:[RegisterNetResquestBean class]]) {
      NSAssert(NO, @"传入的业务Bean的类型不符 !");
      break;
    }
    
    const RegisterNetResquestBean *requestBean = netRequestDomainBean;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
		
		NSString *value = nil;
		
    //  
		value = requestBean.userName;
		if ([NSString isEmpty:value]) {
      NSAssert(NO, @"关键字段丢失 : userName");
      break;
		}
    [params setObject:value forKey:k_Register_RequestKey_userName];
    
    //
		value = requestBean.phoneNumber;
		if ([NSString isEmpty:value]) {
      NSAssert(NO, @"关键字段丢失 : phoneNumber");
      break;
		}
    [params setObject:value forKey:k_Register_RequestKey_phoneNumber];
    
    //
		value = requestBean.email;
		if ([NSString isEmpty:value]) {
      NSAssert(NO, @"关键字段丢失 : email");
      break;
		}
    [params setObject:value forKey:k_Register_RequestKey_email];
    
    //
		value = requestBean.password;
		if ([NSString isEmpty:value]) {
      NSAssert(NO, @"关键字段丢失 : password");
      break;
		}
    [params setObject:value forKey:k_Register_RequestKey_password];
    
    return params;
  } while (NO);
  
  return nil;
}
@end