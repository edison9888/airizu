//
//  LogonNetRequestBean.h
//  airizu
//
//  Created by 唐志华 on 13-1-1.
//
//

#import <Foundation/Foundation.h>

@interface LogonNetRequestBean : NSObject {
  
}

// 登录名
@property (nonatomic, readonly) NSString *loginName;
// 密码
@property (nonatomic, readonly) NSString *password;
// 客户端应用版本号
@property (nonatomic, copy) NSString *clientVersion;
// 客户端android版本号
@property (nonatomic, copy) NSString *clientAVersion;
// 屏幕大小
@property (nonatomic, copy) NSString *screenSize;

#pragma mark -
#pragma mark 方便构造
+(id)logonNetRequestBeanWithLoginName:(NSString *)loginName password:(NSString *)password;

@end
