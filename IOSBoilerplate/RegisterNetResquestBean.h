//
//  RegisterNetResquestBean.h
//  airizu
//
//  Created by 唐志华 on 13-1-1.
//
//

#import <Foundation/Foundation.h>

@interface RegisterNetResquestBean : NSObject {
  
}

// 用户名
@property (nonatomic, readonly) NSString *userName;
// 手机号
@property (nonatomic, readonly) NSString *phoneNumber;
// 电子邮件
@property (nonatomic, readonly) NSString *email;
// 密码
@property (nonatomic, readonly) NSString *password;

#pragma mark -
#pragma mark 方便构造

+(id)registerNetResquestBeanWithUserName:(NSString *)userName
                             phoneNumber:(NSString *)phoneNumber
                                   email:(NSString *)email
                                password:(NSString *)password;
@end
