//
//  RoomCalendarParseDomainBeanToDD.m
//  airizu
//
//  Created by 唐志华 on 13-1-1.
//
//

#import "RoomCalendarParseDomainBeanToDD.h"

#import "RoomCalendarDatabaseFieldsConstant.h"
#import "RoomCalendarNetRequestBean.h"

#import "NSString+Expand.h"

static const NSString *const TAG = @"<RoomCalendarParseDomainBeanToDD>";

@implementation RoomCalendarParseDomainBeanToDD

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
    if (! [netRequestDomainBean isMemberOfClass:[RoomCalendarNetRequestBean class]]) {
      NSAssert(NO, @"传入的业务Bean的类型不符 !");
      break;
    }
    
    const RoomCalendarNetRequestBean *requestBean = netRequestDomainBean;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
		
		NSString *value = nil;
		
    // 房间ID
		value = [requestBean.roomId stringValue];
		if ([NSString isEmpty:value]) {
      NSAssert(NO, @"关键字段丢失:roomId");
      break;
		}
    [params setObject:value forKey:k_RoomCalendar_RequestKey_roomId];
    
    return params;
  } while (NO);
  
  return nil;
}
@end