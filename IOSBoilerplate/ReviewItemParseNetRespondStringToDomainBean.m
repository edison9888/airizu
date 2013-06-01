//
//  ReviewItemParseNetRespondStringToDomainBean.m
//  airizu
//
//  Created by 唐志华 on 13-1-1.
//
//

#import "ReviewItemParseNetRespondStringToDomainBean.h"

#import "ReviewItemDatabaseFieldsConstant.h"
#import "ReviewItemNetRespondBean.h"

#import "JSONKit.h"
#import "NSString+Expand.h"
#import "NSDictionary+SafeValue.h"

#import "ReviewItem.h"

static const NSString *const TAG = @"<ReviewItemParseNetRespondStringToDomainBean>";

@implementation ReviewItemParseNetRespondStringToDomainBean
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
    NSDictionary *jsonObjectForItem = [jsonRootNSDictionary safeDictionaryObjectForKey:k_ReviewItem_RespondKey_item];
    if (jsonObjectForItem == nil || jsonObjectForItem.count <= 0) {
      PRPLog(@"%@-> 网络返回的数据无效", TAG);
      break;
    }
    
    NSMutableArray *itemList = [NSMutableArray arrayWithCapacity:10];
    // 排序后的 关键字
    NSArray *allKeysForSorted = [[jsonObjectForItem allKeys] sortedArrayUsingSelector:@selector(compare:)];
    NSNumber *code = nil;
    NSString *name = nil;
    for (id key in allKeysForSorted) {
      
      ///
      if ([key isKindOfClass:[NSNumber class]]) {
        code = key;
      } else if ([key isKindOfClass:[NSString class]] && ![NSString isEmpty:key]) {
        code = [NSNumber numberWithInt:[key intValue]];
      } else {
        code = @0;
      }
      
      ///
      id value = [jsonObjectForItem objectForKey:key];
      if ([value isKindOfClass:[NSString class]]) {
        name = value;
      } else {
        name = @"";
      }
      
      ReviewItem *item = [ReviewItem reviewItemWithItemCode:code itemName:name];
      [itemList addObject:item];

    }
    return [ReviewItemNetRespondBean reviewItemNetRespondBeanWithItemList:itemList];
    
  } while (NO);
  
  return nil;
}

@end