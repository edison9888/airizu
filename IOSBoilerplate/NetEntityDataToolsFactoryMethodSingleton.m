//
//  NetEntityDataToolsFactoryMethodSingleton.m
//  airizu
//
//  Created by 唐志华 on 12-12-18.
//
//

#import "NetEntityDataToolsFactoryMethodSingleton.h"
#import "NetRequestEntityDataPackageForAirizu.h"
#import "NetRespondEntityDataUnpackAirizu.h"
#import "ServerRespondDataTestAirizu.h"

static const NSString *const TAG = @"<NetEntityDataToolsFactoryMethodSingleton>";

@interface NetEntityDataToolsFactoryMethodSingleton()
@property (nonatomic, retain) id netRequestEntityDataPackageForAirizu;
@property (nonatomic, retain) id netRespondEntityDataUnpackAirizu;
@property (nonatomic, retain) id serverRespondDataTestAirizu;
@end

@implementation NetEntityDataToolsFactoryMethodSingleton

static NetEntityDataToolsFactoryMethodSingleton *singletonInstance = nil;

- (void) initialize {
  _netRequestEntityDataPackageForAirizu = [[NetRequestEntityDataPackageForAirizu alloc] init];
  _netRespondEntityDataUnpackAirizu = [[NetRespondEntityDataUnpackAirizu alloc] init];
  _serverRespondDataTestAirizu = [[ServerRespondDataTestAirizu alloc] init];
}

#pragma mark -
#pragma mark 单例方法群

+ (NetEntityDataToolsFactoryMethodSingleton *) sharedInstance
{
  if (singletonInstance == nil)
  {
    singletonInstance = [[super allocWithZone:NULL] init];
    
    // initialize the first view controller
    // and keep it with the singleton
    [singletonInstance initialize];
  }
  
  return singletonInstance;
}

+ (id) allocWithZone:(NSZone *)zone
{
  return [[self sharedInstance] retain];
}

- (id) copyWithZone:(NSZone*)zone
{
  return self;
}

- (id) retain
{
  return self;
}

- (NSUInteger) retainCount
{
  return NSUIntegerMax;
}

- (oneway void) release
{
  // do nothing
}

- (id) autorelease
{
  return self;
}


#pragma mark
#pragma mark 实现 INetEntityDataTools 接口的方法
- (id<INetRequestEntityDataPackage>) getNetRequestEntityDataPackage {
  return _netRequestEntityDataPackageForAirizu;
}
- (id<INetRespondRawEntityDataUnpack>) getNetRespondEntityDataUnpack {
  return _netRespondEntityDataUnpackAirizu;
}
- (id<IServerRespondDataTest>) getServerRespondDataTest {
  return _serverRespondDataTestAirizu;
}
@end
