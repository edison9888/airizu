//
//  GloblaDataCacheForFile.m
//  airizu
//
//  Created by 唐志华 on 12-12-17.
//
//

#import "GloblaDataCacheForNeedSaveToFileSystem.h"
#import "GlobalDataCacheForMemorySingleton.h"

#import "RecommendNetRespondBean.h"
#import "CitysNetRespondBean.h"
#import "DictionaryNetRespondBean.h"

#import "NSString+Expand.h"
#import "NSObject+Serialization.h"

#import "LocalCacheDataPathConstant.h"










static NSString *const TAG = @"<GloblaDataCacheForNeedSaveToFileSystem>";











// 推荐城市
static NSString *const kLocalCacheDataName_RecommendCity                  = @"RecommendCity";
// 城市列表
static NSString *const kLocalCacheDataName_CityList                       = @"CityList";
// 字典
static NSString *const kLocalCacheDataName_Dictionary                     = @"Dictionary";
// 自动登录的标志
static NSString *const kLocalCacheDataName_AutoLoginMark                  = @"AutoLoginMark";
// 用户最后一次成功登录时的用户名
static NSString *const kLocalCacheDataName_UsernameForLastSuccessfulLogon = @"UsernameForLastSuccessfulLogon";
// 用户最后一次成功登录时的密码
static NSString *const kLocalCacheDataName_PasswordForLastSuccessfulLogon = @"PasswordForLastSuccessfulLogon";
// 是否需要显示 初学者指南 
static NSString *const kLocalCacheDataName_BeginnerGuide                  = @"BeginnerGuide";



@implementation GloblaDataCacheForNeedSaveToFileSystem

#pragma mark -
#pragma mark
+ (void)readRecommendNetRespondBeanToGlobalDataCacheForMemorySingleton {
  RecommendNetRespondBean *object = [NSObject deserializeObjectFromFileWithFileName:kLocalCacheDataName_RecommendCity directoryPath:[LocalCacheDataPathConstant importantDataCachePath]];
  if (object != nil) {
    [[GlobalDataCacheForMemorySingleton sharedInstance] setRecommendNetRespondBean:object];
  }
}
+ (void)readCitysNetRespondBeanToGlobalDataCacheForMemorySingleton {
  CitysNetRespondBean *object = [NSObject deserializeObjectFromFileWithFileName:kLocalCacheDataName_CityList directoryPath:[LocalCacheDataPathConstant importantDataCachePath]];

  if (object != nil) {
    [[GlobalDataCacheForMemorySingleton sharedInstance] setCityInfoNetRespondBean:object];
  }
}
+ (void)readDictionaryNetRespondBeanToGlobalDataCacheForMemorySingleton {
  DictionaryNetRespondBean *object = [NSObject deserializeObjectFromFileWithFileName:kLocalCacheDataName_Dictionary directoryPath:[LocalCacheDataPathConstant importantDataCachePath]];

  if (object != nil) {
    [[GlobalDataCacheForMemorySingleton sharedInstance] setDictionaryNetRespondBean:object];
  }
}
+ (void)readUserLoginInfoToGlobalDataCacheForMemorySingleton {
  NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
  
  // 自动登录的标志
  id autoLoginMark = [userDefaults objectForKey:(NSString *)kLocalCacheDataName_AutoLoginMark];
  if (autoLoginMark == nil) {
    [userDefaults setBool:YES forKey:(NSString *)kLocalCacheDataName_AutoLoginMark];
  }
  BOOL autoLoginMarkBOOL = [userDefaults boolForKey:(NSString *)kLocalCacheDataName_AutoLoginMark];
  [[GlobalDataCacheForMemorySingleton sharedInstance] setNeedAutologin:autoLoginMarkBOOL];
  
  // 用户最后一次成功登录时的用户名
  NSString *usernameForLastSuccessfulLogon = [userDefaults stringForKey:(NSString *)kLocalCacheDataName_UsernameForLastSuccessfulLogon];
  [[GlobalDataCacheForMemorySingleton sharedInstance] setUsernameForLastSuccessfulLogon:usernameForLastSuccessfulLogon];
  
  // 用户最后一次成功登录时的密码
  NSString *passwordForLastSuccessfulLogon = [userDefaults stringForKey:(NSString *)kLocalCacheDataName_PasswordForLastSuccessfulLogon];
  [[GlobalDataCacheForMemorySingleton sharedInstance] setPasswordForLastSuccessfulLogon:passwordForLastSuccessfulLogon];
}

