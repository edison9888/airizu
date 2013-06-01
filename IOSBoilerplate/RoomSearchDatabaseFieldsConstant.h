//
//  RoomSearchDatabaseFieldsConstant.h
//  airizu
//
//  Created by 唐志华 on 12-12-28.
//
//

#ifndef airizu_RoomSearchDatabaseFieldsConstant_h
#define airizu_RoomSearchDatabaseFieldsConstant_h

/************      RequestBean       *************/

// 城市id
#define kRoomSearch_RequestKey_cityId                 @"cityId"
// 城市名称
#define kRoomSearch_RequestKey_cityName               @"cityName"
// 地标名 (从 2.4 房间推荐 接口 可以获取, 另外可以从搜索界面中获取用户手动输入)
#define kRoomSearch_RequestKey_streetName             @"streetName"
// 入住时间(2012-01-01)
#define kRoomSearch_RequestKey_checkinDate            @"checkinDate"
// 退房时间(2012-01-02)
#define kRoomSearch_RequestKey_checkoutDate           @"checkoutDate"
// 入住人数(1~10, 10人以上传10)
#define kRoomSearch_RequestKey_occupancyCount         @"occupancyCount"
// 房间编号
#define kRoomSearch_RequestKey_roomNumber             @"roomNumber"
// 查询从哪行开始
#define kRoomSearch_RequestKey_offset                 @"offset"
// 查询的数据条数
#define kRoomSearch_RequestKey_max                    @"max"
// 价格区间 (0-100, 100-200, 200-300, 300 :300以上传300)
#define kRoomSearch_RequestKey_priceDifference        @"priceDifference"
// 区名称
#define kRoomSearch_RequestKey_districtName           @"districtName"
// 区ID
#define kRoomSearch_RequestKey_districtId             @"districtId"
// 房屋类型(可在 2.8 初始化字典 接口获取)
#define kRoomSearch_RequestKey_roomType               @"roomType"
// 排序方式(爱日租推荐 "tja", 价格从高到低"jgd", 价格从低到高"jga", 评论从高到低"pjd", 距离由近到远"jla")
#define kRoomSearch_RequestKey_order                  @"order"
// 出租方式(可在 2.8 初始化字典接口获取)
#define kRoomSearch_RequestKey_rentType               @"rentType"
// 设施设备(可在 2.8 初始化字典接口获取)
#define kRoomSearch_RequestKey_tamenities             @"tamenities"
// 距离筛选( 500 , 1000,3000)
#define kRoomSearch_RequestKey_distance               @"distance"
// 纬度
#define kRoomSearch_RequestKey_locationLat            @"locationLat"
// 经度
#define kRoomSearch_RequestKey_locationLng            @"locationLng"
// 是否是查询用户 "附近" 的房源(是就 传数字1)
#define kRoomSearch_RequestKey_nearby                 @"nearby"






/************      RespondBean       *************/

//
#define kRoomSearch_RespondKey_data                   @"data"
// 搜索房间总数
#define kRoomSearch_RespondKey_roomCount              @"roomCount"

//
// 房间编号
#define kRoomSearch_RespondKey_roomId                 @"roomId"
// 房间标题
#define kRoomSearch_RespondKey_roomTitle              @"roomTitle"
// 租住方式Id
#define kRoomSearch_RespondKey_rentalWay              @"rentalWay"
// 租住方式名称
#define kRoomSearch_RespondKey_rentalWayName          @"rentalWayName"
// 可住人数
#define kRoomSearch_RespondKey_occupancyCount         @"occupancyCount"
// 评论总数
#define kRoomSearch_RespondKey_reviewCount            @"reviewCount"
// 已预定晚数
#define kRoomSearch_RespondKey_scheduled              @"scheduled"
// 价格
#define kRoomSearch_RespondKey_price                  @"price"
// 房间图片url
#define kRoomSearch_RespondKey_image                  @"image"
// 是否是验证的房间
#define kRoomSearch_RespondKey_verify                 @"verify"
// 百度经度
#define kRoomSearch_RespondKey_len                    @"len"
// 百度纬度
#define kRoomSearch_RespondKey_lat                    @"lat"
// 距离
#define kRoomSearch_RespondKey_distance               @"distance"

#endif
