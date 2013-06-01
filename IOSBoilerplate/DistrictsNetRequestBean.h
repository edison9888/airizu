//
//  DistrictsNetRequestBean.h
//  airizu
//
//  Created by 唐志华 on 13-1-1.
//
//

#import <Foundation/Foundation.h>

@interface DistrictsNetRequestBean : NSObject {
  
}

@property (nonatomic, readonly) NSString *cityId;

#pragma mark -
#pragma mark 方便构造
+(id)districtsNetRequestBeanWithCityId:(NSString *)cityId;
@end
