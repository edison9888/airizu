//
//  CheckBoxPopupList.h
//  airizu
//
//  Created by 唐志华 on 13-3-4.
//
//

#import <UIKit/UIKit.h>
#import "CustomControlDelegate.h"


@class CheckBoxPopupList;






@protocol CheckBoxPopupListDelegate <NSObject>

// 必须实现的协议
@required
-(void)checkBoxPopupList:(CheckBoxPopupList *)checkBoxPopupList didSelectedCellTexts:(NSArray *)texts;

// 选择实现的协议
@optional
-(void)closeCheckBoxPopupList:(CheckBoxPopupList *)checkBoxPopupList;

@end









@interface CheckBoxPopupList : UIView <CustomControlDelegate> {
  
}


@property (retain, nonatomic) IBOutlet UIButton *cancelButton;
@property (retain, nonatomic) IBOutlet UIButton *okButton;
@property (retain, nonatomic) IBOutlet UILabel *titleLabel;
//
@property (retain, nonatomic) IBOutlet UIScrollView *cellScrollView;


/// 已经处于选中状态的数据
@property (nonatomic, readonly) NSMutableArray *selectedCellTexts;


#pragma mark -
#pragma mark 方便构造

+(id)checkBoxPopupListWithTitle:(NSString *)title
                     dataSource:(NSArray *)dataSource
                       delegate:(id<CheckBoxPopupListDelegate>)delegate;

// 统一设置处于选中状态的 cell 项
-(void)setSelectedCells:(NSArray *)dataSourceForSelectedCells;

-(void)showInView:(UIView*)view;
-(void)dismiss;
@end
