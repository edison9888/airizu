//
//  SystemMessageTableViewCell.h
//  airizu
//
//  Created by 唐志华 on 13-2-8.
//
//

#import <UIKit/UIKit.h>

@class SystemMessage;
@interface SystemMessageTableViewCell : UITableViewCell {
  
}

@property (retain, nonatomic) IBOutlet UILabel *dateLabel;
@property (retain, nonatomic) IBOutlet UILabel *messageLabel;

#pragma mark -
#pragma mark 使用 IB编辑 table cell

+ (id)cellForTableView:(UITableView *)tableView fromNib:(UINib *)nib;
+ (UINib *)nib;

-(void)initTableViewCellDataWithSystemMessage:(SystemMessage *)systemMessage;
@end
