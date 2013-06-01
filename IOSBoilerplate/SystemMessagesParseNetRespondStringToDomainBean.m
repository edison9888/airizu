//
//  SystemMessagesParseNetRespondStringToDomainBean.m
//  airizu
//
//  Created by 唐志华 on 13-1-1.
//
//

#import "SystemMessagesParseNetRespondStringToDomainBean.h"

#import "SystemMessageDatabaseFieldsConstant.h"
#import "SystemMessagesNetRespondBean.h"
#import "SystemMessage.h"

#import "JSONKit.h"
#import "NSString+Expand.h"
#import "NSDictionary+SafeValue.h"

static const NSString *const TAG = @"<SystemMessagesParseNetRespondStringToDomainBean>";

@implementation SystemMessagesParseNetRespondStringToDomainBean
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
    
    NSArray *jsonArrayForSystemMessageList = [jsonRootNSDictionary safeArrayObjectForKey:k_SystemMessage_RespondKey_data];
    
    NSMutableArray *systemMessageList = [NSMutableArray array];
    
    for (NSDictionary *jsonObjectForSystemMessage in jsonArrayForSystemMessageList) {
      NSString *date = [jsonObjectForSystemMessage safeStringObjectForKey:k_SystemMessage_RespondKey_date withDefaultValue:defaultValueForString];
      date = [ToolsFunctionForThisProgect transformUtilDateStringToSqlDateString:date];
      NSString *message = [jsonObjectForSystemMessage safeStringObjectForKey:k_SystemMessage_RespondKey_message withDefaultValue:defaultValueForString];
      
      SystemMessage *systemMessage = [SystemMessage systemMessageWithDate:date message:message];
      [systemMessageList addObject:systemMessage];
    }
    
    return [SystemMessagesNetRespondBean systemMessagesNetRespondBeanWithSystemMessageList:systemMessageList];
  } while (NO);
  
  return nil;
}

@end