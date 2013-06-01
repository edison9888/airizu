//
//  SystemMessageTableViewCell.m
//  airizu
//
//  Created by 唐志华 on 13-2-8.
//
//

#import "SystemMessageTableViewCell.h"
#import "SystemMessage.h"

static const NSString *const TAG = @"<SystemMessageTableViewCell>";

@implementation SystemMessageTableViewCell

- (void)dealloc {
  [_dateLabel release];
  [_messageLabel release];
  [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
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

-(void)initTableViewCellDataWithSystemMessage:(SystemMessage *)systemMessage {
  if (![systemMessage isKindOfClass:[SystemMessage class]]) {
    return;
  }
  
  _dateLabel.text = systemMessage.date;
  _messageLabel.text = systemMessage.message;
}

@end
