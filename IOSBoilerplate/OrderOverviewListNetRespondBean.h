//
//  OrderOverviewListNetRespondBean.h
//  airizu
//
//  Created by 唐志华 on 13-1-1.
//
//

#import <Foundation/Foundation.h>

@interface OrderOverviewListNetRespondBean : NSObject {
  
}

@property(nonatomic, readonly) NSArray *orderOverviewList;

#pragma mark -
#pragma mark 方便构造

+(id)orderOverviewListNetRespondBeanWithOrderOverviewList:(NSArray *)orderOverviewList;
@end
