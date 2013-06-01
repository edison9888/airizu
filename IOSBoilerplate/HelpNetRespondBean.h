//
//  HelpNetRespondBean.h
//  airizu
//
//  Created by 唐志华 on 13-1-1.
//
//

#import <Foundation/Foundation.h>

@interface HelpNetRespondBean : NSObject {
  
}

@property(nonatomic, readonly) NSArray *helpInfoList;

#pragma mark -
#pragma mark 方便构造

+(id)helpNetRespondBeanWithHelpInfoList:(NSArray *)helpInfoList;
@end
