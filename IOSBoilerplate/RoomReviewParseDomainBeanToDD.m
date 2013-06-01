//
//  RoomReviewParseDomainBeanToDD.m
//  airizu
//
//  Created by 唐志华 on 13-1-1.
//
//

#import "RoomReviewParseDomainBeanToDD.h"

#import "RoomReviewDatabaseFieldsConstant.h"
#import "RoomReviewNetRequestBean.h"

#import "NSString+Expand.h"

static const NSString *const TAG = @"<RoomReviewParseDomainBeanToDD>";

@implementation RoomReviewParseDomainBeanToDD

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
    if (! [netRequestDomainBean isMemberOfClass:[RoomReviewNetRequestBean class]]) {
      NSAssert(NO, @"传入的业务Bean的类型不符 !");
      break;
    }
    
    const RoomReviewNetRequestBean *requestBean = netRequestDomainBean;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
		
		NSString *value = nil;
		
    //  
		value = requestBean.roomId;
		if ([NSString isEmpty:value]) {
      NSAssert(NO, @"丢失关键字段 roomId");
      break;
		}
    [params setObject:value forKey:k_RoomReview_RequestKey_roomId];
    
    //  
		value = [NSString stringWithFormat:@"%d", requestBean.pageNum];
		if ([NSString isEmpty:value] || requestBean.pageNum < 0) {
      NSAssert(NO, @"丢失关键字段 pageNum");
      break;
		}
    [params setObject:value forKey:k_RoomReview_RequestKey_pageNum];
    return params;
  } while (NO);
  
  return nil;
}
@end