//
//  RoomInfo.h
//  airizu
//
//  Created by 唐志华 on 12-12-28.
//
//

#import <Foundation/Foundation.h>

@interface RoomInfo : NSObject {
  
}

// 房间编号
@property (nonatomic, readonly) NSNumber *roomId;
// 房间标题
@property (nonatomic, readonly) NSString *roomTitle;
// 租住方式Id
@property (nonatomic, readonly) NSString *rentalWay;
// 租住方式名称
@property (nonatomic, readonly) NSString *rentalWayName;
// 可住人数
@property (nonatomic, readonly) NSNumber *occupancyCount;
// 评论总数
@property (nonatomic, readonly) NSNumber *reviewCount;
// 已预定晚数
@property (nonatomic, readonly) NSNumber *scheduled;
// 价格
@property (nonatomic, readonly) NSNumber *price;
// 房间图片URL
@property (nonatomic, readonly) NSString *image;
// 是否是验证的房间
@property (nonatomic, readonly) NSNumber *verify;
// 百度经度
@property (nonatomic, readonly) NSNumber *len;
// 百度纬度
@property (nonatomic, readonly) NSNumber *lat;
// 距离
@property (nonatomic, readonly) NSNumber *distance;

+ (id) roomInfoWithRoomId:(NSNumber *) roomId
                roomTitle:(NSString *) roomTitle
                rentalWay:(NSString *) rentalWay
            rentalWayName:(NSString *) rentalWayName
           occupancyCount:(NSNumber *) occupancyCount
              reviewCount:(NSNumber *) reviewCount
                scheduled:(NSNumber *) scheduled
                    price:(NSNumber *) price
                    image:(NSString *) image
                   verify:(NSNumber *) verify
                      len:(NSNumber *) len
                      lat:(NSNumber *) lat
                 distance:(NSNumber *) distance;
@end
