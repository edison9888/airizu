//
//  AccountIndexNetRespondBean.m
//  airizu
//
//  Created by 唐志华 on 13-1-1.
//
//

#import "AccountIndexNetRespondBean.h"


static const NSString *const TAG = @"<AccountIndexNetRespondBean>";

@implementation AccountIndexNetRespondBean

- (void) dealloc {
	PRPLog(@"dealloc: %@ [0x%x]", TAG, [self hash]);
	
  [_totalPoint release];
  [_phoneNumber release];
  [_waitConfirmCount release];
  [_waitPayCount release];
  [_waitLiveCount release];
  [_waitReviewCount release];
  [_userName release];
  [_userImageURL release];
  //[_sex release];
  [_email release];
  //[_validatePhone release];
  //[_validateEmail release];
  
	[super dealloc];
}

- (id) initWithTotalPoint:(NSNumber *) totalPoint
              phoneNumber:(NSString *) phoneNumber
         waitConfirmCount:(NSNumber *) waitConfirmCount
             waitPayCount:(NSNumber *) waitPayCount
            waitLiveCount:(NSNumber *) waitLiveCount
          waitReviewCount:(NSNumber *) waitReviewCount
                 userName:(NSString *) userName
             userImageURL:(NSString *) userImageURL
                      sex:(SexEnum)    sex
                    email:(NSString *) email
            validatePhone:(BOOL)       isValidatePhone
            validateEmail:(BOOL)       isValidateEmail {
  
  if ((self = [super init])) {
		PRPLog(@"init %@ [0x%x]", TAG, [self hash]);
    
    _totalPoint       = [totalPoint copy];
    _phoneNumber      = [phoneNumber copy];
    _waitConfirmCount = [waitConfirmCount copy];
    _waitPayCount     = [waitPayCount copy];
    _waitLiveCount    = [waitLiveCount copy];
    _waitReviewCount  = [waitReviewCount copy];
    _userName         = [userName copy];
    _userImageURL     = [userImageURL copy];
    _sex              = sex;
    _email            = [email copy];
    _isValidatePhone    = isValidatePhone;
    _isValidateEmail    = isValidateEmail;
  }
  
  return self;
}

#pragma mark -
#pragma mark 方便构造
+(id)accountIndexNetRespondBeanWithTotalPoint:(NSNumber *) totalPoint
                                  phoneNumber:(NSString *) phoneNumber
                             waitConfirmCount:(NSNumber *) waitConfirmCount
                                 waitPayCount:(NSNumber *) waitPayCount
                                waitLiveCount:(NSNumber *) waitLiveCount
                              waitReviewCount:(NSNumber *) waitReviewCount
                                     userName:(NSString *) userName
                                 userImageURL:(NSString *) userImageURL
                                          sex:(SexEnum)    sex
                                        email:(NSString *) email
                                validatePhone:(BOOL)       isValidatePhone
                                validateEmail:(BOOL)       isValidateEmail {
  return [[[AccountIndexNetRespondBean alloc] initWithTotalPoint:totalPoint
                                                     phoneNumber:phoneNumber
                                                waitConfirmCount:waitConfirmCount
                                                    waitPayCount:waitPayCount
                                                   waitLiveCount:waitLiveCount
                                                 waitReviewCount:waitReviewCount
                                                        userName:userName
                                                    userImageURL:userImageURL
                                                             sex:sex
                                                           email:email
                                                   validatePhone:isValidatePhone
                                                   validateEmail:isValidateEmail] autorelease];
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