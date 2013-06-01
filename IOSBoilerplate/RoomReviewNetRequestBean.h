//
//  RoomReviewNetRequestBean.h
//  airizu
//
//  Created by 唐志华 on 13-1-1.
//
//

#import <Foundation/Foundation.h>

@interface RoomReviewNetRequestBean : NSObject {
  
}

// 房间ID
@property (nonatomic, readonly) NSString *roomId;
// 页数
@property (nonatomic, readonly) NSInteger pageNum;

#pragma mark -
#pragma mark 方便构造

+(id)roomReviewNetRequestBeanWithRoomId:(NSString *)roomId
                                pageNum:(NSInteger)pageNum;
@end
