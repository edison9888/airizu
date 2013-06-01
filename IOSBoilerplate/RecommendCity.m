//
//  RecommendCity.m
//  airizu
//
//  Created by 唐志华 on 12-12-25.
//
//

#import "RecommendCity.h"
#import "RecommendCityDatabaseFieldsConstant.h"

static const NSString *const TAG = @"<RecommendCity>";

@implementation RecommendCity

- (void) dealloc {
	PRPLog(@"dealloc: %@ [0x%x]", TAG, [self hash]);
	
  [_ID release];
  [_cityName release];
  [_cityId release];
  [_image release];
  [_sort release];
  [_street1Name release];
  [_street1Id release];
  [_street2Name release];
  [_street2Id release];
  
  /// 20130312 add
  [_street1SimName release];
  [_street2SimName release];
	
	[super dealloc];
}

- (id) initWithID:(NSNumber *) ID
         cityName:(NSString *) cityName
           cityId:(NSNumber *) cityId
            image:(NSString *) image
             sort:(NSNumber *) sort
      street1Name:(NSString *) street1Name
        street1Id:(NSNumber *) street1Id
      street2Name:(NSString *) street2Name
        street2Id:(NSNumber *) street2Id
   street1SimName:(NSString *) street1SimName
   street2SimName:(NSString *) street2SimName {
  
  if ((self = [super init])) {
    
    PRPLog(@"init %@ [0x%x]", TAG, [self hash]);
    
    _ID          = [ID copy];
    _cityName    = [cityName copy];
    _cityId      = [cityId copy];
    _image       = [image copy];
    _sort        = [sort copy];
    _street1Name = [street1Name copy];
    _street1Id   = [street1Id copy];
    _street2Name = [street2Name copy];
    _street2Id   = [street2Id copy];
    
    /// 20130312 add
    _street1SimName   = [street1SimName copy];
    _street2SimName   = [street2SimName copy];
    
  }
  
  return self;
}

#pragma mark -
#pragma mark 方便构造
+(id)recommendCityWithID:(NSNumber *) ID
                cityName:(NSString *) cityName
                  cityId:(NSNumber *) cityId
                   image:(NSString *) image
                    sort:(NSNumber *) sort
             street1Name:(NSString *) street1Name
               street1Id:(NSNumber *) street1Id
             street2Name:(NSString *) street2Name
               street2Id:(NSNumber *) street2Id
          street1SimName:(NSString *) street1SimName
          street2SimName:(NSString *) street2SimName{
  
  RecommendCity *recommendCity
  = [[RecommendCity alloc] initWithID:ID
                             cityName:cityName
                               cityId:cityId
                                image:image
                                 sort:sort
                          street1Name:street1Name
                            street1Id:street1Id
                          street2Name:street2Name
                            street2Id:street2Id
                       street1SimName:street1SimName
                       street2SimName:street2SimName];
  return [recommendCity autorelease];
}

- (NSString *)description {
	return descriptionForDebug(self);
}

#pragma mark -
#pragma mark 实现 NSCoding 接口
- (void)encodeWithCoder:(NSCoder *)aCoder {
  [aCoder encodeObject:_ID          forKey:kRecommendCity_RespondKey_id];
  [aCoder encodeObject:_cityName    forKey:kRecommendCity_RespondKey_cityName];
  [aCoder encodeObject:_cityId      forKey:kRecommendCity_RespondKey_cityId];
  [aCoder encodeObject:_image       forKey:kRecommendCity_RespondKey_image];
  [aCoder encodeObject:_sort        forKey:kRecommendCity_RespondKey_sort];
  [aCoder encodeObject:_street1Name forKey:kRecommendCity_RespondKey_street1Name];
  [aCoder encodeObject:_street1Id   forKey:kRecommendCity_RespondKey_street1Id];
  [aCoder encodeObject:_street2Name forKey:kRecommendCity_RespondKey_street2Name];
  [aCoder encodeObject:_street2Id   forKey:kRecommendCity_RespondKey_street2Id];
  /// 20130312 add
  [aCoder encodeObject:_street1SimName   forKey:kRecommendCity_RespondKey_street1SimName];
  [aCoder encodeObject:_street2SimName   forKey:kRecommendCity_RespondKey_street2SimName];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
  if ((self = [super init])) {
    
    // 如果有不需要序列化的属性存在时, 可以在这里先进行初始化
    
    //
    if ([aDecoder containsValueForKey:kRecommendCity_RespondKey_id]) {
      _ID = [[aDecoder decodeObjectForKey:kRecommendCity_RespondKey_id] copy];
    }
    if ([aDecoder containsValueForKey:kRecommendCity_RespondKey_cityName]) {
      _cityName = [[aDecoder decodeObjectForKey:kRecommendCity_RespondKey_cityName] copy];
    }
    if ([aDecoder containsValueForKey:kRecommendCity_RespondKey_cityId]) {
      _cityId = [[aDecoder decodeObjectForKey:kRecommendCity_RespondKey_cityId] copy];
    }
    if ([aDecoder containsValueForKey:kRecommendCity_RespondKey_image]) {
      _image = [[aDecoder decodeObjectForKey:kRecommendCity_RespondKey_image] copy];
    }
    if ([aDecoder containsValueForKey:kRecommendCity_RespondKey_sort]) {
      _sort = [[aDecoder decodeObjectForKey:kRecommendCity_RespondKey_sort] copy];
    }
    if ([aDecoder containsValueForKey:kRecommendCity_RespondKey_street1Name]) {
      _street1Name = [[aDecoder decodeObjectForKey:kRecommendCity_RespondKey_street1Name] copy];
    }
    if ([aDecoder containsValueForKey:kRecommendCity_RespondKey_street1Id]) {
      _street1Id = [[aDecoder decodeObjectForKey:kRecommendCity_RespondKey_street1Id] copy];
    }
    if ([aDecoder containsValueForKey:kRecommendCity_RespondKey_street2Name]) {
      _street2Name = [[aDecoder decodeObjectForKey:kRecommendCity_RespondKey_street2Name] copy];
    }
    if ([aDecoder containsValueForKey:kRecommendCity_RespondKey_street2Id]) {
      _street2Id = [[aDecoder decodeObjectForKey:kRecommendCity_RespondKey_street2Id] copy];
    }
    
    /// 20130312 add
    if ([aDecoder containsValueForKey:kRecommendCity_RespondKey_street1SimName]) {
      _street1SimName = [[aDecoder decodeObjectForKey:kRecommendCity_RespondKey_street1SimName] copy];
    }
    if ([aDecoder containsValueForKey:kRecommendCity_RespondKey_street2SimName]) {
      _street2SimName = [[aDecoder decodeObjectForKey:kRecommendCity_RespondKey_street2SimName] copy];
    }
    
  }
  
  return self;
}

#pragma mark -
#pragma mark 不能使用默认的init方法初始化对象, 而必须使用当前类特定的 "初始化方法" 初始化所有参数
- (id) init {
  NSAssert(NO, @"Can not use the default init method!");
  
  return nil;
}
@end
