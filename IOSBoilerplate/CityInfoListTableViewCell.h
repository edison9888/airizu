//
//  CityInfoListTableViewCell.h
//  airizu
//
//  Created by 唐志华 on 13-2-25.
//
//

#import <UIKit/UIKit.h>

@class CityInfo;
@interface CityInfoListTableViewCell : UITableViewCell {
  
}

@property (retain, nonatomic) IBOutlet UILabel *cityNameLabel;


#pragma mark -
#pragma mark 使用 IB编辑 table cell

+ (id)cellForTableView:(UITableView *)tableView fromNib:(UINib *)nib;
+ (UINib *)nib;

-(void)initTableViewCellDataWithCityInfo:(CityInfo *)cityInfo;
@end
