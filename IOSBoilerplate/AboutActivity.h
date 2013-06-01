//
//  AboutActivity.h
//  airizu
//
//  Created by 唐志华 on 13-1-24.
//
//

#import "Activity.h"
#import "CustomControlDelegate.h"
#import "QuadCurveMenu.h"

@interface AboutActivity : Activity <CustomControlDelegate, QuadCurveMenuDelegate> {
  
}

@property (retain, nonatomic) IBOutlet UIView *titleBarPlaceholder;



@end
