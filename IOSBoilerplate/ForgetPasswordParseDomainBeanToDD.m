//
//  ForgetPasswordParseDomainBeanToDD.m
//  airizu
//
//  Created by 唐志华 on 13-1-1.
//
//

#import "ForgetPasswordParseDomainBeanToDD.h"
#import "ForgetPasswordDatabaseFieldsConstant.h"
#import "ForgetPasswordNetRequestBean.h"
#import "NSString+Expand.h"

static const NSString *const TAG = @"<ForgetPasswordParseDomainBeanToDD>";

@implementation ForgetPasswordParseDomainBeanToDD

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
    if (! [netRequestDomainBean isMemberOfClass:[ForgetPasswordNetRequestBean class]]) {
      NSAssert(NO, @"传入的业务Bean的类型不符 !");
      break;
    }
    
    const ForgetPasswordNetRequestBean *requestBean = netRequestDomainBean;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
		
		NSString *value = nil;
		
    // 电话号码
		value = requestBean.phoneNumber;
		if ([NSString isEmpty:value]) {
      NSAssert(NO, @"关键字段丢失 : phoneNumber");
      break;
		}
    [params setObject:value forKey:k_ForgetPassword_RequestKey_phoneNumber];
    
    return params;
  } while (NO);
  
  return nil;
}
@end