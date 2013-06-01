//
//  RoomCalendarNetRequestBean.h
//  airizu
//
//  Created by 唐志华 on 13-1-1.
//
//

#import <Foundation/Foundation.h>

@interface RoomCalendarNetRequestBean : NSObject {
  
}

@property (nonatomic, readonly) NSNumber *roomId;// 房间编号

#pragma mark -
#pragma mark 方便构造

+(id)roomCalendarNetRequestBeanWithRoomId:(NSNumber *)roomId;
@end
