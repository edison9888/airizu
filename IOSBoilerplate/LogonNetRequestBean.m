//
//  LogonNetRequestBean.m
//  airizu
//
//  Created by 唐志华 on 13-1-1.
//
//

#import "LogonNetRequestBean.h"

static const NSString *const TAG = @"<LogonNetRequestBean>";

@implementation LogonNetRequestBean

- (void) dealloc {
	PRPLog(@"dealloc: %@ [0x%x]", TAG, [self hash]);
	
  [_loginName release];
  [_password release];
  [_clientVersion release];
  [_clientAVersion release];
  [_screenSize release];
  
	[super dealloc];
}

- (id) initWithLoginName:(NSString *) loginName
                password:(NSString *) password {
  
  if ((self = [super init])) {
		PRPLog(@"init %@ [0x%x]", TAG, [self hash]);
    
    _loginName = [loginName copy];
    _password = [password copy];
    
  }
  
  return self;
}

#pragma mark -
#pragma mark 方便构造
+(id)logonNetRequestBeanWithLoginName:(NSString *)loginName password:(NSString *)password {
  return [[[LogonNetRequestBean alloc] initWithLoginName:loginName password:password] autorelease];
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