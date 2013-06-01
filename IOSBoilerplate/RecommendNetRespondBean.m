//
//  RecommendNetRespondBean.m
//  airizu
//
//  Created by 唐志华 on 12-12-25.
//
//

#import "RecommendNetRespondBean.h"
#import "RecommendCity.h"

static const NSString *const TAG = @"<RecommendNetRespondBean>";

@implementation RecommendNetRespondBean

- (void) dealloc {
	PRPLog(@"dealloc: %@ [0x%x]", TAG, [self hash]);
	[_recommendCityList release];
	
	[super dealloc];
}

- (id) initWithRecommendCityList:(NSArray *) recommendCityList {
  
  if ((self = [super init])) {
    
    PRPLog(@"init %@ [0x%x]", TAG, [self hash]);
    
    _recommendCityList = [recommendCityList copy];

  }
  
  return self;
}

- (NSString *)description {
	return descriptionForDebug(self);
}

#pragma mark -
#pragma mark 方便构造
+(id)recommendNetRespondBeanWithRecommendCityList:(NSArray *)recommendCityList {
  RecommendNetRespondBean *recommendNetRespondBean = [[RecommendNetRespondBean alloc] initWithRecommendCityList:recommendCityList];
  return [recommendNetRespondBean autorelease];
}

#pragma mark -
#pragma mark 实现 NSCoding 接口
- (void)encodeWithCoder:(NSCoder *)aCoder {
  [aCoder encodeObject:_recommendCityList forKey:kNSCodingKeyRecommendCity_recommendCityList];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
  if (self = [super init]) {
    
    _recommendCityList = [[aDecoder decodeObjectForKey:kNSCodingKeyRecommendCity_recommendCityList] copy];
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

