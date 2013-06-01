//
//  RoomSearchDomainBeanToDD.h
//  airizu
//
//  Created by 唐志华 on 12-12-28.
//
//

#import <Foundation/Foundation.h>
#import "IParseDomainBeanToDataDictionary.h"

@interface RoomSearchDomainBeanToDD : NSObject <IParseDomainBeanToDataDictionary> {
  
}

- (NSDictionary *) parseDomainBeanToDataDictionary:(in id) netRequestDomainBean;
@end
