//
//  RecommendCityTableViewCellViewController.m
//  airizu
//
//  Created by 唐志华 on 12-12-26.
//
//

#import "RecommendCityTableViewCell.h"
#import "RecommendCity.h"

static const NSString *const TAG = @"<RecommendCityTableViewCell>";

@implementation RecommendCityTableViewCell

- (void) dealloc {
  
  PRPLog(@"dealloc: %@ [0x%x]", TAG, [self hash]);
  
  [_street1NameButton release];
  [_street2NameButton release];
  [_cityNameLabel release];
  
  
  [_cityPhotoButton release];
  [super dealloc];
}

+ (void)initialize {
	if(self == [RecommendCityTableViewCell class])
	{
    
	}
}

+ (NSString *) cellIdentifier {
  return NSStringFromClass([self class]);
}

+ (id) cellForTableView:(UITableView *) tableView {
  NSString *cellID = [self cellIdentifier];
  
  id cell = [tableView dequeueReusableCellWithIdentifier:cellID];
  if (cell == nil) {
    cell = [[[self alloc] initWithStyle:UITableViewCellStyleDefault
                        reuseIdentifier:cellID] autorelease];
  }
  return cell;
}

+(id)cellForTableView:(UITableView *) tableView fromNib:(UINib *)nib {
  
  NSString *cellID = [self cellIdentifier];
  
  id cell = [tableView dequeueReusableCellWithIdentifier:cellID];
  if (cell == nil) {
    
    // 这是默认的创建 TableViewCell 的方法
    //cell = [[[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID] autorelease];
    
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
- (id) initWithStyle:(UITableViewCellStyle)style
     reuseIdentifier:(NSString *)reuseIdentifier {
  
  if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
  {
		self.backgroundColor = [UIColor whiteColor];
		self.opaque = YES;
  }
  return self;
}


//- (void) drawContentView:(CGRect)rect {
//	self.backgroundColor = [UIColor whiteColor];
//}

/*
 if the cell is reusable (has a reuse identifier),
 this is called just before the cell is returned from the table
 view method dequeueReusableCellWithIdentifier:.
 If you override, you MUST call super.
 
 当表格Cell要重用时调用的方法
 */
- (void) prepareForReuse {
	[super prepareForReuse];
}

-(void)initTableViewCellDataWithRecommendCity:(RecommendCity *)recommendCity {
  _cityNameLabel.text = recommendCity.cityName;
  [_street1NameButton setTitle:recommendCity.street1Name forState:UIControlStateNormal];
  [_street2NameButton setTitle:recommendCity.street2Name forState:UIControlStateNormal];
  
  // 推荐城市的照片, 这里要采用 "本地缓存 + 网络懒加载"
  NSString *imageUrl = [NSString stringWithFormat:@"%@%@", kUrlConstant_URLPrefixForRecommendCityImage, recommendCity.image];
  UIImageView *cityPhotoImage = [[UIImageView alloc]
                                 initWithFrame:CGRectMake(0, 0,
                                                          _cityPhotoButton.frame.size.width,
                                                          _cityPhotoButton.frame.size.height)];
  [cityPhotoImage setImageWithURL:[NSURL URLWithString:imageUrl]];
  [_cityPhotoButton addSubview:cityPhotoImage];
  [cityPhotoImage release];
}


@end
