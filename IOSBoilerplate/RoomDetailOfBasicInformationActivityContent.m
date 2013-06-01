//
//  RoomDetailOfBasicInformationActivityContent.m
//  airizu
//
//  Created by 唐志华 on 13-1-28.
//
//

#import "RoomDetailOfBasicInformationActivityContent.h"

#import "RoomDetailDatabaseFieldsConstant.h"
#import "RoomDetailNetRespondBean.h"

#import "RoomPhotoGalleryForRoomDetailBasicInfo.h"
#import "RoomTitleForRoomDetailBasicInfo.h"
#import "RoomDetailForRoomDetailBasicInfo.h"
#import "TenantReviewsForRoomDetailBasicInfo.h"
#import "RoomFeaturesForRoomDetailBasicInfo.h"
#import "IntroductionForRoomDetailBasicInfo.h"

@interface RoomDetailOfBasicInformationActivityContent ()

// 目前将UI 分为6个子部分
// 1.房间照片画廊
@property (nonatomic, assign) RoomPhotoGalleryForRoomDetailBasicInfo *roomPhotoGalleryForRoomDetailBasicInfo;
// 2.房间 title 信息区域
@property (nonatomic, assign) RoomTitleForRoomDetailBasicInfo        *roomTitleForRoomDetailBasicInfo;
// 3.房间详情 区域
@property (nonatomic, assign) RoomDetailForRoomDetailBasicInfo       *roomDetailForRoomDetailBasicInfo;
// 4.租客点评 区域
@property (nonatomic, assign) TenantReviewsForRoomDetailBasicInfo    *tenantReviewsForRoomDetailBasicInfo;
// 5.房间特色 区域
@property (nonatomic, assign) RoomFeaturesForRoomDetailBasicInfo     *roomFeaturesForRoomDetailBasicInfo;
// 6.广告区域
@property (nonatomic, assign) IntroductionForRoomDetailBasicInfo     *introductionForRoomDetailBasicInfo;

@end

@implementation RoomDetailOfBasicInformationActivityContent

