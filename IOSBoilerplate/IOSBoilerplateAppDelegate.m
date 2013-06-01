

#import "IOSBoilerplateAppDelegate.h"

#import "BrowserViewController.h"

#import "Intent.h"
#import "LocalActivityManager.h"
#import "FirstActivity.h"


#import "GloblaDataCacheForNeedSaveToFileSystem.h"

#import "ToolsFunctionForThisProgect.h"



#import "AlixPay.h"
#import "AlixPayResult.h"
#import "DataVerifier.h"
#import <sys/utsname.h>

#import "JSONKit.h"





#import "CommandInvokerSingleton.h"

#import "CommandForPrintDeviceInfo.h"
#import "CommandForInitLBSLibrary.h"
#import "CommandForInitMobClick.h"
#import "CommandForInitURLCache.h"
#import "CommandForEnableAFNetwork.h"
#import "CommandForGetUserLocationInfo.h"
#import "CommandForLoadingLocalCacheData.h"
#import "CommandForUserAutoLogin.h"
#import "CommandForNewAppVersionCheck.h"



static const NSString *const TAG = @"<IOSBoilerplateAppDelegate>";


/*
 UIApplicationDelegate 代理函数调用的时间（应用程序生命周期）
 
 UIApplicationDelegate 包含下面几个函数监控应用程序状态的改变:
 – application:didFinishLaunchingWithOptions:
 – applicationDidBecomeActive:
 – applicationWillResignActive:
 – applicationDidEnterBackground:
 – applicationWillEnterForeground:
 – applicationWillTerminate:
 
 1)
 当一个应用程序首先运行时，调用函数 didFinishLaunchingWithOptions ，但此时应用程序还处于inactive状态，
 所以接着会调用 applicationDidBecomeActive 函数，此时就进入了应用程序的界面了。
 
 2)
 接着当按下home键时（此时主界面是应用程序主界面），会调用applicationWillResignActive函数，
 接着调用applicationDidEnterBackground函数，这时手机回到桌面。
 
 3)
 当再按下应用程序图标时，（假设此时应用程序的内存还没有被其他的应用程序挤掉），
 调用 applicationWillEnterForeground 函数，接着调用 applicationDidBecomeActive 函数，
 此时又会到应用程序主界面。
 
 4)
 在应用程序的主界面，我们双击home键，（出现多任务栏），调用 applicationWillResignActive 函数，
 点击上面部分又会回到程序中，调用 applicationDidBecomeActive 函数，如果点击多任务栏的其他应用程序，
 则会调用 applicationDidEnterBackground 函数之后，进入其他应用程序的界面。
 
 5)
 而对于 applicationWillTerminate 函数，这里要说明一下：对于我们一般的应用程序，当按下home按钮之后，
 应用程序会处于一个suspended状态，如果现在去运行其他的程序，当内存不足，
 或者在多任务栏点击“减号”会完全退出应用程序，但是不管是哪一种，
 都不会去调用 applicationWillTerminate 函数（针对IOS4以上），因此我们不能在此函数中保存数据。
 那 applicationWillTerminate 函数在什么时间调用呢？我查了下资料，还在网上找了找，
 原来这与当应用程序按下home按钮之后，应用程序的状态有关，当状态为suspended时，是永远不会调用此函数的，
 而当状态为“后台运行”（running in the background）时，当内存不足或者点击“减号”时，才会调用此函数！
 
 官方的原话为：
 （Even if you develop your application using iPhone SDK 4 and later, you must still be prepared for your application to be terminated. If memory becomes constrained, the system might remove applications from memory in order to make more room. If your application is currently suspended, the system removes your application from memory without any notice. However, if your application is currently running in the background, the system does call the applicationWillTerminate:method of the application delegate. Your application cannot request additional background execution time from this method.）
 */




@implementation IOSBoilerplateAppDelegate

typedef NS_ENUM(NSInteger, AlertTypeEnum) {
  // 支付宝支付成功
  kAlertTypeEnum_AlixPayPaySucceed = 0,
  // 支付宝支付失败
  kAlertTypeEnum_AlixPayPayFailed
};

- (void)dealloc {
  PRPLog(@"dealloc: %@ [0x%x]", TAG, [self hash]);
  
  
  // UI
  [_window release];
  [super dealloc];
}

+ (IOSBoilerplateAppDelegate *) sharedAppDelegate {
	return (IOSBoilerplateAppDelegate *) [UIApplication sharedApplication].delegate;
}

- (BOOL) openURL:(NSURL *) url {
  BrowserViewController *bvc = [[BrowserViewController alloc] initWithUrls:url];
  [self.navigationController pushViewController:bvc animated:YES];
  [bvc release];
  
  return YES;
}

#pragma mark -
#pragma mark Application lifecycle



