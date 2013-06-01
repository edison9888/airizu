//
//  RoomDetailNetRespondBean.h
//  airizu
//
//  Created by 唐志华 on 13-1-1.
//
//

#import <Foundation/Foundation.h>

@interface RoomDetailNetRespondBean : NSObject <NSCoding> {
  
}

// 房间编号
@property (nonatomic, readonly) NSNumber *number;

// 用户编号
@property (nonatomic, readonly) NSNumber *userId;
// 建筑面积
@property (nonatomic, readonly) NSNumber *size;
// 房间默认图片
@property (nonatomic, readonly) NSString *image;
// 每晚价钱
@property (nonatomic, readonly) NSNumber *price;
// 房间标题
@property (nonatomic, readonly) NSString *title;
// 房间地址
@property (nonatomic, readonly) NSString *address;
// 百度经度
@property (nonatomic, readonly) NSNumber *len;
// 百度纬度
@property (nonatomic, readonly) NSNumber *lat;

// 曾被预定
@property (nonatomic, readonly) NSNumber *scheduled;
// 卧室数
@property (nonatomic, readonly) NSString *bedRoom;
// 交易规则
@property (nonatomic, readonly) NSString *ruleContent;
// 清洁服务类型
@property (nonatomic, readonly) NSString *clean;
// 房间概括
@property (nonatomic, readonly) NSString *roomDescription;
// 可入住人数
@property (nonatomic, readonly) NSNumber *accommodates;
// 使用规则
@property (nonatomic, readonly) NSString *roomRule;
// 卫浴类型
@property (nonatomic, readonly) NSString *restRoom;
// 是否提供发票1为是,2为否
@property (nonatomic, readonly) BOOL tickets;
// 退订条款
@property (nonatomic, readonly) NSString *cancellation;
// 最少天数
@property (nonatomic, readonly) NSNumber *minNights;
// 租住方式
@property (nonatomic, readonly) NSString *privacy;
// 退房时间
@property (nonatomic, readonly) NSString *checkOutTime;
// 最多天数
@property (nonatomic, readonly) NSNumber *maxNights;
// 床数
@property (nonatomic, readonly) NSNumber *beds;
// 房屋类型
@property (nonatomic, readonly) NSString *propertyType;
// 床型
@property (nonatomic, readonly) NSString *bedType;
// 卫生间数
@property (nonatomic, readonly) NSString *bathRoomNum;


// 租客点评总分
@property (nonatomic, readonly) NSNumber *review;
// 租客点评总条数
@property (nonatomic, readonly) NSNumber *reviewCount;
// 租客点评列表，这里只显示1条记录
@property (nonatomic, readonly) NSString *reviewContent;


// 是否是 "100%验证房"
@property (nonatomic, readonly) BOOL isVerify;
@property (nonatomic, readonly) NSString *verifyDescription;
// 是否是 "特价房"  
@property (nonatomic, readonly) BOOL isSpecial;
@property (nonatomic, readonly) NSString *specialDescription;
// 是否是 "速订房" 
@property (nonatomic, readonly) BOOL isSpeed;
@property (nonatomic, readonly) NSString *speedDescription;
// 是否是 "精品房"
@property (nonatomic, readonly) BOOL isBoutique;
@property (nonatomic, readonly) NSString *boutiqueDescription;

// 介绍字符串
@property (nonatomic, readonly) NSString *introduction;

// 大图地址列表
@property (nonatomic, readonly) NSArray *imageM;
// 缩略图地址列表
@property (nonatomic, readonly) NSArray *imageS;
// 配套设施列表
@property (nonatomic, readonly) NSArray *equipmentList;

// 房间套数
@property (nonatomic, readonly) NSNumber *roomNumber;

// 当前房间是否包含有房间特色, 这里是业务的体现, 如果增加新的房间特色, 要修改这里
-(BOOL)isHaveRoomFeatures;

#pragma mark -
#pragma mark 方便构造

+(id)roomDetailNetRespondBeanWithNumber:(NSNumber *)number
                                 userId:(NSNumber *)userId
                                   size:(NSNumber *)size
                                  image:(NSString *)image
                                  price:(NSNumber *)price
                                  title:(NSString *)title
                                address:(NSString *)address
                                    len:(NSNumber *)len
                                    lat:(NSNumber *)lat
                              scheduled:(NSNumber *)scheduled
                                bedRoom:(NSString *)bedRoom
                            ruleContent:(NSString *)ruleContent
                                  clean:(NSString *)clean
                            description:(NSString *)description
                           accommodates:(NSNumber *)accommodates
                               roomRule:(NSString *)roomRule
                               restRoom:(NSString *)restRoom
                                tickets:(BOOL)tickets
                           cancellation:(NSString *)cancellation
                              minNights:(NSNumber *)minNights
                                privacy:(NSString *)privacy
                           checkOutTime:(NSString *)checkOutTime
                              maxNights:(NSNumber *)maxNights
                                   beds:(NSNumber *)beds
                           propertyType:(NSString *)propertyType
                                bedType:(NSString *)bedType
                            bathRoomNum:(NSString *)bathRoomNum
                                 review:(NSNumber *)review
                            reviewCount:(NSNumber *)reviewCount
                          reviewContent:(NSString *)reviewContent

                               isVerify:(BOOL)isVerify
                      verifyDescription:(NSString *)verifyDescription
                              isSpecial:(BOOL)isSpecial
                     specialDescription:(NSString *)specialDescription
                                isSpeed:(BOOL)isSpeed
                       speedDescription:(NSString *)speedDescription
                             isBoutique:(BOOL)isBoutique
                    boutiqueDescription:(NSString *)boutiqueDescription


                           introduction:(NSString *)introduction

                                 imageM:(NSArray *)imageM
                                 imageS:(NSArray *)imageS
                          equipmentList:(NSArray *)equipmentList

                             roomNumber:(NSNumber *)roomNumber;

@end
