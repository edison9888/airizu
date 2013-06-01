//
//  AccountIndexNetRequestBean.m
//  airizu
//
//  Created by 唐志华 on 13-1-1.
//
//

#import "AccountIndexNetRequestBean.h"

@implementation AccountIndexNetRequestBean

+(id)accountIndexNetRequestBean {
  return [[[AccountIndexNetRequestBean alloc] init] autorelease];
}


- (NSString *)description {
	return descriptionForDebug(self);
}
@end