//
//  RecommendNetRespondBean.h
//  airizu
//
//  Created by 唐志华 on 12-12-25.
//
//

#import <Foundation/Foundation.h>

#define kNSCodingKeyRecommendCity_recommendCityList @"recommendCityList"

@class RecommendCity;
@interface RecommendNetRespondBean : NSObject <NSCoding> {
  
}

@property (nonatomic, readonly) NSArray *recommendCityList;

#pragma mark -
#pragma mark 方便构造
+(id)recommendNetRespondBeanWithRecommendCityList:(NSArray *)recommendCityList;

#pragma mark -
#pragma mark 实现 NSCoding 接口
- (void)encodeWithCoder:(NSCoder *)aCoder;
- (id)initWithCoder:(NSCoder *)aDecoder;
@end
