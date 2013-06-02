
#import <UIKit/UIKit.h>
 
// main
@interface IOSBoilerplateAppDelegate : Activity <UIApplicationDelegate, UIAlertViewDelegate> {
  
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

//@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

+ (IOSBoilerplateAppDelegate*) sharedAppDelegate;

- (BOOL)openURL:(NSURL*)url;

@end
