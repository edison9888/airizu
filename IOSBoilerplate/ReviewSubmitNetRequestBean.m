//
//  ReviewSubmitNetRequestBean.m
//  airizu
//
//  Created by 唐志华 on 13-1-1.
//
//

#import "ReviewSubmitNetRequestBean.h"


static const NSString *const TAG = @"<ReviewSubmitNetRequestBean>";

@implementation ReviewSubmitNetRequestBean

- (void) dealloc {
	PRPLog(@"dealloc: %@ [0x%x]", TAG, [self hash]);
	
  [_orderId release];
  [_reviewContent release];
  [_reviewItemScoreList release];
	
	[super dealloc];
}

- (id) initWithOrderId:(NSString *)orderId
         reviewContent:(NSString *)reviewContent
   reviewItemScoreList:(NSDictionary *)reviewItemScoreList
{
  
  if ((self = [super init])) {
		PRPLog(@"init %@ [0x%x]", TAG, [self hash]);
    
    _orderId = [orderId copy];
    _reviewContent = [reviewContent copy];
    _reviewItemScoreList = [reviewItemScoreList copy];
    
  }
  
  return self;
}

#pragma mark -
#pragma mark 方便构造

+(id)reviewSubmitNetRequestBeanWithOrderId:(NSString *)orderId
                             reviewContent:(NSString *)reviewContent
                       reviewItemScoreList:(NSDictionary *)reviewItemScoreList {
  return [[[ReviewSubmitNetRequestBean alloc] initWithOrderId:orderId
                                                reviewContent:reviewContent
                                          reviewItemScoreList:reviewItemScoreList] autorelease];
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