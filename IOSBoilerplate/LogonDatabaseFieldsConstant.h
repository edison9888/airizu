//
//  LogonDatabaseFieldsConstant.h
//  airizu
//
//  Created by 唐志华 on 12-12-28.
//
//

#ifndef airizu_LogonDatabaseFieldsConstant_h
#define airizu_LogonDatabaseFieldsConstant_h

/************      RequestBean       *************/



// 登录名
#define k_Login_RequestKey_loginName        @"loginName"
// 密码
#define k_Login_RequestKey_password         @"password"
// 客户端应用版本号
#define k_Login_RequestKey_clientVersion    @"clientVersion"
// 客户端android版本号
#define k_Login_RequestKey_clientAVersion   @"clientAVersion"
// 屏幕大小
#define k_Login_RequestKey_screenSize       @"screenSize"

/************      RespondBean       *************/


// 消息
#define k_Login_RespondKey_message          @"message"
// 用户Id
#define k_Login_RespondKey_userId           @"userId"
// 用户名称
#define k_Login_RespondKey_userName         @"userName"
// sessionId
#define k_Login_RespondKey_JESSIONID        @"JESSIONID"
// 用户手机号
#define k_Login_RespondKey_phoneNumber      @"phoneNumber"



#endif
