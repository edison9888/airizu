//
//  GlobalConstant.h
//  airizu
//
//  Created by 唐志华 on 12-12-17.
//
//

#import <Foundation/Foundation.h>

@interface GlobalDataCacheForDataDictionary : NSObject {
  
}

+ (GlobalDataCacheForDataDictionary *) sharedInstance;

@property (nonatomic, readonly) NSDictionary *dataSourceForPhotoGetTypeList;
// 入住人数
@property (nonatomic, readonly) NSDictionary *dataSourceForOccupancyCountList;
// 房间价格
@property (nonatomic, readonly) NSDictionary *dataSourceForPriceDifferenceList;
// 房源距离
@property (nonatomic, readonly) NSDictionary *dataSourceForDistanceList;
// 房源排序
@property (nonatomic, readonly) NSDictionary *dataSourceForSortTypeList;
@end
