//
//  RegisterNetRespondBean.h
//  airizu
//
//  Created by 唐志华 on 13-1-1.
//
//

#import <Foundation/Foundation.h>

@interface RegisterNetRespondBean : NSObject {
  
}

@property (nonatomic, readonly) NSString *message;

#pragma mark -
#pragma mark 方便构造

+(id)registerNetRespondBeanWithMessage:(NSString *)message;
@end
