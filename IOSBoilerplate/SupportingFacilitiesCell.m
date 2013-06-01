//
//  SupportingFacilitiesCellView.m
//  airizu
//
//  Created by 唐志华 on 13-2-12.
//
//

#import "SupportingFacilitiesCell.h"

#import "RoomDetailNetRespondBean.h"
#import "SupportingFacilitiyView.h"

@interface SupportingFacilitiesCell ()

//
@property (nonatomic, assign) RoomDetailNetRespondBean *roomDetailNetRespondBean;
@end

@implementation SupportingFacilitiesCell

- (void)dealloc {
  
  
  [super dealloc];
}

#pragma mark -
#pragma mark Subclass

- (NSString *)title {
  return NSLocalizedString(@"配套设施",);
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
  
  if ([_roomDetailNetRespondBean.equipmentList isKindOfClass:[NSArray class]] && _roomDetailNetRespondBean.equipmentList.count > 0) {
    
    NSInteger count = _roomDetailNetRespondBean.equipmentList.count;
    CGFloat offsetX = 0;
    CGFloat offsetY = 0;
    CGFloat controlWidth = 100;
    CGFloat controlHeight = 21 + 5 + 5;
    for (NSString *supportingFacility in _roomDetailNetRespondBean.equipmentList) {
      SupportingFacilitiyView *view = [SupportingFacilitiyView supportingFacilitiyViewWithName:supportingFacility];
      view.frame = CGRectMake(offsetX, offsetY, controlWidth, controlHeight);
      [cell.contentView addSubview:view];
      
      offsetX += controlWidth;
      if (offsetX/controlWidth == 3) {
        offsetX = 0;
        offsetY += controlHeight;
      }
    }
    if (count % 3 != 0) {
      offsetY += controlHeight;
    }
    cell.contentView.frame = CGRectMake(0, 0, 300, offsetY);
  }
  
  
  return cell;
}

+(id)supportingFacilitiesCellWithRoomDetailNetRespondBean:(RoomDetailNetRespondBean *)roomDetailNetRespondBean viewController:(UIViewController*)givenViewController{
  
  SupportingFacilitiesCell *supportingFacilitiesCell = [[SupportingFacilitiesCell alloc] initWithViewController:givenViewController];
  supportingFacilitiesCell.roomDetailNetRespondBean = roomDetailNetRespondBean;
  return [supportingFacilitiesCell autorelease];
}
@end
