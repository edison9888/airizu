//
//  DictionaryNetRespondBean.h
//  airizu
//
//  Created by 唐志华 on 13-1-1.
//
//

#import <Foundation/Foundation.h>

#define kNSCodingKeyDataDictionary_roomTypes   @"roomTypes"
#define kNSCodingKeyDataDictionary_rentManners @"rentManners"
#define kNSCodingKeyDataDictionary_equipments  @"equipments"

@interface DictionaryNetRespondBean : NSObject <NSCoding> {
  
}

@property(nonatomic, readonly) NSArray *roomTypes;
@property(nonatomic, readonly) NSArray *rentManners;
@property(nonatomic, readonly) NSArray *equipments;

#pragma mark -
#pragma mark 方便构造

+(id)dictionaryNetRespondBeanWithRoomTypes:(NSArray *)roomTypes
                               rentManners:(NSArray *)rentManners
                                equipments:(NSArray *)equipments;

#pragma mark -
#pragma mark 实现 NSCoding 接口
- (void)encodeWithCoder:(NSCoder *)aCoder;
- (id)initWithCoder:(NSCoder *)aDecoder;
@end
