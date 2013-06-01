//
//  DistrictsParseNetRespondStringToDomainBean.m
//  airizu
//
//  Created by 唐志华 on 13-1-1.
//
//

#import "DistrictsParseNetRespondStringToDomainBean.h"

#import "DistrictsDatabaseFieldsConstant.h"
#import "DistrictsNetRespondBean.h"
#import "DistrictInfo.h"

#import "JSONKit.h"
#import "NSString+Expand.h"
#import "NSDictionary+SafeValue.h"

static const NSString *const TAG = @"<DistrictsParseNetRespondStringToDomainBean>";

@implementation DistrictsParseNetRespondStringToDomainBean
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
    
    NSMutableArray *districtInfoList = [NSMutableArray array];
    
    // 关键数据字段检测
    NSString *defaultValueForString = @"";
    NSNumber *defaultValueForNumber = [NSNumber numberWithBool:NO];
    
    NSArray *jsonArrayForDistrictInfoList = [jsonRootNSDictionary safeArrayObjectForKey:k_DistrictInfo_RespondKey_districts];
    
    for (NSDictionary *jsonObjectForDistrictInfo in jsonArrayForDistrictInfoList) {
      NSNumber *ID = [jsonObjectForDistrictInfo safeNumberObjectForKey:k_DistrictInfo_RespondKey_id withDefaultValue:defaultValueForNumber];
      NSNumber *cityId = [jsonObjectForDistrictInfo safeNumberObjectForKey:k_DistrictInfo_RespondKey_cityId withDefaultValue:defaultValueForNumber];
      NSString *name = [jsonObjectForDistrictInfo safeStringObjectForKey:k_DistrictInfo_RespondKey_name withDefaultValue:defaultValueForString];
      NSString *code = [jsonObjectForDistrictInfo safeStringObjectForKey:k_DistrictInfo_RespondKey_code withDefaultValue:defaultValueForString];
      
      NSString *hot = [jsonObjectForDistrictInfo safeStringObjectForKey:k_DistrictInfo_RespondKey_hot withDefaultValue:defaultValueForString];
      NSNumber *sort = [jsonObjectForDistrictInfo safeNumberObjectForKey:k_DistrictInfo_RespondKey_sort withDefaultValue:defaultValueForNumber];
      
      NSNumber *minLng = [jsonObjectForDistrictInfo safeNumberObjectForKey:k_DistrictInfo_RespondKey_minLng withDefaultValue:defaultValueForNumber];
      NSNumber *maxLng = [jsonObjectForDistrictInfo safeNumberObjectForKey:k_DistrictInfo_RespondKey_maxLng withDefaultValue:defaultValueForNumber];
      NSNumber *minLat = [jsonObjectForDistrictInfo safeNumberObjectForKey:k_DistrictInfo_RespondKey_minLat withDefaultValue:defaultValueForNumber];
      NSNumber *maxLat = [jsonObjectForDistrictInfo safeNumberObjectForKey:k_DistrictInfo_RespondKey_maxLat withDefaultValue:defaultValueForNumber];
      
      NSNumber *locationLat = [jsonObjectForDistrictInfo safeNumberObjectForKey:k_DistrictInfo_RespondKey_locationLat withDefaultValue:defaultValueForNumber];
      NSNumber *locationLng = [jsonObjectForDistrictInfo safeNumberObjectForKey:k_DistrictInfo_RespondKey_locationLng withDefaultValue:defaultValueForNumber];
      NSNumber *locationLatBaidu = [jsonObjectForDistrictInfo safeNumberObjectForKey:k_DistrictInfo_RespondKey_locationLatBaidu withDefaultValue:defaultValueForNumber];
      NSNumber *locationLngBaidu = [jsonObjectForDistrictInfo safeNumberObjectForKey:k_DistrictInfo_RespondKey_locationLngBaidu withDefaultValue:defaultValueForNumber];
      
      NSNumber *minLngBaidu = [jsonObjectForDistrictInfo safeNumberObjectForKey:k_DistrictInfo_RespondKey_minLngBaidu withDefaultValue:defaultValueForNumber];
      NSNumber *minLatBaidu = [jsonObjectForDistrictInfo safeNumberObjectForKey:k_DistrictInfo_RespondKey_minLatBaidu withDefaultValue:defaultValueForNumber];
      NSNumber *maxLatBaidu = [jsonObjectForDistrictInfo safeNumberObjectForKey:k_DistrictInfo_RespondKey_maxLatBaidu withDefaultValue:defaultValueForNumber];
      NSNumber *maxLngBaidu = [jsonObjectForDistrictInfo safeNumberObjectForKey:k_DistrictInfo_RespondKey_maxLngBaidu withDefaultValue:defaultValueForNumber];
      
      DistrictInfo *districtInfo = [DistrictInfo districtInfoWithID:ID
                                                             cityId:cityId
                                                               name:name
                                                               code:code
                                    
                                                                hot:hot
                                                               sort:sort
                                    
                                                             minLng:minLng
                                                             maxLng:maxLng
                                                             minLat:minLat
                                                             maxLat:maxLat
                                    
                                                        locationLat:locationLat
                                                        locationLng:locationLng
                                                   locationLatBaidu:locationLatBaidu
                                                   locationLngBaidu:locationLngBaidu
                                    
                                                        minLngBaidu:minLngBaidu
                                                        minLatBaidu:minLatBaidu
                                                        maxLatBaidu:maxLatBaidu
                                                        maxLngBaidu:maxLngBaidu];
      
      [districtInfoList addObject:districtInfo];
      
    }
    
    return [DistrictsNetRespondBean districtsNetRespondBeanWithDistrictInfoList:districtInfoList];
  } while (NO);
  
  return nil;
}

@end