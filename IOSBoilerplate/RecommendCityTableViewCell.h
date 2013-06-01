//
//  RecommendCityTableViewCellViewController.h
//  airizu
//
//  Created by 唐志华 on 12-12-26.
//
//  修改记录:
//          1) 20130122 完成第一版本正式代码
//

#import <UIKit/UIKit.h>
 
@class RecommendCity;
@interface RecommendCityTableViewCell : UITableViewCell {
  
}

@property (retain, nonatomic) IBOutlet UILabel *cityNameLabel;
@property (retain, nonatomic) IBOutlet UIButton *street1NameButton;
@property (retain, nonatomic) IBOutlet UIButton *street2NameButton;
@property (retain, nonatomic) IBOutlet UIButton *cityPhotoButton;

+(id)cellForTableView:(UITableView *)tableView fromNib:(UINib *)nib;
 
+(NSString *)nibName;
+(UINib *)nib;

-(void)initTableViewCellDataWithRecommendCity:(RecommendCity *)recommendCity;
@end

/*
 使用IB来设计 TableViewCell 时, 
 需要在IB中 设置 Objects 中 的自定义Class 为 RecommendCityTableViewCell, 然后将 
 RecommendCityTableViewCell 类中的 IBOutlet 属性和 UI中的控件对应, 
 而不要设置 Placeholders 
 */