//
//  ForgetPasswordNetRespondBean.h
//  airizu
//
//  Created by 唐志华 on 13-1-1.
//
//

#import <Foundation/Foundation.h>

@interface ForgetPasswordNetRespondBean : NSObject {
  
}

@property (nonatomic, readonly) NSString *message;

#pragma mark -
#pragma mark 方便构造
+(id)forgetPasswordNetRespondBeanWithMessage:(NSString *)message;
@end
