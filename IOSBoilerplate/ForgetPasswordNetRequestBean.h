//
//  ForgetPasswordNetRequestBean.h
//  airizu
//
//  Created by 唐志华 on 13-1-1.
//
//

#import <Foundation/Foundation.h>

@interface ForgetPasswordNetRequestBean : NSObject {
  
}

@property (nonatomic, readonly) NSString *phoneNumber;

#pragma mark -
#pragma mark 方便构造
+(id)forgetPasswordNetRequestBeanWithPhoneNumber:(NSString *)phoneNumber;

@end
