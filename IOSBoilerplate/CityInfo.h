//
//  CityInfo.h
//  airizu
//
//  Created by 唐志华 on 13-1-1.
//
//

#import <Foundation/Foundation.h>

@interface CityInfo : NSObject <NSCoding> {
  
}

@property (nonatomic, readonly) NSNumber *ID;
@property (nonatomic, readonly) NSString *name;
// 城市中文名称的拼音(如 beijing)
@property (nonatomic, readonly) NSString *code;
//
@property (nonatomic, readonly) NSNumber *provinceId;

#pragma mark -
#pragma mark 方便构造

+(id)cityInfoWithID:(NSNumber *) ID
               name:(NSString *) name
               code:(NSString *) code
         provinceId:(NSNumber *) provinceId;


#pragma mark -
#pragma mark 实现 NSCoding 接口
- (void)encodeWithCoder:(NSCoder *)aCoder;
- (id)initWithCoder:(NSCoder *)aDecoder;
@end
