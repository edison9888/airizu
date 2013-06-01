//
//  NetRequestEntityDataPackageForAirizu.m
//  airizu
//
//  Created by 唐志华 on 12-12-18.
//
//

#import "NetRequestEntityDataPackageForAirizu.h"

static const NSString *const TAG = @"<NetRequestEntityDataPackageForAirizu>";

@implementation NetRequestEntityDataPackageForAirizu
- (id) init {
	
	if ((self = [super init])) {
		PRPLog(@"init %@ [0x%x]", TAG, [self hash]);
    
	}
	
	return self;
}

- (void) dealloc {
	PRPLog(@"dealloc: %@ [0x%x]", TAG, [self hash]);
	
	[super dealloc];
}

//static NSString * AFURLEncodedStringFromString(NSString *string) {
//  static NSString * const kAFLegalCharactersToBeEscaped = @"?!@#$^&%*+,:;='\"`<>()[]{}/\\|~ ";
//  
//	return [(NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
//                                                              (CFStringRef)string,
//                                                              NULL,
//                                                              (CFStringRef)kAFLegalCharactersToBeEscaped,
//                                                              CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding)) autorelease];
//}
//
//static NSString * AFQueryStringFromParameters(NSDictionary *parameters) {
//  NSMutableArray *mutableParameterComponents = [NSMutableArray array];
//  for (id key in [parameters allKeys]) {
//    NSString *component = [NSString stringWithFormat:@"%@=%@",
//                           AFURLEncodedStringFromString([key description]),
//                           AFURLEncodedStringFromString([[parameters valueForKey:key] description])];
//    [mutableParameterComponents addObject:component];
//  }
//  
//  return [mutableParameterComponents componentsJoinedByString:@"&"];
//}

#pragma mark 实现 INetRequestEntityDataPackage 接口方法
- (NSData *) packageNetRequestEntityData:(NSDictionary *) domainDD {
  
  if ([domainDD count] <= 0) {
    // 入参为空
    return nil;
  }
  
  // 这里只是演示 NSEnumerator 如何使用, 上面 AFQueryStringFromParameters 方法才是更好的
  NSEnumerator *keyEnumerator = [domainDD keyEnumerator];
  NSString *key = [keyEnumerator nextObject];
  NSMutableString *entityDataString = [NSMutableString string];
  while (key != nil) {
    NSString *value = [domainDD objectForKey:key];
    if ([value length] > 0) {
      [entityDataString appendFormat:@"%@=%@", key, value];
    }
    
    key = [keyEnumerator nextObject];
    if (key != nil) {
      [entityDataString appendString:@"&"];
    }
  }
  
  PRPLog(@"packageNetRequestEntityData-> %@", entityDataString);
  
  return [entityDataString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
}
@end
