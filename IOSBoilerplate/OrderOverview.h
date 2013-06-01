//
//  OrderOverview.h
//  airizu
//
//  Created by 唐志华 on 13-1-1.
//
//

#import <Foundation/Foundation.h>

@interface OrderOverview : NSObject {
  
}

// 订单编号
@property (nonatomic, readonly) NSNumber *orderId;
// 房间标题
@property (nonatomic, readonly) NSString *roomTitle;
// 入住时间
@property (nonatomic, readonly) NSString *checkInDate;
// 退房时间
@property (nonatomic, readonly) NSString *checkOutDate;
// 订单状态代码
@property (nonatomic, readonly) NSNumber *statusCode;
// 订单总额
@property (nonatomic, readonly) NSNumber *orderTotalPrice;
// 房间图片地址
@property (nonatomic, readonly) NSString *roomImage;
// 房间ID
@property (nonatomic, readonly) NSNumber *roomId;
// 当前订单的实际状态说明信息
@property (nonatomic, readonly) NSString *statusContent;

#pragma mark -
#pragma mark 方便构造

+(id)orderOverviewWithOrderId:(NSNumber *)orderId
                    roomTitle:(NSString *)roomTitle
                  checkInDate:(NSString *)checkInDate
                 checkOutDate:(NSString *)checkOutDate
                   statusCode:(NSNumber *)statusCode
              orderTotalPrice:(NSNumber *)orderTotalPrice
                    roomImage:(NSString *)roomImage
                       roomId:(NSNumber *)roomId
                statusContent:(NSString *)statusContent;
@end
