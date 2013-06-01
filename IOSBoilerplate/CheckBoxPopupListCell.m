//
//  CheckBoxPopupListCell.m
//  airizu
//
//  Created by 唐志华 on 13-3-5.
//
//

#import "CheckBoxPopupListCell.h"

#import "CustomControlDelegate.h"





@interface CheckBoxPopupListCell ()
@property (nonatomic, copy) NSString *text;
@end





@implementation CheckBoxPopupListCell

-(void)setSelected:(BOOL)isSelected{
  if (isSelected) {
    _selectedIconImageView.hidden = NO;
  } else {
    _selectedIconImageView.hidden = YES;
  }
  
  _isSelected = isSelected;
}

- (void)dealloc {
  
  /// UI
  [_selectedIconImageView release];
  [_clickButton release];
  [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    // Initialization code
    _selectedIconImageView.hidden = YES;
    _isSelected = NO;
  }
  return self;
}

- (IBAction)clickButtonOnClickListener:(id)sender {
  
  self.isSelected = !_isSelected;
  
  if ([_delegate conformsToProtocol:@protocol(CustomControlDelegate)]) {
    [_delegate customControl:self onAction:kCheckBoxPopupListCellActionEnum_Clicked];
  }
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */
+ (NSString *) nibName {
  return NSStringFromClass([self class]);
}

+ (UINib *) nib {
  NSBundle *classBundle = [NSBundle bundleForClass:[self class]];
  return [UINib nibWithNibName:[self nibName] bundle:classBundle];
}

#pragma mark -
#pragma mark 方便构造

+(id)checkBoxPopupListCellWithText:(NSString *)text {
  NSArray *nibObjects = [[self nib] instantiateWithOwner:nil options:nil];
  
  CheckBoxPopupListCell *newObject = [nibObjects objectAtIndex:0];
  newObject.isSelected = NO;
  newObject.text = text;
  [newObject.clickButton setTitle:text forState:UIControlStateNormal];
  
  return newObject;
}

@end
