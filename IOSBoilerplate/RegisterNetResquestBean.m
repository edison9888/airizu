//
//  RegisterNetResquestBean.m
//  airizu
//
//  Created by 唐志华 on 13-1-1.
//
//

#import "RegisterNetResquestBean.h"

static const NSString *const TAG = @"<RegisterNetResquestBean>";

@implementation RegisterNetResquestBean

- (void) dealloc {
	PRPLog(@"dealloc: %@ [0x%x]", TAG, [self hash]);
	
  [_userName release];
  [_phoneNumber release];
  [_email release];
  [_password release];
  
	[super dealloc];
}

- (id) initWithUserName:(NSString *) userName
            phoneNumber:(NSString *) phoneNumber
                  email:(NSString *) email
               password:(NSString *) password {
  
  if ((self = [super init])) {
		PRPLog(@"init %@ [0x%x]", TAG, [self hash]);
    
    _userName = [userName copy];
    _phoneNumber = [phoneNumber copy];
    _email = [email copy];
    _password = [password copy];
  }
  
  return self;
}

#pragma mark -
#pragma mark 方便构造

+(id)registerNetResquestBeanWithUserName:(NSString *)userName
                             phoneNumber:(NSString *)phoneNumber
                                   email:(NSString *)email
                                password:(NSString *)password {
  return [[[RegisterNetResquestBean alloc] initWithUserName:userName
                                                phoneNumber:phoneNumber
                                                      email:email
                                                   password:password] autorelease];
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