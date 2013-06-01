//
//  RoomSearchNetRespondBean.m
//  airizu
//
//  Created by 唐志华 on 12-12-28.
//
//

#import "RoomSearchNetRespondBean.h"
#import "RoomInfo.h"

static const NSString *const TAG = @"<RoomSearchNetRespondBean>";

@implementation RoomSearchNetRespondBean

- (void) dealloc {
	PRPLog(@"dealloc: %@ [0x%x]", TAG, [self hash]);
	[_roomCount release];
  [_roomInfoList release];
	
	[super dealloc];
}

- (id) initWithRoomInfoList:(NSArray *) roomInfoList
              withRoomCount:(NSNumber *) roomCount {
  
  if ((self = [super init])) {
    PRPLog(@"init %@ [0x%x]", TAG, [self hash]);
    
    _roomInfoList = [roomInfoList copy];
    _roomCount = [roomCount copy];

  }
  
  return self;
}

- (NSString *)description {
	return descriptionForDebug(self);
}

#pragma mark
#pragma mark 不能使用默认的init方法初始化对象, 而必须使用当前类特定的 "初始化方法" 初始化所有参数
- (id) init {
  NSAssert(NO, @"Can not use the default init method!");
  
  return nil;
}

#pragma mark -
#pragma mark 方便构造
+ (id) roomSearchNetRespondBeanWithRoomInfoList:(NSArray *) roomInfoList
                                  withRoomCount:(NSNumber *) roomCount {
  return [[[RoomSearchNetRespondBean alloc] initWithRoomInfoList:roomInfoList
                                                   withRoomCount:roomCount] autorelease];
}
@end