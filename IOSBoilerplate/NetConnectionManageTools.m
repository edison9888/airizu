//
//  NetConnectionManageTools.m
//  airizu
//
//  Created by 唐志华 on 12-12-20.
//
//

#import "NetConnectionManageTools.h"
#import <SystemConfiguration/SystemConfiguration.h>
#include <netdb.h>

static const NSString *const TAG = @"<NetConnectionManageTools>";

@implementation NetConnectionManageTools
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

- (BOOL) isNetAvailable {
  // 以下objc相关函数、类型需要添加System Configuration 框架
  // 用0.0.0.0来判断本机网络状态
	struct sockaddr_in zeroAddress;
	bzero(&zeroAddress, sizeof(zeroAddress));
	zeroAddress.sin_len = sizeof(zeroAddress);
	zeroAddress.sin_family = AF_INET;
  
	// Recover reachability flags
	SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
	SCNetworkReachabilityFlags flags;
	
	//获得连接的标志
	BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
	CFRelease(defaultRouteReachability);
	
	//如果不能获取连接标志，则不能连接网络，直接返回
	if (!didRetrieveFlags){
		return NO;
	}
	
	//根据获得的连接标志进行判断
	BOOL isReachable = flags & kSCNetworkFlagsReachable;
	BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
	return (isReachable && !needsConnection) ? YES : NO;
}

#pragma mark -
#pragma mark 方便构造
+(id)netConnectionManageTools {
  return [[[NetConnectionManageTools alloc] init] autorelease];
}
@end
