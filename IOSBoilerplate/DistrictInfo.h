//
//  DistrictInfo.h
//  airizu
//
//  Created by 唐志华 on 13-1-1.
//
//

#import <Foundation/Foundation.h>

@interface DistrictInfo : NSObject {
  
}

@property (nonatomic, readonly) NSNumber *ID;
@property (nonatomic, readonly) NSNumber *cityId;
@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) NSString *code;

@property (nonatomic, readonly) NSString *hot;
@property (nonatomic, readonly) NSNumber *sort;

@property (nonatomic, readonly) NSNumber *minLng;
@property (nonatomic, readonly) NSNumber *maxLng;
@property (nonatomic, readonly) NSNumber *minLat;
@property (nonatomic, readonly) NSNumber *maxLat;

@property (nonatomic, readonly) NSNumber *locationLat;
@property (nonatomic, readonly) NSNumber *locationLng;
@property (nonatomic, readonly) NSNumber *locationLatBaidu;
@property (nonatomic, readonly) NSNumber *locationLngBaidu;

@property (nonatomic, readonly) NSNumber *minLngBaidu;
@property (nonatomic, readonly) NSNumber *minLatBaidu;
@property (nonatomic, readonly) NSNumber *maxLatBaidu;
@property (nonatomic, readonly) NSNumber *maxLngBaidu;

#pragma mark -
#pragma mark 方便构造

+(id)districtInfoWithID:(NSNumber *)ID
                 cityId:(NSNumber *)cityId
                   name:(NSString *)name
                   code:(NSString *)code

                    hot:(NSString *)hot
                   sort:(NSNumber *)sort

                 minLng:(NSNumber *)minLng
                 maxLng:(NSNumber *)maxLng
                 minLat:(NSNumber *)minLat
                 maxLat:(NSNumber *)maxLat

            locationLat:(NSNumber *)locationLat
            locationLng:(NSNumber *)locationLng
       locationLatBaidu:(NSNumber *)locationLatBaidu
       locationLngBaidu:(NSNumber *)locationLngBaidu

            minLngBaidu:(NSNumber *)minLngBaidu
            minLatBaidu:(NSNumber *)minLatBaidu
            maxLatBaidu:(NSNumber *)maxLatBaidu
            maxLngBaidu:(NSNumber *)maxLngBaidu;
@end
