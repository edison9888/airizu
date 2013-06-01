//
//  DictionaryNetRespondBean.m
//  airizu
//
//  Created by 唐志华 on 13-1-1.
//
//

#import "DictionaryNetRespondBean.h"
#import "DictionaryDatabaseFieldsConstant.h"

static const NSString *const TAG = @"<DictionaryNetRespondBean>";

@implementation DictionaryNetRespondBean

- (void) dealloc {
	PRPLog(@"dealloc: %@ [0x%x]", TAG, [self hash]);
	
  [_roomTypes release];
  [_rentManners release];
  [_equipments release];
  
	[super dealloc];
}

- (id) initWithRoomTypes:(NSArray *)roomTypes
             rentManners:(NSArray *)rentManners
              equipments:(NSArray *)equipments
{
  
  if ((self = [super init])) {
		PRPLog(@"init %@ [0x%x]", TAG, [self hash]);
    
    _roomTypes = [roomTypes copy];
    _rentManners = [rentManners copy];
    _equipments = [equipments copy];
    
  }
  
  return self;
}

- (NSString *)description {
	return descriptionForDebug(self);
}

#pragma mark -
#pragma mark 方便构造

+(id)dictionaryNetRespondBeanWithRoomTypes:(NSArray *)roomTypes
                               rentManners:(NSArray *)rentManners
                                equipments:(NSArray *)equipments {
  return [[[DictionaryNetRespondBean alloc] initWithRoomTypes:roomTypes rentManners:rentManners equipments:equipments] autorelease];
}

#pragma mark -
#pragma mark 实现 NSCoding 接口
- (void)encodeWithCoder:(NSCoder *)aCoder {
  [aCoder encodeObject:_roomTypes   forKey:kNSCodingKeyDataDictionary_roomTypes];
  [aCoder encodeObject:_rentManners forKey:kNSCodingKeyDataDictionary_rentManners];
  [aCoder encodeObject:_equipments  forKey:kNSCodingKeyDataDictionary_equipments];
  
}

- (id)initWithCoder:(NSCoder *)aDecoder {
  if ((self = [super init])) {
    
    // 如果有不需要序列化的属性存在时, 可以在这里先进行初始化
    
    //
    if ([aDecoder containsValueForKey:kNSCodingKeyDataDictionary_roomTypes]) {
      _roomTypes = [[aDecoder decodeObjectForKey:kNSCodingKeyDataDictionary_roomTypes] copy];
    }
    //
    if ([aDecoder containsValueForKey:kNSCodingKeyDataDictionary_rentManners]) {
      _rentManners = [[aDecoder decodeObjectForKey:kNSCodingKeyDataDictionary_rentManners] copy];
    }
    //
    if ([aDecoder containsValueForKey:kNSCodingKeyDataDictionary_equipments]) {
      _equipments = [[aDecoder decodeObjectForKey:kNSCodingKeyDataDictionary_equipments] copy];
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