//
//  NetRespondEvent.m
//  airizu
//
//  Created by 唐志华 on 12-12-18.
//
//

#import "NetRespondEvent.h"

static const NSString *const TAG = @"<NetRespondEvent>";

@interface NetRespondEvent()
@property (nonatomic, readwrite, assign) NSInteger threadID;
@property (nonatomic, readwrite, retain) NSData *netRespondRawEntityData;
@property (nonatomic, readwrite, retain) NetErrorBean *netError;
@end

@implementation NetRespondEvent

- (void) dealloc {
  PRPLog(@"dealloc: %@ [0x%x]", TAG, [self hash]);
  
  [_netRespondRawEntityData release];
  [_netError release];
  
  [super dealloc];
}

- (id) initWithThreadID:(NSInteger)threadID
netRespondRawEntityData:(NSData *)netRespondRawEntityData
               netError:(NetErrorBean *)netError {
  
  if ((self = [super init])) {
		PRPLog(@"init %@ [0x%x]", TAG, [self hash]);
    
    self.threadID                = threadID;
    self.netRespondRawEntityData = netRespondRawEntityData;
    self.netError                = netError;
  }
  
  return self;
}

#pragma mark -
#pragma mark 方便构造
+(id)netRespondEventWithThreadID:(NSInteger)threadID
         netRespondRawEntityData:(NSData *)netRespondRawEntityData
                        netError:(NetErrorBean *)netError {
  
  return [[[NetRespondEvent alloc] initWithThreadID:threadID
                            netRespondRawEntityData:netRespondRawEntityData
                                           netError:netError] autorelease];
}

#pragma mark
#pragma mark 不能使用默认的init方法初始化对象, 而必须使用当前类特定的 "初始化方法" 初始化所有参数
- (id) init {
  NSAssert(NO, @"Can not use the default init method!");
  
  return nil;
}

@end
