//
//  LogonNetRespondBean.h
//  airizu
//
//  Created by 唐志华 on 13-1-1.
//
//

#import <Foundation/Foundation.h>

@interface LogonNetRespondBean : NSObject {
  
}

// 消息
@property (nonatomic, readonly) NSString *message;
// 用户Id
@property (nonatomic, readonly) NSNumber *userId;
// 用户名称
@property (nonatomic, readonly) NSString *userName;
// sessionId
@property (nonatomic, readonly) NSString *sessionId;
// 用户Id
@property (nonatomic, readonly) NSString *phoneNumber;

#pragma mark -
#pragma mark 方便构造

+(id)LogonNetRespondBeanWithMessage:(NSString *)message
                             userId:(NSNumber *)userId
                           userName:(NSString *)userName
                          sessionId:(NSString *)sessionId
                        phoneNumber:(NSString *)phoneNumber;
@end