- (void)dealloc {
  
  // UI
  [_roomPriceLabel release];
  //
  [_roomPhotoGalleryPlaceholder release];
  [_roomTitlePlaceholder release];
  [_roomDetailPlaceholder release];
  [_tenantReviewsPlaceholder release];
  [_roomFeaturesPlaceholder release];
  
  [_introductionPlaceholder release];
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

#pragma mark -
#pragma mark 实现 CustomControlDelegate 接口
-(void)customControl:(id)control onAction:(NSUInteger)action{
  if ([_delegate conformsToProtocol:@protocol(CustomControlDelegate)]) {
    if ([_delegate respondsToSelector:@selector(customControl:onAction:)]) {
      [_delegate customControl:self onAction:action];
    }
  }
}

+ (NSString *) nibName {
  return NSStringFromClass([self class]);
}

+ (UINib *) nib {
  NSBundle *classBundle = [NSBundle bundleForClass:[self class]];
  return [UINib nibWithNibName:[self nibName] bundle:classBundle];
}

#pragma mark -
#pragma mark 方便构造
+(id)roomDetailOfBasicInformationActivityContentWithRoomDetailNetRespondBean:(RoomDetailNetRespondBean *)roomDetailNetRespondBean {
  NSArray *nibObjects = [[self nib] instantiateWithOwner:nil options:nil];
  RoomDetailOfBasicInformationActivityContent *roomDetailOfBasicInformationActivityContent = [nibObjects objectAtIndex:0];
  [roomDetailOfBasicInformationActivityContent loadSubviewAndUseRoomDetailNetRespondBeanInitialize:roomDetailNetRespondBean];
  return roomDetailOfBasicInformationActivityContent;
}

#pragma mark -
#pragma mark 加载子View
-(void)loadSubviewAndUseRoomDetailNetRespondBeanInitialize:(RoomDetailNetRespondBean *)roomDetailNetRespondBean{
  
  // 房间照片画廊上面的 房间价格
  NSString *roomPriceString = [NSString stringWithFormat:@"¥%d", [roomDetailNetRespondBean.price integerValue]];
  [_roomPriceLabel setText:roomPriceString];
  
  // 加载 1.房间照片画廊
  self.roomPhotoGalleryForRoomDetailBasicInfo
  = [RoomPhotoGalleryForRoomDetailBasicInfo roomPhotoGalleryForRoomDetailBasicInfoWithRoomDetailNetRespondBean:roomDetailNetRespondBean];
  self.roomPhotoGalleryForRoomDetailBasicInfo.delegate = self;
  [_roomPhotoGalleryPlaceholder addSubview:self.roomPhotoGalleryForRoomDetailBasicInfo];
  
  // 加载 2.房间 title 信息区域
  self.roomTitleForRoomDetailBasicInfo
  = [RoomTitleForRoomDetailBasicInfo roomTitleForRoomDetailBasicInfoWithRoomDetailNetRespondBean:roomDetailNetRespondBean];
  self.roomTitleForRoomDetailBasicInfo.delegate = self;
  
  [_roomTitlePlaceholder setFrame:CGRectMake(0,
                                             _roomTitlePlaceholder.frame.origin.y,
                                             CGRectGetWidth(self.roomTitleForRoomDetailBasicInfo.frame),
                                             CGRectGetHeight(self.roomTitleForRoomDetailBasicInfo.frame))];
  [_roomTitlePlaceholder addSubview:self.roomTitleForRoomDetailBasicInfo];
  
  // 加载 3.房间详情 区域
  self.roomDetailForRoomDetailBasicInfo
  = [RoomDetailForRoomDetailBasicInfo roomDetailForRoomDetailBasicInfoWithRoomDetailNetRespondBean:roomDetailNetRespondBean];
  self.roomDetailForRoomDetailBasicInfo.delegate = self;
  [_roomDetailPlaceholder setFrame:CGRectMake(0,
                                              CGRectGetMaxY(_roomTitlePlaceholder.frame) + 10,
                                              CGRectGetWidth(self.roomDetailForRoomDetailBasicInfo.frame),
                                              CGRectGetHeight(self.roomDetailForRoomDetailBasicInfo.frame))];
  [_roomDetailPlaceholder addSubview:self.roomDetailForRoomDetailBasicInfo];
  
  
  // 加载 4.租客点评 区域
  if ([self isNeedShowTenantReviews:roomDetailNetRespondBean]) {
    
    self.tenantReviewsForRoomDetailBasicInfo
    = [TenantReviewsForRoomDetailBasicInfo tenantReviewsForRoomDetailBasicInfoWithRoomDetailNetRespondBean:roomDetailNetRespondBean];
    self.tenantReviewsForRoomDetailBasicInfo.delegate = self;
    [_tenantReviewsPlaceholder setFrame:CGRectMake(0,
                                                   CGRectGetMaxY(_roomDetailPlaceholder.frame) + 10,
                                                   CGRectGetWidth(self.tenantReviewsForRoomDetailBasicInfo.frame),
                                                   CGRectGetHeight(self.tenantReviewsForRoomDetailBasicInfo.frame))];
    [_tenantReviewsPlaceholder addSubview:self.tenantReviewsForRoomDetailBasicInfo];
    
  } else {
    
    // 当前房间没有评论内容
    _tenantReviewsPlaceholder.hidden = YES;
    
    [_tenantReviewsPlaceholder setFrame:CGRectMake(0, CGRectGetMaxY(_roomDetailPlaceholder.frame), 0, 0)];
  }
  
  // 加载 5.房间特色 区域
  if ([roomDetailNetRespondBean isHaveRoomFeatures]) {
    self.roomFeaturesForRoomDetailBasicInfo
    = [RoomFeaturesForRoomDetailBasicInfo roomFeaturesForRoomDetailBasicInfoWithRoomDetailNetRespondBean:roomDetailNetRespondBean];
    [_roomFeaturesPlaceholder setFrame:CGRectMake(0,
                                                  CGRectGetMaxY(_tenantReviewsPlaceholder.frame) + 10,
                                                  CGRectGetWidth(self.roomFeaturesForRoomDetailBasicInfo.frame),
                                                  CGRectGetHeight(self.roomFeaturesForRoomDetailBasicInfo.frame))];
    [_roomFeaturesPlaceholder addSubview:self.roomFeaturesForRoomDetailBasicInfo];
    
  } else {
    
    // 当前房间没有特色
    _roomFeaturesPlaceholder.hidden = YES;
    
    [_roomFeaturesPlaceholder setFrame:CGRectMake(0, CGRectGetMaxY(_tenantReviewsPlaceholder.frame), 0, 0)];
    
  }
  
  // 加载 6.介绍区域
  //
  self.introductionForRoomDetailBasicInfo
  = [IntroductionForRoomDetailBasicInfo introductionForRoomDetailBasicInfoWithRoomDetailNetRespondBean:roomDetailNetRespondBean];
  self.introductionForRoomDetailBasicInfo.delegate = self;
  [_introductionPlaceholder setFrame:CGRectMake(0,
                                                CGRectGetMaxY(_roomFeaturesPlaceholder.frame) + 10,
                                                CGRectGetWidth(self.introductionForRoomDetailBasicInfo.frame),
                                                CGRectGetHeight(self.introductionForRoomDetailBasicInfo.frame))];
  [_introductionPlaceholder addSubview:self.introductionForRoomDetailBasicInfo];
  
  
  // 更新 content 区域frame
  CGRect contentFrame = self.frame;
  [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, CGRectGetMaxY(_introductionPlaceholder.frame))];
  contentFrame = self.frame;
}

-(BOOL)isNeedShowTenantReviews:(RoomDetailNetRespondBean *)roomDetailNetRespondBean {
  do {
    if ([NSString isEmpty:roomDetailNetRespondBean.reviewContent]) {
      break;
    }
    
    if ([roomDetailNetRespondBean.reviewCount integerValue] <= 0) {
      break;
    }
    return YES;
  } while (NO);
  
  return NO;
}

@end
