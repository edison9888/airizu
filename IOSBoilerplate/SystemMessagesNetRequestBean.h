//
//  SystemMessagesNetRequestBean.h
//  airizu
//
//  Created by 唐志华 on 13-1-1.
//
//

#import <Foundation/Foundation.h>

@interface SystemMessagesNetRequestBean : NSObject {
  
}

@property (nonatomic, readonly) NSNumber *pageNum;

#pragma mark -
#pragma mark 方便构造

+(id)systemMessagesNetRequestBeanWithPageNum:(NSNumber *)pageNum;
@end
