//
//  TenantReviewsTableViewCell.m
//  airizu
//
//  Created by 唐志华 on 13-2-13.
//
//

#import "TenantReviewsTableViewCell.h"

#import "RoomReview.h"
#import "UIColor+ColorSchemes.h"

static const NSString *const TAG = @"<TenantReviewsTableViewCell>";

@implementation TenantReviewsTableViewCell

- (void)dealloc {
  
  // UI
  [_userReviewLayout release];
  [_userName release];
  [_userReviewTime release];
  [_userReview release];
  [_hostReviewLayout release];
  [_hostReviewTime release];
  [_hostReview release];
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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
  [super setSelected:selected animated:animated];
  
  // Configure the view for the selected state
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

+(id)tenantReviewsTableViewCell {
  NSArray *nibObjects = [[self nib] instantiateWithOwner:nil options:nil];
  TenantReviewsTableViewCell *tenantReviewsTableViewCell = [nibObjects objectAtIndex:0];
  return tenantReviewsTableViewCell;
}

-(void)initTableViewCellDataWithRoomReview:(RoomReview *)roomReview {
  if (![roomReview isKindOfClass:[RoomReview class]]) {
    return;
  }
  
  //
  _userReviewLayout.layer.borderWidth = 1;
  _userReviewLayout.layer.borderColor = [UIColor grayColor].CGColor;
  _userReviewLayout.layer.cornerRadius = 5;
  
  ////
  _userName.text = roomReview.userName;
  _userReviewTime.text = roomReview.userReviewTime;
  _userReview.text = roomReview.userReview;
  _hostReviewTime.text = roomReview.hostReviewTime;
  _hostReview.text = roomReview.hostReview;
  
  CGFloat cellHeight = 0;
  CGFloat offsetY = CGRectGetMaxY(_userReviewLayout.frame);
  
  // 用户评论
  if (![NSString isEmpty:roomReview.userReview]) {
    
    CGRect userReviewFrame = _userReview.frame;
    CGSize size = [roomReview.userReview sizeWithFont:_userReview.font constrainedToSize:CGSizeMake(userReviewFrame.size.width, 1000) lineBreakMode:UILineBreakModeCharacterWrap];
    _userReview.frame = CGRectMake(CGRectGetMinX(userReviewFrame),
                                   CGRectGetMinY(userReviewFrame),
                                   size.width,
                                   size.height);
    offsetY = CGRectGetMaxY(_userReview.frame) + 10;
  } else {
    
  }
  _userReviewLayout.frame = CGRectMake(CGRectGetMinX(_userReviewLayout.frame),
                                       CGRectGetMinY(_userReviewLayout.frame),
                                       CGRectGetWidth(_userReviewLayout.frame),
                                       offsetY);
  offsetY = CGRectGetMaxY(_userReviewLayout.frame) + 8;
  cellHeight = offsetY;
  
  //// -----------------------------------------------------------------------------
  
  _hostReviewLayout.frame = CGRectMake(CGRectGetMinX(_hostReviewLayout.frame),
                                       offsetY,
                                       CGRectGetWidth(_hostReviewLayout.frame),
                                       CGRectGetHeight(_hostReviewLayout.frame));
  
  // 房东回复
  if (![NSString isEmpty:roomReview.hostReview]) {
    
    
    CGRect hostReviewFrame = _hostReview.frame;
    CGSize size = [roomReview.hostReview sizeWithFont:_hostReview.font constrainedToSize:CGSizeMake(hostReviewFrame.size.width, 1000) lineBreakMode:UILineBreakModeCharacterWrap];
    _hostReview.frame = CGRectMake(CGRectGetMinX(hostReviewFrame),
                                   CGRectGetMinY(hostReviewFrame),
                                   size.width,
                                   size.height);
    offsetY = CGRectGetMaxY(_hostReview.frame) + 10;
    
    _hostReviewLayout.frame = CGRectMake(CGRectGetMinX(_hostReviewLayout.frame),
                                         CGRectGetMinY(_hostReviewLayout.frame),
                                         CGRectGetWidth(_hostReviewLayout.frame),
                                         offsetY);
    cellHeight += (offsetY + 10);
  } else {
    _hostReviewLayout.hidden = YES;
  }

}


@end
