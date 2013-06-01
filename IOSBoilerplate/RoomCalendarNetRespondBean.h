//
//  RoomCalendarNetRespondBean.h
//  airizu
//
//  Created by 唐志华 on 13-1-1.
//
//

#import <Foundation/Foundation.h>

@interface RoomCalendarNetRespondBean : NSObject {
  
}

// 入住时间包括当前月内，三个月之内不能订房的日期
@property(nonatomic, readonly) NSArray *roomUnselectableCalendarList;

#pragma mark -
#pragma mark 方便构造

+(id)roomCalendarNetRespondBeanWithRoomUnselectableCalendarList:(NSArray *)roomUnselectableCalendarList;
@end
