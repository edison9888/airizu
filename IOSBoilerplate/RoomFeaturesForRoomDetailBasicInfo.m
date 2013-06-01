//
//  RoomFeaturesForRoomDetailBasicInfo.m
//  airizu
//
//  Created by 唐志华 on 13-1-28.
//
//

#import "RoomFeaturesForRoomDetailBasicInfo.h"

#import "RoomDetailOfBasicInformationActivityContent.h"
#import "RoomDetailNetRespondBean.h"

@implementation RoomFeaturesForRoomDetailBasicInfo

- (void)dealloc {
 
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

+ (NSString *) nibName {
  return NSStringFromClass([self class]);
}

+ (UINib *) nib {
  NSBundle *classBundle = [NSBundle bundleForClass:[self class]];
  return [UINib nibWithNibName:[self nibName] bundle:classBundle];
}

-(UIView *)createRoomFeatureItemViewWithIcon:(UIImage *)icon andText:(NSString *)text andY:(CGFloat)y {
  UIView *view = [[UIView alloc] initWithFrame:CGRectMake(20, y, 280, 31)];
  
  UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 5, 45, 22)];
  imageView.image = icon;
  [view addSubview:imageView];
  [imageView release];
  
  UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(53, 6, 227, 21)];
  label.text = text;
  [label setFont:[UIFont systemFontOfSize:12]];
  [view addSubview:label];
  [label release];
  
  return [view autorelease];
}
#pragma mark -
#pragma mark 加载子View
-(void)initUseRoomDetailNetRespondBean:(RoomDetailNetRespondBean *)roomDetailNetRespondBean{
  
  CGFloat y = 31;
  
  // 100%验证
  if (roomDetailNetRespondBean.isVerify) {
    UIImage *icon = [UIImage imageNamed:@"icon_yanzheng_for_room_detail_basic_info_activity.png"];
    UIView *view = [self createRoomFeatureItemViewWithIcon:icon andText:roomDetailNetRespondBean.verifyDescription andY:y];
    [self addSubview:view];
    
    y += 31;
  }
  
  // 速定
  if (roomDetailNetRespondBean.isSpeed) {
    UIImage *icon = [UIImage imageNamed:@"icon_suding_for_room_detail_basic_info_activity.png"];
    UIView *view = [self createRoomFeatureItemViewWithIcon:icon andText:roomDetailNetRespondBean.speedDescription andY:y];
    [self addSubview:view];
    
    y += 31;
  }
  
  // 特价
  if (roomDetailNetRespondBean.isSpecial) {
    UIImage *icon = [UIImage imageNamed:@"icon_tejia_for_room_detail_basic_info_activity.png"];
    UIView *view = [self createRoomFeatureItemViewWithIcon:icon andText:roomDetailNetRespondBean.specialDescription andY:y];
    [self addSubview:view];
    
    y += 31;
  }
  
  // 精品房
  if (roomDetailNetRespondBean.isBoutique) {
    UIImage *icon = [UIImage imageNamed:@"icon_tejia_for_room_detail_basic_info_activity.png"];
    UIView *view = [self createRoomFeatureItemViewWithIcon:icon andText:roomDetailNetRespondBean.boutiqueDescription andY:y];
    [self addSubview:view];
    
    y += 31;
  }
  
  y += 5;
  self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, CGRectGetWidth(self.frame), y);
}

#pragma mark -
#pragma mark 方便构造
+(id)roomFeaturesForRoomDetailBasicInfoWithRoomDetailNetRespondBean:(RoomDetailNetRespondBean *)roomDetailNetRespondBean {
  NSArray *nibObjects = [[self nib] instantiateWithOwner:nil options:nil];
  RoomFeaturesForRoomDetailBasicInfo *roomFeaturesForRoomDetailBasicInfo = [nibObjects objectAtIndex:0];
  [roomFeaturesForRoomDetailBasicInfo initUseRoomDetailNetRespondBean:roomDetailNetRespondBean];
  return roomFeaturesForRoomDetailBasicInfo;
}



@end