#pragma mark 1) 应用程序入口
- (BOOL) application:(UIApplication *) application didFinishLaunchingWithOptions:(NSDictionary *) launchOptions {
  
  PRPLog(@"init %@ [0x%x]", TAG, [self hash]);
  
  id command = nil;
  
  // 打印当前设备的信息
  command = [CommandForPrintDeviceInfo commandForPrintDeviceInfo];
  [[CommandInvokerSingleton sharedInstance] runCommandWithCommandObject:command];
  
  // 初始化 百度LBS
  command = [CommandForInitLBSLibrary commandForInitLBSLibrary];
  [[CommandInvokerSingleton sharedInstance] runCommandWithCommandObject:command];
  
  // 启动友盟SDK
  command = [CommandForInitMobClick commandForInitMobClick];
  [[CommandInvokerSingleton sharedInstance] runCommandWithCommandObject:command];
  
  // use custom URLCache to get disk caching on iOS
  command = [CommandForInitURLCache commandForInitURLCache];
  [[CommandInvokerSingleton sharedInstance] runCommandWithCommandObject:command];
  
  // 打开 AFNetworking 引擎
  command = [CommandForEnableAFNetwork commandForEnableAFNetwork];
  [[CommandInvokerSingleton sharedInstance] runCommandWithCommandObject:command];
  
  // 获取用户当前所在位置信息
  command = [CommandForGetUserLocationInfo commandForGetUserLocationInfo];
  [[CommandInvokerSingleton sharedInstance] runCommandWithCommandObject:command];
  
  // 加载本地缓存的数据
  command = [CommandForLoadingLocalCacheData commandForLoadingLocalCacheData];
  [[CommandInvokerSingleton sharedInstance] runCommandWithCommandObject:command];
  
  // 用户自动登录
  command = [CommandForUserAutoLogin commandForUserAutoLogin];
  [[CommandInvokerSingleton sharedInstance] runCommandWithCommandObject:command];
  
  // 启动 "新版本信息检测" 子线程
  command = [CommandForNewAppVersionCheck commandForNewAppVersionCheck];
  [[CommandInvokerSingleton sharedInstance] runCommandWithCommandObject:command];
  
  
  
  //////////////////////////////////////////////////////////////
  // Add the view controller's view to the window and display.
  LocalActivityManager *localActivityManager = [LocalActivityManager sharedInstance];
  [_window addSubview:localActivityManager.rootViewController.view];
  [_window makeKeyAndVisible];
  
  // 启动App第一个界面
  Intent *intent = [Intent intentWithSpecificComponentClass:[FirstActivity class]];
  [self startActivity:intent];
  //////////////////////////////////////////////////////////////
  
  
  
  
  //////////////////////////////////////////////////////////////
  /*
	 * 支付宝安全支付所需要的代码支持 - 单任务handleURL处理
	 */
	if ([self isSingleTask]) {
		NSURL *url = [launchOptions objectForKey:@"UIApplicationLaunchOptionsURLKey"];
		
		if (nil != url) {
			[self parseURL:url application:application];
		}
	}
  //////////////////////////////////////////////////////////////
  
  
  
  
  return YES;
}

#pragma mark 2) 应用程序被中断（如来电，来短信）
- (void)applicationWillResignActive:(UIApplication *)application {
  
}
#pragma mark 3) 进入后台(比如按下 home 按键)
- (void)applicationDidEnterBackground:(UIApplication *)application {
  // 在这里保存那些需要固化到文件系统的数据
  [GloblaDataCacheForNeedSaveToFileSystem saveAllCacheDataToFileSystem];
}
#pragma mark 4) 从后台返回前台
- (void)applicationWillEnterForeground:(UIApplication *)application
{
  
}
#pragma mark 5)
- (void)applicationDidBecomeActive:(UIApplication *)application
{
  
}
#pragma mark 6)
- (void)applicationWillTerminate:(UIApplication *)application
{
  
}
#pragma mark 7) 内存不足
- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
  
}













#pragma mark -
#pragma mark 支付宝接口
- (BOOL)isSingleTask{
	struct utsname name;
	uname(&name);
	float version = [[UIDevice currentDevice].systemVersion floatValue];//判定系统版本。
	if (version < 4.0 || strstr(name.machine, "iPod1,1") != 0 || strstr(name.machine, "iPod2,1") != 0) {
		return YES;
	}
	else {
		return NO;
	}
}

