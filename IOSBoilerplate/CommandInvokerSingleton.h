//
//  CommandInvokerSingleton.h
//  airizu
//
//  Created by 唐志华 on 13-3-22.
//
//

#import <Foundation/Foundation.h>

//
typedef NS_ENUM(NSInteger, CommandEnum) {
  // 打印当前硬件设备信息
  kCommandEnum_PrintDeviceInfo = 0,
  // 初始化 LBS 类库
  kCommandEnum_InitLBSLibrary,
  // 初始化 友盟 类库
  kCommandEnum_InitMobClick,
  // 初始化 URLCache 
  kCommandEnum_InitURLCache,
  // 初始化 AFNetwork
  kCommandEnum_EnableAFNetwork,
  // 获取用户当前位置信息
  kCommandEnum_GetUserLocationInfo,
  // 加载本地缓存的数据
  kCommandEnum_LoadingLocalCacheData,
  // 请求用户自动登录
  kCommandEnum_UserAutoLogin,
  // 检查当前APP版本
  kCommandEnum_NewAppVersionCheck
};

@interface CommandInvokerSingleton : NSObject {
  
}

+ (CommandInvokerSingleton *) sharedInstance;
//
-(void)runCommandWithCommandEnum:(CommandEnum)commandEnum;
//
-(void)runCommandWithCommandObject:(id)commandObject;
@end
