//
//  DistrictInfo.m
//  airizu
//
//  Created by 唐志华 on 13-1-1.
//
//

#import "DistrictInfo.h"

static const NSString *const TAG = @"<DistrictInfo>";

@implementation DistrictInfo

- (void) dealloc {
	PRPLog(@"dealloc: %@ [0x%x]", TAG, [self hash]);
	
  [_ID release];
  [_cityId release];
  [_name release];
  [_code release];
  
  [_hot release];
  [_sort release];
  
  [_minLng release];
  [_maxLng release];
  [_minLat release];
  [_maxLat release];
  
  [_locationLat release];
  [_locationLng release];
  [_locationLatBaidu release];
  [_locationLngBaidu release];
  
  [_minLngBaidu release];
  [_minLatBaidu release];
  [_maxLatBaidu release];
  [_maxLngBaidu release];
  
	[super dealloc];
}

- (id) initWithID:(NSNumber *)ID
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
      maxLngBaidu:(NSNumber *)maxLngBaidu {
  
  if ((self = [super init])) {
		PRPLog(@"init %@ [0x%x]", TAG, [self hash]);
    
    _ID = [ID copy];
    _cityId = [cityId copy];
    _name = [name copy];
    _code = [code copy];
    
    _hot = [hot copy];
    _sort = [sort copy];
    
    _minLng = [minLng copy];
    _maxLng = [maxLng copy];
    _minLat = [minLat copy];
    _maxLat = [maxLat copy];
    
    _locationLat = [locationLat copy];
    _locationLng = [locationLng copy];
    _locationLatBaidu = [locationLatBaidu copy];
    _locationLngBaidu = [locationLngBaidu copy];
    
    _minLngBaidu = [minLngBaidu copy];
    _minLatBaidu = [minLatBaidu copy];
    _maxLatBaidu = [maxLatBaidu copy];
    _maxLngBaidu = [maxLngBaidu copy];
    
  }
  
  return self;
}

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
            maxLngBaidu:(NSNumber *)maxLngBaidu {
  
  return [[[DistrictInfo alloc] initWithID:ID
                                    cityId:cityId
                                      name:name
                                      code:code
           
                                       hot:hot
                                      sort:sort
           
                                    minLng:minLng
                                    maxLng:maxLng
                                    minLat:minLat
                                    maxLat:maxLat
           
                               locationLat:locationLat
                               locationLng:locationLng
                          locationLatBaidu:locationLatBaidu
                          locationLngBaidu:locationLngBaidu
           
                               minLngBaidu:minLngBaidu
                               minLatBaidu:minLatBaidu
                               maxLatBaidu:maxLatBaidu
                               maxLngBaidu:maxLngBaidu] autorelease];
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

@end