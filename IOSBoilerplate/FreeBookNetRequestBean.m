//
//  FreeBookNetRequestBean.m
//  airizu
//
//  Created by 唐志华 on 13-1-1.
//
//

#import "FreeBookNetRequestBean.h"
#import "FreeBookDatabaseFieldsConstant.h"

static const NSString *const TAG = @"<FreeBookNetRequestBean>";

@implementation FreeBookNetRequestBean

- (void) dealloc {
	PRPLog(@"dealloc: %@ [0x%x]", TAG, [self hash]);
	
  // 必选
  [_roomId release];
  [_checkInDate release];
  [_checkOutDate release];
  [_guestNum release];
  
  // 可选
  [_iVoucherCode release];
  [_pointNum release];
	
	[super dealloc];
}

- (id) initWithRoomId:(NSString *)roomId
          checkInDate:(NSString *)checkInDate
         checkOutDate:(NSString *)checkOutDate
        voucherMethod:(VoucherMethodEnum)voucherMethod
             guestNum:(NSString *)guestNum {
  
  if ((self = [super init])) {
		PRPLog(@"init %@ [0x%x]", TAG, [self hash]);
    
    // 必选
    _roomId        = [roomId copy];
    _checkInDate   = [checkInDate copy];
    _checkOutDate  = [checkOutDate copy];
    _voucherMethod = voucherMethod;
    _guestNum      = [guestNum copy];
    
    // 可选
    _iVoucherCode  = [[NSString alloc] initWithString:@""];
    _pointNum      = [[NSString alloc] initWithString:@""];
  }
  
  return self;
}

#pragma mark -
#pragma mark 方便构造

+(id)freeBookNetRequestBeanWithRoomId:(NSString *)roomId
                          checkInDate:(NSString *)checkInDate
                         checkOutDate:(NSString *)checkOutDate
                        voucherMethod:(VoucherMethodEnum)voucherMethod
                             guestNum:(NSString *)guestNum {
  
  return [[[FreeBookNetRequestBean alloc] initWithRoomId:roomId
                                             checkInDate:checkInDate
                                            checkOutDate:checkOutDate
                                           voucherMethod:voucherMethod
                                                guestNum:guestNum] autorelease];
}

#pragma mark
#pragma mark 不能使用默认的init方法初始化对象, 而必须使用当前类特定的 "初始化方法" 初始化所有参数
- (id) init {
  NSAssert(NO, @"Can not use the default init method!");
  
  return nil;
}

#pragma mark -
#pragma mark 实现 NSCoding 接口
- (void)encodeWithCoder:(NSCoder *)aCoder {
  
  // 必选
  [aCoder encodeObject:_roomId        forKey:k_OrderFreebook_RequestKey_roomId];
  [aCoder encodeObject:_checkInDate   forKey:k_OrderFreebook_RequestKey_checkInDate];
  [aCoder encodeObject:_checkOutDate  forKey:k_OrderFreebook_RequestKey_checkOutDate];
  [aCoder encodeObject:[NSNumber numberWithUnsignedInteger:_voucherMethod] forKey:k_OrderFreebook_RequestKey_voucherMethod];
  [aCoder encodeObject:_guestNum      forKey:k_OrderFreebook_RequestKey_guestNum];
  
  // 可选
  [aCoder encodeObject:_iVoucherCode  forKey:k_OrderFreebook_RequestKey_iVoucherCode];
  [aCoder encodeObject:_pointNum      forKey:k_OrderFreebook_RequestKey_pointNum];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
  if ((self = [super init])) {
    
    // 如果有不需要序列化的属性存在时, 可以在这里先进行初始化
    
    //
    if ([aDecoder containsValueForKey:k_OrderFreebook_RequestKey_roomId]) {
      _roomId = [[aDecoder decodeObjectForKey:k_OrderFreebook_RequestKey_roomId] copy];
    }
    //
    if ([aDecoder containsValueForKey:k_OrderFreebook_RequestKey_checkInDate]) {
      _checkInDate = [[aDecoder decodeObjectForKey:k_OrderFreebook_RequestKey_checkInDate] copy];
    }
    //
    if ([aDecoder containsValueForKey:k_OrderFreebook_RequestKey_checkOutDate]) {
      _checkOutDate = [[aDecoder decodeObjectForKey:k_OrderFreebook_RequestKey_checkOutDate] copy];
    }
    //
    if ([aDecoder containsValueForKey:k_OrderFreebook_RequestKey_voucherMethod]) {
      _voucherMethod = [[aDecoder decodeObjectForKey:k_OrderFreebook_RequestKey_voucherMethod] integerValue];
    }
    //
    if ([aDecoder containsValueForKey:k_OrderFreebook_RequestKey_guestNum]) {
      _guestNum = [[aDecoder decodeObjectForKey:k_OrderFreebook_RequestKey_guestNum] copy];
    }
    
    //
    //
    if ([aDecoder containsValueForKey:k_OrderFreebook_RequestKey_iVoucherCode]) {
      _iVoucherCode = [[aDecoder decodeObjectForKey:k_OrderFreebook_RequestKey_iVoucherCode] copy];
    }
    if ([aDecoder containsValueForKey:k_OrderFreebook_RequestKey_pointNum]) {
      _pointNum = [[aDecoder decodeObjectForKey:k_OrderFreebook_RequestKey_pointNum] copy];
    }
  }
  
  return self;
}

- (NSString *)description {
	return descriptionForDebug(self);
}
@end