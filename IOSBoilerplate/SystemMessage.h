//
//  SystemMessage.h
//  airizu
//
//  Created by 唐志华 on 13-1-1.
//
//

#import <Foundation/Foundation.h>

@interface SystemMessage : NSObject {
  
}

// 时间
@property (nonatomic, readonly) NSString *date;
// 内容
@property (nonatomic, readonly) NSString *message;

#pragma mark -
#pragma mark 方便构造

+(id)systemMessageWithDate:(NSString *)date
                   message:(NSString *)message;
@end
