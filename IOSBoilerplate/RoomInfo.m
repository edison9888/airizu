//
//  RoomInfo.m
//  airizu
//
//  Created by 唐志华 on 12-12-28.
//
//

#import "RoomInfo.h"

static const NSString *const TAG = @"<RoomInfo>";

@implementation RoomInfo

- (void) dealloc {
	PRPLog(@"dealloc: %@ [0x%x]", TAG, [self hash]);
	
  [_roomId release];
  [_roomTitle release];
  [_rentalWay release];
  [_rentalWayName release];
  [_occupancyCount release];
  [_reviewCount release];
  [_scheduled release];
  [_price release];
  [_image release];
  [_verify release];
  [_len release];
  [_lat release];
  [_distance release];
	
	[super dealloc];
}

- (id) initWithRoomId:(NSNumber *) roomId
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
             distance:(NSNumber *) distance {
  
  if ((self = [super init])) {
		PRPLog(@"init %@ [0x%x]", TAG, [self hash]);
    
    _roomId         = [roomId copy];;
    _roomTitle      = [roomTitle copy];
    _rentalWay      = [rentalWay copy];
    _rentalWayName  = [rentalWayName copy];
    _occupancyCount = [occupancyCount copy];
    _reviewCount    = [reviewCount copy];
    _scheduled      = [scheduled copy];
    _price          = [price copy];
    _image          = [image copy];
    _verify         = [verify copy];
    _len            = [len copy];
    _lat            = [lat copy];
    _distance       = [distance copy];
  }
  
  return self;
}

- (NSString *)description {
  return descriptionForDebug(self);
}

#pragma mark
#pragma mark 不能使用默认的init方法初始化对象, 而必须使用当前类特定的 "初始化方法" 初始化所有参数
- (id) init {
  NSAssert(NO, @"Can not use the default init method!");
  
  return nil;
}

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
                 distance:(NSNumber *) distance {
  
  return [[[RoomInfo alloc] initWithRoomId:roomId
                                 roomTitle:roomTitle
                                 rentalWay:rentalWay
                             rentalWayName:rentalWayName
                            occupancyCount:occupancyCount
                               reviewCount:reviewCount
                                 scheduled:scheduled
                                     price:price
                                     image:image
                                    verify:verify
                                       len:len
                                       lat:lat
                                  distance:distance] autorelease];
}
@end
