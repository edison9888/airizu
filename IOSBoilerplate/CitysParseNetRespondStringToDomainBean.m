//
//  CitysParseNetRespondStringToDomainBean.m
//  airizu
//
//  Created by 唐志华 on 13-1-1.
//
//

#import "CitysParseNetRespondStringToDomainBean.h"

#import "CitysDatabaseFieldsConstant.h"
#import "CitysNetRespondBean.h"
#import "CityInfo.h"

#import "JSONKit.h"
#import "NSString+Expand.h"
#import "NSDictionary+SafeValue.h"

static const NSString *const TAG = @"<CitysParseNetRespondStringToDomainBean>";

@implementation CitysParseNetRespondStringToDomainBean
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
    
    NSMutableArray *cityInfoList = [NSMutableArray array];
    
    // 关键数据字段检测
    NSArray *jsonArrayForCityInfoList = [jsonRootNSDictionary safeArrayObjectForKey:k_CityInfo_RespondKey_citys];
    
    for (NSDictionary *jsonObjectForCityInfo in jsonArrayForCityInfoList) {
      
      NSNumber *ID = [jsonObjectForCityInfo safeNumberObjectForKey:k_CityInfo_RespondKey_id];
      if (ID == nil) {
        continue;
      }
      NSString *name = [jsonObjectForCityInfo safeStringObjectForKey:k_CityInfo_RespondKey_name];
      if (name == nil) {
        continue;
      }
      // 城市中文名称的拼音
      NSString *code = [jsonObjectForCityInfo safeStringObjectForKey:k_CityInfo_RespondKey_code];
      if (code == nil) {
        continue;
      }
      NSNumber *provinceId = [jsonObjectForCityInfo safeNumberObjectForKey:k_CityInfo_RespondKey_provinceId];
      
      CityInfo *cityInfo = [CityInfo cityInfoWithID:ID
                                               name:name
                                               code:code
                                         provinceId:provinceId];
      [cityInfoList addObject:cityInfo];
    }
    
    NSArray *jsonArrayForTopCitys = [jsonRootNSDictionary safeArrayObjectForKey:k_CityInfo_RespondKey_topCitys];
    NSMutableArray *topCitys = [NSMutableArray array];
    
    for (int i=0; i<jsonArrayForTopCitys.count; i++) {
      NSDictionary *item = [jsonArrayForTopCitys objectAtIndex:i];
      if (![item isKindOfClass:[NSDictionary class]]) {
        continue;
      }
      if (item.count <= 0) {
        continue;
      }
      NSString *cityName = [[item allValues] objectAtIndex:0];
      id cityId = [[item allKeys] objectAtIndex:0];
      NSNumber *cityIdNumber = nil;
      if ([cityId isKindOfClass:[NSNumber class]]) {
        cityIdNumber = cityId;
      } else {
        cityIdNumber = [NSNumber numberWithInt:[cityId intValue]];
      }
      CityInfo *cityInfo = [CityInfo cityInfoWithID:cityIdNumber
                                               name:cityName
                                               code:nil
                                         provinceId:nil];
      [topCitys addObject:cityInfo];
    }
   
    return [CitysNetRespondBean citysNetRespondBeanWithCityInfoList:cityInfoList topCitys:topCitys];
  } while (NO);
  
  return nil;
}

@end