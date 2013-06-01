//
//  DistrictsNetRespondBean.h
//  airizu
//
//  Created by 唐志华 on 13-1-1.
//
//

#import <Foundation/Foundation.h>

@interface DistrictsNetRespondBean : NSObject {
  
}

@property (nonatomic, readonly) NSArray *districtInfoList;

#pragma mark -
#pragma mark 方便构造
+(id)districtsNetRespondBeanWithDistrictInfoList:(NSArray *)districtInfoList;
@end
