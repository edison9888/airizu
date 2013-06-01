//
//  ToolsFunctionForThisProgect.m
//  airizu
//
//  Created by 唐志华 on 13-1-6.
//
//

#import "ToolsFunctionForThisProgect.h"

#import "NSDictionary+SafeValue.h"
#import "NSString+Expand.h"
#import "DomainProtocolNetHelperSingleton.h"
#import "NSDate+Convenience.h"

#import "RoomSearchDatabaseFieldsConstant.h"
#import "RoomSearchNetRequestBean.h"

#import "GlobalDataCacheForDataDictionary.h"
#import "MacroConstantForThisProject.h"
#import "SimpleLocationHelperForBaiduLBS.h"

#import "SimpleCookieSingleton.h"
#import "LogonNetRespondBean.h"

#import "VersionNetRespondBean.h"

#import "JSONKit.h"

#import "PreloadingUIToolBar.h"

static const NSString *const TAG = @"<ToolsFunctionForThisProgect>";

@implementation ToolsFunctionForThisProgect


/**
 * 记录用户登录成功后的重要信息
 *
 * @param logonNetRespondBean
 * @param usernameForLastSuccessfulLogon
 * @param passwordForLastSuccessfulLogon
 */
+(void)noteLogonSuccessfulInfoWithLogonNetRespondBean:(LogonNetRespondBean *)logonNetRespondBean
                       usernameForLastSuccessfulLogon:(NSString *)usernameForLastSuccessfulLogon
                       passwordForLastSuccessfulLogon:(NSString *)passwordForLastSuccessfulLogon {
  
  if (logonNetRespondBean == nil) {
    NSAssert(NO, @"logonNetRespondBean is null !");
    return;
  }
  
  if ([NSString isEmpty:usernameForLastSuccessfulLogon] || [NSString isEmpty:passwordForLastSuccessfulLogon]) {
    NSAssert(NO, @"username or password is empty ! ");
    return;
  }
  
  PRPLog(@"%@ logonRespond ---> %@", TAG, logonNetRespondBean);
  PRPLog(@"%@ username ---> %@", TAG, usernameForLastSuccessfulLogon);
  PRPLog(@"%@ password ---> %@", TAG, passwordForLastSuccessfulLogon);
  
  // 设置Cookie
  [[SimpleCookieSingleton sharedInstance] setObject:logonNetRespondBean.sessionId forKey:@"JSESSIONID"];
  
  // 保用用户登录成功的信息
  [[GlobalDataCacheForMemorySingleton sharedInstance] setLogonNetRespondBean:logonNetRespondBean];
  
  // 保留用户最后一次登录成功时的 用户名
  [[GlobalDataCacheForMemorySingleton sharedInstance] setUsernameForLastSuccessfulLogon:usernameForLastSuccessfulLogon];
  
  // 保留用户最后一次登录成功时的 密码
  [[GlobalDataCacheForMemorySingleton sharedInstance] setPasswordForLastSuccessfulLogon:passwordForLastSuccessfulLogon];
}

/**
 * 清空登录相关信息
 */
+(void)clearLogonInfo {
  [[SimpleCookieSingleton sharedInstance] removeObjectForKey:@"JSESSIONID"];
  
  [[GlobalDataCacheForMemorySingleton sharedInstance] setLogonNetRespondBean:nil];
}

+(NSString *)transformHtmlStringToTextString:(NSString *)htmlString {
	NSArray *escapeChars = [NSArray arrayWithObjects:@"<b>",@"</b>",@"<br/>",@"<p>",@"</p>",@"<p/>", nil];
  NSArray *replaceChars = [NSArray arrayWithObjects:@"",@"",@"\r\n",@"    ",@"\r\n",@"\r\n",nil];
  NSInteger len = [escapeChars count];
	NSMutableString *temp = [NSMutableString stringWithString:htmlString];
  for (NSInteger i = 0; i < len; i++) {
    [temp replaceOccurrencesOfString:[escapeChars objectAtIndex:i]
                          withString:[replaceChars objectAtIndex:i]
                             options:NSLiteralSearch
                               range:NSMakeRange(0, [temp length])];
  }
  NSString *outStr = [NSString stringWithString: temp];
  return outStr;
}

