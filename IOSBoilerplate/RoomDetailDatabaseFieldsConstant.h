//
//  RoomDetailDatabaseFieldsConstant.h
//  airizu
//
//  Created by 唐志华 on 12-12-28.
//
//

#ifndef airizu_RoomDetailDatabaseFieldsConstant_h
#define airizu_RoomDetailDatabaseFieldsConstant_h

/************      RequestBean       *************/

#define k_RoomDetail_RequestKey_roomId               @"roomId"

/************      RespondBean       *************/

// 房间编号
#define k_RoomDetail_RespondKey_number               @"number"

// 用户编号
#define k_RoomDetail_RespondKey_userId               @"userId"
// 建筑面积
#define k_RoomDetail_RespondKey_size                 @"size"
// 房间默认图片
#define k_RoomDetail_RespondKey_image                @"image"
// 每晚价钱
#define k_RoomDetail_RespondKey_price                @"price"
// 房间标题
#define k_RoomDetail_RespondKey_title                @"title"
// 房间地址
#define k_RoomDetail_RespondKey_address              @"address"
// 百度经度
#define k_RoomDetail_RespondKey_len                  @"len"
// 百度纬度
#define k_RoomDetail_RespondKey_lat                  @"lat"

// 曾被预订
#define k_RoomDetail_RespondKey_scheduled            @"scheduled"
// 卧室数量
#define k_RoomDetail_RespondKey_bedRoom              @"bedRoom"
// 规则内容
#define k_RoomDetail_RespondKey_ruleContent          @"ruleContent"
// 清洁服务类型
#define k_RoomDetail_RespondKey_clean                @"clean"
// 房间概括
#define k_RoomDetail_RespondKey_roomDescription      @"description"
// 可住人数
#define k_RoomDetail_RespondKey_accommodates         @"accommodates"
// 使用规则
#define k_RoomDetail_RespondKey_roomRule             @"roomRule"
// 卫浴类型
#define k_RoomDetail_RespondKey_restRoom             @"restRoom"
// 提供发票 (1 : 提供, 2 : 不提供)
#define k_RoomDetail_RespondKey_tickets              @"tickets"
// 退订条款
#define k_RoomDetail_RespondKey_cancellation         @"cancellation"
// 最少天数
#define k_RoomDetail_RespondKey_minNights            @"minNights"
// 租住方式
#define k_RoomDetail_RespondKey_privacy              @"privacy"
// 退房时间
#define k_RoomDetail_RespondKey_checkOutTime         @"checkOutTime"
// 最多天数
#define k_RoomDetail_RespondKey_maxNights            @"maxNights"
// 房间床数
#define k_RoomDetail_RespondKey_beds                 @"beds"
// 房屋类型
#define k_RoomDetail_RespondKey_propertyType         @"propertyType"
// 房间床型
#define k_RoomDetail_RespondKey_bedType              @"bedType"
// 卫生间数
#define k_RoomDetail_RespondKey_bathRoomNum          @"bathRoomNum"
// 租客点评总分
#define k_RoomDetail_RespondKey_review               @"review"
// 租客点评总条数
#define k_RoomDetail_RespondKey_reviewCount          @"reviewCount"
// 租客点评列表，这里只显示1条记录
#define k_RoomDetail_RespondKey_reviewContent        @"reviewContent"

// 是否是 "100%验证房间"
#define k_RoomDetail_RespondKey_isVerify             @"isVerify"
#define k_RoomDetail_RespondKey_verifyDescription    @"verifyContent"

// 是否是 "特价房"
#define k_RoomDetail_RespondKey_isSpecial            @"isSpecial"
#define k_RoomDetail_RespondKey_specialDescription   @"specials"

// 是否是 "速定房"
#define k_RoomDetail_RespondKey_isSpeed              @"speed"
#define k_RoomDetail_RespondKey_speedDescription     @"speedContent"

// 是否是 "精品房"
#define k_RoomDetail_RespondKey_isBoutique           @"isBoutique"
// 房间类型(0 : 普通房间, 1 : 精品房间)
#define k_RoomDetail_RespondKey_roomType             @"roomType"
// 精品房间描述
#define k_RoomDetail_RespondKey_boutiqueDescription  @"boutiqueDescription"

// 介绍字符串
#define k_RoomDetail_RespondKey_introduction         @"introduction"

// 大图地址列表
#define k_RoomDetail_RespondKey_imageM               @"imageM"
// 缩略图地址列表
#define k_RoomDetail_RespondKey_imageS               @"imageS"
// 配套设施列表
#define k_RoomDetail_RespondKey_equipmentList        @"equipmentList"

// 房间套数
#define k_RoomDetail_RespondKey_roomNumber           @"roomNumber"

#endif

  