+ (void)readAppConfigInfoToGlobalDataCacheForMemorySingleton {
  NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
  
  // 是否需要在启动后显示初学者指南界面
  id isNeedShowBeginnerGuideTest = [userDefaults objectForKey:kLocalCacheDataName_BeginnerGuide];
  if (nil == isNeedShowBeginnerGuideTest) {
    [userDefaults setBool:YES forKey:kLocalCacheDataName_BeginnerGuide];
  }
  BOOL isNeedShowBeginnerGuide = [userDefaults boolForKey:kLocalCacheDataName_BeginnerGuide];
  [[GlobalDataCacheForMemorySingleton sharedInstance] setNeedShowBeginnerGuide:isNeedShowBeginnerGuide];
}






#pragma mark -
#pragma mark 
+ (void)writeRecommendNetRespondBeanToFileSystem {
  RecommendNetRespondBean *object = [[GlobalDataCacheForMemorySingleton sharedInstance] recommendNetRespondBean];
  [object serializeObjectToFileWithFileName:kLocalCacheDataName_RecommendCity directoryPath:[LocalCacheDataPathConstant importantDataCachePath]];
}
+ (void)writeCitysNetRespondBeanToFileSystem {
  CitysNetRespondBean *object = [[GlobalDataCacheForMemorySingleton sharedInstance] cityInfoNetRespondBean];
  [object serializeObjectToFileWithFileName:kLocalCacheDataName_CityList directoryPath:[LocalCacheDataPathConstant importantDataCachePath]];
}
+ (void)writeDictionaryNetRespondBeanToFileSystem {
  DictionaryNetRespondBean *object = [[GlobalDataCacheForMemorySingleton sharedInstance] dictionaryNetRespondBean];
  [object serializeObjectToFileWithFileName:kLocalCacheDataName_Dictionary directoryPath:[LocalCacheDataPathConstant importantDataCachePath]];
}
+ (void)writeUserLoginInfoToFileSystem {
  NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
  
  // 自动登录的标志
  BOOL autoLoginMark = [[GlobalDataCacheForMemorySingleton sharedInstance] isNeedAutologin];
  [userDefaults setBool:autoLoginMark forKey:(NSString *)kLocalCacheDataName_AutoLoginMark];
  
  
  // 用户最后一次成功登录时的用户名
  NSString *usernameForLastSuccessfulLogon = [[GlobalDataCacheForMemorySingleton sharedInstance] usernameForLastSuccessfulLogon];
  if (![NSString isEmpty:usernameForLastSuccessfulLogon]) {
    [userDefaults setObject:usernameForLastSuccessfulLogon forKey:(NSString *)kLocalCacheDataName_UsernameForLastSuccessfulLogon];
  }
  
  // 用户最后一次成功登录时的密码
  NSString *passwordForLastSuccessfulLogon = [[GlobalDataCacheForMemorySingleton sharedInstance] passwordForLastSuccessfulLogon];
  if (![NSString isEmpty:passwordForLastSuccessfulLogon]) {
    [userDefaults setObject:passwordForLastSuccessfulLogon forKey:(NSString *)kLocalCacheDataName_PasswordForLastSuccessfulLogon];
  }
  
}

+ (void)writeAppConfigInfoToFileSystem {
  NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
  
  // 是否需要显示用户第一次登录时的帮助界面的标志
  BOOL isNeedShowBeginnerGuide = [GlobalDataCacheForMemorySingleton sharedInstance].isNeedShowBeginnerGuide;
  [userDefaults setBool:isNeedShowBeginnerGuide forKey:kLocalCacheDataName_BeginnerGuide];
}

#pragma mark -
#pragma mark
+ (void)saveAllCacheDataToFileSystem {
  [GloblaDataCacheForNeedSaveToFileSystem writeRecommendNetRespondBeanToFileSystem];
  [GloblaDataCacheForNeedSaveToFileSystem writeCitysNetRespondBeanToFileSystem];
  //[GloblaDataCacheForNeedSaveToFileSystem writeDictionaryNetRespondBeanToFileSystem];
  [GloblaDataCacheForNeedSaveToFileSystem writeUserLoginInfoToFileSystem];
  [GloblaDataCacheForNeedSaveToFileSystem writeAppConfigInfoToFileSystem];
}

@end
