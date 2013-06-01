//
//  HelpInfo.h
//  airizu
//
//  Created by 唐志华 on 13-1-1.
//
//

#import <Foundation/Foundation.h>

@interface HelpInfo : NSObject {
  
}

// 类型
@property (nonatomic, readonly) NSString *type;
// 标题
@property (nonatomic, readonly) NSString *title;
// 内容
@property (nonatomic, readonly) NSString *content;


#pragma mark -
#pragma mark 方便构造

+(id)helpInfoWithType:(NSString *)type
                title:(NSString *)title
              content:(NSString *)content;
@end
