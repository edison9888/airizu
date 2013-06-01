//
//  AccountIndexNetRespondBean.h
//  airizu
//
//  Created by 唐志华 on 13-1-1.
//
//

#import <Foundation/Foundation.h>

typedef enum {
  kSexEnum_Woman = 0,
  kSexEnum_Man   = 1
} SexEnum;

@interface AccountIndexNetRespondBean : NSObject {
  
}

// 总积分
@property (nonatomic, readonly) NSNumber *totalPoint;
// 手机号码
@property (nonatomic, readonly) NSString *phoneNumber;
// 等待房东确认的订单数量
@property (nonatomic, readonly) NSNumber *waitConfirmCount;
// 等待支付的订单数量
@property (nonatomic, readonly) NSNumber *waitPayCount;
// 等待入住的订单数量
@property (nonatomic, readonly) NSNumber *waitLiveCount;
// 等待评价的订单数量
@property (nonatomic, readonly) NSNumber *waitReviewCount;
// 用户名
@property (nonatomic, readonly) NSString *userName;
// 头像地址
@property (nonatomic, readonly) NSString *userImageURL;
// 性别
@property (nonatomic, readonly) SexEnum sex;
// 邮箱
@property (nonatomic, readonly) NSString *email;
// 手机是否验证
@property (nonatomic, readonly) BOOL isValidatePhone;
// 邮箱是否验证
@property (nonatomic, readonly) BOOL isValidateEmail;

#pragma mark -
#pragma mark 方便构造
+(id)accountIndexNetRespondBeanWithTotalPoint:(NSNumber *) totalPoint
                                  phoneNumber:(NSString *) phoneNumber
                             waitConfirmCount:(NSNumber *) waitConfirmCount
                                 waitPayCount:(NSNumber *) waitPayCount
                                waitLiveCount:(NSNumber *) waitLiveCount
                              waitReviewCount:(NSNumber *) waitReviewCount
                                     userName:(NSString *) userName
                                 userImageURL:(NSString *) userImageURL
                                          sex:(SexEnum)    sex
                                        email:(NSString *) email
                                validatePhone:(BOOL)       isValidatePhone
                                validateEmail:(BOOL)       isValidateEmail;
@end
