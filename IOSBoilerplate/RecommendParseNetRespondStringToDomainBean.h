//
//  RecommendParseNetRespondStringToDomainBean.h
//  airizu
//
//  Created by 唐志华 on 12-12-25.
//
//

#import <Foundation/Foundation.h>
#import "IParseNetRespondStringToDomainBean.h"

@interface RecommendParseNetRespondStringToDomainBean : NSObject <IParseNetRespondStringToDomainBean> {
  
}

#pragma mark 实现 IParseNetRespondStringToDomainBean 接口
- (id) parseNetRespondStringToDomainBean:(in NSString *) netRespondString;
@end