/*
 AlixPayResult 表示安全支付返回的结果,都是只读信息。
 
 5.1 statusCode
 返回安全支付的操作状态。
 - (int)statusCode
 返回值 安全支付的操作状态码。状态码的含义请参考表 B。
 
 5.2 statusMessage
 返回安全支付的操作状态信息。
 - (NSString *)statusMessage
 返回值
 安全支付的操作状态的字符串描述。
 
 5.3resultString
 安全支付返回的结果
 - (NSString *)resultString
 返回值
 安全支付返回的原始字符串。
 
 5.4 signString
 对 resultString 的签名字符串,方便外部商户验签结果安全性。
 - (NSString *)signString
 返回值
 对 resultString 的签名字符串。
 
 
 ￼5.5 signType
 签名类型,目前为 RSA 类型。
 - (int)signString
 返回值
 签名类型。
 
 
 */
- (void)parseURL:(NSURL *)url application:(UIApplication *)application {
	AlixPay *alixpay = [AlixPay shared];
	AlixPayResult *result = [alixpay handleOpenURL:url];
	if (result) {
    /*
     特别说明:
     调用本方法的应用程序,需要通过resultStatus以及result字段的值来综合判断并确 定支付结果。
     在resultStatus=9000, 并且success="true"以及sign="xxx"校验通过的情 况下,
     证明支付成功。其它情况归为失败。
     较低安全级别的场合, 也可以只通过检查 resultStatus以及success="true"来判定支付结果。
     */
		if (9000 == result.statusCode) {//是否支付成功
			/*
			 *用公钥验证签名
			 */
			id<DataVerifier> verifier
      = CreateRSADataVerifier([[NSBundle mainBundle] objectForInfoDictionaryKey:@"RSA public key"]);
      
			if ([verifier verifyString:result.resultString withSign:result.signString]) {
				UIAlertView *alertView
        = [[UIAlertView alloc] initWithTitle:nil
                                     message:@"预订成功"
                                    delegate:self
                           cancelButtonTitle:@"确定"
                           otherButtonTitles:nil];
        alertView.tag = kAlertTypeEnum_AlixPayPaySucceed;
				[alertView show];
				[alertView release];
        
			} else {// 验签错误
        
				UIAlertView *alertView
        = [[UIAlertView alloc] initWithTitle:nil
                                     message:@"签名错误"
                                    delegate:self
                           cancelButtonTitle:@"确定"
                           otherButtonTitles:nil];
        alertView.tag = kAlertTypeEnum_AlixPayPayFailed;
				[alertView show];
				[alertView release];
			}
      
		} else {// 如果支付失败,可以通过result.statusCode查询错误码
      
			UIAlertView *alertView
      = [[UIAlertView alloc] initWithTitle:nil
                                   message:result.statusMessage
                                  delegate:self
                         cancelButtonTitle:@"确定"
                         otherButtonTitles:nil];
      alertView.tag = kAlertTypeEnum_AlixPayPayFailed;
			[alertView show];
			[alertView release];
		}
		
	}
}

/*
 
 订单支付接口。
 + (int)pay:(NSString *)orderString applicationScheme:(NSString *)scheme;
 
 这是一个异步方法,可以在 UI 线程中调用。 安全支付结束时,会生成一个如下的 URL:
 <yourApplicationScheme>://safepay/?<query> 并且会对这个 URL 调用如下的方法:
 [[UIApplication sharedApplication] openURL:url]; 返回外部商户程序,需要处理该 URL
 
 */

/*
 定义 ----
 当安全支付回调,处理 applicationDelegate 中系统函数 application:handleOpenURL 中的 URL。
 - (AlixPayResult *)handleOpenURL:(NSURL *)url;
 
 参数 ----
 application:handleOpenURL 中的 URL,这个 URL 包含安全支付服务信息。 返回值
 如果由安全支付服务打开外部商户程序,返回一个 AlixPayResult 的实例。 如果该 URL 不是由安全支付回调打开的,则返回 nil。
 
 说明 ----
 安全支付完成后(不管是否操作成功),第三方应用都会被安全支付重新唤起,这时第 三方应用需要接收回调的 url,
 并将返回的 url 交由 handleOpenURL 去解析安全支付服务回 调信息。
 */
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
	
	[self parseURL:url application:application];
	return YES;
}

#pragma mark -
#pragma mark 实现 UIAlertViewDelegate 接口
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
  
  switch (alertView.tag) {
      
    case kAlertTypeEnum_AlixPayPaySucceed:{// 订单已经支付成功
      Intent *intent = [Intent intent];
      [intent setAction:[[NSNumber numberWithUnsignedInteger:kUserNotificationEnum_OrderPaySucceed] stringValue]];
      [self sendBroadcast:intent];
    }break;
      
    case kAlertTypeEnum_AlixPayPayFailed: {
      Intent *intent = [Intent intent];
      [intent setAction:[[NSNumber numberWithUnsignedInteger:kUserNotificationEnum_OrderPayFailed] stringValue]];
      [self sendBroadcast:intent];
    }break;
    default:
      break;
  }
  
}
@end
