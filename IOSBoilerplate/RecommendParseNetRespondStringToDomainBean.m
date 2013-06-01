//
//  RecommendParseNetRespondStringToDomainBean.m
//  airizu
//
//  Created by 唐志华 on 12-12-25.
//
//

#import "RecommendParseNetRespondStringToDomainBean.h"

#import "RecommendCity.h"
#import "RecommendCityDatabaseFieldsConstant.h"
#import "RecommendNetRespondBean.h"

#import "JSONKit.h"
#import "NSString+Expand.h"
#import "NSDictionary+SafeValue.h"

static const NSString *const TAG = @"<RecommendParseNetRespondStringToDomainBean>";

@implementation RecommendParseNetRespondStringToDomainBean
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
    BOOL isLostImportantData = NO;
    NSArray *jsonArrayForRecommendCityList = [jsonRootNSDictionary safeArrayObjectForKey:kRecommendCity_RespondKey_data];
    
    NSMutableArray *recommendCityList = [NSMutableArray array];
    NSString *defaultValueForString = @"";
    NSNumber *defaultValueForNumber = [NSNumber numberWithBool:NO];
    for (NSDictionary *recommendCityNSDictionary in jsonArrayForRecommendCityList) {
      
      if (![recommendCityNSDictionary isKindOfClass:[NSDictionary class]]) {
        isLostImportantData = YES;
        PRPLog(@"%@-> 当前 recommendCityNSDictionary对象类型不是 NSDictionary", TAG);
        break;
      }
      
      // 编号
      NSNumber *ID = [recommendCityNSDictionary safeNumberObjectForKey:kRecommendCity_RespondKey_id];
      if (ID == nil) {
        isLostImportantData = YES;
        PRPLog(@"%@-> 关键字段丢失 : id", TAG);
        break;
      }
      // 城市名称
      NSString *cityName = [recommendCityNSDictionary safeStringObjectForKey:kRecommendCity_RespondKey_cityName];
      if ([NSString isEmpty:cityName]) {
        isLostImportantData = YES;
        PRPLog(@"%@-> 关键字段丢失 : cityName", TAG);
        break;
      }
      // 城市id
      NSNumber *cityId = [recommendCityNSDictionary safeNumberObjectForKey:kRecommendCity_RespondKey_cityId];
      if (cityId == nil) {
        isLostImportantData = YES;
        PRPLog(@"%@-> 关键字段丢失 : cityId", TAG);
        break;
      }
      
      // 排序 (目前还未用到排序字段, 是按照网络数据返回的排列顺序)
      NSNumber *sort
      = [recommendCityNSDictionary safeNumberObjectForKey:kRecommendCity_RespondKey_sort
                                         withDefaultValue:defaultValueForNumber];
      
      // 对应图片地址
      NSString *image
      = [recommendCityNSDictionary safeStringObjectForKey:kRecommendCity_RespondKey_image
                                         withDefaultValue:defaultValueForString];
      // 地标1 名称
      NSString *street1Name
      = [recommendCityNSDictionary safeStringObjectForKey:kRecommendCity_RespondKey_street1Name
                                         withDefaultValue:defaultValueForString];
      // 地标1 编号
      NSNumber *street1Id
      = [recommendCityNSDictionary safeNumberObjectForKey:kRecommendCity_RespondKey_street1Id
                                         withDefaultValue:defaultValueForNumber];
      // 地标2名称
      NSString *street2Name
      = [recommendCityNSDictionary safeStringObjectForKey:kRecommendCity_RespondKey_street2Name
                                         withDefaultValue:defaultValueForString];
      // 地标2编号
      NSNumber *street2Id
      = [recommendCityNSDictionary safeNumberObjectForKey:kRecommendCity_RespondKey_street2Id
                                         withDefaultValue:defaultValueForNumber];
      
      /// 20130312 add
      NSString *street1SimName
      = [recommendCityNSDictionary safeStringObjectForKey:kRecommendCity_RespondKey_street1SimName
                                         withDefaultValue:defaultValueForString];
      NSString *street2SimName
      = [recommendCityNSDictionary safeStringObjectForKey:kRecommendCity_RespondKey_street2SimName
                                         withDefaultValue:defaultValueForString];
      
      RecommendCity *recommendCity
      = [RecommendCity recommendCityWithID:ID
                                  cityName:cityName
                                    cityId:cityId
                                     image:image
                                      sort:sort
                               street1Name:street1Name
                                 street1Id:street1Id
                               street2Name:street2Name
                                 street2Id:street2Id
                            street1SimName:street1SimName
                            street2SimName:street2SimName];
      [recommendCityList addObject:recommendCity];
      
      
    }
    
    // 出现数据不完整, 因为这种分页的数据, 控制层会以实际返回的数据条数 和 接口返回的总数据条数最比对, 所以如果关键数据丢失, 就认为此次数据都无效
    if (isLostImportantData) {
      break;
    }
    
    return [RecommendNetRespondBean recommendNetRespondBeanWithRecommendCityList:recommendCityList];
  } while (NO);
  
  return nil;
}

@end


