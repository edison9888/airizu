//
//  PointsToOffsetControl.h
//  airizu
//
//  Created by 唐志华 on 13-3-2.
//
//

#import <UIKit/UIKit.h>

@class FreeBookNetRespondBean;
@class PointsToOffsetControl;

///
@protocol PointsToOffsetControlDelegate <NSObject>

- (void)sliderDidChange:(PointsToOffsetControl *)sender;

@end

///
@interface PointsToOffsetControl : UIView {
  
}

@property (retain, nonatomic) IBOutlet UISlider *pointSlider;
// 下限
@property (retain, nonatomic) IBOutlet UILabel *minimumValueLabel;
// 上限
@property (retain, nonatomic) IBOutlet UILabel *maximumValueLabel;
// 当前值
@property (retain, nonatomic) IBOutlet UILabel *currentlyValueLabel;
// 账户积分信息
@property (retain, nonatomic) IBOutlet UILabel *accountPointsInfoLabel;

//
@property (nonatomic, assign) NSInteger value;


+(id)pointsToOffsetControlWithFreeBookNetRespondBeanForUnusedPromotions:(FreeBookNetRespondBean *)freeBookNetRespondBeanForUnusedPromotions moneyForLatest:(NSString *)moneyForLatest delegate:(id<PointsToOffsetControlDelegate>)delegate;
@end
