//
//  CitysNetRequestBean.m
//  airizu
//
//  Created by 唐志华 on 13-1-1.
//
//

#import "CitysNetRequestBean.h"

@implementation CitysNetRequestBean

+(id)citysNetRequestBean {
  return [[[CitysNetRequestBean alloc] init] autorelease];
}

- (NSString *)description {
	return descriptionForDebug(self);
}
@end
