//
//  CommandInvokerSingleton.m
//  airizu
//
//  Created by 唐志华 on 13-3-22.
//
//

#import "CommandInvokerSingleton.h"
#import "Command.h"

@implementation CommandInvokerSingleton

#pragma mark -
#pragma mark 单例方法群
static CommandInvokerSingleton *singletonInstance = nil;

-(void)initialize {
  
}

+(CommandInvokerSingleton *)sharedInstance {
  if (singletonInstance == nil) {
    singletonInstance = [[super allocWithZone:NULL] init];
    
    // initialize the first view controller
    // and keep it with the singleton
    [singletonInstance initialize];
  }
  
  return singletonInstance;
}

+(id)allocWithZone:(NSZone *)zone {
  return [[self sharedInstance] retain];
}

-(id)copyWithZone:(NSZone*)zone {
  return self;
}

-(id)retain {
  return self;
}

-(NSUInteger)retainCount {
  return NSUIntegerMax;
}

-(oneway void)release {
  // do nothing
}

-(id)autorelease {
  return self;
}

#pragma mark -
#pragma mark 执行命令
-(void)runCommandWithCommandEnum:(CommandEnum)commandEnum {
  switch (commandEnum) {
    case kCommandEnum_PrintDeviceInfo:{
      
    }break;
    case kCommandEnum_InitLBSLibrary:{
      
    }break;
    case kCommandEnum_InitMobClick:{
      
    }break;
    case kCommandEnum_InitURLCache:{
      
    }break;
    case kCommandEnum_EnableAFNetwork:{
      
    }break;
    case kCommandEnum_GetUserLocationInfo:{
      
    }break;
    case kCommandEnum_LoadingLocalCacheData:{
      
    }break;
    case kCommandEnum_UserAutoLogin:{
      
    }break;
    case kCommandEnum_NewAppVersionCheck:{
      
    }break;
    default:
      break;
  }
}

-(void)runCommandWithCommandObject:(id)commandObject {
  if ([commandObject conformsToProtocol:@protocol(Command)]) {
    [commandObject execute];
  }
}

@end
