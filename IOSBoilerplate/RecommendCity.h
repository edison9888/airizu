//
//  RecommendCity.h
//  airizu
//
//  Created by 唐志华 on 12-12-25.
//
//

#import <Foundation/Foundation.h>

@interface RecommendCity : NSObject <NSCoding> {
  
}

// 编号
@property (nonatomic, readonly) NSNumber *ID;
// 城市名称
@property (nonatomic, readonly) NSString *cityName;
// 城市id
@property (nonatomic, readonly) NSNumber *cityId;
// 对应图片地址
@property (nonatomic, readonly) NSString *image;
// 排序
@property (nonatomic, readonly) NSNumber *sort;

/// 这里的地标名称只是用于显示在 地标按钮 中的文字信息, 不要把这个字段传给后台. (例如 "国贸商圈精品短租")
// 地标1 名称
@property (nonatomic, readonly) NSString *street1Name;
// 地标1 编号
@property (nonatomic, readonly) NSNumber *street1Id;
// 地标2名称
@property (nonatomic, readonly) NSString *street2Name;
// 地标2编号
@property (nonatomic, readonly) NSNumber *street2Id;

/// 这里是真实的地标名称(例如 "国贸"), 需要把这个数据传给后台 20130312 add
//
@property (nonatomic, readonly) NSString *street1SimName;
//
@property (nonatomic, readonly) NSString *street2SimName;

#pragma mark -
#pragma mark 方便构造
+(id)recommendCityWithID:(NSNumber *) ID
                cityName:(NSString *) cityName
                  cityId:(NSNumber *) cityId
                   image:(NSString *) image
                    sort:(NSNumber *) sort
             street1Name:(NSString *) street1Name
               street1Id:(NSNumber *) street1Id
             street2Name:(NSString *) street2Name
               street2Id:(NSNumber *) street2Id
          street1SimName:(NSString *) street1SimName
          street2SimName:(NSString *) street2SimName;

#pragma mark -
#pragma mark 实现 NSCoding 接口
- (void)encodeWithCoder:(NSCoder *)aCoder;
- (id)initWithCoder:(NSCoder *)aDecoder;
@end

