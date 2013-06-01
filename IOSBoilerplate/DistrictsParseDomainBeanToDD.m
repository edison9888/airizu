//
//  DistrictsParseDomainBeanToDD.m
//  airizu
//
//  Created by 唐志华 on 13-1-1.
//
//

#import "DistrictsParseDomainBeanToDD.h"

#import "DistrictsDatabaseFieldsConstant.h"
#import "DistrictsNetRequestBean.h"

#import "NSString+Expand.h"

static const NSString *const TAG = @"<DistrictsParseDomainBeanToDD>";

@implementation DistrictsParseDomainBeanToDD

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
    if (! [netRequestDomainBean isMemberOfClass:[DistrictsNetRequestBean class]]) {
      NSAssert(NO, @"传入的业务Bean的类型不符 !");
      break;
    }
    
    const DistrictsNetRequestBean *requestBean = netRequestDomainBean;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
		
		NSString *value = nil;
		
    // 城市id
		value = requestBean.cityId;
		if ([NSString isEmpty:value]) {
      NSAssert(NO, @"丢失关键字段 : cityId");
      break;
		}
    [params setObject:value forKey:k_DistrictInfo_RequestKey_cityId];
    
    return params;
  } while (NO);
  
  return nil;
}
@end