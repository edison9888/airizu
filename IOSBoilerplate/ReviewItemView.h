//
//  ReviewItemView.h
//  airizu
//
//  Created by 唐志华 on 13-2-27.
//
//

#import <UIKit/UIKit.h>
#import "DLStarRatingControl.h"

@interface ReviewItemView : UIView <DLStarRatingDelegate>{
  
}

@property (retain, nonatomic) IBOutlet UILabel *itemNameLabel;

@property (retain, nonatomic) IBOutlet DLStarRatingControl *starRatingControl;

@property (retain, nonatomic) IBOutlet UILabel *scoreLabel;


@property (nonatomic, readonly) NSInteger itemCode;
@property (nonatomic, readonly) float itemScore;

#pragma mark - 
#pragma mark 方便构造
+(id)reviewItemViewWithItemName:(NSString *)itemName code:(NSInteger)itemCode;
@end
