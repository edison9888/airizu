//
//  ReviewItem.m
//  airizu
//
//  Created by 唐志华 on 13-2-26.
//
//

#import "ReviewItem.h"

@implementation ReviewItem

- (void) dealloc {
	PRPLog(@"dealloc: [0x%x]", [self hash]);
	
  [_code release];
  [_name release];
  
	[super dealloc];
}

-(id)initWithItemCode:(NSNumber *)code itemName:(NSString *)name {
  
  if ((self = [super init])) {
		PRPLog(@"init [0x%x]", [self hash]);
    
    _code = [code copy];
    _name = [name copy];
    
  }
  
  return self;
}

#pragma mark -
#pragma mark 方便构造
+(id)reviewItemWithItemCode:(NSNumber *)code itemName:(NSString *)name {
  
  return [[[ReviewItem alloc] initWithItemCode:code itemName:name] autorelease];
}

#pragma mark
#pragma mark 不能使用默认的init方法初始化对象, 而必须使用当前类特定的 "初始化方法" 初始化所有参数
- (id) init {
  NSAssert(NO, @"Can not use the default init method!");
  
  return nil;
}

- (NSString *)description {
	return descriptionForDebug(self);
}
@end
