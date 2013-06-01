//
//  RoomDetailParseDomainBeanToDD.m
//  airizu
//
//  Created by 唐志华 on 13-1-1.
//
//

#import "RoomDetailParseDomainBeanToDD.h"

#import "RoomDetailDatabaseFieldsConstant.h"
#import "RoomDetailNetRequestBean.h"

#import "NSString+Expand.h"

static const NSString *const TAG = @"<RoomDetailParseDomainBeanToDD>";

@implementation RoomDetailParseDomainBeanToDD

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
    if (! [netRequestDomainBean isMemberOfClass:[RoomDetailNetRequestBean class]]) {
      NSAssert(NO, @"传入的业务Bean的类型不符 !");
      break;
    }
    
    const RoomDetailNetRequestBean *requestBean = netRequestDomainBean;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
		
		NSString *value = nil;
		
    // 房间id
		value = requestBean.roomId;
		if ([NSString isEmpty:value]) {
      NSAssert(NO, @"丢失关键数据字典:roomId");
      break;
		}
    [params setObject:value forKey:k_RoomDetail_RequestKey_roomId];
    
    return params;
  } while (NO);
  
  return nil;
}
@end