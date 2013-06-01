//
//  FreeBookNetRequestBean.h
//  airizu
//
//  Created by 唐志华 on 13-1-1.
//
//

#import <Foundation/Foundation.h>

@interface FreeBookNetRequestBean : NSObject <NSCoding> {
  
}

/// 必选参数

// 房间id
@property (nonatomic, readonly) NSString *roomId;
// 入住时间
@property (nonatomic, readonly) NSString *checkInDate;
// 退房时间
@property (nonatomic, readonly) NSString *checkOutDate;
// 优惠卷类型
// 0：不使用优惠
// 1：VIP优惠
// 2：普通优惠卷
// 3：现金卷
@property (nonatomic, assign) VoucherMethodEnum voucherMethod;
// 入住人数
@property (nonatomic, readonly) NSString *guestNum;






/// 可选参数

// 优惠劵码
@property (nonatomic, copy) NSString *iVoucherCode;
// 积分
@property (nonatomic, copy) NSString *pointNum;

#pragma mark -
#pragma mark 方便构造

+(id)freeBookNetRequestBeanWithRoomId:(NSString *)roomId
                          checkInDate:(NSString *)checkInDate
                         checkOutDate:(NSString *)checkOutDate
                        voucherMethod:(VoucherMethodEnum)voucherMethod
                             guestNum:(NSString *)guestNum;

#pragma mark -
#pragma mark 实现 NSCoding 接口
- (void)encodeWithCoder:(NSCoder *)aCoder;
- (id)initWithCoder:(NSCoder *)aDecoder;

@end
