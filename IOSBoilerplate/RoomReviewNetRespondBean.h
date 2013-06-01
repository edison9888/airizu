//
//  RoomReviewNetRespondBean.h
//  airizu
//
//  Created by 唐志华 on 13-1-1.
//
//

#import <Foundation/Foundation.h>

@interface RoomReviewNetRespondBean : NSObject {
  
}

// 评论总数
@property (nonatomic, readonly) NSNumber *reviewCount;
// 房间总的平均分(为浮点类型)
@property (nonatomic, readonly) NSString *avgScore;
// 当前房间的评论项
@property(nonatomic, readonly) NSDictionary *reviewItemMap;
// 当前房间的评论信息
@property(nonatomic, readonly) NSArray *roomReviewList;

#pragma mark -
#pragma mark 方便构造

+(id)roomReviewNetRespondBeanWithReviewCount:(NSNumber *)reviewCount
                                    avgScore:(NSString *)avgScore
                               reviewItemMap:(NSDictionary *)reviewItemMap
                              roomReviewList:(NSArray *)roomReviewList;
@end
