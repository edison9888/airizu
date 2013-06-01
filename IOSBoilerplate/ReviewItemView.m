//
//  ReviewItemView.m
//  airizu
//
//  Created by 唐志华 on 13-2-27.
//
//

#import "ReviewItemView.h"

@interface ReviewItemView ()
@property (nonatomic, assign) NSInteger itemCode;
@end

@implementation ReviewItemView

-(float)itemScore{
  return _starRatingControl.rating;
}

- (void)dealloc {
  [_itemNameLabel release];
  [_starRatingControl release];
  [_scoreLabel release];
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

#pragma mark -
#pragma mark 实现 DLStarRatingDelegate 协议

-(void)newRating:(DLStarRatingControl *)control :(float)rating {
	_scoreLabel.text = [NSString stringWithFormat:@"( %0.1f )", rating];
}

#pragma mark -
#pragma mark 方便构造
+(id)reviewItemViewWithItemName:(NSString *)itemName code:(NSInteger)itemCode {
  NSArray *nibObjects = [[self nib] instantiateWithOwner:nil options:nil];
  ReviewItemView *newControl = [nibObjects objectAtIndex:0];
  newControl.itemNameLabel.text = itemName;
  newControl.starRatingControl.rating = 5.0;
  [newControl newRating:nil :newControl.starRatingControl.rating];
  newControl.itemCode = itemCode;
  return newControl;
}

@end
