//
//  CheckBoxPopupListCell.h
//  airizu
//
//  Created by 唐志华 on 13-3-5.
//
//

#import <UIKit/UIKit.h>

@protocol CustomControlDelegate;

typedef enum  {
  //
  kCheckBoxPopupListCellActionEnum_Clicked = 0
} CheckBoxPopupListCellActionEnum;

@interface CheckBoxPopupListCell : UIView {
  
}


@property (retain, nonatomic) IBOutlet UIImageView *selectedIconImageView;
@property (retain, nonatomic) IBOutlet UIButton *clickButton;


///
@property (nonatomic, assign) id<CustomControlDelegate> delegate;
///
@property (nonatomic, assign, setter = setSelected:) BOOL isSelected;
@property (nonatomic, readonly) NSString *text;

#pragma mark -
#pragma mark 方便构造
+(id)checkBoxPopupListCellWithText:(NSString *)text;
@end
