//
//  ThirdPartyLibrariesVersionInfoSingleton.h
//  airizu
//
//  Created by 唐志华 on 13-2-27.
//
//

#import <Foundation/Foundation.h>

@interface ThirdPartyLibrariesVersionInfoSingleton : NSObject {
  
}

+ (ThirdPartyLibrariesVersionInfoSingleton *) sharedInstance;

// 百度LBS
@property (nonatomic, readonly) NSString *BMKVersion;
// 支付宝 - 安全支付
@property (nonatomic, readonly) NSString *AlixPayVersion;
// 友盟 - 分析SDK
@property (nonatomic, readonly) NSString *UMAnalyticsVersion;
@end
