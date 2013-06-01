//
//  PromoCodeDiscountControl.m
//  airizu
//
//  Created by 唐志华 on 13-3-3.
//
//

#import "PromoCodeDiscountControl.h"

#import "CustomControlDelegate.h"





@interface PromoCodeDiscountControl ()
@property (nonatomic, assign) CGRect textFieldLayoutOriginalFrame;
//
@property (nonatomic, copy) NSString *promoCode;
@end







@implementation PromoCodeDiscountControl

- (void)dealloc {
  [_promoCodeTextField release];
  [_textFieldLayout release];
  [_titleLabel release];
  [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    // Initialization code
  }
  return self;
}

+ (NSString *) nibName {
  return NSStringFromClass([self class]);
}

+ (UINib *) nib {
  NSBundle *classBundle = [NSBundle bundleForClass:[self class]];
  return [UINib nibWithNibName:[self nibName] bundle:classBundle];
}

+(id)promoCodeDiscountControlWithPromoCode:(NSString *)promoCode {
  NSArray *nibObjects = [[self nib] instantiateWithOwner:nil options:nil];
  PromoCodeDiscountControl *newControl = [nibObjects objectAtIndex:0];
  
  if (![NSString isEmpty:promoCode]) {
    newControl.promoCodeTextField.text = promoCode;
    newControl.promoCode = promoCode;
  }
  
  newControl.textFieldLayoutOriginalFrame = newControl.textFieldLayout.frame;
  return newControl;
}

#pragma mark -
#pragma mark 关闭输入框键盘
- (IBAction)closeKeyBord:(id)sender{
  [_promoCodeTextField resignFirstResponder];
}

#pragma mark -
#pragma mark 实现 UITextFieldDelegate 接口

// called when 'return' key pressed. return NO to ignore.
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  
  self.promoCode = textField.text;
  
  [self closeKeyBord:nil];
  
  if (![NSString isEmpty:textField.text]) {
    if ([_delegate conformsToProtocol:@protocol(CustomControlDelegate)]) {
      if ([_delegate respondsToSelector:@selector(customControl:onAction:)]) {
        [_delegate customControl:self onAction:kPromoCodeDiscountControlActionEnum_UpdatePromoCode];
      }
    }
  }
  
  return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
  _titleLabel.hidden = YES;
  _textFieldLayout.frame
  = CGRectMake(CGRectGetMinX(_textFieldLayoutOriginalFrame),
               CGRectGetMinY(_titleLabel.frame),
               CGRectGetWidth(_textFieldLayoutOriginalFrame),
               CGRectGetHeight(_textFieldLayoutOriginalFrame));
	[_textFieldLayout setNeedsDisplay];
	return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
	_titleLabel.hidden = NO;
  _textFieldLayout.frame = _textFieldLayoutOriginalFrame;
	[_textFieldLayout setNeedsDisplay];
	return YES;
}

@end
