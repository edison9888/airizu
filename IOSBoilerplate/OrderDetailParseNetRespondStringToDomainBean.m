//
//  OrderDetailParseNetRespondStringToDomainBean.m
//  airizu
//
//  Created by 唐志华 on 13-1-1.
//
//

#import "OrderDetailParseNetRespondStringToDomainBean.h"

#import "OrderDetailDatabaseFieldsConstant.h"
#import "OrderDetailNetRespondBean.h"

#import "JSONKit.h"
#import "NSString+Expand.h"
#import "NSDictionary+SafeValue.h"

static const NSString *const TAG = @"<OrderDetailParseNetRespondStringToDomainBean>";

@implementation OrderDetailParseNetRespondStringToDomainBean
- (id) init {
	
	if ((self = [super init])) {
		PRPLog(@"init %@ [0x%x]", TAG, [self hash]);
    
	}
	
	return self;
}

- (void) dealloc {
	PRPLog(@"dealloc: %@ [0x%x]", TAG, [self hash]);
	
	[super dealloc];
}

#pragma mark 实现 IParseNetRespondStringToDomainBean 接口
- (id) parseNetRespondStringToDomainBean:(in NSString *) netRespondString {
  do {
    if ([NSString isEmpty:netRespondString]) {
      PRPLog(@"%@-> 入参 netRespondString 为空 !", TAG);
      break;
    }
    
    const char *jsonStringForUTF8 = [netRespondString UTF8String];
		NSError *error = [[NSError alloc] init];
    JSONDecoder *jsonDecoder = [[JSONDecoder alloc] init];
    NSDictionary *jsonRootNSDictionary
    = [jsonDecoder objectWithUTF8String:(const unsigned char *)jsonStringForUTF8
                                 length:(unsigned int)strlen(jsonStringForUTF8)];
    [jsonDecoder release], jsonDecoder = nil;
		[error release], error = nil;
    
    if (![jsonRootNSDictionary isKindOfClass:[NSDictionary class]]) {
      PRPLog(@"%@-> json 解析失败!", TAG);
      break;
    }
    
    // 关键字段检测
    NSString *defaultValueForString = @"";
    NSNumber *defaultValueForNumber = [NSNumber numberWithBool:NO];
    
    // 订单编号
    NSNumber *orderId
    = [jsonRootNSDictionary safeNumberObjectForKey:k_OrderDetail_RespondKey_orderId
                                  withDefaultValue:defaultValueForNumber];
    // 订单状态
    NSNumber *orderState
    = [jsonRootNSDictionary safeNumberObjectForKey:k_OrderDetail_RespondKey_orderState
                                  withDefaultValue:defaultValueForNumber];
    // 消息
    NSString *message
    = [jsonRootNSDictionary safeStringObjectForKey:k_OrderDetail_RespondKey_message
                                  withDefaultValue:defaultValueForString];
    // 开始时间
    NSString *chenckInDate
    = [jsonRootNSDictionary safeStringObjectForKey:k_OrderDetail_RespondKey_chenckInDate
                                  withDefaultValue:defaultValueForString];
    chenckInDate = [ToolsFunctionForThisProgect transformUtilDateStringToSqlDateString:chenckInDate];
    // 结束时间
    NSString *chenckOutDate
    = [jsonRootNSDictionary safeStringObjectForKey:k_OrderDetail_RespondKey_chenckOutDate
                                  withDefaultValue:defaultValueForString];
    chenckOutDate = [ToolsFunctionForThisProgect transformUtilDateStringToSqlDateString:chenckOutDate];
    // 入住人数
    NSNumber *guestNum
    = [jsonRootNSDictionary safeNumberObjectForKey:k_OrderDetail_RespondKey_guestNum
                                  withDefaultValue:defaultValueForNumber];
    // 预付定金
    NSNumber *pricePerNight
    = [jsonRootNSDictionary safeNumberObjectForKey:k_OrderDetail_RespondKey_pricePerNight
                                  withDefaultValue:defaultValueForNumber];
    // 线下支付
    NSNumber *linePay
    = [jsonRootNSDictionary safeNumberObjectForKey:k_OrderDetail_RespondKey_linePay
                                  withDefaultValue:defaultValueForNumber];
    // 订单总额
    NSNumber *subPrice
    = [jsonRootNSDictionary safeNumberObjectForKey:k_OrderDetail_RespondKey_subPrice
                                  withDefaultValue:defaultValueForNumber];
    // 订单类型(0普通 1快速)
    NSNumber *orderTypeNomber
    = [jsonRootNSDictionary safeNumberObjectForKey:k_OrderDetail_RespondKey_orderType
                                  withDefaultValue:defaultValueForNumber];
    OrderTypeEnum orderTypeEnum = [orderTypeNomber integerValue];
    // 订单状态内容
    NSString *statusContent
    = [jsonRootNSDictionary safeStringObjectForKey:k_OrderDetail_RespondKey_statusContent withDefaultValue:defaultValueForString];
    
    // 房间详情相关接口
    // 房间编号
    NSNumber *number
    = [jsonRootNSDictionary safeNumberObjectForKey:k_OrderDetail_RespondKey_number
                                  withDefaultValue:defaultValueForNumber];
    // 房间图片
    NSString *image
    = [jsonRootNSDictionary safeStringObjectForKey:k_OrderDetail_RespondKey_image
                                  withDefaultValue:defaultValueForString];
    // 房间标题
    NSString *title
    = [jsonRootNSDictionary safeStringObjectForKey:k_OrderDetail_RespondKey_title
                                  withDefaultValue:defaultValueForString];
    // 房间地址
    NSString *address
    = [jsonRootNSDictionary safeStringObjectForKey:k_OrderDetail_RespondKey_address
                                  withDefaultValue:defaultValueForString];
    
    // 房东信息相关
    // 是否显示房东信息boolean（true：显示，false：不显示）
    NSNumber *ifShowHostNumber
    = [jsonRootNSDictionary safeNumberObjectForKey:k_OrderDetail_RespondKey_ifShowHost
                                  withDefaultValue:defaultValueForNumber];
    BOOL ifShowHost = [ifShowHostNumber boolValue];
    // 房东姓名
    NSString *hostName
    = [jsonRootNSDictionary safeStringObjectForKey:k_OrderDetail_RespondKey_hostName
                                  withDefaultValue:defaultValueForString];
    
    // 房东电话
    NSString *hostPhone
    = [jsonRootNSDictionary safeStringObjectForKey:k_OrderDetail_RespondKey_hostPhone
                                  withDefaultValue:defaultValueForString];

    // 房东备用电话
    NSString *hostBackupPhone
    = [jsonRootNSDictionary safeStringObjectForKey:k_OrderDetail_RespondKey_hostBackupPhone
                                  withDefaultValue:defaultValueForString];
    
    // 订单状态与客户端互相转换的状态订单状态
    // 1待确定
    // 2待支付
    // 3待入住
    // 4待评价
    // 5已完成
    NSNumber *conversionStateNumber
    = [jsonRootNSDictionary safeNumberObjectForKey:k_OrderDetail_RespondKey_conversionState withDefaultValue:defaultValueForNumber];
    OrderStateEnum orderStateEnum = [conversionStateNumber integerValue];
    
    return [OrderDetailNetRespondBean orderDetailNetRespondBeanWithOrderId:orderId
                                                                orderState:orderState
                                                                   message:message
                                                              chenckInDate:chenckInDate
                                                             chenckOutDate:chenckOutDate
                                                                  guestNum:guestNum
                                                             pricePerNight:pricePerNight
                                                                   linePay:linePay
                                                                  subPrice:subPrice
                                                                 orderType:orderTypeEnum
                                                             statusContent:statusContent
            
                                                                    number:number
                                                                     image:image
                                                                     title:title
                                                                   address:address
            
                                                                ifShowHost:ifShowHost
                                                                  hostName:hostName
                                                                 hostPhone:hostPhone
                                                           hostBackupPhone:hostBackupPhone
            
                                                                orderState:orderStateEnum];
  } while (NO);
  
  return nil;
}

@end