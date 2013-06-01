//
//  OrderOverviewTableViewCell.h
//  airizu
//
//  Created by 唐志华 on 13-2-16.
//
//

#import <UIKit/UIKit.h>

@class OrderOverview;
@interface OrderOverviewTableViewCell : UITableViewCell {
  
}

// 房间图片
@property (retain, nonatomic) IBOutlet UIImageView *roomImage;
// 房间标题
@property (retain, nonatomic) IBOutlet UILabel *roomTitle;
// 入住时间
@property (retain, nonatomic) IBOutlet UILabel *checkInDate;
// 退房时间
@property (retain, nonatomic) IBOutlet UILabel *checkOutDate;
// 订单状态
@property (retain, nonatomic) IBOutlet UILabel *statusCode;
// 订单总额
@property (retain, nonatomic) IBOutlet UILabel *orderTotalPrice;


#pragma mark -
#pragma mark 使用 IB编辑 table cell

+ (id)cellForTableView:(UITableView *)tableView fromNib:(UINib *)nib;
+ (UINib *)nib;

-(void)initTableViewCellDataWithOrderOverview:(OrderOverview *)orderOverview orderStateEnum:(OrderStateEnum)orderStateEnum;

@end
