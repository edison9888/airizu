//
//  GlobalDataCache.h
//  gameqa
//
//  Created by user on 12-9-13.
//
//

#import <Foundation/Foundation.h>
#import "BMapKit.h"

@class LogonNetRespondBean;
@class CitysNetRespondBean;
@class DictionaryNetRespondBean;
@class RecommendNetRespondBean;
@class HelpNetRespondBean;
@class ReviewItemNetRespondBean;
@class BMKUserLocation;
@class BMKAddrInfo;

@interface GlobalDataCacheForMemorySingleton : NSObject {
  
}

// 是否需要在app启动时, 显示 "初学者指南界面"
@property (nonatomic, assign, setter=setNeedShowBeginnerGuide:) BOOL isNeedShowBeginnerGuide;
// 是否需要自动登录的标志
@property (nonatomic, assign, setter=setNeedAutologin:) BOOL isNeedAutologin;
// 客户端应用版本号
@property (nonatomic, copy) NSString *clientVersion;
// 客户端 Android 版本号
@property (nonatomic, copy) NSString *clientAVersion;
// 屏幕大小
@property (nonatomic, copy) NSString *screenSize;
// 用户登录成功后, 服务器返回的信息(判断有无此对象来判断当前用户是否已经登录)
@property (nonatomic, retain) LogonNetRespondBean *logonNetRespondBean;
// 用户最后一次登录成功时的用户名
@property (nonatomic, copy) NSString *usernameForLastSuccessfulLogon;
// 用户最后一次登录成功时的密码
@property (nonatomic, copy) NSString *passwordForLastSuccessfulLogon;
// 城市信息列表(2.6 搜索城市)
@property (nonatomic, retain) CitysNetRespondBean *cityInfoNetRespondBean;
// 字典接口 : "房屋类型" "出租方式" "设施设备" (2.8 初始化字典)
// 目前没有机会重新拉取 "数据字典", 所以这个只能做成是临时性缓存
@property (nonatomic, retain) DictionaryNetRespondBean *dictionaryNetRespondBean;
// 用户最后一次的 "附近" 坐标 (这里使用的是百度的LBS库)
@property (nonatomic, retain) BMKUserLocation *lastLocation;
// 用户最后一次的 "附近" 位置信息 (这里使用的是百度的LBS库)
@property (nonatomic, retain) BMKAddrInfo *lastMKAddrInfo;
// 推荐城市 (2.4 房间推荐)
@property (nonatomic, retain) RecommendNetRespondBean *recommendNetRespondBean;
// 帮助信息 (2.16 帮助)
@property (nonatomic, retain) HelpNetRespondBean *helpNetRespondBean;
// 评论项 (2.26 获取评论项(这个用于 写评论 界面))
@property (nonatomic, retain) ReviewItemNetRespondBean *reviewItemNetRespondBean;

// 本地缓存目录大小
@property (nonatomic, readonly) NSUInteger localCacheSize;

+ (GlobalDataCacheForMemorySingleton *) sharedInstance;
@end
