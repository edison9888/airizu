//
//  NetErrorBean.m
//  airizu
//
//  Created by 唐志华 on 12-12-17.
//
//

#import "NetErrorBean.h"

static const NSString *const TAG = @"<NetErrorBean>";

@implementation NetErrorBean

-(NSString *)errorMessage{
  if (_errorMessage == nil) {
    self.errorMessage = @"";
  }
  return _errorMessage;
}

- (id) init {
	
	if ((self = [super init])) {
		PRPLog(@"init %@ [0x%x]", TAG, [self hash]);
    
    _errorType = NET_ERROR_TYPE_SUCCESS;
    _errorCode = 200;
    _errorMessage = [[NSString alloc] initWithString:@"OK"];
	}
	
	return self;
}

- (void) dealloc {
	PRPLog(@"dealloc: %@ [0x%x]", TAG, [self hash]);
	
  [_errorMessage release];
  
	[super dealloc];
}

- (NSString *)description {
  NSString *description = [NSString stringWithFormat:@"NetErrorBean [errorCode=%i, errorType=%i, errorMessage=%@]", _errorCode, _errorType, _errorMessage];
  return description;
}

#pragma mark -
#pragma mark 方便构造
+(id)netErrorBean {
  return [[[NetErrorBean alloc] init] autorelease];
}

#pragma mark -
#pragma mark 实现 NSCopying 接口
- (id)copyWithZone:(NSZone *)zone {
  NetErrorBean *copy = [[[self class] allocWithZone:zone] init];
  copy.errorType = _errorType;
  copy.errorCode = _errorCode;
  copy.errorMessage = _errorMessage;
  
  return copy;
}
@end
