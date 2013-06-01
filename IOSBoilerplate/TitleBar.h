//
//  TitleBar.h
//  airizu
//
//  Created by 唐志华 on 12-12-24.
//
//  修改记录:
//          1) 20130122 完成第一版本正式代码
//

#import <UIKit/UIKit.h>

#import "CustomControlDelegate.h"


typedef enum  {
  //
  kTitleBarActionEnum_LeftButtonClicked = 0,
  //
  kTitleBarActionEnum_RightButtonClicked
} TitleBarActionEnum;

@interface TitleBar : UIView {
  
}
@property (retain, nonatomic) IBOutlet UIButton *leftButton;
@property (retain, nonatomic) IBOutlet UIButton *rightButton;
@property (retain, nonatomic) IBOutlet UIImageView *logoImage;
@property (retain, nonatomic) IBOutlet UILabel *titleLabel;

@property (nonatomic, assign) id<CustomControlDelegate> delegate;

+(id)titleBar;

-(void)setLeftButtonByImageName:(NSString *)imageName forState:(UIControlState)state;
-(void)setRightButtonByImageName:(NSString *)imageName forState:(UIControlState)state;
-(void)setTitleByString:(NSString *)titleNameString;
-(void)setTitleByImageName:(NSString *)imageName;

-(void)hideLeftButton:(BOOL)hide;
-(void)hideRightButton:(BOOL)hide;

@end
