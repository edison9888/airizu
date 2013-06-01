//
//  FreebookToolBar.m
//  airizu
//
//  Created by 唐志华 on 13-1-28.
//
//

#import "FreebookToolBar.h"

static const NSString *const TAG = @"<FreebookToolBar>";

@implementation FreebookToolBar

- (void)dealloc {
  //
  [_priceLabel release];
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

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */
- (IBAction)freebookButtonOnClickListener:(id)sender {
  if ([_delegate conformsToProtocol:@protocol(CustomControlDelegate)]) {
    if ([_delegate respondsToSelector:@selector(customControl:onAction:)]) {
      [_delegate customControl:self onAction:kFreebookToolBarActionEnum_FreebookButtonClicked];
    }
  }
}

+ (NSString *) nibName {
  return NSStringFromClass([self class]);
}

+ (UINib *) nib {
  NSBundle *classBundle = [NSBundle bundleForClass:[self class]];
  return [UINib nibWithNibName:[self nibName] bundle:classBundle];
}

+(id)freebookToolBar {
  NSArray *nibObjects = [[self nib] instantiateWithOwner:nil options:nil];
  FreebookToolBar *freebookToolBar = [nibObjects objectAtIndex:0];
  return freebookToolBar;
}

-(void)setRoomPrice:(NSNumber *)price {
  NSNumber *priceNumber = [NSNumber numberWithInteger:0];
  if ([price isKindOfClass:[NSNumber class]]) {
    priceNumber = price;
  }
  NSString *priceString = [NSString stringWithFormat:@"¥%d", [priceNumber integerValue]];
  [self.priceLabel setText:priceString];
}

@end
