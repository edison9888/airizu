//
//  CitysNetRespondBean.h
//  airizu
//
//  Created by 唐志华 on 13-1-1.
//
//

#import <Foundation/Foundation.h>

// 热门城市列表
UIKIT_EXTERN NSString *const kNSCodingKeyCitys_topCitys;
// 普通城市列表
UIKIT_EXTERN NSString *const kNSCodingKeyCitys_cityInfoList;

@interface CitysNetRespondBean : NSObject <NSCoding> {
  
}

// 所有城市
@property (nonatomic, readonly) NSArray *cityInfoList;
// 热门城市
@property (nonatomic, readonly) NSArray *topCitys;

#pragma mark -
#pragma mark 方便构造

+(id)citysNetRespondBeanWithCityInfoList:(NSArray *)cityInfoList topCitys:(NSArray *)topCitys;

#pragma mark -
#pragma mark 实现 NSCoding 接口
- (void)encodeWithCoder:(NSCoder *)aCoder;
- (id)initWithCoder:(NSCoder *)aDecoder;
@end
