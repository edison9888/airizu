//
//  NetRequestEvent.m
//  airizu
//
//  Created by 唐志华 on 12-12-18.
//
//

#import "NetRequestEvent.h"
#import "IDomainNetRespondCallback.h"

static const NSString *const TAG = @"<NetRequestEvent>";

@interface NetRequestEvent()

// 当前业务网络请求事件对应的 下载线程的线程ID
@property (nonatomic, readwrite, assign) NSInteger threadID;
// 将 "网络请求业务Bean" 的 getClassName() 作为和这个业务Bean对应的抽象工厂产品的唯一识别Key
@property (nonatomic, readwrite, copy) NSString *abstractFactoryMappingKey;
// 控制层 对此次网络请求的标识
@property (nonatomic, readwrite, assign) NSUInteger requestEventEnum;
// 控制层 的代理对象(也就是 具体的 Activity 对象, 这里目前一定要 retain, 将来这里可以改为 week)
@property (nonatomic, readwrite, retain) id<IDomainNetRespondCallback> netRespondDelegate;
// Http请求参数集合
@property (nonatomic, readwrite, retain) NSDictionary *httpRequestParameterMap;

@end

@implementation NetRequestEvent

- (void) dealloc {
  PRPLog(@"dealloc: %@ [0x%x]", TAG, [self hash]);
  
  [_abstractFactoryMappingKey release];
  [_netRespondDelegate release];
  [_httpRequestParameterMap release];
  
  [super dealloc];
}

-(id)    initWithThreadID:(NSInteger)threadID
abstractFactoryMappingKey:(NSString *)abstractFactoryMappingKey
         requestEventEnum:(NSUInteger)requestEventEnum
       netRespondDelegate:(id<IDomainNetRespondCallback>)netRespondDelegate
  httpRequestParameterMap:(NSDictionary *)httpRequestParameterMap {
  
  if ((self = [super init])) {
		PRPLog(@"init %@ [0x%x]", TAG, [self hash]);
    
    self.threadID                  = threadID;
    self.abstractFactoryMappingKey = abstractFactoryMappingKey;
    self.requestEventEnum          = requestEventEnum;
    self.netRespondDelegate        = netRespondDelegate;
    self.httpRequestParameterMap   = [NSDictionary dictionaryWithDictionary:httpRequestParameterMap];
  }
  
  return self;
}

#pragma mark -
#pragma mark 方便构造
+(id)netRequestEventWithThreadID:(NSInteger)threadID
       abstractFactoryMappingKey:(NSString *)abstractFactoryMappingKey
                requestEventEnum:(NSUInteger)requestEventEnum
              netRespondDelegate:(id<IDomainNetRespondCallback>)netRespondDelegate
         httpRequestParameterMap:(NSDictionary *)httpRequestParameterMap {
  
  return [[[NetRequestEvent alloc] initWithThreadID:threadID
                          abstractFactoryMappingKey:abstractFactoryMappingKey
                                   requestEventEnum:requestEventEnum
                                 netRespondDelegate:netRespondDelegate
                            httpRequestParameterMap:httpRequestParameterMap] autorelease];
}

#pragma mark
#pragma mark 不能使用默认的init方法初始化对象, 而必须使用当前类特定的 "初始化方法" 初始化所有参数
- (id) init {
  NSAssert(NO, @"Can not use the default init method!");
  
  return nil;
}




@end
