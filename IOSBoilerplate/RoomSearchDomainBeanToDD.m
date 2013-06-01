//
//  RoomSearchDomainBeanToDD.m
//  airizu
//
//  Created by 唐志华 on 12-12-28.
//
//

#import "RoomSearchDomainBeanToDD.h"
#import "RoomSearchNetRequestBean.h"
#import "RoomSearchDatabaseFieldsConstant.h"
#import "NSString+Expand.h"

static const NSString *const TAG = @"<RoomSearchDomainBeanToDD>";

@implementation RoomSearchDomainBeanToDD

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

- (NSDictionary *) parseDomainBeanToDataDictionary:(in id) netRequestDomainBean {
  NSAssert(netRequestDomainBean != nil, @"入参为空 !");
  
  do {
    if (! [netRequestDomainBean isMemberOfClass:[RoomSearchNetRequestBean class]]) {
      NSAssert(NO, @"传入的业务Bean的类型不符 !");
      break;
    }
    
    const RoomSearchNetRequestBean *roomSearchNetRequestBean = netRequestDomainBean;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
		
		NSString *value = nil;
		
    // 城市id
		value = roomSearchNetRequestBean.cityId;
		if (![NSString isEmpty:value]) {
      [params setObject:value forKey:kRoomSearch_RequestKey_cityId];
		}
    
    // 城市名称
		value = roomSearchNetRequestBean.cityName;
		if (![NSString isEmpty:value]) {
			[params setObject:value forKey:kRoomSearch_RequestKey_cityName];
		}
    
    // 地标名
		value = roomSearchNetRequestBean.streetName;
		if (![NSString isEmpty:value]) {
			[params setObject:value forKey:kRoomSearch_RequestKey_streetName];
		}
    
    // 入住时间
		value = roomSearchNetRequestBean.checkinDate;
		if (![NSString isEmpty:value]) {
			[params setObject:value forKey:kRoomSearch_RequestKey_checkinDate];
		}
    
    // 退房时间
		value = roomSearchNetRequestBean.checkoutDate;
		if (![NSString isEmpty:value]) {
			[params setObject:value forKey:kRoomSearch_RequestKey_checkoutDate];
		}
    
    // 入住人数
		value = roomSearchNetRequestBean.occupancyCount;
		if (![NSString isEmpty:value]) {
			[params setObject:value forKey:kRoomSearch_RequestKey_occupancyCount];
		}
    
    // 房间编号
		value = roomSearchNetRequestBean.roomNumber;
		if (![NSString isEmpty:value]) {
			[params setObject:value forKey:kRoomSearch_RequestKey_roomNumber];
		}
    
    // 查询从哪行开始
		value = roomSearchNetRequestBean.offset;
		if (![NSString isEmpty:value]) {
			[params setObject:value forKey:kRoomSearch_RequestKey_offset];
		}
    
    // 查询的数据条数
		value = roomSearchNetRequestBean.max;
		if (![NSString isEmpty:value]) {
			[params setObject:value forKey:kRoomSearch_RequestKey_max];
		}
    
    // 价格区间
		value = roomSearchNetRequestBean.priceDifference;
		if (![NSString isEmpty:value]) {
			[params setObject:value forKey:kRoomSearch_RequestKey_priceDifference];
		}
    
    // 区名称
		value = roomSearchNetRequestBean.districtName;
		if (![NSString isEmpty:value]) {
			[params setObject:value forKey:kRoomSearch_RequestKey_districtName];
		}
    
    // 区ID
		value = roomSearchNetRequestBean.districtId;
		if (![NSString isEmpty:value]) {
			[params setObject:value forKey:kRoomSearch_RequestKey_districtId];
		}
    
    // 房屋类型
		value = roomSearchNetRequestBean.roomType;
		if (![NSString isEmpty:value]) {
			[params setObject:value forKey:kRoomSearch_RequestKey_roomType];
		}
    
    // 排序方式
		value = roomSearchNetRequestBean.order;
		if (![NSString isEmpty:value]) {
			[params setObject:value forKey:kRoomSearch_RequestKey_order];
		}
    
    // 出租方式
		value = roomSearchNetRequestBean.rentType;
		if (![NSString isEmpty:value]) {
			[params setObject:value forKey:kRoomSearch_RequestKey_rentType];
		}
    
    // 设施设备
		value = roomSearchNetRequestBean.tamenities;
		if (![NSString isEmpty:value]) {
			[params setObject:value forKey:kRoomSearch_RequestKey_tamenities];
		}
    
    // 距离筛选
		value = roomSearchNetRequestBean.distance;
		if (![NSString isEmpty:value]) {
			[params setObject:value forKey:kRoomSearch_RequestKey_distance];
		}
    
    // 纬度
		value = roomSearchNetRequestBean.locationLat;
		if (![NSString isEmpty:value]) {
			[params setObject:value forKey:kRoomSearch_RequestKey_locationLat];
		}
    
    // 经度
		value = roomSearchNetRequestBean.locationLng;
		if (![NSString isEmpty:value]) {
			[params setObject:value forKey:kRoomSearch_RequestKey_locationLng];
		}
    
    // 是否是查询用户 "附近" 的房源
		value = roomSearchNetRequestBean.nearby;
		if (![NSString isEmpty:value]) {
			[params setObject:value forKey:kRoomSearch_RequestKey_nearby];
		}
    
    return params;
  } while (NO);
  
  return nil;
}
@end