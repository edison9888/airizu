//
//  OrderDetailDatabaseFieldsConstant.h
//  airizu
//
//  Created by 唐志华 on 12-12-28.
//
//

#ifndef airizu_OrderDetailDatabaseFieldsConstant_h
#define airizu_OrderDetailDatabaseFieldsConstant_h

/************      RequestBean       *************/

#define k_OrderDetail_RequestKey_orderId          @"orderId"

/************      RespondBean       *************/



// 订单编号
#define k_OrderDetail_RespondKey_orderId          @"orderId"
// 订单状态
#define k_OrderDetail_RespondKey_orderState       @"orderState"
// 消息
#define k_OrderDetail_RespondKey_message          @"message"
// 开始时间
#define k_OrderDetail_RespondKey_chenckInDate     @"chenckInDate"
// 结束时间
#define k_OrderDetail_RespondKey_chenckOutDate    @"chenckOutDate"
// 入住人数
#define k_OrderDetail_RespondKey_guestNum         @"guestNum"
// 预付定金
#define k_OrderDetail_RespondKey_pricePerNight    @"pricePerNight"
// 线下支付
#define k_OrderDetail_RespondKey_linePay          @"linePay"
// 订单总额
#define k_OrderDetail_RespondKey_subPrice         @"subPrice"
// 订单类型
#define k_OrderDetail_RespondKey_orderType        @"orderType"
// 订单状态内容
#define k_OrderDetail_RespondKey_statusContent    @"statusContent"

// 房间详情相关接口
// 房间编号
#define k_OrderDetail_RespondKey_number           @"number"
// 房间图片
#define k_OrderDetail_RespondKey_image            @"image"
// 房间标题
#define k_OrderDetail_RespondKey_title            @"title"
// 房间地址
#define k_OrderDetail_RespondKey_address          @"address"

// 房东信息相关
// 是否显示房东信息boolean（true：显示，false：不显示）
#define k_OrderDetail_RespondKey_ifShowHost       @"ifShowHost"
// 房东姓名
#define k_OrderDetail_RespondKey_hostName         @"hostName"
// 房东电话
#define k_OrderDetail_RespondKey_hostPhone        @"hostPhone"
// 房东备用电话
#define k_OrderDetail_RespondKey_hostBackupPhone  @"hostBackupPhone"

// 订单状态与客户端互相转换的状态订单状态
// 1待确定
// 2待支付
// 3待入住
// 4待评价
// 5已完成
#define k_OrderDetail_RespondKey_conversionState  @"conversionState"

#endif
