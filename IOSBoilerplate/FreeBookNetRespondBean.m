//
//  FreeBookNetRespondBean.m
//  airizu
//
//  Created by 唐志华 on 13-1-1.
//
//

#import "FreeBookNetRespondBean.h"
#import "FreeBookDatabaseFieldsConstant.h"

static const NSString *const TAG = @"<FreeBookNetRespondBean>";

@implementation FreeBookNetRespondBean

- (void) dealloc {
	PRPLog(@"dealloc: %@ [0x%x]", TAG, [self hash]);
	
  [_totalPrice release];
  [_advancedDeposit release];
  [_underLinePaid release];
  [_availablePoint release];
  
	[super dealloc];
}

- (id) initWithTotalPrice:(NSNumber *)totalPrice
          advancedDeposit:(NSNumber *)advancedDeposit
            underLinePaid:(NSNumber *)underLinePaid
           availablePoint:(NSNumber *)availablePoint
                  isCheap:(BOOL)isCheap
{
  
  if ((self = [super init])) {
		PRPLog(@"init %@ [0x%x]", TAG, [self hash]);
    
    _totalPrice = [totalPrice copy];
    _advancedDeposit = [advancedDeposit copy];
    _underLinePaid = [underLinePaid copy];
    _availablePoint = [availablePoint copy];
    _isCheap = isCheap;
  }
  
  return self;
}

#pragma mark -
#pragma mark 方便构造

+(id)freeBookNetRespondBeanWithTotalPrice:(NSNumber *)totalPrice
                          advancedDeposit:(NSNumber *)advancedDeposit
                            underLinePaid:(NSNumber *)underLinePaid
                           availablePoint:(NSNumber *)availablePoint
                                  isCheap:(BOOL)isCheap {
  
  return [[[FreeBookNetRespondBean alloc] initWithTotalPrice:totalPrice
                                             advancedDeposit:advancedDeposit
                                               underLinePaid:underLinePaid
                                              availablePoint:availablePoint
                                                     isCheap:isCheap] autorelease];
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
  [aCoder encodeObject:_totalPrice      forKey:k_OrderFreebook_RespondKey_totalPrice];
  [aCoder encodeObject:_advancedDeposit forKey:k_OrderFreebook_RespondKey_advancedDeposit];
  [aCoder encodeObject:_underLinePaid   forKey:k_OrderFreebook_RespondKey_underLinePaid];
  [aCoder encodeObject:_availablePoint  forKey:k_OrderFreebook_RespondKey_availablePoint];
  [aCoder encodeObject:[NSNumber numberWithBool:_isCheap] forKey:k_OrderFreebook_RespondKey_isCheap];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
  if ((self = [super init])) {
    
    // 如果有不需要序列化的属性存在时, 可以在这里先进行初始化
    
    //
    if ([aDecoder containsValueForKey:k_OrderFreebook_RespondKey_totalPrice]) {
      _totalPrice = [[aDecoder decodeObjectForKey:k_OrderFreebook_RespondKey_totalPrice] copy];
    }
    //
    if ([aDecoder containsValueForKey:k_OrderFreebook_RespondKey_advancedDeposit]) {
      _advancedDeposit = [[aDecoder decodeObjectForKey:k_OrderFreebook_RespondKey_advancedDeposit] copy];
    }
    //
    if ([aDecoder containsValueForKey:k_OrderFreebook_RespondKey_underLinePaid]) {
      _underLinePaid = [[aDecoder decodeObjectForKey:k_OrderFreebook_RespondKey_underLinePaid] copy];
    }
    //
    if ([aDecoder containsValueForKey:k_OrderFreebook_RespondKey_availablePoint]) {
      _availablePoint = [[aDecoder decodeObjectForKey:k_OrderFreebook_RespondKey_availablePoint] copy];
    }
    //
    if ([aDecoder containsValueForKey:k_OrderFreebook_RespondKey_isCheap]) {
      _isCheap = [[aDecoder decodeObjectForKey:k_OrderFreebook_RespondKey_isCheap] boolValue];
    }

  }
  
  return self;
}

- (NSString *)description {
	return descriptionForDebug(self);
}
@end