//
//  RoomSearchParseNetRespondStringDomainBean.m
//  airizu
//
//  Created by 唐志华 on 12-12-28.
//
//

#import "RoomSearchParseNetRespondStringDomainBean.h"

#import "RoomSearchDatabaseFieldsConstant.h"
#import "RoomSearchNetRespondBean.h"
#import "RoomInfo.h"

#import "JSONKit.h"
#import "NSString+Expand.h"
#import "NSDictionary+SafeValue.h"

static const NSString *const TAG = @"<RoomSearchParseNetRespondStringDomainBean>";

@implementation RoomSearchParseNetRespondStringDomainBean
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
    NSArray *jsonArrayForRoomInfoList = [jsonRootNSDictionary safeArrayObjectForKey:kRoomSearch_RespondKey_data];
    // 房源总数量
    NSNumber *roomCount = [jsonRootNSDictionary safeNumberObjectForKey:kRoomSearch_RespondKey_roomCount];
    if (roomCount == nil) {
      isLostImportantData = YES;
      PRPLog(@"%@-> 关键字段丢失 : roomCount", TAG);
      break;
    }
    
    NSMutableArray *roomInfoList = [NSMutableArray array];
    NSString *defaultValueForString = @"";
    NSNumber *defaultValueForNumber = [NSNumber numberWithBool:NO];
    for (NSDictionary *roomInfoNSDictionary in jsonArrayForRoomInfoList) {
      if (![roomInfoNSDictionary isKindOfClass:[NSDictionary class]]) {
        isLostImportantData = YES;
        PRPLog(@"%@-> 当前 roomInfoNSDictionary对象类型不是 NSDictionary", TAG);
        break;
      }
      
      // 房间编号
      NSNumber *roomId = [roomInfoNSDictionary safeNumberObjectForKey:kRoomSearch_RespondKey_roomId];
      if (roomId == nil) {
        isLostImportantData = YES;
        PRPLog(@"%@-> 关键字段丢失 : roomId", TAG);
        break;
      }
      // 房间标题
      NSString *roomTitle = [roomInfoNSDictionary safeStringObjectForKey:kRoomSearch_RespondKey_roomTitle withDefaultValue:defaultValueForString];
      // 租住方式Id
      NSString *rentalWay = [roomInfoNSDictionary safeStringObjectForKey:kRoomSearch_RespondKey_rentalWay withDefaultValue:defaultValueForString];
      // 租住方式名称
      NSString *rentalWayName = [roomInfoNSDictionary safeStringObjectForKey:kRoomSearch_RespondKey_rentalWayName withDefaultValue:defaultValueForString];
      // 可住人数
      NSNumber *occupancyCount = [roomInfoNSDictionary safeNumberObjectForKey:kRoomSearch_RespondKey_occupancyCount withDefaultValue:defaultValueForNumber];
      // 评论总数
      NSNumber *reviewCount = [roomInfoNSDictionary safeNumberObjectForKey:kRoomSearch_RespondKey_reviewCount withDefaultValue:defaultValueForNumber];
      // 已预定晚数
      NSNumber *scheduled = [roomInfoNSDictionary safeNumberObjectForKey:kRoomSearch_RespondKey_scheduled withDefaultValue:defaultValueForNumber];
      // 价格
      NSNumber *price = [roomInfoNSDictionary safeNumberObjectForKey:kRoomSearch_RespondKey_price withDefaultValue:defaultValueForNumber];
      // 房间图片URL
      NSString *image = [roomInfoNSDictionary safeStringObjectForKey:kRoomSearch_RespondKey_image withDefaultValue:defaultValueForString];
      // 是否是验证的房间
      NSNumber *verify = [roomInfoNSDictionary safeNumberObjectForKey:kRoomSearch_RespondKey_verify withDefaultValue:defaultValueForNumber];
      // 百度经度
      NSNumber *len = [roomInfoNSDictionary safeNumberObjectForKey:kRoomSearch_RespondKey_len withDefaultValue:defaultValueForNumber];
      // 百度纬度
      NSNumber *lat = [roomInfoNSDictionary safeNumberObjectForKey:kRoomSearch_RespondKey_lat withDefaultValue:defaultValueForNumber];
      // 距离
      NSNumber *distance = [roomInfoNSDictionary safeNumberObjectForKey:kRoomSearch_RespondKey_distance withDefaultValue:defaultValueForNumber];
      
      RoomInfo *roomInfo = [RoomInfo roomInfoWithRoomId:roomId
                                              roomTitle:roomTitle
                                              rentalWay:rentalWay
                                          rentalWayName:rentalWayName
                                         occupancyCount:occupancyCount
                                            reviewCount:reviewCount
                                              scheduled:scheduled
                                                  price:price
                                                  image:image
                                                 verify:verify
                                                    len:len
                                                    lat:lat
                                               distance:distance];
      [roomInfoList addObject:roomInfo];
    }
    
    // 出现数据不完整, 因为这种分页的数据, 控制层会以实际返回的数据条数 和 接口返回的总数据条数最比对, 所以如果关键数据丢失, 就认为此次数据都无效
    if (isLostImportantData) {
      break;
    }
    
    return [RoomSearchNetRespondBean roomSearchNetRespondBeanWithRoomInfoList:roomInfoList
                                                                withRoomCount:roomCount];
  } while (NO);
  
  return nil;
}

@end