//
//  DictionaryParseNetRespondStringToDomainBean.m
//  airizu
//
//  Created by 唐志华 on 13-1-1.
//
//

#import "DictionaryParseNetRespondStringToDomainBean.h"

#import "DictionaryDatabaseFieldsConstant.h"
#import "DictionaryNetRespondBean.h"

#import "RoomType.h"
#import "RentManner.h"
#import "Equipment.h"

#import "JSONKit.h"
#import "NSString+Expand.h"
#import "NSDictionary+SafeValue.h"

static const NSString *const TAG = @"<DictionaryParseNetRespondStringToDomainBean>";

@implementation DictionaryParseNetRespondStringToDomainBean
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
    
    // 房间类型
    NSMutableArray *roomTypeList = [NSMutableArray array];
    NSArray *jsonArrayForRoomTypeList = [jsonRootNSDictionary safeArrayObjectForKey:k_RoomDictionary_RespondKey_roomType];
    for (NSDictionary *jsonObjectForOneRoomType in jsonArrayForRoomTypeList) {
      NSString *typeName = [jsonObjectForOneRoomType safeStringObjectForKey:k_RoomDictionary_RespondKey_typeName];
      NSString *typeId = [jsonObjectForOneRoomType safeStringObjectForKey:k_RoomDictionary_RespondKey_typeId];
      
      RoomType *roomType = [RoomType roomTypeWithTypeName:typeName typeId:typeId];
      [roomTypeList addObject:roomType];
    }
    
    // 获取出租方式
    NSMutableArray *rentMannerList = [NSMutableArray array];
    NSArray *jsonArrayForRentMannerList = [jsonRootNSDictionary safeArrayObjectForKey:k_RoomDictionary_RespondKey_rentManner];
    for (NSDictionary *jsonObjectForOneManner in jsonArrayForRentMannerList) {
      NSString *rentalWayName = [jsonObjectForOneManner safeStringObjectForKey:k_RoomDictionary_RespondKey_rentalWayName];
      NSString *rentalWayId = [jsonObjectForOneManner safeStringObjectForKey:k_RoomDictionary_RespondKey_rentalWayId];
      
      RentManner *rentManner = [RentManner rentMannerWithRentalWayName:rentalWayName rentalWayId:rentalWayId];
      [rentMannerList addObject:rentManner];
    }
    
    // 获取设施设备
    NSMutableArray *equipmentList = [NSMutableArray array];
    NSArray *jsonArrayForEquipmentList = [jsonRootNSDictionary safeArrayObjectForKey:k_RoomDictionary_RespondKey_equipment];
    for (NSDictionary *jsonObjectForOneEquipment in jsonArrayForEquipmentList) {
      NSString *equipmentName = [jsonObjectForOneEquipment safeStringObjectForKey:k_RoomDictionary_RespondKey_equipmentName];
      NSString *equipmentId = [jsonObjectForOneEquipment safeStringObjectForKey:k_RoomDictionary_RespondKey_equipmentId];
      
      Equipment *equipment = [Equipment equipmentWithEquipmentName:equipmentName equipmentId:equipmentId];
      [equipmentList addObject:equipment];
    }
    
    return [DictionaryNetRespondBean dictionaryNetRespondBeanWithRoomTypes:roomTypeList rentManners:rentMannerList equipments:equipmentList];
  } while (NO);
  
  return nil;
}

@end