//
//  ReviewBar.m
//  airizu
//
//  Created by 唐志华 on 13-2-27.
//
//

#import "ReviewBar.h"

#import "ReviewItem.h"
#import "ReviewItemNetRespondBean.h"

#import "ReviewItemView.h"

@interface ReviewBar ()
@property (nonatomic, assign) NSInteger itemNumber;
@end

@implementation ReviewBar

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

// 返回整个评论控件, 所有评论项的值, 字典构成是 (key:code value:分数)
-(NSDictionary *)reviewItemValueDictionary {
  NSMutableDictionary *valueDictionary = [NSMutableDictionary dictionaryWithCapacity:_itemNumber];
  for (id subview in self.subviews) {
    if ([subview isKindOfClass:[ReviewItemView class]]) {
      ReviewItemView *reviewItemView = (ReviewItemView *)subview;
      [valueDictionary setObject:[NSNumber numberWithFloat:reviewItemView.itemScore] forKey:[NSNumber numberWithInteger:reviewItemView.itemCode]];
    }
  }
  
  return valueDictionary;
}

#pragma mark -
#pragma mark 方便构造
+(id)reviewBarWithFrame:(CGRect)frame reviewItemNetRespondBean:(ReviewItemNetRespondBean *)reviewItemNetRespondBean {
  ReviewBar *newControl = [[ReviewBar alloc] initWithFrame:frame];
  
  do {
    if (![reviewItemNetRespondBean isKindOfClass:[ReviewItemNetRespondBean class]]) {
      break;
    }
    if (reviewItemNetRespondBean.itemList == nil) {
      break;
    }
    // 评论项数量
    newControl.itemNumber = reviewItemNetRespondBean.itemList.count;
    
    CGFloat yOffset = 0;
    for (ReviewItem *reviewItem in reviewItemNetRespondBean.itemList) {
      ReviewItemView *reviewItemView
      = [ReviewItemView reviewItemViewWithItemName:reviewItem.name
                                              code:[reviewItem.code integerValue]];
      reviewItemView.frame = CGRectMake(CGRectGetMinX(reviewItemView.frame),
                                        yOffset,
                                        CGRectGetWidth(reviewItemView.frame),
                                        CGRectGetHeight(reviewItemView.frame));
      yOffset += CGRectGetHeight(reviewItemView.frame);
      
      [newControl addSubview:reviewItemView];
    }
    
    newControl.frame = CGRectMake(CGRectGetMinX(newControl.frame),
                                  CGRectGetMinY(newControl.frame),
                                  CGRectGetWidth(newControl.frame),
                                  yOffset);
  } while (NO);
  
  return newControl;
}

@end
