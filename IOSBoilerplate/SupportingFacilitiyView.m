//
//  SupportingFacilitiyView.m
//  airizu
//
//  Created by 唐志华 on 13-2-12.
//
//

#import "SupportingFacilitiyView.h"

@implementation SupportingFacilitiyView

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

- (void)dealloc {
  [_supportingFacilityLabel release];
  [super dealloc];
}

+ (NSString *) nibName {
  return NSStringFromClass([self class]);
}

+ (UINib *) nib {
  NSBundle *classBundle = [NSBundle bundleForClass:[self class]];
  return [UINib nibWithNibName:[self nibName] bundle:classBundle];
}

+(id)supportingFacilitiyViewWithName:(NSString *)name {
  NSArray *nibObjects = [[self nib] instantiateWithOwner:nil options:nil];
  SupportingFacilitiyView *supportingFacilitiyView = [nibObjects objectAtIndex:0];
  supportingFacilitiyView.supportingFacilityLabel.text = name;
  if ([name length] > 5) {
    supportingFacilitiyView.supportingFacilityLabel.font = [UIFont systemFontOfSize:12];
  }
  return supportingFacilitiyView;
}
@end
