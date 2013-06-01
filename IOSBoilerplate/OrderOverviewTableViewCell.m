//
//  OrderOverviewTableViewCell.m
//  airizu
//
//  Created by 唐志华 on 13-2-16.
//
//

#import "OrderOverviewTableViewCell.h"
#import "OrderOverview.h"

static const NSString *const TAG = @"<OrderOverviewTableViewCell>";

@implementation OrderOverviewTableViewCell

- (void)dealloc {
  
  // UI
  [_roomImage release];
  [_roomTitle release];
  [_checkInDate release];
  [_checkOutDate release];
  [_statusCode release];
  [_orderTotalPrice release];
  [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    // Initialization code
  }
  return self;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

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


-(void)initTableViewCellDataWithOrderOverview:(OrderOverview *)orderOverview orderStateEnum:(OrderStateEnum)orderStateEnum{
  if (![orderOverview isKindOfClass:[OrderOverview class]]) {
    return;
  }
  
  // 房间图片
  [_roomImage setImageWithURL:[NSURL URLWithString:orderOverview.roomImage]];
  // 房间标题
  _roomTitle.text = orderOverview.roomTitle;
  // 入住时间
  _checkInDate.text = orderOverview.checkInDate;
  // 退房时间
  _checkOutDate.text = orderOverview.checkOutDate;
  // 订单状态信息
  // 20130307 : 和静楠确认过, 目前前四个状态显示是可以写死的, 而 "已完成" 状态, 需要显示目标订单真实的状态信息
  NSString *orderStatusInfo = nil;
  if (kOrderStateEnum_HasEnded == orderStateEnum) {
    orderStatusInfo = orderOverview.statusContent;
  } else {
    orderStatusInfo = [ToolsFunctionForThisProgect orderStateDescriptionForOrderStateEnum:orderStateEnum];
  }
  _statusCode.text = orderStatusInfo;
  
  // 订单总额
  _orderTotalPrice.text = [NSString stringWithFormat:@"¥%d", [orderOverview.orderTotalPrice intValue]];
}


@end
