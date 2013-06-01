//
//  CitysNetRespondBean.m
//  airizu
//
//  Created by 唐志华 on 13-1-1.
//
//

#import "CitysNetRespondBean.h"
#import "CitysDatabaseFieldsConstant.h"

static const NSString *const TAG = @"<CitysNetRespondBean>";

// 热门城市列表
NSString *const kNSCodingKeyCitys_topCitys = @"topCitys";
// 普通城市列表
NSString *const kNSCodingKeyCitys_cityInfoList = @"cityInfoList";

@implementation CitysNetRespondBean

- (void) dealloc {
	PRPLog(@"dealloc: %@ [0x%x]", TAG, [self hash]);
	
  [_cityInfoList release];
  [_topCitys release];
  
	[super dealloc];
}

-(id)initWithCityInfoList:(NSArray *)cityInfoList topCitys:(NSArray *)topCitys{
  
  if ((self = [super init])) {
		PRPLog(@"init %@ [0x%x]", TAG, [self hash]);
    
    _cityInfoList = [cityInfoList copy];
    _topCitys = [topCitys copy];
  }
  
  return self;
}

#pragma mark -
#pragma mark 方便构造

+(id)citysNetRespondBeanWithCityInfoList:(NSArray *)cityInfoList topCitys:(NSArray *)topCitys{
  return [[[CitysNetRespondBean alloc] initWithCityInfoList:cityInfoList topCitys:topCitys] autorelease];
}

#pragma mark -
#pragma mark 实现 NSCoding 接口
- (void)encodeWithCoder:(NSCoder *)aCoder {
  
  //
  [aCoder encodeObject:_topCitys forKey:kNSCodingKeyCitys_topCitys];
  //
  [aCoder encodeObject:_cityInfoList forKey:kNSCodingKeyCitys_cityInfoList];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
  if ((self = [super init])) {
    
    // 如果有不需要序列化的属性存在时, 可以在这里先进行初始化
    
    //
    if ([aDecoder containsValueForKey:kNSCodingKeyCitys_topCitys]) {
      _topCitys = [[aDecoder decodeObjectForKey:kNSCodingKeyCitys_topCitys] copy];
    }
    
    //
    if ([aDecoder containsValueForKey:kNSCodingKeyCitys_cityInfoList]) {
      _cityInfoList = [[aDecoder decodeObjectForKey:kNSCodingKeyCitys_cityInfoList] copy];
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