//
//  PayInfoParseNetRespondStringToDomainBean.m
//  airizu
//
//  Created by 唐志华 on 13-1-1.
//
//

#import "PayInfoParseNetRespondStringToDomainBean.h"

#import "PayInfoDatabaseFieldsConstant.h"
#import "PayInfoNetRespondBean.h"

#import "JSONKit.h"
#import "NSString+Expand.h"
#import "NSDictionary+SafeValue.h"

static const NSString *const TAG = @"<PayInfoParseNetRespondStringToDomainBean>";

@implementation PayInfoParseNetRespondStringToDomainBean
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

    NSString *payInfo = [jsonRootNSDictionary safeStringObjectForKey:k_OrderPay_RespondKey_payInfo withDefaultValue:defaultValueForString];
    if ([NSString isEmpty:payInfo]) {
      PRPLog(@"丢失关键字段 : payInfo");
      break;
    }
    return [PayInfoNetRespondBean payInfoNetRespondBeanWithPayInfo:payInfo];
    
  } while (NO);
  
  return nil;
}

@end