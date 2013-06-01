//
//  RoomSearchNetRequestBean.m
//  airizu
//
//  Created by 唐志华 on 12-12-28.
//
//

#import "RoomSearchNetRequestBean.h"


static const NSString *const TAG = @"<RoomSearchNetRequestBean>";

@implementation RoomSearchNetRequestBean

- (void) dealloc {
	PRPLog(@"dealloc: %@ [0x%x]", TAG, [self hash]);
  
  // 二者必须有其一
	[_cityId release];// 城市id
  [_cityName release];// 城市名称
  
  [_streetName release];// 地标名
  [_checkinDate release];// 入住时间
  [_checkoutDate release];// 退房时间
  [_occupancyCount release];// 入住人数
  [_roomNumber release];// 房间编号
  [_offset release];// 查询从哪行开始
  [_max release];// 查询的数据条数
  [_priceDifference release];// 价格区间
  [_districtName release];// 区名称
  [_districtId release];// 区ID
  [_roomType release];// 房屋类型
  [_order release];// 排序方式
  [_rentType release];// 出租方式
  [_tamenities release];// 设施设备
  [_distance release];// 距离筛选
  [_locationLat release];// 纬度
  [_locationLng release];// 经度
  [_nearby release];// 是否是查询 "附近" 的房源(是就 传数字1)
  
	
	[super dealloc];
}

- (id) init {
  
  if ((self = [super init])) {
		PRPLog(@"init %@ [0x%x]", TAG, [self hash]);

  }
  
  return self;
}

- (NSString *)description {
	return descriptionForDebug(self);
}

#pragma mark -
#pragma mark 方便构造
+(id)roomSearchNetRequestBean {
  RoomSearchNetRequestBean *roomSearchNetRequestBean = [[RoomSearchNetRequestBean alloc] init];
  return [roomSearchNetRequestBean autorelease];
}
@end