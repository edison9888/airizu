//
//  FreeBookParseDomainBeanToDD.m
//  airizu
//
//  Created by 唐志华 on 13-1-1.
//
//

#import "FreeBookParseDomainBeanToDD.h"

#import "FreeBookDatabaseFieldsConstant.h"
#import "FreeBookNetRequestBean.h"

#import "NSString+Expand.h"

static const NSString *const TAG = @"<FreeBookParseDomainBeanToDD>";

@implementation FreeBookParseDomainBeanToDD

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
    if (! [netRequestDomainBean isMemberOfClass:[FreeBookNetRequestBean class]]) {
      NSAssert(NO, @"传入的业务Bean的类型不符 !");
      break;
    }
    
    const FreeBookNetRequestBean *requestBean = netRequestDomainBean;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
		
		NSString *value = nil;
		
    //  
		value = requestBean.roomId;
		if ([NSString isEmpty:value]) {
      NSAssert(NO, @"缺失重要字段 : roomId");
      break;
		}
    [params setObject:value forKey:k_OrderFreebook_RequestKey_roomId];
    //
		value = requestBean.checkInDate;
		if ([NSString isEmpty:value]) {
      NSAssert(NO, @"缺失重要字段 : checkInDate");
      break;
		}
    [params setObject:value forKey:k_OrderFreebook_RequestKey_checkInDate];
    //
		value = requestBean.checkOutDate;
		if ([NSString isEmpty:value]) {
      NSAssert(NO, @"缺失重要字段 : checkOutDate");
      break;
		}
    [params setObject:value forKey:k_OrderFreebook_RequestKey_checkOutDate];
    
    //
    NSInteger voucherMethod = requestBean.voucherMethod;
    if (voucherMethod > kVoucherMethodEnum_CashVolume) {
      voucherMethod = kVoucherMethodEnum_DoNotUsePromotions;
    }
    value = [NSString stringWithFormat:@"%d", voucherMethod];
    [params setObject:value forKey:k_OrderFreebook_RequestKey_voucherMethod];
    
    //
		value = requestBean.guestNum;
		if ([NSString isEmpty:value]) {
      NSAssert(NO, @"缺失重要字段 : guestNum");
      break;
		}
    [params setObject:value forKey:k_OrderFreebook_RequestKey_guestNum];
    
    
    /// 可选参数
    //
		value = requestBean.iVoucherCode;
		if (![NSString isEmpty:value]) {
      [params setObject:value forKey:k_OrderFreebook_RequestKey_iVoucherCode];
		}
    //
		value = requestBean.pointNum;
		if (![NSString isEmpty:value]) {
      [params setObject:value forKey:k_OrderFreebook_RequestKey_pointNum];
		}
    return params;
  } while (NO);
  
  return nil;
}
@end