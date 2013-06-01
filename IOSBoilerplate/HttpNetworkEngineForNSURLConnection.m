//
//  HttpNetworkEngineForNSURLConnection.m
//  airizu
//
//  Created by 唐志华 on 12-12-20.
//
//

#import "HttpNetworkEngineForNSURLConnection.h"

#import "HttpNetworkEngineParameterEnum.h"
#import "NetErrorBean.h"
#import "NSString+Expand.h"

static const NSString *const TAG = @"<HttpNetworkEngineForNSURLConnection>";

@interface HttpNetworkEngineForNSURLConnection ()
@property (nonatomic, assign) long long expectedContentLength;
@property (nonatomic, assign) BOOL finished;
@property (nonatomic, retain) NSMutableData *receivedData;
@property (nonatomic, retain) NetErrorBean *netErrorBean;
@end

@implementation HttpNetworkEngineForNSURLConnection

- (id) init {
	
	if ((self = [super init])) {
		PRPLog(@"init %@ [0x%x]", TAG, [self hash]);
    
    _expectedContentLength = 0;
    _finished = NO;
    _receivedData = [[NSMutableData alloc] init];
    _netErrorBean = [[NetErrorBean alloc] init];
	}
	
	return self;
}

#pragma mark -
#pragma mark 方便构造
+(id)httpNetworkEngineForNSURLConnection {
  return [[[HttpNetworkEngineForNSURLConnection alloc] init] autorelease];
}

- (void) dealloc {
	PRPLog(@"dealloc: %@ [0x%x]", TAG, [self hash]);
	
  [_receivedData release];
  [_netErrorBean release];
	[super dealloc];
}

