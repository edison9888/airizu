//
//  GlobalConstant.m
//  airizu
//
//  Created by 唐志华 on 12-12-17.
//
//

#import "GlobalDataCacheForDataDictionary.h"

static const NSString *const TAG = @"<GlobalDataCacheForDataDictionary>";

@implementation GlobalDataCacheForDataDictionary

- (void) initDataSourceForPhotoGetTypeList:(OrderedDictionary *) dictionary {
  [dictionary insertObject:@"PICK" forKey:@"调用相册" atIndex:0];
  [dictionary insertObject:@"IMAGE_CAPTURE" forKey:@"调用照相机" atIndex:1];
}

- (void) initDataSourceForOccupancyCountList:(OrderedDictionary *) dictionary {
  
  int i = 0;
  [dictionary insertObject:@"1" forKey:@"1人" atIndex:i++];
  [dictionary insertObject:@"2" forKey:@"2人" atIndex:i++];
  [dictionary insertObject:@"3" forKey:@"3人" atIndex:i++];
  [dictionary insertObject:@"4" forKey:@"4人" atIndex:i++];
  [dictionary insertObject:@"5" forKey:@"5人" atIndex:i++];
  [dictionary insertObject:@"6" forKey:@"6人" atIndex:i++];
  [dictionary insertObject:@"7" forKey:@"7人" atIndex:i++];
  [dictionary insertObject:@"8" forKey:@"8人" atIndex:i++];
  [dictionary insertObject:@"9" forKey:@"9人" atIndex:i++];
  [dictionary insertObject:@"10" forKey:@"10人以上" atIndex:i++];
}

- (void) initDataSourceForPriceDifferenceList:(OrderedDictionary *) dictionary {
  
  int i = 0;
  [dictionary insertObject:@"0-100" forKey:@"100元以下" atIndex:i++];
  [dictionary insertObject:@"100-200" forKey:@"100-200元" atIndex:i++];
  [dictionary insertObject:@"200-300" forKey:@"200-300元" atIndex:i++];
  [dictionary insertObject:@"300" forKey:@"300元以上" atIndex:i++];
  
}

- (void) initDataSourceForDistanceList:(OrderedDictionary *) dictionary {
  
  int i = 0;
  [dictionary insertObject:@"500" forKey:@"500米" atIndex:i++];
  [dictionary insertObject:@"1000" forKey:@"1000米" atIndex:i++];
  [dictionary insertObject:@"3000" forKey:@"3000米" atIndex:i++];
  
}

- (void) initDataSourceForSortTypeList:(OrderedDictionary *) dictionary {
  
  int i = 0;
  [dictionary insertObject:kRoomListOrderType_OrderByAirizuCommend forKey:@"爱日租推荐" atIndex:i++];
  [dictionary insertObject:kRoomListOrderType_OrderByPriceHeightToLow forKey:@"价格从高到低" atIndex:i++];
  [dictionary insertObject:kRoomListOrderType_OrderByPriceLowToHeight forKey:@"价格从低到高" atIndex:i++];
  [dictionary insertObject:kRoomListOrderType_OrderByCommendNumber forKey:@"评论从高到低" atIndex:i++];
  [dictionary insertObject:kRoomListOrderType_OrderByDistance forKey:@"距离由近到远" atIndex:i++];
  
}

static GlobalDataCacheForDataDictionary *singletonInstance = nil;

- (void) initialize {
  @synchronized(self) {
    //
    _dataSourceForPhotoGetTypeList = [[OrderedDictionary alloc] init];
    [self initDataSourceForPhotoGetTypeList:(OrderedDictionary *)_dataSourceForPhotoGetTypeList];
    
    // 入住人数
    _dataSourceForOccupancyCountList = [[OrderedDictionary alloc] init];
    [self initDataSourceForOccupancyCountList:(OrderedDictionary *)_dataSourceForOccupancyCountList];
    
    // 价格差异
    _dataSourceForPriceDifferenceList = [[OrderedDictionary alloc] init];
    [self initDataSourceForPriceDifferenceList:(OrderedDictionary *)_dataSourceForPriceDifferenceList];
    
    // 房源距离
    _dataSourceForDistanceList = [[OrderedDictionary alloc] init];
    [self initDataSourceForDistanceList:(OrderedDictionary *)_dataSourceForDistanceList];
    
    // 房源排序
    _dataSourceForSortTypeList = [[OrderedDictionary alloc] init];
    [self initDataSourceForSortTypeList:(OrderedDictionary *)_dataSourceForSortTypeList];
  }
}

#pragma mark -
#pragma mark 单例方法群

+ (GlobalDataCacheForDataDictionary *) sharedInstance
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
@end
