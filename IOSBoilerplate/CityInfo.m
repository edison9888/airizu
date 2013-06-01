//
//  CityInfo.m
//  airizu
//
//  Created by 唐志华 on 13-1-1.
//
//

#import "CityInfo.h"
#import "CitysDatabaseFieldsConstant.h"

static const NSString *const TAG = @"<CityInfo>";

@implementation CityInfo

- (void) dealloc {
	PRPLog(@"dealloc: %@ [0x%x]", TAG, [self hash]);
	
  [_ID release];
  [_name release];
  [_code release];
  [_provinceId release];
  
	[super dealloc];
}

- (id) initWithID:(NSNumber *) ID
             name:(NSString *) name
             code:(NSString *) code
       provinceId:(NSNumber *) provinceId {
  
  if ((self = [super init])) {
		PRPLog(@"init %@ [0x%x]", TAG, [self hash]);
    
    _ID = [ID copy];
    _name = [name copy];
    _code = [code copy];
    _provinceId = [provinceId copy];
  }
  
  return self;
}

#pragma mark -
#pragma mark 方便构造

+(id)cityInfoWithID:(NSNumber *) ID
               name:(NSString *) name
               code:(NSString *) code
         provinceId:(NSNumber *) provinceId {
  
  return [[[CityInfo alloc] initWithID:ID
                                  name:name
                                  code:code
                            provinceId:provinceId] autorelease];
}

#pragma mark -
#pragma mark 实现 NSCoding 接口
- (void)encodeWithCoder:(NSCoder *)aCoder {
  [aCoder encodeObject:_ID               forKey:k_CityInfo_RespondKey_id];
  [aCoder encodeObject:_name             forKey:k_CityInfo_RespondKey_name];
  [aCoder encodeObject:_code             forKey:k_CityInfo_RespondKey_code];
  [aCoder encodeObject:_provinceId       forKey:k_CityInfo_RespondKey_provinceId];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
  if ((self = [super init])) {
    
    // 如果有不需要序列化的属性存在时, 可以在这里先进行初始化
    
    //
    if ([aDecoder containsValueForKey:k_CityInfo_RespondKey_id]) {
      _ID = [[aDecoder decodeObjectForKey:k_CityInfo_RespondKey_id] copy];
    }
    //
    if ([aDecoder containsValueForKey:k_CityInfo_RespondKey_name]) {
      _name = [[aDecoder decodeObjectForKey:k_CityInfo_RespondKey_name] copy];
    }
    //
    if ([aDecoder containsValueForKey:k_CityInfo_RespondKey_code]) {
      _code = [[aDecoder decodeObjectForKey:k_CityInfo_RespondKey_code] copy];
    }
    
    //
    //
    if ([aDecoder containsValueForKey:k_CityInfo_RespondKey_provinceId]) {
      _provinceId = [[aDecoder decodeObjectForKey:k_CityInfo_RespondKey_provinceId] copy];
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

- (NSString *)description {
	return descriptionForDebug(self);
}
@end