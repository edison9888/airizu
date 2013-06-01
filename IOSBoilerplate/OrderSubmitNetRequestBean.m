//
//  OrderSubmitNetRequestBean.m
//  airizu
//
//  Created by 唐志华 on 13-1-1.
//
//

#import "OrderSubmitNetRequestBean.h"

static const NSString *const TAG = @"<OrderSubmitNetRequestBean>";

@implementation OrderSubmitNetRequestBean

- (void) dealloc {
	PRPLog(@"dealloc: %@ [0x%x]", TAG, [self hash]);
	
  [_roomId release];
  [_checkInDate release];
  [_checkOutDate release];
  
  [_guestNum release];
  [_checkinName release];
  [_checkinPhone release];
  
  [_pointNum release];
  [_iVoucherCode release];
  [_keyword release];
  [_source release];
  
	[super dealloc];
}

- (id) initWithRoomId:(NSString *)roomId
          checkInDate:(NSString *)checkInDate
         checkOutDate:(NSString *)checkOutDate
        voucherMethod:(VoucherMethodEnum)voucherMethod
             guestNum:(NSString *)guestNum
          checkinName:(NSString *)checkinName
         checkinPhone:(NSString *)checkinPhone
{
  
  if ((self = [super init])) {
		PRPLog(@"init %@ [0x%x]", TAG, [self hash]);
    
    _roomId = [roomId copy];
    _checkInDate = [checkInDate copy];
    _checkOutDate = [checkOutDate copy];
    _voucherMethod = voucherMethod;
    _guestNum = [guestNum copy];
    _checkinName = [checkinName copy];
    _checkinPhone = [checkinPhone copy];
    
  }
  
  return self;
}

#pragma mark -
#pragma mark 方便构造

+(id)orderSubmitNetRequestBeanWithRoomId:(NSString *)roomId
                             checkInDate:(NSString *)checkInDate
                            checkOutDate:(NSString *)checkOutDate
                           voucherMethod:(VoucherMethodEnum)voucherMethod
                                guestNum:(NSString *)guestNum
                             checkinName:(NSString *)checkinName
                            checkinPhone:(NSString *)checkinPhone {
  
  return [[[OrderSubmitNetRequestBean alloc] initWithRoomId:roomId
                                                checkInDate:checkInDate
                                               checkOutDate:checkOutDate
                                              voucherMethod:voucherMethod
                                                   guestNum:guestNum
                                                checkinName:checkinName
                                               checkinPhone:checkinPhone] autorelease];
}

#pragma mark
#pragma mark 不能使用默认的init方法初始化对象, 而必须使用当前类特定的 "初始化方法" 初始化所有参数
- (id) init {
  NSAssert(NO, @"Can not use the default init method!");
  
  return nil;
}

- (NSString *)description {
	return descriptionForDebug(self);
}
@end