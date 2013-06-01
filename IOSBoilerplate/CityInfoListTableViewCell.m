//
//  CityInfoListTableViewCell.m
//  airizu
//
//  Created by 唐志华 on 13-2-25.
//
//

#import "CityInfoListTableViewCell.h"
#import "CityInfo.h"

@implementation CityInfoListTableViewCell

- (void)dealloc {
  
  // UI
  [_cityNameLabel release];
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


-(void)initTableViewCellDataWithCityInfo:(CityInfo *)cityInfo {
  if (![cityInfo isKindOfClass:[CityInfo class]]) {
    return;
  }
  
  // 城市名称
  _cityNameLabel.text = cityInfo.name;
}
@end
