//
//  ReviewItemNetRequestBean.m
//  airizu
//
//  Created by 唐志华 on 13-1-1.
//
//

#import "ReviewItemNetRequestBean.h"

@implementation ReviewItemNetRequestBean

+(id)reviewItemNetRequestBean {
  return [[[ReviewItemNetRequestBean alloc] init] autorelease];
}

- (NSString *)description {
	return descriptionForDebug(self);
}
@end