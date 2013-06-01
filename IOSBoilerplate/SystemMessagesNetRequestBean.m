//
//  SystemMessagesNetRequestBean.m
//  airizu
//
//  Created by 唐志华 on 13-1-1.
//
//

#import "SystemMessagesNetRequestBean.h"

static const NSString *const TAG = @"<SystemMessagesNetRequestBean>";

@implementation SystemMessagesNetRequestBean

- (void) dealloc {
	PRPLog(@"dealloc: %@ [0x%x]", TAG, [self hash]);
	
  [_pageNum release];
  
	[super dealloc];
}

- (id) initWithPageNum:(NSNumber *) pageNum {
  
  if ((self = [super init])) {
		PRPLog(@"init %@ [0x%x]", TAG, [self hash]);
    
    _pageNum = [pageNum copy];
    
  }
  
  return self;
}

#pragma mark -
#pragma mark 方便构造

+(id)systemMessagesNetRequestBeanWithPageNum:(NSNumber *)pageNum {
  return [[[SystemMessagesNetRequestBean alloc] initWithPageNum:pageNum] autorelease];
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