+(NSString *)transformUtilDateStringToSqlDateString:(NSString *)utilDateString {
  if ([NSString isEmpty:utilDateString]) {
    return @"";
  }
  
  NSString *sqlDateString = @"";
  NSDate *date = [NSDate stringToDate:utilDateString];
  if ([date isKindOfClass:[NSDate class]]) {
    sqlDateString = [date stringWithDateFormat:@"yyyy-MM-dd"];
  }
  
  return sqlDateString;
}

+(NSString *)orderStateDescriptionForOrderStateEnum:(OrderStateEnum)orderStateEnum {
  NSString *orderStateDescription = nil;
  
  switch (orderStateEnum) {
    case kOrderStateEnum_WaitConfirm:{
      orderStateDescription = @"待确认";
    }break;
    case kOrderStateEnum_WaitPay:{
      orderStateDescription = @"待支付";
    }break;
    case kOrderStateEnum_WaitLive:{
      orderStateDescription = @"待入住";
    }break;
    case kOrderStateEnum_WaitComment:{
      orderStateDescription = @"待评价";
    }break;
    case kOrderStateEnum_HasEnded:{
      orderStateDescription = @"已完成";
    }break;
    default:
      break;
  }
  
  return orderStateDescription;
}

// 检查新版本信息, 并且返回 VersionNetRespondBean
#define APP_URL @"http://itunes.apple.com/lookup?id=494520120"
+(VersionNetRespondBean *)checkNewVersionAndReturnVersionBean {
  VersionNetRespondBean *versionBean = nil;
  
  do {
    
    
    
    break;
    
    
    
    NSString *URL = APP_URL;
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] init];
    [urlRequest setURL:[NSURL URLWithString:URL]];
    [urlRequest setHTTPMethod:@"POST"];
    NSHTTPURLResponse *urlResponse = nil;
    NSError *error = nil;
    // 同步请求网络数据
    NSData *recervedData
    = [NSURLConnection sendSynchronousRequest:urlRequest
                            returningResponse:&urlResponse
                                        error:&error];
    if (![recervedData isKindOfClass:[NSData class]]) {
      break;
    }
    if (recervedData.length <= 0) {
      break;
    }
    JSONDecoder *jsonDecoder = [[JSONDecoder alloc] init];
    NSDictionary *jsonRootNSDictionary
    = [jsonDecoder objectWithData:recervedData];
    [jsonDecoder release];
    [urlRequest release];
    
    if (![jsonRootNSDictionary isKindOfClass:[NSDictionary class]]) {
      break;
    }
    NSArray *infoArray = [jsonRootNSDictionary objectForKey:@"results"];
    if ([infoArray count] > 0) {
      NSDictionary *releaseInfo = [infoArray objectAtIndex:0];
      NSString *lastVersion = [releaseInfo objectForKey:@"version"];
      NSString *trackViewUrl = [releaseInfo objectForKey:@"trackViewUrl"];
      NSString *fileSizeBytes = [releaseInfo objectForKey:@"fileSizeBytes"];
      versionBean = [VersionNetRespondBean versionNetRespondBeanWithNewVersion:lastVersion
                                                                   andFileSize:fileSizeBytes
                                                              andUpdateContent:nil
                                                            andDownloadAddress:trackViewUrl];
    }
  } while (NO);
  
  return versionBean;
}

+(NSString *)localAppVersion {
  NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
  NSString *appVersion = [infoDic objectForKey:@"CFBundleVersion"];
  return appVersion;
}

// 加载内部错误时的UI(Activity之间传递的必须参数无效), 并且隐藏 bodyLayout
+(void)loadIncomingIntentValidUIWithSuperView:(UIView *)superView andHideBodyLayout:(UIView *)bodyLayout {
  if (![superView isKindOfClass:[UIView class]]) {
    // 入参错误
    return;
  }
  
  PreloadingUIToolBar *preloadingUIToolBar = [PreloadingUIToolBar preloadingUIToolBar];
  [preloadingUIToolBar setHintInfo:kIncomingIntentValid];
  [preloadingUIToolBar showInView:superView];
  
  // 外部传入的数据非法, 就隐藏掉 bodyLayout
  if ([bodyLayout isKindOfClass:[UIView class]]) {
    bodyLayout.hidden = YES;
  }
  
}
@end
