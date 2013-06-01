//
//  HelpParseNetRespondStringToDomainBean.m
//  airizu
//
//  Created by 唐志华 on 13-1-1.
//
//

#import "HelpParseNetRespondStringToDomainBean.h"

#import "HelpDatabaseFieldsConstant.h"
#import "HelpInfo.h"
#import "HelpNetRespondBean.h"

#import "JSONKit.h"
#import "NSString+Expand.h"
#import "NSDictionary+SafeValue.h"

static const NSString *const TAG = @"<HelpParseNetRespondStringToDomainBean>";

@implementation HelpParseNetRespondStringToDomainBean
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
    
    NSArray *jsonArrayForData = [jsonRootNSDictionary safeArrayObjectForKey:k_Help_RespondKey_data];
    
    NSMutableArray *helpInfoList = [NSMutableArray array];
    
    for (NSDictionary *jsonObjectForHelpInfo in jsonArrayForData) {
      NSString *type = [jsonObjectForHelpInfo safeStringObjectForKey:k_Help_RespondKey_type withDefaultValue:defaultValueForString];
      NSString *title = [jsonObjectForHelpInfo safeStringObjectForKey:k_Help_RespondKey_title withDefaultValue:defaultValueForString];
      NSString *content = [jsonObjectForHelpInfo safeStringObjectForKey:k_Help_RespondKey_content withDefaultValue:defaultValueForString];
      
      // 将 html string 转换成 text string
      content = [ToolsFunctionForThisProgect transformHtmlStringToTextString:content];
      
      HelpInfo *helpInfo = [HelpInfo helpInfoWithType:type title:title content:content];
      [helpInfoList addObject:helpInfo];
    }
    
    return [HelpNetRespondBean helpNetRespondBeanWithHelpInfoList:helpInfoList];
  } while (NO);
  
  return nil;
}

@end