//
//  OrderDetailNetRespondBean.h
//  airizu
//
//  Created by 唐志华 on 13-1-1.
//
//

#import <Foundation/Foundation.h>

@interface OrderDetailNetRespondBean : NSObject {
  
}

//
// 订单编号
@property (nonatomic, readonly) NSNumber *orderId;
// 订单状态
@property (nonatomic, readonly) NSNumber *orderState;
// 消息
@property (nonatomic, readonly) NSString *message;
// 开始时间
@property (nonatomic, readonly) NSString *chenckInDate;
// 结束时间
@property (nonatomic, readonly) NSString *chenckOutDate;
// 入住人数
@property (nonatomic, readonly) NSNumber *guestNum;
// 预付定金
@property (nonatomic, readonly) NSNumber *pricePerNight;
// 线下支付
@property (nonatomic, readonly) NSNumber *linePay;
// 订单总额
@property (nonatomic, readonly) NSNumber *subPrice;
// 订单类型(0普通 1快速)
@property (nonatomic, readonly) OrderTypeEnum orderTypeEnum;
// 订单状态内容
@property (nonatomic, readonly) NSString *statusContent;

// 房间详情相关接口
// 房间编号
@property (nonatomic, readonly) NSNumber *number;
// 房间图片
@property (nonatomic, readonly) NSString *image;
// 房间标题
@property (nonatomic, readonly) NSString *title;
// 房间地址
@property (nonatomic, readonly) NSString *address;

// 房东信息相关
// 是否显示房东信息boolean（true：显示，false：不显示）
@property (nonatomic, readonly) BOOL ifShowHost;
// 房东姓名
@property (nonatomic, readonly) NSString *hostName;
// 房东电话
@property (nonatomic, readonly) NSString *hostPhone;
// 房东备用电话
@property (nonatomic, readonly) NSString *hostBackupPhone;

// 订单状态与客户端互相转换的状态订单状态
// 1待确定
// 2待支付
// 3待入住
// 4待评价
// 5已完成
@property (nonatomic, readonly) OrderStateEnum orderStateEnum;

#pragma mark -
#pragma mark 方便构造

+(id)orderDetailNetRespondBeanWithOrderId:(NSNumber *)orderId
                               orderState:(NSNumber *)orderState
                                  message:(NSString *)message
                             chenckInDate:(NSString *)chenckInDate
                            chenckOutDate:(NSString *)chenckOutDate
                                 guestNum:(NSNumber *)guestNum
                            pricePerNight:(NSNumber *)pricePerNight
                                  linePay:(NSNumber *)linePay
                                 subPrice:(NSNumber *)subPrice
                                orderType:(OrderTypeEnum)orderTypeEnum
                            statusContent:(NSString *)statusContent

                                   number:(NSNumber *)number
                                    image:(NSString *)image
                                    title:(NSString *)title
                                  address:(NSString *)address

                               ifShowHost:(BOOL)ifShowHost
                                 hostName:(NSString *)hostName
                                hostPhone:(NSString *)hostPhone
                          hostBackupPhone:(NSString *)hostBackupPhone

                               orderState:(OrderStateEnum)orderStateEnum;



@end
