//
//  FreeBookDatabaseFieldsConstant.h
//  airizu
//
//  Created by 唐志华 on 12-12-28.
//
//

#ifndef airizu_FreeBookDatabaseFieldsConstant_h
#define airizu_FreeBookDatabaseFieldsConstant_h

/************      RequestBean       *************/

/// 必选
// 房间id
#define k_OrderFreebook_RequestKey_roomId            @"roomId"
// 入住时间
#define k_OrderFreebook_RequestKey_checkInDate       @"checkInDate"
// 退房时间
#define k_OrderFreebook_RequestKey_checkOutDate      @"checkOutDate"
// 优惠卷类型
// 0：不使用优惠
// 1：vip优惠
// 2：普通优惠卷
// 3：现金卷
#define k_OrderFreebook_RequestKey_voucherMethod     @"voucherMethod"
// 人数
#define k_OrderFreebook_RequestKey_guestNum          @"guestNum"

/// 可选
// 优惠劵码
#define k_OrderFreebook_RequestKey_iVoucherCode      @"iVoucherCode"
// 积分
#define k_OrderFreebook_RequestKey_pointNum          @"pointNum"



/************      RespondBean       *************/

// 订单总额
#define k_OrderFreebook_RespondKey_totalPrice        @"totalPrice"
// 预付订金
#define k_OrderFreebook_RespondKey_advancedDeposit   @"advancedDeposit"
// 线下支付
#define k_OrderFreebook_RespondKey_underLinePaid     @"underLinePaid"
// 用户积分
#define k_OrderFreebook_RespondKey_availablePoint    @"availablePoint"
// 是否优惠（0优惠，1没优惠）
#define k_OrderFreebook_RespondKey_isCheap           @"isCheap"


#endif
