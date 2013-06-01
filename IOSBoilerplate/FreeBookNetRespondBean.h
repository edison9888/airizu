//
//  FreeBookNetRespondBean.h
//  airizu
//
//  Created by 唐志华 on 13-1-1.
//
//

#import <Foundation/Foundation.h>

@interface FreeBookNetRespondBean : NSObject <NSCoding> {
  
}

// 订单总额
@property (nonatomic, readonly) NSNumber *totalPrice;
// 预付订金
@property (nonatomic, readonly) NSNumber *advancedDeposit;
// 线下支付
@property (nonatomic, readonly) NSNumber *underLinePaid;
// 用户积分
@property (nonatomic, readonly) NSNumber *availablePoint;
// 是否优惠（0优惠，1没优惠）
@property (nonatomic, readonly) BOOL isCheap;

#pragma mark -
#pragma mark 方便构造

+(id)freeBookNetRespondBeanWithTotalPrice:(NSNumber *)totalPrice
                          advancedDeposit:(NSNumber *)advancedDeposit
                            underLinePaid:(NSNumber *)underLinePaid
                           availablePoint:(NSNumber *)availablePoint
                                  isCheap:(BOOL)isCheap;

#pragma mark -
#pragma mark 实现 NSCoding 接口
- (void)encodeWithCoder:(NSCoder *)aCoder;
- (id)initWithCoder:(NSCoder *)aDecoder;
@end
