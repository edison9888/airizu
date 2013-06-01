//
//  PointsToOffsetControl.m
//  airizu
//
//  Created by 唐志华 on 13-3-2.
//
//

#import "PointsToOffsetControl.h"
#import "FreeBookNetRespondBean.h"








@interface PointsToOffsetControl ()
@property (nonatomic, assign) FreeBookNetRespondBean *freeBookNetRespondBeanForUnusedPromotions;

// 当前积分可以兑换的金钱最大额度
@property (nonatomic, assign) NSInteger moneyWithAvailabelPointInteger;
// 上一次的历史记录
@property (nonatomic, assign) NSInteger historyValue;
//
@property (nonatomic, assign) id<PointsToOffsetControlDelegate> delegate;

//
@property (nonatomic, assign) NSInteger currentlyValue;
@end











@implementation PointsToOffsetControl

-(NSInteger)value{
  return _currentlyValue;
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

- (void)dealloc {
  
  /// UI
  [_pointSlider release];
  [_accountPointsInfoLabel release];
  [_minimumValueLabel release];
  [_maximumValueLabel release];
  [_currentlyValueLabel release];
  [super dealloc];
}

+ (NSString *) nibName {
  return NSStringFromClass([self class]);
}

+ (UINib *) nib {
  NSBundle *classBundle = [NSBundle bundleForClass:[self class]];
  return [UINib nibWithNibName:[self nibName] bundle:classBundle];
}


-(void)initAccountPointsInfoLabel {
  NSInteger pointInteger = [_freeBookNetRespondBeanForUnusedPromotions.availablePoint integerValue];
  NSString *info = [NSString stringWithFormat:@"您的账号目前有%d积分,本次预定最多可冲抵%d元房费", pointInteger, _moneyWithAvailabelPointInteger];
  _accountPointsInfoLabel.text = info;
}

-(void)initPointSlider{
  [_pointSlider setThumbImage:[UIImage imageNamed:@"thumb_icon_for_use_promotions_activity.png"] forState:UIControlStateNormal];
  
  /*
   - (UIImage *)stretchableImageWithLeftCapWidth:(NSInteger)leftCapWidth topCapHeight:
   
   (NSInteger)topCapHeight 这个函数是UIImage的一个实例函数，它的功能是创建一个内容可拉伸，而边角不拉伸的图片，
   需要两个参数，第一个是左边不拉伸区域的宽度，第二个参数是上面不拉伸的高度。
   
   根据设置的宽度和高度，将接下来的一个像素进行左右扩展和上下拉伸。
   
   注意：可拉伸的范围都是距离leftCapWidth后的1竖排像素，和距离topCapHeight后的1横排像素。
   
   参数的意义是，如果参数指定10，5。那么，图片左边10个像素，上边5个像素。不会被拉伸，x坐标为11和一个像素会被横向复制，
   y坐标为6的一个像素会被纵向复制。
   
   注意：只是对一个像素进行复制到一定宽度。而图像后面的剩余像素也不会被拉伸。
   
   */
  UIImage *imageMinBase = [UIImage imageNamed:@"minimum_track_image.png"];
  UIImage *imageForMin = [imageMinBase stretchableImageWithLeftCapWidth:10 topCapHeight:0];
  UIImage *imageMaxBase = [UIImage imageNamed:@"maximum_track_image.png"];
  UIImage *imageForMax = [imageMaxBase stretchableImageWithLeftCapWidth:10 topCapHeight:0];
  [_pointSlider setMinimumTrackImage:imageForMin forState:UIControlStateNormal];
  [_pointSlider setMaximumTrackImage:imageForMax forState:UIControlStateNormal];
  _pointSlider.minimumValue = 8;
  _pointSlider.maximumValue = _moneyWithAvailabelPointInteger;
  _pointSlider.value = _historyValue;
  
  //
  [_pointSlider addTarget:self
                   action:@selector(sliderDidChange:)
         forControlEvents:UIControlEventValueChanged];
  
  // 更新 可冲抵积分的上限和下限
  _minimumValueLabel.text = [NSString stringWithFormat:@"%0.0f", _pointSlider.minimumValue];
  _maximumValueLabel.text = [NSString stringWithFormat:@"%0.0f", _pointSlider.maximumValue];
  
  [self sliderDidChange:_pointSlider];
}

- (void)sliderDidChange:(id)sender {
  if ([sender isKindOfClass:[UISlider class]]) {
    UISlider *slider = sender;
    
    CGFloat sliderMin = slider.minimumValue;
    CGFloat sliderMax = slider.maximumValue;
    CGFloat sliderMaxMinDiff = sliderMax - sliderMin;
    CGFloat sliderValue = slider.value;
    
    
    CGFloat xCoord = ((sliderValue - sliderMin) / sliderMaxMinDiff) * (slider.frame.size.width-_currentlyValueLabel.frame.size.width);
      
    _currentlyValueLabel.frame
    = CGRectMake(xCoord + _currentlyValueLabel.frame.size.width/2 - 3,
                 CGRectGetMinY(_currentlyValueLabel.frame),
                 CGRectGetWidth(_currentlyValueLabel.frame),
                 CGRectGetHeight(_currentlyValueLabel.frame));
    
    _currentlyValue = (NSInteger)sliderValue;
    _currentlyValueLabel.text = [NSString stringWithFormat:@"¥%d", _currentlyValue];
    
    
    if ([_delegate conformsToProtocol:@protocol(PointsToOffsetControlDelegate)]) {
      if ([_delegate respondsToSelector:@selector(sliderDidChange:)]) {
        [_delegate sliderDidChange:self];
      }
    }
  }
}

+(id)pointsToOffsetControlWithFreeBookNetRespondBeanForUnusedPromotions:(FreeBookNetRespondBean *)freeBookNetRespondBeanForUnusedPromotions moneyForLatest:(NSString *)moneyForLatest delegate:(id<PointsToOffsetControlDelegate>)delegate {
  
  NSArray *nibObjects = [[self nib] instantiateWithOwner:nil options:nil];
  PointsToOffsetControl *newControl = [nibObjects objectAtIndex:0];
  
  //
  newControl.freeBookNetRespondBeanForUnusedPromotions = freeBookNetRespondBeanForUnusedPromotions;
  newControl.delegate = delegate;
  newControl.currentlyValueLabel.text = @"0";
  
  newControl.moneyWithAvailabelPointInteger = [freeBookNetRespondBeanForUnusedPromotions.availablePoint integerValue]/100 > [freeBookNetRespondBeanForUnusedPromotions.advancedDeposit integerValue] ? ([freeBookNetRespondBeanForUnusedPromotions.advancedDeposit integerValue] - 1) : [freeBookNetRespondBeanForUnusedPromotions.availablePoint integerValue]/100;
  

  if (![NSString isEmpty:moneyForLatest]) {
    newControl.historyValue = [moneyForLatest integerValue];
  } else {
    newControl.historyValue = newControl.moneyWithAvailabelPointInteger;
  }

  //
  [newControl initAccountPointsInfoLabel];
  //
  [newControl initPointSlider];
  
  return newControl;
}
@end
