//
//  TableHeaderForCityList.m
//  airizu
//
//  Created by 唐志华 on 13-2-21.
//
//

#import "TableHeaderForCityList.h"

@implementation TableHeaderForCityList

- (void)dealloc {
  [_currentCityLabel release];
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

+(id)tableHeaderForCityList {
  NSArray *nibObjects = [[self nib] instantiateWithOwner:nil options:nil];
  TableHeaderForCityList *newControl = [nibObjects objectAtIndex:0];
  return newControl;
}

@end
