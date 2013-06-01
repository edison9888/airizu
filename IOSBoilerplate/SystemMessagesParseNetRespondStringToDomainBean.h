//
//  SystemMessagesParseNetRespondStringToDomainBean.h
//  airizu
//
//  Created by 唐志华 on 13-1-1.
//
//

#import <Foundation/Foundation.h>
#import "IParseNetRespondStringToDomainBean.h"

@interface SystemMessagesParseNetRespondStringToDomainBean : NSObject <IParseNetRespondStringToDomainBean> {
  
}

#pragma mark 实现 IParseNetRespondStringToDomainBean 接口
- (id) parseNetRespondStringToDomainBean:(in NSString *) netRespondString;
@end