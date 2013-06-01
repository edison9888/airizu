//
//  TitleBar.m
//  airizu
//
//  Created by 唐志华 on 12-12-24.
//
//

#import "TitleBar.h"

static const NSString *const TAG = @"<TitleBar>";

@implementation TitleBar

- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    // Initialization code
    PRPLog(@"init %@ [0x%x]", TAG, [self hash]);
  }
  return self;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

- (void)dealloc {
  PRPLog(@"dealloc: %@ [0x%x]", TAG, [self hash]);
  
  [_leftButton release];
  [_rightButton release];
  [_titleLabel release];
  [_logoImage release];
  [super dealloc];
}

+ (NSString *) nibName {
  return NSStringFromClass([self class]);
}

+ (UINib *) nib {
  NSBundle *classBundle = [NSBundle bundleForClass:[self class]];
  return [UINib nibWithNibName:[self nibName] bundle:classBundle];
}

- (IBAction)buttonForTitleBarOnClickListener:(UIButton *)sender {
  if ([_delegate conformsToProtocol:@protocol(CustomControlDelegate)]) {
    if ([_delegate respondsToSelector:@selector(customControl:onAction:)]) {
      [_delegate customControl:self onAction:sender.tag];
    }
  }
}

+(id)titleBar {
  NSArray *nibObjects = [[self nib] instantiateWithOwner:nil options:nil];
  TitleBar *titleBar = [nibObjects objectAtIndex:0];
  titleBar.leftButton.tag = kTitleBarActionEnum_LeftButtonClicked;
  titleBar.rightButton.tag = kTitleBarActionEnum_RightButtonClicked;
  
  return titleBar;
}

-(void)setLeftButtonByImageName:(NSString *)imageName forState:(UIControlState)state{
  _leftButton.hidden = NO;
  [_leftButton setImage:[UIImage imageNamed:imageName] forState:state];
}
-(void)setRightButtonByImageName:(NSString *)imageName forState:(UIControlState)state{
  _rightButton.hidden = NO;
  [_rightButton setImage:[UIImage imageNamed:imageName] forState:state];
}
-(void)setTitleByString:(NSString *)titleNameString {
  _titleLabel.hidden = NO;
  _logoImage.hidden = YES;
  [_titleLabel setText:titleNameString];
}
-(void)setTitleByImageName:(NSString *)imageName {
  _titleLabel.hidden = YES;
  _logoImage.hidden = NO;
}

-(void)hideLeftButton:(BOOL)hide{
  _leftButton.hidden = hide;
}
-(void)hideRightButton:(BOOL)hide{
  _rightButton.hidden = hide;
}

@end
