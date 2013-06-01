//
//  RentManner.h
//  airizu
//
//  Created by 唐志华 on 13-1-1.
//
//

#import <Foundation/Foundation.h>

@interface RentManner : NSObject <NSCoding> {
  
}

@property(nonatomic, readonly) NSString *rentalWayName;
@property(nonatomic, readonly) NSString *rentalWayId;

#pragma mark -
#pragma mark 方便构造

+(id)rentMannerWithRentalWayName:(NSString *) rentalWayName
                     rentalWayId:(NSString *) rentalWayId;

#pragma mark -
#pragma mark 实现 NSCoding 接口
- (void)encodeWithCoder:(NSCoder *)aCoder;
- (id)initWithCoder:(NSCoder *)aDecoder;
@end
