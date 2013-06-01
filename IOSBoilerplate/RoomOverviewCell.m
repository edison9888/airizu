//
//  RoomOverviewCell.m
//  airizu
//
//  Created by 唐志华 on 13-2-12.
//
//

#import "RoomOverviewCell.h"

#import "RoomDetailNetRespondBean.h"

@interface RoomOverviewCell ()

//
@property (nonatomic, assign) RoomDetailNetRespondBean *roomDetailNetRespondBean;
@end

@implementation RoomOverviewCell

- (void)dealloc {
  
  
  [super dealloc];
}

#pragma mark -
#pragma mark Subclass

- (NSString *)title {
  return NSLocalizedString(@"房间概况",);
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
  
  if (![NSString isEmpty:_roomDetailNetRespondBean.roomDescription]) {
    CGSize size = [_roomDetailNetRespondBean.roomDescription sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(290, 1000) lineBreakMode:UILineBreakModeCharacterWrap];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, size.width, size.height)];
    label.text = _roomDetailNetRespondBean.roomDescription;
    label.font = [UIFont systemFontOfSize:14];
    label.lineBreakMode = UILineBreakModeCharacterWrap;
    label.numberOfLines = 0;
    [cell.contentView addSubview:label];
    [label release];
    
    cell.contentView.frame = CGRectMake(0, 0, 300, size.height + 10);
    
  }

  
  return cell;
}

+(id)roomOverviewCellWithRoomDetailNetRespondBean:(RoomDetailNetRespondBean *)roomDetailNetRespondBean viewController:(UIViewController*)givenViewController{
  
  RoomOverviewCell *roomOverviewCell = [[RoomOverviewCell alloc] initWithViewController:givenViewController];
  roomOverviewCell.roomDetailNetRespondBean = roomDetailNetRespondBean;
  return [roomOverviewCell autorelease];
}

@end
