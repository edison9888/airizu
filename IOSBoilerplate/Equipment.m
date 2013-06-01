//
//  Equipment.m
//  airizu
//
//  Created by 唐志华 on 13-1-1.
//
//

#import "Equipment.h"
#import "DictionaryDatabaseFieldsConstant.h"

static const NSString *const TAG = @"<Equipment>";

@implementation Equipment

- (void) dealloc {
	PRPLog(@"dealloc: %@ [0x%x]", TAG, [self hash]);
	
  [_equipmentName release];
  [_equipmentId release];
  
	[super dealloc];
}

- (id) initWithEquipmentName:(NSString *) equipmentName
                 equipmentId:(NSString *) equipmentId
{
  
  if ((self = [super init])) {
		PRPLog(@"init %@ [0x%x]", TAG, [self hash]);
    
    _equipmentName = [equipmentName copy];
    _equipmentId = [equipmentId copy];
    
  }
  
  return self;
}

- (NSString *)description {
	return descriptionForDebug(self);
}

#pragma mark -
#pragma mark 方便构造

+(id)equipmentWithEquipmentName:(NSString *) equipmentName
                    equipmentId:(NSString *) equipmentId {
  return [[[Equipment alloc] initWithEquipmentName:equipmentName equipmentId:equipmentId] autorelease];
}

#pragma mark -
#pragma mark 实现 NSCoding 接口
- (void)encodeWithCoder:(NSCoder *)aCoder {
  [aCoder encodeObject:_equipmentName forKey:k_RoomDictionary_RespondKey_equipmentName];
  [aCoder encodeObject:_equipmentId   forKey:k_RoomDictionary_RespondKey_equipmentId];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
  if ((self = [super init])) {
    
    // 如果有不需要序列化的属性存在时, 可以在这里先进行初始化
    
    //
    if ([aDecoder containsValueForKey:k_RoomDictionary_RespondKey_equipmentName]) {
      _equipmentName = [[aDecoder decodeObjectForKey:k_RoomDictionary_RespondKey_equipmentName] copy];
    }
    //
    if ([aDecoder containsValueForKey:k_RoomDictionary_RespondKey_equipmentId]) {
      _equipmentId = [[aDecoder decodeObjectForKey:k_RoomDictionary_RespondKey_equipmentId] copy];
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
