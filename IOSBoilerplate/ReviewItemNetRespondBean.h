//
//  ReviewItemNetRespondBean.h
//  airizu
//
//  Created by 唐志华 on 13-1-1.
//
//

#import <Foundation/Foundation.h>

@interface ReviewItemNetRespondBean : NSObject {
  
}

@property (nonatomic, readonly) NSArray *itemList;

#pragma mark -
#pragma mark 方便构造

+(id)reviewItemNetRespondBeanWithItemList:(NSArray *)itemList;

@end