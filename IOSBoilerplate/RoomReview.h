//
//  RoomReview.h
//  airizu
//
//  Created by 唐志华 on 13-1-1.
//
//

#import <Foundation/Foundation.h>

@interface RoomReview : NSObject {
  
}

// 租客姓名
@property (nonatomic, readonly) NSString *userName;
// 用户发表评论时间
@property (nonatomic, readonly) NSString *userReviewTime;
// 用户评论内容
@property (nonatomic, readonly) NSString *userReview;
// 房东回复评论的时间
@property (nonatomic, readonly) NSString *hostReviewTime;
// 房东回复评论的内容
@property (nonatomic, readonly) NSString *hostReview;


#pragma mark -
#pragma mark 方便构造

+(id)roomReviewWithUserName:(NSString *)userName
             userReviewTime:(NSString *)userReviewTime
                 userReview:(NSString *)userReview
             hostReviewTime:(NSString *)hostReviewTime
                 hostReview:(NSString *)hostReview;
@end
