//
//  HeaderViewForCityInfoTableView.m
//  airizu
//
//  Created by 唐志华 on 13-2-25.
//
//

#import "HeaderViewForCityInfoTableView.h"

@implementation HeaderViewForCityInfoTableView

- (void)dealloc {
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

+(id)headerViewForCityInfoTableViewWithTitle:(NSString *)title{
  NSArray *nibObjects = [[self nib] instantiateWithOwner:nil options:nil];
  HeaderViewForCityInfoTableView *newControl = [nibObjects objectAtIndex:0];
  newControl.titleLabel.text = title;
  return newControl;
}
@end
