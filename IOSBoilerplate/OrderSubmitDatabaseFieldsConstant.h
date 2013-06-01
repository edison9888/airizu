//
//  OrderSubmitDatabaseFieldsConstant.h
//  airizu
//
//  Created by 唐志华 on 12-12-28.
//
//

#ifndef airizu_OrderSubmitDatabaseFieldsConstant_h
#define airizu_OrderSubmitDatabaseFieldsConstant_h

/************      RequestBean       *************/

// 必选参数
// 房间id
#define k_OrderSubmit_RequestKey_roomId              @"roomId"
// 入住日期
#define k_OrderSubmit_RequestKey_checkInDate         @"checkInDate"
// 退房日期
#define k_OrderSubmit_RequestKey_checkOutDate        @"checkOutDate"
// 入住人数
#define k_OrderSubmit_RequestKey_guestNum            @"guestNum"
// 优惠方式(0：不使用优惠卷；1：vip优惠；2：普通优惠卷；3：现金卷)
#define k_OrderSubmit_RequestKey_voucherMethod       @"voucherMethod"
// 租客姓名
#define k_OrderSubmit_RequestKey_checkinName         @"checkinName"
// 租客电话
#define k_OrderSubmit_RequestKey_checkinPhone        @"checkinPhone"

// 可选参数
// 积分
#define k_OrderSubmit_RequestKey_pointNum            @"pointNum"
// 优惠码
#define k_OrderSubmit_RequestKey_iVoucherCode        @"iVoucherCode"
// 来源关键字
#define k_OrderSubmit_RequestKey_keyword             @"semKeyword"
// 来源
#define k_OrderSubmit_RequestKey_source              @"semSource"




/************      RespondBean       *************/


// 这里使用 OrderDetail 的数据库字段
#import "OrderDetailDatabaseFieldsConstant.h"


#endif
