//
//  Equipment.h
//  airizu
//
//  Created by 唐志华 on 13-1-1.
//
//

#import <Foundation/Foundation.h>

@interface Equipment : NSObject <NSCoding> {
  
}

@property (nonatomic, readonly) NSString *equipmentName;
@property (nonatomic, readonly) NSString *equipmentId;

#pragma mark -
#pragma mark 方便构造

+(id)equipmentWithEquipmentName:(NSString *) equipmentName
                    equipmentId:(NSString *) equipmentId;

#pragma mark -
#pragma mark 实现 NSCoding 接口
- (void)encodeWithCoder:(NSCoder *)aCoder;
- (id)initWithCoder:(NSCoder *)aDecoder;
@end
