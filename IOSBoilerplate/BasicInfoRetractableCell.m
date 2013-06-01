//
//  BasicInfoRetractableCell.m
//  airizu
//
//  Created by 唐志华 on 13-2-12.
//
//

#import "BasicInfoRetractableCell.h"

#import "RoomDetailNetRespondBean.h"
#import "BasicInfoRetractableCellView.h"

@interface BasicInfoRetractableCell ()

//
@property (nonatomic, assign) RoomDetailNetRespondBean *roomDetailNetRespondBean;
@end

@implementation BasicInfoRetractableCell

- (void)dealloc {
  
  
  [super dealloc];
}

#pragma mark -
#pragma mark Subclass

- (NSString *)title {
  return NSLocalizedString(@"基本信息",);
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
  
  //
  BasicInfoRetractableCellView *contentView = [BasicInfoRetractableCellView basicInfoRetractableCellViewWithRoomDetailNetRespondBean:_roomDetailNetRespondBean];
  cell.frame = contentView.frame;
  [cell.contentView addSubview:contentView];
  return cell;
}


+(id)basicInfoRetractableCellWithRoomDetailNetRespondBean:(RoomDetailNetRespondBean*)roomDetailNetRespondBean viewController:(UIViewController*)givenViewController {
  
  BasicInfoRetractableCell *basicInfoRetractableCell = [[BasicInfoRetractableCell alloc] initWithViewController:givenViewController];
  basicInfoRetractableCell.roomDetailNetRespondBean = roomDetailNetRespondBean;
  return [basicInfoRetractableCell autorelease];
}

@end