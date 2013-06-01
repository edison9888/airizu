//
//  RootType.h
//  airizu
//
//  Created by 唐志华 on 13-1-1.
//
//

#import <Foundation/Foundation.h>

@interface RoomType : NSObject <NSCoding> {
  
}

@property(nonatomic, readonly) NSString *typeName;
@property(nonatomic, readonly) NSString *typeId;

#pragma mark -
#pragma mark 方便构造

+(id)roomTypeWithTypeName:(NSString *) typeName
                   typeId:(NSString *) typeId;

#pragma mark -
#pragma mark 实现 NSCoding 接口
- (void)encodeWithCoder:(NSCoder *)aCoder;
- (id)initWithCoder:(NSCoder *)aDecoder;
@end
