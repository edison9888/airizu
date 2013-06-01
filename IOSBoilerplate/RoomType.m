//
//  RootType.m
//  airizu
//
//  Created by 唐志华 on 13-1-1.
//
//

#import "RoomType.h"
#import "DictionaryDatabaseFieldsConstant.h"

static const NSString *const TAG = @"<RoomType>";

@implementation RoomType

- (void) dealloc {
	PRPLog(@"dealloc: %@ [0x%x]", TAG, [self hash]);
	
  [_typeName release];
  [_typeId release];
	
	[super dealloc];
}

- (id) initWithTypeName:(NSString *) typeName
                 typeId:(NSString *) typeId
{
  
  if ((self = [super init])) {
		PRPLog(@"init %@ [0x%x]", TAG, [self hash]);
    
    _typeName = [typeName copy];
    _typeId = [typeId copy];
    
  }
  
  return self;
}

- (NSString *)description {
	return descriptionForDebug(self);
}

#pragma mark -
#pragma mark 方便构造

+(id)roomTypeWithTypeName:(NSString *) typeName
                   typeId:(NSString *) typeId {
  return [[[RoomType alloc] initWithTypeName:typeName typeId:typeId] autorelease];
}

#pragma mark -
#pragma mark 实现 NSCoding 接口
- (void)encodeWithCoder:(NSCoder *)aCoder {
  [aCoder encodeObject:_typeName forKey:k_RoomDictionary_RespondKey_typeName];
  [aCoder encodeObject:_typeId   forKey:k_RoomDictionary_RespondKey_typeId];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
  if ((self = [super init])) {
    
    // 如果有不需要序列化的属性存在时, 可以在这里先进行初始化
    
    //
    if ([aDecoder containsValueForKey:k_RoomDictionary_RespondKey_typeName]) {
      _typeName = [[aDecoder decodeObjectForKey:k_RoomDictionary_RespondKey_typeName] copy];
    }
    //
    if ([aDecoder containsValueForKey:k_RoomDictionary_RespondKey_typeId]) {
      _typeId = [[aDecoder decodeObjectForKey:k_RoomDictionary_RespondKey_typeId] copy];
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