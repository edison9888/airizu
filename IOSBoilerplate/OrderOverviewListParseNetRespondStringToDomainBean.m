//
//  OrderOverviewListParseNetRespondStringToDomainBean.m
//  airizu
//
//  Created by 唐志华 on 13-1-1.
//
//

#import "OrderOverviewListParseNetRespondStringToDomainBean.h"

#import "OrderOverviewDatabaseFieldsConstant.h"
#import "OrderOverviewListNetRespondBean.h"
#import "OrderOverview.h"

#import "JSONKit.h"
#import "NSString+Expand.h"
#import "NSDictionary+SafeValue.h"

#import "ToolsFunctionForThisProgect.h"

static const NSString *const TAG = @"<OrderOverviewListParseNetRespondStringToDomainBean>";

@implementation OrderOverviewListParseNetRespondStringToDomainBean
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
    
    // 关键数据字段检测
    NSString *defaultValueForString = @"";
    NSNumber *defaultValueForNumber = [NSNumber numberWithBool:NO];
    
    NSMutableArray *orderOverviewList = [NSMutableArray array];
    NSArray *jsonArrayForOrderOverviewList = [jsonRootNSDictionary safeArrayObjectForKey:k_OrderList_RespondKey_data];
    
    for (NSDictionary *jsonObjectForOrderOverview in jsonArrayForOrderOverviewList) {
      // 订单编号
      NSNumber *orderId = [jsonObjectForOrderOverview safeNumberObjectForKey:k_OrderList_RespondKey_orderId withDefaultValue:defaultValueForNumber];
      // 房间标题
      NSString *roomTitle = [jsonObjectForOrderOverview safeStringObjectForKey:k_OrderList_RespondKey_roomTitle withDefaultValue:defaultValueForString];
      // 入住时间
      NSString *checkInDate = [jsonObjectForOrderOverview safeStringObjectForKey:k_OrderList_RespondKey_checkInDate withDefaultValue:defaultValueForString];
      checkInDate = [ToolsFunctionForThisProgect transformUtilDateStringToSqlDateString:checkInDate];
      // 退房时间
      NSString *checkOutDate = [jsonObjectForOrderOverview safeStringObjectForKey:k_OrderList_RespondKey_checkOutDate withDefaultValue:defaultValueForString];
      checkOutDate = [ToolsFunctionForThisProgect transformUtilDateStringToSqlDateString:checkOutDate];
      // 订单状态代码
      NSNumber *statusCode = [jsonObjectForOrderOverview safeNumberObjectForKey:k_OrderList_RespondKey_statusCode withDefaultValue:defaultValueForNumber];
      // 订单总额
      NSNumber *orderTotalPrice = [jsonObjectForOrderOverview safeNumberObjectForKey:k_OrderList_RespondKey_orderTotalPrice withDefaultValue:defaultValueForNumber];
      // 房间图片地址
      NSString *roomImage = [jsonObjectForOrderOverview safeStringObjectForKey:k_OrderList_RespondKey_roomImage withDefaultValue:defaultValueForString];
      // 房间ID
      NSNumber *roomId = [jsonObjectForOrderOverview safeNumberObjectForKey:k_OrderList_RespondKey_roomId withDefaultValue:defaultValueForNumber];
      // 当前订单的状态描述信息
      NSString *statusContent = [jsonObjectForOrderOverview safeStringObjectForKey:k_OrderList_RespondKey_statusContent withDefaultValue:defaultValueForString];
      
      OrderOverview *orderOverview
      = [OrderOverview orderOverviewWithOrderId:orderId
                                      roomTitle:roomTitle
                                    checkInDate:checkInDate
                                   checkOutDate:checkOutDate
                                     statusCode:statusCode
                                orderTotalPrice:orderTotalPrice
                                      roomImage:roomImage
                                         roomId:roomId
                                  statusContent:statusContent];
      [orderOverviewList addObject:orderOverview];
    }
    
    return [OrderOverviewListNetRespondBean orderOverviewListNetRespondBeanWithOrderOverviewList:orderOverviewList];
  } while (NO);
  
  return nil;
}

@end