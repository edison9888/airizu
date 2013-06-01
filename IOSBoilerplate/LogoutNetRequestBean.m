//
//  LogoutNetRequestBean.m
//  airizu
//
//  Created by 唐志华 on 13-1-1.
//
//

#import "LogoutNetRequestBean.h"

@implementation LogoutNetRequestBean

+(id)logoutNetRequestBean {
  return [[[LogoutNetRequestBean alloc] init] autorelease];
}

- (NSString *)description {
	return descriptionForDebug(self);
}
@end
