//
//  OrderSubmitNetRequestBean.h
//  airizu
//
//  Created by 唐志华 on 13-1-1.
//
//

#import <Foundation/Foundation.h>

@interface OrderSubmitNetRequestBean : NSObject {
  
}

/// 必选参数

// 房间id
@property (nonatomic, readonly) NSString *roomId;
// 入住日期
@property (nonatomic, readonly) NSString *checkInDate;
// 退房日期
@property (nonatomic, readonly) NSString *checkOutDate;
// 优惠方式(0：不使用优惠卷；1：VIP优惠；2：普通优惠卷；3：现金卷)
@property (nonatomic, readonly) VoucherMethodEnum voucherMethod;
// 入住人数
@property (nonatomic, readonly) NSString *guestNum;
// 租客姓名
@property (nonatomic, readonly) NSString *checkinName;
// 租客手机
@property (nonatomic, readonly) NSString *checkinPhone;


/// 可选参数

// 优惠码
@property (nonatomic, copy) NSString *iVoucherCode;
// 积分
@property (nonatomic, copy) NSString *pointNum;

/// 未确定参数
// 来源关键字
@property (nonatomic, copy) NSString *keyword;
// 来源
@property (nonatomic, copy) NSString *source;

#pragma mark -
#pragma mark 方便构造

+(id)orderSubmitNetRequestBeanWithRoomId:(NSString *)roomId
                             checkInDate:(NSString *)checkInDate
                            checkOutDate:(NSString *)checkOutDate
                           voucherMethod:(VoucherMethodEnum)voucherMethod
                                guestNum:(NSString *)guestNum
                             checkinName:(NSString *)checkinName
                            checkinPhone:(NSString *)checkinPhone;
@end
