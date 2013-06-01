//
//  HelpNetRequestBean.m
//  airizu
//
//  Created by 唐志华 on 13-1-1.
//
//

#import "HelpNetRequestBean.h"

@implementation HelpNetRequestBean

+(id)helpNetRequestBean {
  return [[[HelpNetRequestBean alloc] init] autorelease];
}

- (NSString *)description {
	return descriptionForDebug(self);
}
@end
 