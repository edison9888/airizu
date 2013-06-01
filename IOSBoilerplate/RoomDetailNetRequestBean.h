//
//  RoomDetailNetRequestBean.h
//  airizu
//
//  Created by 唐志华 on 13-1-1.
//
//

#import <Foundation/Foundation.h>

@interface RoomDetailNetRequestBean : NSObject {
  
}

@property (nonatomic, readonly) NSString *roomId;// 房间编号

#pragma mark -
#pragma mark 方便构造

+(id)roomDetailNetRequestBeanWithRoomId:(NSString *)roomId;
@end
