//
//  LogonNetRespondBean.m
//  airizu
//
//  Created by 唐志华 on 13-1-1.
//
//

#import "LogonNetRespondBean.h"

static const NSString *const TAG = @"<LogonNetRespondBean>";

@implementation LogonNetRespondBean

- (void) dealloc {
	PRPLog(@"dealloc: %@ [0x%x]", TAG, [self hash]);
	
  [_message release];
  [_userId release];
  [_userName release];
  [_sessionId release];
  [_phoneNumber release];
  
	[super dealloc];
}

- (id) initWithMessage:(NSString *) message
                userId:(NSNumber *)userId
              userName:(NSString *)userName
             sessionId:(NSString *)sessionId
           phoneNumber:(NSString *)phoneNumber {
  
  if ((self = [super init])) {
		PRPLog(@"init %@ [0x%x]", TAG, [self hash]);
    
    _message = [message copy];
    _userId = [userId copy];
    _userName = [userName copy];
    _sessionId = [sessionId copy];
    _phoneNumber = [phoneNumber copy];
  }
  
  return self;
}

#pragma mark -
#pragma mark 方便构造

+(id)LogonNetRespondBeanWithMessage:(NSString *)message
                             userId:(NSNumber *)userId
                           userName:(NSString *)userName
                          sessionId:(NSString *)sessionId
                        phoneNumber:(NSString *)phoneNumber {
  return [[[LogonNetRespondBean alloc] initWithMessage:message
                                                userId:userId
                                              userName:userName
                                             sessionId:sessionId
                                           phoneNumber:phoneNumber] autorelease];
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