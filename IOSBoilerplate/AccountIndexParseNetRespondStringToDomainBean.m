//
//  AccountIndexParseNetRespondStringToDomainBean.m
//  airizu
//
//  Created by 唐志华 on 13-1-1.
//
//

#import "AccountIndexParseNetRespondStringToDomainBean.h"

#import "AccountIndexDatabaseFieldsConstant.h"
#import "AccountIndexNetRespondBean.h"

#import "JSONKit.h"
#import "NSString+Expand.h"
#import "NSDictionary+SafeValue.h"

static const NSString *const TAG = @"<AccountIndexParseNetRespondStringToDomainBean>";

@implementation AccountIndexParseNetRespondStringToDomainBean
- (id) init {
	
	if ((self = [super init])) {
		PRPLog(@"init %@ [0x%x]", TAG, [self hash]);
    
	}
	
	return self;
}

- (void) dealloc {
	PRPLog(@"dealloc: %@ [0x%x]", TAG, [self hash]);
	
	[super dealloc];
}

#pragma mark 实现 IParseNetRespondStringToDomainBean 接口
- (id) parseNetRespondStringToDomainBean:(in NSString *) netRespondString {
  do {
    if ([NSString isEmpty:netRespondString]) {
      PRPLog(@"%@-> 入参 netRespondString 为空 !", TAG);
      break;
    }
    
    const char *jsonStringForUTF8 = [netRespondString UTF8String];
		NSError *error = [[NSError alloc] init];
    JSONDecoder *jsonDecoder = [[JSONDecoder alloc] init];
    NSDictionary *jsonRootNSDictionary
    = [jsonDecoder objectWithUTF8String:(const unsigned char *)jsonStringForUTF8
                                 length:(unsigned int)strlen(jsonStringForUTF8)];
    [jsonDecoder release], jsonDecoder = nil;
		[error release], error = nil;
    
    if (![jsonRootNSDictionary isKindOfClass:[NSDictionary class]]) {
      PRPLog(@"%@-> json 解析失败!", TAG);
      break;
    }
    
    // 关键数据字段检测
    NSString *defaultValueForString = @"";
    NSNumber *defaultValueForNumber = [NSNumber numberWithBool:NO];
    
    NSNumber *totalPoint = [jsonRootNSDictionary safeNumberObjectForKey:k_AccountIndex_RespondKey_totalPoint
                                                       withDefaultValue:defaultValueForNumber];
		NSString *phoneNumber = [jsonRootNSDictionary safeStringObjectForKey:k_AccountIndex_RespondKey_phoneNumber
                                                        withDefaultValue:defaultValueForString];
		NSNumber *waitConfirmCount = [jsonRootNSDictionary safeNumberObjectForKey:k_AccountIndex_RespondKey_waitConfirmCount
                                                             withDefaultValue:defaultValueForNumber];
		NSNumber *waitPayCount = [jsonRootNSDictionary safeNumberObjectForKey:k_AccountIndex_RespondKey_waitPayCount
                                                         withDefaultValue:defaultValueForNumber];
		NSNumber *waitLiveCount = [jsonRootNSDictionary safeNumberObjectForKey:k_AccountIndex_RespondKey_waitLiveCount
                                                          withDefaultValue:defaultValueForNumber];
		NSNumber *waitReviewCount = [jsonRootNSDictionary safeNumberObjectForKey:k_AccountIndex_RespondKey_waitReviewCount
                                                            withDefaultValue:defaultValueForNumber];
		NSString *userImageURL = [jsonRootNSDictionary safeStringObjectForKey:k_AccountIndex_RespondKey_userImageURL
                                                         withDefaultValue:defaultValueForString];
		NSString *sexString = [jsonRootNSDictionary safeStringObjectForKey:k_AccountIndex_RespondKey_sex
                                                      withDefaultValue:defaultValueForString];
    SexEnum sex = kSexEnum_Woman;
    if ([sexString isEqualToString:@"1"]) {
      sex = kSexEnum_Man;
    }
		NSString *email = [jsonRootNSDictionary safeStringObjectForKey:k_AccountIndex_RespondKey_email
                                                  withDefaultValue:defaultValueForString];
		NSString *userName = [jsonRootNSDictionary safeStringObjectForKey:k_AccountIndex_RespondKey_userName];
		NSNumber *validatePhone = [jsonRootNSDictionary safeNumberObjectForKey:k_AccountIndex_RespondKey_validatePhone
                                                          withDefaultValue:defaultValueForNumber];
		NSNumber *validateEmail = [jsonRootNSDictionary safeNumberObjectForKey:k_AccountIndex_RespondKey_validateEmail
                                                          withDefaultValue:defaultValueForNumber];
    
    return [AccountIndexNetRespondBean accountIndexNetRespondBeanWithTotalPoint:totalPoint
                                                                    phoneNumber:phoneNumber
                                                               waitConfirmCount:waitConfirmCount
                                                                   waitPayCount:waitPayCount
                                                                  waitLiveCount:waitLiveCount
                                                                waitReviewCount:waitReviewCount
                                                                       userName:userName
                                                                   userImageURL:userImageURL
                                                                            sex:sex
                                                                          email:email
                                                                  validatePhone:[validatePhone boolValue]
                                                                  validateEmail:[validateEmail boolValue]];
    
    
  } while (NO);
  
  return nil;
}

@end