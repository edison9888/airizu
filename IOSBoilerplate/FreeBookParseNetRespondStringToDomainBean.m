//
//  FreeBookParseNetRespondStringToDomainBean.m
//  airizu
//
//  Created by 唐志华 on 13-1-1.
//
//

#import "FreeBookParseNetRespondStringToDomainBean.h"

#import "FreeBookDatabaseFieldsConstant.h"
#import "FreeBookNetRespondBean.h"

#import "JSONKit.h"
#import "NSString+Expand.h"
#import "NSDictionary+SafeValue.h"

static const NSString *const TAG = @"<FreeBookParseNetRespondStringToDomainBean>";

@implementation FreeBookParseNetRespondStringToDomainBean
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
    //NSString *defaultValueForString = @"";
    NSNumber *defaultValueForNumber = @NO;
    
    NSNumber *totalPrice
    = [jsonRootNSDictionary safeNumberObjectForKey:k_OrderFreebook_RespondKey_totalPrice
                                  withDefaultValue:defaultValueForNumber];
    NSNumber *advancedDeposit
    = [jsonRootNSDictionary safeNumberObjectForKey:k_OrderFreebook_RespondKey_advancedDeposit
                                  withDefaultValue:defaultValueForNumber];
    NSNumber *underLinePaid
    = [jsonRootNSDictionary safeNumberObjectForKey:k_OrderFreebook_RespondKey_underLinePaid
                                  withDefaultValue:defaultValueForNumber];
    NSNumber *availablePoint
    = [jsonRootNSDictionary safeNumberObjectForKey:k_OrderFreebook_RespondKey_availablePoint
                                  withDefaultValue:defaultValueForNumber];
    
    // 注意 : 协议文档中写明 : 是否优惠（0优惠，1没优惠）, 这个跟语义相反, 所以这里做了取反操作
    // YES : 已优惠
    // NO  : 未优惠
    NSNumber *isCheap
    = [jsonRootNSDictionary safeNumberObjectForKey:k_OrderFreebook_RespondKey_isCheap
                                  withDefaultValue:defaultValueForNumber];
    
    return [FreeBookNetRespondBean freeBookNetRespondBeanWithTotalPrice:totalPrice
                                                        advancedDeposit:advancedDeposit
                                                          underLinePaid:underLinePaid
                                                         availablePoint:availablePoint
                                                                isCheap:![isCheap boolValue]];
  } while (NO);
  
  return nil;
}

@end