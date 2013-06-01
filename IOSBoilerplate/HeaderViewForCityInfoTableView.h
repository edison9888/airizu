//
//  HeaderViewForCityInfoTableView.h
//  airizu
//
//  Created by 唐志华 on 13-2-25.
//
//

#import <UIKit/UIKit.h>

@interface HeaderViewForCityInfoTableView : UIView {
  
}


@property (retain, nonatomic) IBOutlet UILabel *titleLabel;

+(id)headerViewForCityInfoTableViewWithTitle:(NSString *)title;
@end
