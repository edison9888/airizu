//
//  RoomInfoTableViewCell.h
//  airizu
//
//  Created by 唐志华 on 13-1-5.
//
//  修改记录:
//          1) 20130122 完成第一版本正式代码
//

#import <Foundation/Foundation.h>

@class RoomInfo;
@interface RoomInfoTableViewCell : UITableViewCell {
  
}

@property (retain, nonatomic) IBOutlet UIImageView *roomImageUIImageView;
@property (retain, nonatomic) IBOutlet UILabel *roomTitleUILabel;
@property (retain, nonatomic) IBOutlet UILabel *roomDistanceUILabel;

// 出租方式 + 入住人数
@property (retain, nonatomic) IBOutlet UIView *roomWayAndOccupancyPlaceholder;
@property (retain, nonatomic) IBOutlet UILabel *roomWayUILabel;
@property (retain, nonatomic) IBOutlet UILabel *occupancyCountUILabel;

//
@property (retain, nonatomic) IBOutlet UILabel *reviewCountUILabel;
@property (retain, nonatomic) IBOutlet UIImageView *iconForRoomSchedule;
@property (retain, nonatomic) IBOutlet UILabel *roomScheduledUILabel;
@property (retain, nonatomic) IBOutlet UILabel *roomPriceUILabel;

#pragma mark -
#pragma mark 使用 IB编辑 table cell

+ (id)cellForTableView:(UITableView *)tableView fromNib:(UINib *)nib;
+ (UINib *)nib;

-(void)initTableViewCellDataWithRoomInfo:(RoomInfo *)roomInfo showDistance:(BOOL)isShowDistance;

@end
