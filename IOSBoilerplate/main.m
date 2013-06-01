//
//  main.m
//  IOSBoilerplate
//
//  Created by Alberto Gimeno Brieba on 08/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

int main(int argc, char *argv[])
{
  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
  int retVal = UIApplicationMain(argc, argv, @"MyApplication", nil);
  
  // 在垃圾回收环境中, release 是一个空操作, 因此 NSAutoreleasePool 提供了 drain 方法,
  // 在引用记数环境中, 该方法的作用等同与调用 release, 但是在垃圾回收环境中, 他会触发垃圾回收.
  // 因此在通常情况下, 您应该使用 drain 而不是 release来销毁自动释放池.
  [pool drain];
  return retVal;
}


