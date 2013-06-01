//
//  RoomSearchNetRespondBean.h
//  airizu
//
//  Created by 唐志华 on 12-12-28.
//
//

#import <Foundation/Foundation.h>

@class RoomInfo;
@interface RoomSearchNetRespondBean : NSObject {
  
}

@property (nonatomic, readonly) NSNumber *roomCount;// 搜索房间总数
@property (nonatomic, readonly) NSArray *roomInfoList;

#pragma mark -
#pragma mark 方便构造
+ (id) roomSearchNetRespondBeanWithRoomInfoList:(NSArray *) roomInfoList
                                  withRoomCount:(NSNumber *) roomCount;
@end
