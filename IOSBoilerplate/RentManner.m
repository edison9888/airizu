//
//  RentManner.m
//  airizu
//
//  Created by 唐志华 on 13-1-1.
//
//

#import "RentManner.h"
#import "DictionaryDatabaseFieldsConstant.h"

static const NSString *const TAG = @"<RentManner>";

@implementation RentManner

- (void) dealloc {
	PRPLog(@"dealloc: %@ [0x%x]", TAG, [self hash]);
	
  [_rentalWayName release];
  [_rentalWayId release];
	
	[super dealloc];
}

- (id) initWithRentalWayName:(NSString *) rentalWayName
                 rentalWayId:(NSString *) rentalWayId
{
  
  if ((self = [super init])) {
		PRPLog(@"init %@ [0x%x]", TAG, [self hash]);
    
    _rentalWayName = [rentalWayName copy];
    _rentalWayId = [rentalWayId copy];
    
  }
  
  return self;
}

- (NSString *)description {
	return descriptionForDebug(self);
}

#pragma mark -
#pragma mark 方便构造

+(id)rentMannerWithRentalWayName:(NSString *) rentalWayName
                     rentalWayId:(NSString *) rentalWayId {
  return [[[RentManner alloc] initWithRentalWayName:rentalWayName rentalWayId:rentalWayId] autorelease];
}

#pragma mark -
#pragma mark 实现 NSCoding 接口
- (void)encodeWithCoder:(NSCoder *)aCoder {
  [aCoder encodeObject:_rentalWayName forKey:k_RoomDictionary_RespondKey_rentalWayName];
  [aCoder encodeObject:_rentalWayId   forKey:k_RoomDictionary_RespondKey_rentalWayId];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
  if ((self = [super init])) {
    
    // 如果有不需要序列化的属性存在时, 可以在这里先进行初始化
    
    //
    if ([aDecoder containsValueForKey:k_RoomDictionary_RespondKey_rentalWayName]) {
      _rentalWayName = [[aDecoder decodeObjectForKey:k_RoomDictionary_RespondKey_rentalWayName] copy];
    }
    //
    if ([aDecoder containsValueForKey:k_RoomDictionary_RespondKey_rentalWayId]) {
      _rentalWayId = [[aDecoder decodeObjectForKey:k_RoomDictionary_RespondKey_rentalWayId] copy];
    }
    
  }
  
  return self;
}

#pragma mark
#pragma mark 不能使用默认的init方法初始化对象, 而必须使用当前类特定的 "初始化方法" 初始化所有参数
- (id) init {
  NSAssert(NO, @"Can not use the default init method!");
  
  return nil;
}

@end