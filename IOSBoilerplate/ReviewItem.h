//
//  ReviewItem.h
//  airizu
//
//  Created by 唐志华 on 13-2-26.
//
//

#import <Foundation/Foundation.h>

@interface ReviewItem : NSObject {
  
}

@property (nonatomic, readonly) NSNumber *code;
@property (nonatomic, readonly) NSString *name;

#pragma mark -
#pragma mark 方便构造
+(id)reviewItemWithItemCode:(NSNumber *)code itemName:(NSString *)name;
@end
