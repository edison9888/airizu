//
//  TradingRulesCell.m
//  airizu
//
//  Created by 唐志华 on 13-2-12.
//
//

#import "TradingRulesCell.h"

#import "RoomDetailNetRespondBean.h"

@interface TradingRulesCell ()

//
@property (nonatomic, assign) RoomDetailNetRespondBean *roomDetailNetRespondBean;
@end

@implementation TradingRulesCell

- (void)dealloc {
  
  
  [super dealloc];
}

#pragma mark -
#pragma mark Subclass

- (NSString *)title {
  return NSLocalizedString(@"交易规则",);
}

- (NSString *)titleContentForRow:(NSUInteger)row {
  return nil;
}

- (NSUInteger)contentNumberOfRow {
  return 1;
}

- (void)didSelectContentCellAtRow:(NSUInteger)row {
  
}

#pragma mark -
#pragma mark Customization

- (UITableViewCell *)cellForRow:(NSUInteger)row {
  //All cells in the GCRetractableSectionController will be indented
  UITableViewCell* cell = [super cellForRow:row];
  
  cell.indentationLevel = 1;
  
  return cell;
}

- (UITableViewCell *)titleCell {
  //I removed the detail text here, but you can do whatever you want
  UITableViewCell* titleCell = [super titleCell];
  titleCell.detailTextLabel.text = nil;
  
  return titleCell;
}

- (UITableViewCell *)contentCellForRow:(NSUInteger)row {
  //You can reuse GCRetractableSectionController work by calling super, but you can start from scratch and give a new cell
  UITableViewCell *cell = [super contentCellForRow:row];
  cell.selectionStyle = UITableViewCellSelectionStyleNone;
  cell.backgroundColor = [UIColor whiteColor];
  cell.accessoryType = UITableViewCellAccessoryNone;
  
  if (![NSString isEmpty:_roomDetailNetRespondBean.ruleContent]) {
    CGSize size = [_roomDetailNetRespondBean.ruleContent sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(290, 1000) lineBreakMode:UILineBreakModeCharacterWrap];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, size.width, size.height)];
    label.text = _roomDetailNetRespondBean.ruleContent;
    label.font = [UIFont systemFontOfSize:14];
    label.lineBreakMode = UILineBreakModeCharacterWrap;
    label.numberOfLines = 0;
    [cell.contentView addSubview:label];
    [label release];
    
    cell.contentView.frame = CGRectMake(0, 0, 300, size.height + 10);
    
  }
  
  return cell;
}

+(id)tradingRulesCellWithRoomDetailNetRespondBean:(RoomDetailNetRespondBean *)roomDetailNetRespondBean viewController:(UIViewController*)givenViewController{
  
  TradingRulesCell *tradingRulesCell = [[TradingRulesCell alloc] initWithViewController:givenViewController];
  tradingRulesCell.roomDetailNetRespondBean = roomDetailNetRespondBean;
  return [tradingRulesCell autorelease];
}


@end
