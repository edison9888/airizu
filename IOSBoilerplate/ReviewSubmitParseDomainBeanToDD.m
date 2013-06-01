//
//  ReviewSubmitParseDomainBeanToDD.m
//  airizu
//
//  Created by 唐志华 on 13-1-1.
//
//

#import "ReviewSubmitParseDomainBeanToDD.h"

#import "ReviewSubmitDatabaseFieldsConstant.h"
#import "ReviewSubmitNetRequestBean.h"

#import "NSString+Expand.h"

static const NSString *const TAG = @"<ReviewSubmitParseDomainBeanToDD>";

@implementation ReviewSubmitParseDomainBeanToDD

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

- (NSDictionary *) parseDomainBeanToDataDictionary:(in id) netRequestDomainBean {
  NSAssert(netRequestDomainBean != nil, @"入参为空 !");
  
  do {
    if (! [netRequestDomainBean isMemberOfClass:[ReviewSubmitNetRequestBean class]]) {
      NSAssert(NO, @"传入的业务Bean的类型不符 !");
      break;
    }
    
    const ReviewSubmitNetRequestBean *requestBean = netRequestDomainBean;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
		
		NSString *value = nil;
		
    //
		value = requestBean.orderId;
		if ([NSString isEmpty:value]) {
      NSAssert(NO, @"丢失关键字段 : orderId");
      break;
		}
    [params setObject:value forKey:k_ReviewSubmit_RequestKey_orderId];
    
    //
		value = requestBean.reviewContent;
		if ([NSString isEmpty:value]) {
      NSAssert(NO, @"丢失关键字段 : reviewContent");
      break;
		}
    [params setObject:value forKey:k_ReviewSubmit_RequestKey_reviewContent];
    
    //
    NSDictionary *reviewItemScoreList = requestBean.reviewItemScoreList;
    for (NSNumber *key in [reviewItemScoreList allKeys]) {
      NSString *scoreKey
      = [NSString stringWithFormat:@"%@%d", k_ReviewSubmit_RequestKey_score_, [key integerValue]];
      NSNumber *scoreValue = [reviewItemScoreList objectForKey:key];
      [params setObject:[scoreValue stringValue] forKey:scoreKey];
    }
    
    return params;
  } while (NO);
  
  return nil;
}
@end