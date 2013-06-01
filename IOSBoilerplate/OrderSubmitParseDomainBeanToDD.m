//
//  OrderSubmitParseDomainBeanToDD.m
//  airizu
//
//  Created by 唐志华 on 13-1-1.
//
//

#import "OrderSubmitParseDomainBeanToDD.h"

#import "OrderSubmitDatabaseFieldsConstant.h"
#import "OrderSubmitNetRequestBean.h"

#import "NSString+Expand.h"

static const NSString *const TAG = @"<OrderSubmitParseDomainBeanToDD>";

@implementation OrderSubmitParseDomainBeanToDD

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

- (NSDictionary *) parseDomainBeanToDataDictionary:(in id) netRequestDomainBean {
  NSAssert(netRequestDomainBean != nil, @"入参为空 !");
  
  do {
    if (! [netRequestDomainBean isMemberOfClass:[OrderSubmitNetRequestBean class]]) {
      NSAssert(NO, @"传入的业务Bean的类型不符 !");
      break;
    }
    
    const OrderSubmitNetRequestBean *requestBean = netRequestDomainBean;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
		
		NSString *value = nil;
		
    // 必选参数
    // 房间id
		value = requestBean.roomId;
		if ([NSString isEmpty:value]) {
      NSAssert(NO, @"丢失关键字段 : roomId");
      break;
		}
    [params setObject:value forKey:k_OrderSubmit_RequestKey_roomId];
    // 入住日期
		value = requestBean.checkInDate;
		if ([NSString isEmpty:value]) {
      NSAssert(NO, @"丢失关键字段 : checkInDate");
      break;
		}
    [params setObject:value forKey:k_OrderSubmit_RequestKey_checkInDate];
    // 退房日期
		value = requestBean.checkOutDate;
		if ([NSString isEmpty:value]) {
      NSAssert(NO, @"丢失关键字段 : checkOutDate");
      break;
		}
    [params setObject:value forKey:k_OrderSubmit_RequestKey_checkOutDate];
    // 优惠方式(0：不使用优惠卷；1：vip优惠；2：普通优惠卷；3：现金卷)
		NSInteger voucherMethod = requestBean.voucherMethod;
		if (voucherMethod > kVoucherMethodEnum_CashVolume) {
      voucherMethod = kVoucherMethodEnum_DoNotUsePromotions;
		}
    value = [NSString stringWithFormat:@"%d", voucherMethod];
    [params setObject:value forKey:k_OrderSubmit_RequestKey_voucherMethod];
    // 入住人数
		value = requestBean.guestNum;
		if ([NSString isEmpty:value]) {
      NSAssert(NO, @"丢失关键字段 : guestNum");
      break;
		}
    [params setObject:value forKey:k_OrderSubmit_RequestKey_guestNum];
    // 入住人姓名
		value = requestBean.checkinName;
		if ([NSString isEmpty:value]) {
      NSAssert(NO, @"丢失关键字段 : checkinName");
      break;
		}
    [params setObject:value forKey:k_OrderSubmit_RequestKey_checkinName];
    // 入住人电话
		value = requestBean.checkinPhone;
		if ([NSString isEmpty:value]) {
      NSAssert(NO, @"丢失关键字段 : checkinPhone");
      break;
		}
    [params setObject:value forKey:k_OrderSubmit_RequestKey_checkinPhone];
    
    // 可选参数
    // 积分
		value = requestBean.pointNum;
		if (![NSString isEmpty:value]) {
      [params setObject:value forKey:k_OrderSubmit_RequestKey_pointNum];
		}
    // 优惠码
		value = requestBean.iVoucherCode;
		if (![NSString isEmpty:value]) {
      [params setObject:value forKey:k_OrderSubmit_RequestKey_iVoucherCode];
		}
    // 来源关键字
		value = requestBean.keyword;
		if (![NSString isEmpty:value]) {
      [params setObject:value forKey:k_OrderSubmit_RequestKey_keyword];
		}
    // 来源
		value = requestBean.source;
		if (![NSString isEmpty:value]) {
      [params setObject:value forKey:k_OrderSubmit_RequestKey_source];
		}
    
    return params;
  } while (NO);
  
  return nil;
}
@end