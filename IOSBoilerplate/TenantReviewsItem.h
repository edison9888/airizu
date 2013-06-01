//
//  TenantReviewsItem.h
//  airizu
//
//  Created by 唐志华 on 13-2-13.
//
//

#import <UIKit/UIKit.h>

@interface TenantReviewsItem : UIView {
  
}

// 评论项标题
@property (retain, nonatomic) IBOutlet UILabel *titleLabel;
// 平均分
@property (retain, nonatomic) IBOutlet UILabel *averageLabel;
// 等级条背景View
@property (retain, nonatomic) IBOutlet UIView *ratingBarBackgroundView;

+(id)tenantReviewsItemWithTitle:(NSString *)title average:(NSNumber *)average;
@end
