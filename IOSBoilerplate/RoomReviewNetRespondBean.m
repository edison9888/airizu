//
//  RoomReviewNetRespondBean.m
//  airizu
//
//  Created by 唐志华 on 13-1-1.
//
//

#import "RoomReviewNetRespondBean.h"

static const NSString *const TAG = @"<RoomReviewNetRespondBean>";

@implementation RoomReviewNetRespondBean

- (void) dealloc {
	PRPLog(@"dealloc: %@ [0x%x]", TAG, [self hash]);
	
  [_reviewCount release];
  [_avgScore release];
  [_reviewItemMap release];
  [_roomReviewList release];
	
	[super dealloc];
}

- (id) initWithReviewCount:(NSNumber *)reviewCount
                  avgScore:(NSString *)avgScore
             reviewItemMap:(NSDictionary *)reviewItemMap
            roomReviewList:(NSArray *)roomReviewList
{
  
  if ((self = [super init])) {
		PRPLog(@"init %@ [0x%x]", TAG, [self hash]);
    
    _reviewCount = [reviewCount copy];
    _avgScore = [avgScore copy];
    _reviewItemMap = [reviewItemMap copy];
    _roomReviewList = [roomReviewList copy];
  }
  
  return self;
}

#pragma mark -
#pragma mark 方便构造

+(id)roomReviewNetRespondBeanWithReviewCount:(NSNumber *)reviewCount
                                    avgScore:(NSString *)avgScore
                               reviewItemMap:(NSDictionary *)reviewItemMap
                              roomReviewList:(NSArray *)roomReviewList {
  
  return [[[RoomReviewNetRespondBean alloc] initWithReviewCount:reviewCount
                                                       avgScore:avgScore
                                                  reviewItemMap:reviewItemMap
                                                 roomReviewList:roomReviewList] autorelease];
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