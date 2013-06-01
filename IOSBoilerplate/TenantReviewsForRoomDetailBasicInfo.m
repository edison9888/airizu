//
//  TenantReviewsForRoomDetailBasicInfo.m
//  airizu
//
//  Created by 唐志华 on 13-1-28.
//
//

#import "TenantReviewsForRoomDetailBasicInfo.h"

#import "CustomControlDelegate.h"
#import "RoomDetailOfBasicInformationActivityContent.h"
#import "RoomDetailNetRespondBean.h"

@implementation TenantReviewsForRoomDetailBasicInfo

- (void)dealloc {
  
  // UI
  [_reviewLabel release];
  [_reviewCountLabel release];
  [_reviewContentLabel release];
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

- (IBAction)tenantReviewsButtonOnClickListener:(id)sender {
  if ([_delegate conformsToProtocol:@protocol(CustomControlDelegate)]) {
    if ([_delegate respondsToSelector:@selector(customControl:onAction:)]) {
      [_delegate customControl:self onAction:kRoomDetailOfBasicInformationActivityContentActionEnum_TenantReviewsButtonClicked];
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

#pragma mark -
#pragma mark 加载子View
-(void)initUseRoomDetailNetRespondBean:(RoomDetailNetRespondBean *)roomDetailNetRespondBean{
  // 租客点评总分
  NSString *scoreString = [NSString stringWithFormat:@"%.1f",[roomDetailNetRespondBean.review floatValue]];
  [_reviewLabel setText:scoreString];
  // 租客点评总条数
  NSString *reviewTotalString = [NSString stringWithFormat:@"%d条评论",[roomDetailNetRespondBean.reviewCount integerValue]];
  [_reviewCountLabel setText:reviewTotalString];
  // 租客点评列表，这里只显示1条记录
  [_reviewContentLabel setText:roomDetailNetRespondBean.reviewContent];
  
}

#pragma mark -
#pragma mark 方便构造
+(id)tenantReviewsForRoomDetailBasicInfoWithRoomDetailNetRespondBean:(RoomDetailNetRespondBean *)roomDetailNetRespondBean {
  NSArray *nibObjects = [[self nib] instantiateWithOwner:nil options:nil];
  TenantReviewsForRoomDetailBasicInfo *tenantReviewsForRoomDetailBasicInfo = [nibObjects objectAtIndex:0];
  [tenantReviewsForRoomDetailBasicInfo initUseRoomDetailNetRespondBean:roomDetailNetRespondBean];
  return tenantReviewsForRoomDetailBasicInfo;
}


@end
