//
//  GloblaDataCacheForFile.h
//  airizu
//
//  Created by 唐志华 on 12-12-17.
//
//

#import <Foundation/Foundation.h>



// GlobalDataCacheForMemorySingleton 类中有些数据是需要固化到设备中的,
// 本类就是用来完成这些数据固化工作的 "通讯录模式"
@interface GloblaDataCacheForNeedSaveToFileSystem : NSObject {
  
}

///
+ (void)readRecommendNetRespondBeanToGlobalDataCacheForMemorySingleton;
+ (void)readCitysNetRespondBeanToGlobalDataCacheForMemorySingleton;
+ (void)readDictionaryNetRespondBeanToGlobalDataCacheForMemorySingleton;
+ (void)readUserLoginInfoToGlobalDataCacheForMemorySingleton;
+ (void)readAppConfigInfoToGlobalDataCacheForMemorySingleton;

///
+ (void)writeRecommendNetRespondBeanToFileSystem;
+ (void)writeCitysNetRespondBeanToFileSystem;
+ (void)writeDictionaryNetRespondBeanToFileSystem;
+ (void)writeUserLoginInfoToFileSystem;
+ (void)writeAppConfigInfoToFileSystem;

///
+ (void)saveAllCacheDataToFileSystem;
@end
