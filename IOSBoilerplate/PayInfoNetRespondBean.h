//
//  PayInfoNetRespondBean.h
//  airizu
//
//  Created by 唐志华 on 13-1-1.
//
//

#import <Foundation/Foundation.h>

@interface PayInfoNetRespondBean : NSObject {
  
}

@property (nonatomic, readonly) NSString *payInfo;// 支付信息

#pragma mark -
#pragma mark 方便构造

+(id)payInfoNetRespondBeanWithPayInfo:(NSString *)payInfo;
@end
