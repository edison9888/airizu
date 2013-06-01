//
//  ForgetPasswordNetRequestBean.m
//  airizu
//
//  Created by 唐志华 on 13-1-1.
//
//

#import "ForgetPasswordNetRequestBean.h"

static const NSString *const TAG = @"<ForgetPasswordNetRequestBean>";

@implementation ForgetPasswordNetRequestBean

- (void) dealloc {
	PRPLog(@"dealloc: %@ [0x%x]", TAG, [self hash]);
	
  [_phoneNumber release];
  
	[super dealloc];
}

- (id) initWithPhoneNumber:(NSString *) phoneNumber {
  
  if ((self = [super init])) {
		PRPLog(@"init %@ [0x%x]", TAG, [self hash]);
    
    _phoneNumber = [phoneNumber copy];
    
  }
  
  return self;
}

#pragma mark -
#pragma mark 方便构造
+(id)forgetPasswordNetRequestBeanWithPhoneNumber:(NSString *)phoneNumber {
  return [[[ForgetPasswordNetRequestBean alloc] initWithPhoneNumber:phoneNumber] autorelease];
}

#pragma mark
#pragma mark 不能使用默认的init方法初始化对象, 而必须使用当前类特定的 "初始化方法" 初始化所有参数
- (id) init {
  NSAssert(NO, @"Can not use the default init method!");
  
  return nil;
}

- (NSString *)description {
	return descriptionForDebug(self);
}
@end