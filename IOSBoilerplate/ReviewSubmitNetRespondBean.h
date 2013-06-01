//
//  ReviewSubmitNetRespondBean.h
//  airizu
//
//  Created by 唐志华 on 13-1-1.
//
//

#import <Foundation/Foundation.h>

@interface ReviewSubmitNetRespondBean : NSObject {
  
}

@property (nonatomic, readonly) NSString *message;

#pragma mark -
#pragma mark 方便构造

+(id)reviewSubmitNetRespondBeanWithMessage:(NSString *) message;
@end
