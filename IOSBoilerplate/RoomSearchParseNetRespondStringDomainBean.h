//
//  RoomSearchParseNetRespondStringDomainBean.h
//  airizu
//
//  Created by 唐志华 on 12-12-28.
//
//

#import <Foundation/Foundation.h>
#import "IParseNetRespondStringToDomainBean.h"

@interface RoomSearchParseNetRespondStringDomainBean : NSObject<IParseNetRespondStringToDomainBean> {
  
}

#pragma mark 实现 IParseNetRespondStringToDomainBean 接口
- (id) parseNetRespondStringToDomainBean:(in NSString *) netRespondString;
@end
