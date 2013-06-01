//
//  DistrictsNetRespondBean.m
//  airizu
//
//  Created by 唐志华 on 13-1-1.
//
//

#import "DistrictsNetRespondBean.h"

static const NSString *const TAG = @"<DistrictsNetRespondBean>";

@implementation DistrictsNetRespondBean

- (void) dealloc {
	PRPLog(@"dealloc: %@ [0x%x]", TAG, [self hash]);
	
  [_districtInfoList release];
  
	[super dealloc];
}

- (id) initWithDistrictInfoList:(NSArray *) districtInfoList {
  
  if ((self = [super init])) {
		PRPLog(@"init %@ [0x%x]", TAG, [self hash]);
    
    _districtInfoList = [districtInfoList copy];
    
  }
  
  return self;
}


- (NSString *)description {
	return descriptionForDebug(self);
}

#pragma mark -
#pragma mark 方便构造
+(id)districtsNetRespondBeanWithDistrictInfoList:(NSArray *)districtInfoList {
  return [[[DistrictsNetRespondBean alloc] initWithDistrictInfoList:districtInfoList] autorelease];
}

#pragma mark
#pragma mark 不能使用默认的init方法初始化对象, 而必须使用当前类特定的 "初始化方法" 初始化所有参数
- (id) init {
  NSAssert(NO, @"Can not use the default init method!");
  
  return nil;
}

@end