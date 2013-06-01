//
//  CustomPageControl.m
//  airizu
//
//  Created by 唐志华 on 13-1-29.
//
//

#import "CustomPageControl.h"

@implementation CustomPageControl

- (void)dealloc {
	[_activeImage release];
	[_inactiveImage release];
  
  [super dealloc];
}

// 用于IB
-(id) initWithCoder:(NSCoder *)aDecoder {
  self = [super initWithCoder:aDecoder];
  
  if (self) {
		self.activeImage = [UIImage imageNamed:@"page_controll_active_icon.png"];
		self.inactiveImage = [UIImage imageNamed:@"page_controll_inactive_icon.png"];
	}
  
  return self;
}

-(id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
	if (self) {
		self.activeImage = [UIImage imageNamed:@"page_controll_active_icon.png"];
		self.inactiveImage = [UIImage imageNamed:@"page_controll_inactive_icon.png"];
	}
  return self;
}

-(void)updateDots {
  for (int i=0; i<[self.subviews count]; i++) {
    UIImageView *dot = [self.subviews objectAtIndex:i];
    if (i == self.currentPage) {
      dot.image = _activeImage;
    } else {
      dot.image = _inactiveImage;
    }
  }
}

-(void)setCurrentPage:(NSInteger)page {
  [super setCurrentPage:page];
  [self updateDots];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//	UITouch *touch = [touches anyObject];
//	CGPoint currentPosition = [touch locationInView:self];
//	CGFloat starWidth = currentPosition.x;
//	CGFloat width = self.frame.size.width/[self.subviews count];
//	NSInteger index = floor(starWidth/width);
//	[self setCurrentPage:index];
//	[self sendActionsForControlEvents:UIControlEventTouchUpInside];
}

- (void)drawRect:(CGRect)rect {
	[self updateDots];
}

@end
