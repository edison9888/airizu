//
//  RoomInfoTableViewCell.m
//  airizu
//
//  Created by 唐志华 on 13-1-5.
//
//

#import "RoomInfoTableViewCell.h"
#import "RoomInfo.h"

static const NSString *const TAG = @"<RoomInfoTableViewCell>";

@implementation RoomInfoTableViewCell

- (void) dealloc {
  PRPLog(@"dealloc: %@ [0x%x]", TAG, [self hash]);
  
  // UI
  [_roomImageUIImageView release];
  [_roomTitleUILabel release];
  [_roomDistanceUILabel release];
  [_roomWayUILabel release];
  [_occupancyCountUILabel release];
  [_reviewCountUILabel release];
  [_roomScheduledUILabel release];
  [_roomPriceUILabel release];
  [_roomWayAndOccupancyPlaceholder release];
  [_iconForRoomSchedule release];
  [super dealloc];
}

+ (NSString *) cellIdentifier {
  return NSStringFromClass([self class]);
}

+ (id) cellForTableView:(UITableView *) tableView
                fromNib:(UINib *) nib {
  
  NSString *cellID = [self cellIdentifier];
  
  id cell = [tableView dequeueReusableCellWithIdentifier:cellID];
  if (cell == nil) {
    
    NSArray *nibObjects = [nib instantiateWithOwner:nil options:nil];
    NSAssert2(([nibObjects count] > 0) && [[nibObjects objectAtIndex:0] isKindOfClass:[self class]], @"Nib '%@' does not appear to contain a valid %@", [self nibName], NSStringFromClass([self class]));
    cell = [nibObjects objectAtIndex:0];
    
    PRPLog(@"init %@ [0x%x]", TAG, [cell hash]);
  }
  return cell;
}

+ (NSString *)nibName {
  return [self cellIdentifier];
}

+ (UINib *)nib {
  NSBundle *classBundle = [NSBundle bundleForClass:[self class]];
  return [UINib nibWithNibName:[self nibName] bundle:classBundle];
}
 
-(void)initTableViewCellDataWithRoomInfo:(RoomInfo *)roomInfo showDistance:(BOOL)isShowDistance{
  
  if (![roomInfo isKindOfClass:[RoomInfo class]]) {
    // 入参异常
    return;
  }
  
  // 房间图片
  [_roomImageUIImageView setImageWithURL:[NSURL URLWithString:roomInfo.image]];
  
  // 房间标题
  _roomTitleUILabel.text = roomInfo.roomTitle;
  
  if (isShowDistance) {
    _roomDistanceUILabel.hidden = NO;
    double distanceDouble = [roomInfo.distance doubleValue];
    NSString *distanceString = nil;
    if (distanceDouble >= 1000) {
      distanceString = [NSString stringWithFormat:@"%.1fkm", distanceDouble/1000];
    }else{
      distanceString = [NSString stringWithFormat:@"%.0fm", distanceDouble];
    }
    _roomDistanceUILabel.text = distanceString;
    
  } else {
    
    _roomDistanceUILabel.hidden = YES;
    
    CGRect frame = _roomWayAndOccupancyPlaceholder.frame;
    
    // 房屋出租方式
    frame.origin.x = CGRectGetMinX(_roomDistanceUILabel.frame);
    [_roomWayAndOccupancyPlaceholder setFrame:frame];
    
    // 入住人数
    if ([roomInfo.rentalWayName length] <= 2) {
      frame = _occupancyCountUILabel.frame;
      frame.origin.x = CGRectGetMinX(_iconForRoomSchedule.frame) - CGRectGetMinX(_roomWayAndOccupancyPlaceholder.frame);
      [_occupancyCountUILabel setFrame:frame];
    } else {
      
    }
  }
  
  // 房间出租方式
  _roomWayUILabel.text = roomInfo.rentalWayName;
  // 限住人数
  _occupancyCountUILabel.text = [NSString stringWithFormat:@"限住%@人", roomInfo.occupancyCount];
  // 评论总数
  _reviewCountUILabel.text = [roomInfo.reviewCount stringValue];
  // 房间曾被预定的次数
  _roomScheduledUILabel.text = [NSString stringWithFormat:@"已预订%@晚", roomInfo.scheduled];
  // 房间单价
  _roomPriceUILabel.text = [NSString stringWithFormat:@"¥%@", roomInfo.price];
}

@end