#pragma mark 实现 IHttpNetworkEngine 接口
- (NSData *) requestNetByHttpWithHttpRequestParameter:(in NSDictionary *) httpRequestParameterMap
                                   outputNetErrorBean:(out NetErrorBean *) netErrorForOUT {
  
  PRPLog(@"--> requestNetByHttpConnection is start ! ");
  
  do {
    if (![httpRequestParameterMap isKindOfClass:[NSDictionary class]] || ![netErrorForOUT isKindOfClass:[NetErrorBean class]]) {
      PRPLog(@"--> 方法入参异常 ! httpRequestHeadMap/netErrorForOUT 类型不正确 !  ");
      [_netErrorBean setErrorType:NET_ERROR_TYPE_CLIENT_EXCEPTION];
      [_netErrorBean setErrorMessage:@"入参非法!"];
			break;
    }
    if ([httpRequestParameterMap count] <= 0) {
      PRPLog(@"--> 方法入参异常 ! httpRequestHeadMap的内容不能为空 !  ");
      [_netErrorBean setErrorType:NET_ERROR_TYPE_CLIENT_EXCEPTION];
      [_netErrorBean setErrorMessage:@"入参非法!"];
			break;
		}
		
    // URL
		NSString *urlString = [httpRequestParameterMap objectForKey:kHttpNetworkEngineParameterEnum_URL];
    // RequestMethod
		NSString *requestMethodString = [httpRequestParameterMap objectForKey:kHttpNetworkEngineParameterEnum_REQUEST_METHOD];
    // EntityData
		NSData *entityDataString =[httpRequestParameterMap objectForKey:kHttpNetworkEngineParameterEnum_ENTITY_DATA];
    //NSString *readTimeoutString = [httpRequestParameterMap objectForKey:kHttpNetworkEngineParameterEnum_READ_TIMEOUT];
    // Cookie
		NSString *cookieString = [httpRequestParameterMap objectForKey:kHttpNetworkEngineParameterEnum_COOKIE];
    // ContentType
		NSString *contentTypeString = [httpRequestParameterMap objectForKey:kHttpNetworkEngineParameterEnum_CONTENT_TYPE];
		// final String contentEncodingString = httpRequestParameterMap.get(HttpNetworkEngineParameterEnum.CONTENT_ENCODING.name());
		// final String userAgentString = httpRequestParameterMap.get(HttpNetworkEngineParameterEnum.USER_AGENT.name());
		if ([NSString isEmpty:urlString] || [NSString isEmpty:requestMethodString]) {
      PRPLog(@"--> 主要的Http请求参数不能为空(URL/REQUEST_METHOD) ! ");
      [_netErrorBean setErrorType:NET_ERROR_TYPE_CLIENT_EXCEPTION];
      [_netErrorBean setErrorMessage:@"主要的Http请求参数不全!"];
			break;
		}
    
    PRPLog(@"--> 1. 开始构建 NSMutableURLRequest ");
    NSURL *url = [[[NSURL alloc]initWithString:urlString] autorelease];
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
    // 设置网络请求超时时间 (秒)
    [request setTimeoutInterval:10];
    // 设置Cookie
    if (![NSString isEmpty:cookieString]) {
      [request setValue:cookieString forHTTPHeaderField:@"Cookie"];
    }
    
    //
    [request setURL: url];
    
    // 设置请求类型
    if ([requestMethodString isEqualToString:@"GET"]) {
      [request setHTTPMethod:@"GET"];
    } else {
      [request setHTTPMethod:@"POST"];
      
      NSUInteger dataLength = [entityDataString length];
      if (dataLength > 0) {
        [request setValue:[[NSNumber numberWithUnsignedInteger:dataLength] stringValue] forHTTPHeaderField:@"Content-Length"];
        [request setHTTPBody:entityDataString];
      }
    }
    
    //
    [request setValue:contentTypeString forHTTPHeaderField:@"Content-Type"];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    
    PRPLog(@"--> 2. 开始构建 NSURLConnection ");
    NSURLConnection *connection = [[[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:true] autorelease];
    if (connection == nil) {
      [_netErrorBean setErrorType:NET_ERROR_TYPE_CLIENT_NET_ERROR];
      [_netErrorBean setErrorMessage:@"客户端连接网络失败!"];
      break;
    }
    
    //
    while(!_finished) {
      [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    
  } while (NO);
  
  [netErrorForOUT setErrorCode:_netErrorBean.errorCode];
  [netErrorForOUT setErrorType:_netErrorBean.errorType];
  [netErrorForOUT setErrorMessage:_netErrorBean.errorMessage];
  return _receivedData;
}

#pragma mark -
#pragma mark NSURLConnectionDataDelegate
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
  PRPLog(@"--> connection:didReceiveResponse:");
  if (response != nil) {
    PRPLog(@"--> connection:didReceiveResponse:MIMEType=%@", [response MIMEType]);
    PRPLog(@"--> connection:didReceiveResponse:URL=%@", [response URL]);
    
    // 本次网络请求, 输入流实体数据长度
    _expectedContentLength = [response expectedContentLength];
    PRPLog(@"--> connection:didReceiveResponse:expectedContentLength=%lld", [response expectedContentLength]);
    PRPLog(@"--> connection:didReceiveResponse:textEncodingName=%@", [response textEncodingName]);
    PRPLog(@"--> connection:didReceiveResponse:suggestedFilename=%@", [response suggestedFilename]);
  }
  
  // 设置...???
	[_receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
  PRPLog(@"--> connection:didReceiveData:");
  if (data != nil) {
    PRPLog(@"--> connection:didReceiveData:本次下载的数据长度 length=%d", [data length]);
  }
	[_receivedData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
  PRPLog(@"--> connectionDidFinishLoading:%@", connection);
  
  if (_expectedContentLength == _receivedData.length) {
    [_netErrorBean setErrorType:NET_ERROR_TYPE_SUCCESS];
    [_netErrorBean setErrorMessage:@"OK"];
  } else {
    [_netErrorBean setErrorType:NET_ERROR_TYPE_SERVER_NET_ERROR];
    [_netErrorBean setErrorMessage:@"数据下载不完整."];
  }
  
  // 正常下载完成
	_finished = YES;
}

#pragma mark -
#pragma mark NSURLConnectionDelegate
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
  PRPLog(@"--> connection:didFailWithError:");
  // 出现错误
  if (error != nil) {
    PRPLog(@"--> connection:didFailWithError:domain=%@", [error domain]);
    PRPLog(@"--> connection:didFailWithError:code=%d", [error code]);
    PRPLog(@"--> connection:didFailWithError:userInfo=%@", [error userInfo]);
    PRPLog(@"--> connection:didFailWithError:localizedDescription=%@", [error localizedDescription]);
    PRPLog(@"--> connection:didFailWithError:localizedFailureReason=%@", [error localizedFailureReason]);
    PRPLog(@"--> connection:didFailWithError:localizedRecoverySuggestion=%@", [error localizedRecoverySuggestion]);
    PRPLog(@"--> connection:didFailWithError:helpAnchor=%@", [error helpAnchor]);
  }
  
  [_netErrorBean setErrorType:NET_ERROR_TYPE_SERVER_NET_ERROR];
  [_netErrorBean setErrorMessage:[error localizedDescription]];
  [_netErrorBean setErrorCode:[error code]];
  
	_finished = YES;
}

@end
