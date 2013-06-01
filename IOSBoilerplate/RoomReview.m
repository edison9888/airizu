//
//  RoomReview.m
//  airizu
//
//  Created by 唐志华 on 13-1-1.
//
//

#import "RoomReview.h"

static const NSString *const TAG = @"<RoomReview>";

@implementation RoomReview

- (void) dealloc {
	PRPLog(@"dealloc: %@ [0x%x]", TAG, [self hash]);
	
  [_userName release];
  [_userReviewTime release];
  [_userReview release];
  [_hostReviewTime release];
  [_hostReview release];
  
	[super dealloc];
}

- (id) initWithUserName:(NSString *)userName
         userReviewTime:(NSString *)userReviewTime
             userReview:(NSString *)userReview
         hostReviewTime:(NSString *)hostReviewTime
             hostReview:(NSString *)hostReview
{
  
  if ((self = [super init])) {
		PRPLog(@"init %@ [0x%x]", TAG, [self hash]);
    
    _userName = [userName copy];
    _userReviewTime = [userReviewTime copy];
    _userReview = [userReview copy];
    _hostReviewTime = [hostReviewTime copy];
    _hostReview = [hostReview copy];
    
  }
  
  return self;
}

#pragma mark -
#pragma mark 方便构造

+(id)roomReviewWithUserName:(NSString *)userName
             userReviewTime:(NSString *)userReviewTime
                 userReview:(NSString *)userReview
             hostReviewTime:(NSString *)hostReviewTime
                 hostReview:(NSString *)hostReview {
  
  return [[[RoomReview alloc] initWithUserName:userName
                                userReviewTime:userReviewTime
                                    userReview:userReview
                                hostReviewTime:hostReviewTime
                                    hostReview:hostReview] autorelease];
}

#pragma mark
#pragma mark 不能使用默认的init方法初始化对象, 而必须使用当前类特定的 "初始化方法" 初始化所有参数
- (id) init {
  NSAssert(NO, @"Can not use the default init method!");
  
  return nil;
}

- (NSString *)description {
	return descriptionForDebug(self);
}
@end