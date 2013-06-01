//
//  SystemMessagesNetRespondBean.h
//  airizu
//
//  Created by 唐志华 on 13-1-1.
//
//

#import <Foundation/Foundation.h>

@interface SystemMessagesNetRespondBean : NSObject {
  
}

@property (nonatomic, readonly) NSArray *systemMessageList;

#pragma mark -
#pragma mark 方便构造

+(id)systemMessagesNetRespondBeanWithSystemMessageList:(NSArray *)systemMessageList;
@end
