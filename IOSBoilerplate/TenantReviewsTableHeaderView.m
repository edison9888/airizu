//
//  TenantReviewsTableHeaderView.m
//  airizu
//
//  Created by 唐志华 on 13-2-13.
//
//

#import "TenantReviewsTableHeaderView.h"

#import "RoomReviewNetRespondBean.h"
#import "TenantReviewsItem.h"

@implementation TenantReviewsTableHeaderView

- (void)dealloc {
  
  // UI
  [_avgScore release];
  [_reviewCount release];
  [_reviewsLayout release];
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

+(id)tenantReviewsTableHeaderViewWithRoomReviewNetRespondBean:(RoomReviewNetRespondBean *)roomReviewNetRespondBean {
  
  NSArray *nibObjects = [[self nib] instantiateWithOwner:nil options:nil];
  TenantReviewsTableHeaderView *tenantReviewsTableHeaderView = [nibObjects objectAtIndex:0];
  
  if ([roomReviewNetRespondBean isKindOfClass:[RoomReviewNetRespondBean class]]) {
    
    tenantReviewsTableHeaderView.avgScore.text = roomReviewNetRespondBean.avgScore;
    tenantReviewsTableHeaderView.reviewCount.text = [NSString stringWithFormat:@"%@条评论", roomReviewNetRespondBean.reviewCount];
    
    // 房间评论项
    if (roomReviewNetRespondBean.reviewItemMap.count > 0) {
      CGFloat offsetY = 0;
      for (NSString *key in [roomReviewNetRespondBean.reviewItemMap allKeys]) {
        NSString *value = [roomReviewNetRespondBean.reviewItemMap objectForKey:key];
        TenantReviewsItem *item = [TenantReviewsItem tenantReviewsItemWithTitle:key average:[NSNumber numberWithFloat:[value floatValue]]];
        CGRect itemFrame = item.frame;
        itemFrame.origin.y = offsetY;
        offsetY += CGRectGetHeight(itemFrame);
        item.frame = itemFrame;
        
        [tenantReviewsTableHeaderView.reviewsLayout addSubview:item];
      }
      
      // 校正 reviewsLayout.frame
      tenantReviewsTableHeaderView.reviewsLayout.frame
      = CGRectMake(CGRectGetMinX(tenantReviewsTableHeaderView.reviewsLayout.frame),
                   CGRectGetMinY(tenantReviewsTableHeaderView.reviewsLayout.frame),
                   CGRectGetWidth(tenantReviewsTableHeaderView.reviewsLayout.frame),
                   offsetY);
      
      // 校正 tenantReviewsTableHeaderView.frame
      tenantReviewsTableHeaderView.frame
      = CGRectMake(0,
                   0,
                   CGRectGetWidth(tenantReviewsTableHeaderView.frame),
                   CGRectGetMaxY(tenantReviewsTableHeaderView.reviewsLayout.frame) + 10);
      
    }
  }
  
  return tenantReviewsTableHeaderView;
  
}
@end
