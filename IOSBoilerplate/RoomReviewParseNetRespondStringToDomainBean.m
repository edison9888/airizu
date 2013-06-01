//
//  RoomReviewParseNetRespondStringToDomainBean.m
//  airizu
//
//  Created by 唐志华 on 13-1-1.
//
//

#import "RoomReviewParseNetRespondStringToDomainBean.h"

#import "RoomReviewDatabaseFieldsConstant.h"
#import "RoomReview.h"
#import "RoomReviewNetRespondBean.h"

#import "JSONKit.h"
#import "NSString+Expand.h"
#import "NSDictionary+SafeValue.h"

#import "ToolsFunctionForThisProgect.h"

static const NSString *const TAG = @"<RoomReviewParseNetRespondStringToDomainBean>";

@implementation RoomReviewParseNetRespondStringToDomainBean
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
    
    // 评论总数
    NSNumber *reviewCount = [jsonRootNSDictionary safeNumberObjectForKey:k_RoomReview_RespondKey_reviewCount withDefaultValue:defaultValueForNumber];
    
    // 房间总的平均分
    NSString *avgScore = [jsonRootNSDictionary safeStringObjectForKey:k_RoomReview_RespondKey_avgScore withDefaultValue:defaultValueForString];
    
    // 当前房间的评论项
    NSMutableDictionary *reviewItemMap = [NSMutableDictionary dictionary];
    NSDictionary *jsonObjectForItem = [jsonRootNSDictionary safeDictionaryObjectForKey:k_RoomReview_RespondKey_item];
    [reviewItemMap addEntriesFromDictionary:jsonObjectForItem];
    
    // 评论列表
		NSMutableArray *roomReviewList = [NSMutableArray array];
		NSArray *jsonArrayForReviewList = [jsonRootNSDictionary safeArrayObjectForKey:k_RoomReview_RespondKey_reviews];
    
    for (NSDictionary *jsonObjectForReview in jsonArrayForReviewList) {
      // 用户名
      NSString *userName = [jsonObjectForReview safeStringObjectForKey:k_RoomReview_RespondKey_userName withDefaultValue:defaultValueForString];
      // 用户发表评论的时间
      NSString *userReviewTime = [jsonObjectForReview safeStringObjectForKey:k_RoomReview_RespondKey_userReviewTime withDefaultValue:defaultValueForString];
      userReviewTime = [ToolsFunctionForThisProgect transformUtilDateStringToSqlDateString:userReviewTime];
      // 评论内容
      NSString *userReview = [jsonObjectForReview safeStringObjectForKey:k_RoomReview_RespondKey_userReview withDefaultValue:defaultValueForString];
      // 房东回复评论的时间
      NSString *hostReviewTime = [jsonObjectForReview safeStringObjectForKey:k_RoomReview_RespondKey_hostReviewTime withDefaultValue:defaultValueForString];
      hostReviewTime = [ToolsFunctionForThisProgect transformUtilDateStringToSqlDateString:hostReviewTime];
      // 房东回复的内容
      NSString *hostReview = [jsonObjectForReview safeStringObjectForKey:k_RoomReview_RespondKey_hostReview withDefaultValue:defaultValueForString];
      
      RoomReview *roomReview = [RoomReview roomReviewWithUserName:userName
                                                   userReviewTime:userReviewTime
                                                       userReview:userReview
                                                   hostReviewTime:hostReviewTime
                                                       hostReview:hostReview];
      [roomReviewList addObject:roomReview];
    }
    
    return [RoomReviewNetRespondBean roomReviewNetRespondBeanWithReviewCount:reviewCount
                                                                    avgScore:avgScore
                                                               reviewItemMap:reviewItemMap
                                                              roomReviewList:roomReviewList];
  } while (NO);
  
  return nil;
}

@end