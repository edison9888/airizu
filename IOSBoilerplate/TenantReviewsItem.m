//
//  TenantReviewsItem.m
//  airizu
//
//  Created by 唐志华 on 13-2-13.
//
//

#import "TenantReviewsItem.h"
#import "UIColor+ColorSchemes.h"

@implementation TenantReviewsItem

- (void)dealloc {
  
  // UI
  [_titleLabel release];
  [_averageLabel release];
  [_ratingBarBackgroundView release];
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

+ (NSString *) nibName {
  return NSStringFromClass([self class]);
}

+ (UINib *) nib {
  NSBundle *classBundle = [NSBundle bundleForClass:[self class]];
  return [UINib nibWithNibName:[self nibName] bundle:classBundle];
}

-(void)drawRatingBarByAverage:(NSNumber *)average{
  _ratingBarBackgroundView.layer.borderWidth = 1;
  _ratingBarBackgroundView.layer.borderColor = [UIColor colorForLabelOrangeText].CGColor;
  _ratingBarBackgroundView.layer.cornerRadius = 2;
  
  NSInteger scoreInteger = [average intValue];
  CGFloat scoreFloat = [average floatValue];
  int i = 0;
  CGFloat offsetDimension = 2;
  CGFloat offsetX = offsetDimension;
  CGFloat offsetY = offsetDimension;
  CGFloat ratingItemWidth = 30;
  CGFloat ratingItemHeight = 10;
  // 整数部分的 等级方块
  for (i=0; i<scoreInteger; i++) {
    UIView *ratingRectView = [[UIView alloc] initWithFrame:CGRectMake(offsetX, offsetY, ratingItemWidth - offsetDimension, ratingItemHeight)];
    [ratingRectView setBackgroundColor:[UIColor orangeColor]];
    [_ratingBarBackgroundView addSubview:ratingRectView];
    [ratingRectView release];
    
    offsetX += ratingItemWidth;
  }
  
  // 小数部分的 等级方块
  CGFloat decimalFloat = scoreFloat - scoreInteger;
  if (decimalFloat > 0) {
    UIView *ratingRectView = [[UIView alloc] initWithFrame:CGRectMake(offsetX, offsetY, ratingItemWidth * decimalFloat, ratingItemHeight)];
    [ratingRectView setBackgroundColor:[UIColor orangeColor]];
    [_ratingBarBackgroundView addSubview:ratingRectView];
    [ratingRectView release];
  } 

}

+(id)tenantReviewsItemWithTitle:(NSString *)title average:(NSNumber *)average {
  NSArray *nibObjects = [[self nib] instantiateWithOwner:nil options:nil];
  TenantReviewsItem *tenantReviewsItem = [nibObjects objectAtIndex:0];
  tenantReviewsItem.titleLabel.text = title;
  
  NSString *averageString = [NSString stringWithFormat:@"%0.1f", [average floatValue]];
  tenantReviewsItem.averageLabel.text = averageString;
  if ([average isKindOfClass:[NSNumber class]]) {
    [tenantReviewsItem drawRatingBarByAverage:average];
  }
  
  return tenantReviewsItem;
}
@end
