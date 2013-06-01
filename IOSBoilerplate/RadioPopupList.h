//
//  RadioPopupList.h
//  airizu
//
//  Created by 唐志华 on 13-1-14.
//
//

#import <UIKit/UIKit.h>

@class RadioPopupList;






@protocol RadioPopupListDelegate <NSObject>

// 必须实现的协议
@required
-(void)radioPopupList:(RadioPopupList *)radioPopupList didSelectRowAtIndex:(NSUInteger)index;

// 选择实现的协议
@optional
-(void)closeRadioPopupList:(RadioPopupList *)radioPopupList;

@end






@interface RadioPopupList : UIView <UITableViewDelegate, UITableViewDataSource> {
  
}

@property (retain, nonatomic) IBOutlet UIButton *cancelButton;
@property (retain, nonatomic) IBOutlet UIButton *okButton;
@property (retain, nonatomic) IBOutlet UILabel *titleLabel;
@property (retain, nonatomic) IBOutlet UITableView *listviewTable;

+(id)radioPopupListWithTitle:(NSString *)title
                  dataSource:(NSArray *)dataSource
                    delegate:(id<RadioPopupListDelegate>)delegate;
-(void)setDefaultSelectedIndex:(NSInteger)defaultSelectedIndex;
-(id)objectAtIndex:(NSUInteger)index;
-(void)showInView:(UIView*)view;
-(void)dismiss;
@end
