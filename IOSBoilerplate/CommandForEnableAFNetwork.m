//
//  CommandForEnableAFNetwork.m
//  airizu
//
//  Created by 唐志华 on 13-3-22.
//
//

#import "CommandForEnableAFNetwork.h"
#import "AFNetworkActivityIndicatorManager.h"

@implementation CommandForEnableAFNetwork
/**
 
 * 执行命令对应的操作
 
 */
-(void)execute {
  [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
}

+(id)commandForEnableAFNetwork {
  return [[[CommandForEnableAFNetwork alloc] init] autorelease];
}
@end
