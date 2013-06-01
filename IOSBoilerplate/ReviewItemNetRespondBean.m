//
//  ReviewItemNetRespondBean.m
//  airizu
//
//  Created by 唐志华 on 13-1-1.
//
//

#import "ReviewItemNetRespondBean.h"

static const NSString *const TAG = @"<ReviewItemNetRespondBean>";

@implementation ReviewItemNetRespondBean

- (void) dealloc {
	PRPLog(@"dealloc: [0x%x]", [self hash]);
	
  [_itemList release];
  
	[super dealloc];
}

-(id)initWithItemList:(NSArray *)itemList {
  
  if ((self = [super init])) {
		PRPLog(@"init [0x%x]", [self hash]);
    
    _itemList = [itemList copy];
    
  }
  
  return self;
}

#pragma mark -
#pragma mark 方便构造

+(id)reviewItemNetRespondBeanWithItemList:(NSArray *)itemList {
  return [[[ReviewItemNetRespondBean alloc] initWithItemList:itemList] autorelease];
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