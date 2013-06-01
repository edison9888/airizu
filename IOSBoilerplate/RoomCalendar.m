//
//  RoomCalendar.m
//  airizu
//
//  Created by 唐志华 on 13-1-17.
//
//

#import "RoomCalendar.h"

#import "UIColor+ColorSchemes.h"
#import "TitleBar.h"
#import "NSDate+Convenience.h"



static const NSString *const TAG = @"<RoomCalendar>";

@interface RoomCalendar ()

@property (nonatomic, assign) id<RoomCalendarDelegate> delegate;

// "今天" 对应的 NSDate
@property(nonatomic, retain) NSDate *dateForToday;
// 当前月份对应的 NSDate
@property(nonatomic, retain) NSDate *dateForCurrentMonth;
// 最大限制天数对应的NSDate
@property(nonatomic, retain) NSDate *maxDayDate;

@property(nonatomic, retain) NSDate *defaultSelectedDate;
@end


@implementation RoomCalendar

-(void)setMaxNumberOfDaysSpanInteger:(NSInteger)v{
  _maxNumberOfDaysSpanInteger = v;
  
  if (v > 0) {
    self.maxDayDate = [_dateForToday offsetDay:v];
  }
}

-(void)dealloc {
  
  
  [_dataSourceForUnselectableDate release];
  
  [_dateForToday release];
  [_dateForCurrentMonth release];
  
  [_selectableDayMarkForStart release];
  [_selectableDayMarkForEnd release];
  [_maxDayDate release];
  
  [_defaultSelectedDate release];
  
  // UI
  [_currentlyDateLabel release];
  [_weekBar release];
  [_dayBar release];
  [super dealloc];
}

-(id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    // Initialization code
    PRPLog(@"init %@ [0x%x]", TAG, [self hash]);
  }
  return self;
}

+(NSString *)nibName {
  return NSStringFromClass([self class]);
}

+(UINib *)nib {
  NSBundle *classBundle = [NSBundle bundleForClass:[self class]];
  return [UINib nibWithNibName:[self nibName] bundle:classBundle];
}

#pragma mark -
#pragma mark 初始化UI

-(void)updateCalendar {
  [self updateTitleBar];
  [self updateWeekBar];
  [self updateDayBar];
}

-(void)updateTitleBar {
  _currentlyDateLabel.text = [_dateForCurrentMonth stringWithDateFormat:@"yyyy年MM月"];
}

-(void)updateWeekBar {
  
  if ([_dateForCurrentMonth isEqualToDate:_dateForToday withDateFormat:@"yyyyMM"]) {
    // 当前月份
    NSInteger weekday = [_dateForToday dateComponents].weekday;
    UILabel *weekLabel = (UILabel *)[_weekBar viewWithTag:weekday];
    weekLabel.textColor = [UIColor orangeColor];
  } else {
    NSArray *weekLabelArray = [_weekBar subviews];
    for (UILabel *weekLabel in weekLabelArray) {
      weekLabel.textColor = [UIColor blackColor];
    }
  }
  
}

typedef enum {
  // 无效日期
  kDayBallTypeEnum_Invalid = 0,
  // "今天" && "可选"
  kDayBallTypeEnum_TodayAndSelectable,
  // "今天" && "不可选"
  kDayBallTypeEnum_TodayAndUnselectable,
  // "可选"
  kDayBallTypeEnum_Selectable,
  // "不可选"
  kDayBallTypeEnum_Unselectable
} DayBallTypeEnum;

-(void)setDayButton:(UIButton *)button
       withDayIndex:(NSInteger)dayIndex
    withDayBallType:(DayBallTypeEnum)dayBallType {
  [button setTitle:[[NSNumber numberWithInteger:dayIndex] stringValue] forState:UIControlStateNormal];
  
  switch (dayBallType) {
      
    case kDayBallTypeEnum_Invalid:{// 无效日期
      [button setUserInteractionEnabled:NO];
      [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
      [button setBackgroundImage:[UIImage imageNamed:@"icon_ball_invalid_date.png"] forState:UIControlStateNormal];
    }break;
      
    case kDayBallTypeEnum_TodayAndSelectable:{// "今天" && "可选"
      [button setUserInteractionEnabled:YES];
      [button setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
      [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
      [button setBackgroundImage:[UIImage imageNamed:@"icon_ball_today_and_selectable.png"] forState:UIControlStateNormal];
    }break;
      
    case kDayBallTypeEnum_TodayAndUnselectable:{// "今天" && "不可选"
      [button setUserInteractionEnabled:NO];
      [button setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
      [button setBackgroundImage:[UIImage imageNamed:@"icon_ball_today_and_unselectable.png"] forState:UIControlStateNormal];
    }break;
      
    case kDayBallTypeEnum_Selectable:{// "可选"
      [button setUserInteractionEnabled:YES];
      [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
      [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
      [button setBackgroundImage:[UIImage imageNamed:@"icon_ball_selectable.png"] forState:UIControlStateNormal];
    }break;
      
    case kDayBallTypeEnum_Unselectable:{// "不可选"
      [button setUserInteractionEnabled:NO];
      [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
      [button setBackgroundImage:[UIImage imageNamed:@"icon_ball_unselectable.png"] forState:UIControlStateNormal];
    }break;
      
    default:
      break;
  }
}

-(DayBallTypeEnum)testDayBallTypeWithDayIndex:(NSInteger)dayIndex {
  
  NSDate *dayDate = [NSDate dayDateFromMonthDate:_dateForCurrentMonth dayIndex:dayIndex];
	NSString *dayDateString = [dayDate stringWithDateFormat:@"yyyyMMdd"];
  
  DayBallTypeEnum dayBallTypeEnum = kDayBallTypeEnum_Invalid;
  
  //////////    无效日期的判断    ///////////
  NSDate *earlierDateForToday = [dayDate earlierDate:_dateForToday];
  if (earlierDateForToday == dayDate && ![earlierDateForToday isEqualToDate:_dateForToday withDateFormat:@"yyyyMMdd"]) {
    // "今天" 之前的日期都是无效日期(记着要把 "今天" 摘出去)
    return kDayBallTypeEnum_Invalid;
  }
  if (_maxDayDate != nil) {
    NSDate *laterDateForMaxDay = [dayDate laterDate:_maxDayDate];
    if (laterDateForMaxDay == dayDate || [dayDate isEqualToDate:_maxDayDate withDateFormat:@"yyyyMMdd"]) {
      // "最大天数" 之后的日期都是无效日期(记着要把 "最大天数" 那天包括进来)
      dayBallTypeEnum = kDayBallTypeEnum_Invalid;
      return kDayBallTypeEnum_Invalid;
    }
  }
  ////////////////////////////////////////
  
  do {
    
    //////////    有效日期的判断    ///////////
    
    BOOL isUnselectableDate = [_dataSourceForUnselectableDate containsObject:dayDateString];
    
    if (isUnselectableDate) {// 当前房间, 当前日期不可被预订(比对数据来自后台接口)
      dayBallTypeEnum = kDayBallTypeEnum_Unselectable;
      break;
    }
    
    // 这里是对 "入住时间" 和 "退房时间" 业务逻辑的体现, 也就是 "退房时间" 一定在 "入住时间" 后一天
    if (_selectableDayMarkForStart != nil) {
      NSDate *earlierDateForStartDay = [dayDate earlierDate:_selectableDayMarkForStart];
      if (earlierDateForStartDay == dayDate) {
        // "开始日期" 之前的日期是不可选日期
        dayBallTypeEnum = kDayBallTypeEnum_Unselectable;
        break;
      }
    }
    
    if (_selectableDayMarkForEnd != nil) {
      NSDate *laterDateForEndDay = [dayDate laterDate:_selectableDayMarkForEnd];
      if (laterDateForEndDay == dayDate) {
        // "结束" 之后的日期都是不可选日期
        dayBallTypeEnum = kDayBallTypeEnum_Unselectable;
        break;
      }
    }
    
    // 其他日期都是可选日期
    dayBallTypeEnum = kDayBallTypeEnum_Selectable;
    ////////////////////////////////////////
  } while (NO);
  
  // 对于 "今天" 的处理
  if ([_dateForToday isEqualToDate:dayDate withDateFormat:@"yyyyMMdd"]) {
    if (dayBallTypeEnum == kDayBallTypeEnum_Unselectable) {
      dayBallTypeEnum = kDayBallTypeEnum_TodayAndUnselectable;
    } else {
      dayBallTypeEnum = kDayBallTypeEnum_TodayAndSelectable;
    }
  }
  
  return dayBallTypeEnum;
}

// 非常抱歉目前房东仅接受60天之内的入住请求,请重选您的入住时间! (包括今天)
-(void)updateDayBar{
  NSInteger firstWeekDayInMonth = [_dateForCurrentMonth firstWeekDayInMonth];
  NSInteger numberOfDaysInMonth = [_dateForCurrentMonth numberOfDaysInMonth];
  
  NSArray *dayButtonArray = [_dayBar subviews];
  NSRange monthDayRange = NSMakeRange(firstWeekDayInMonth, numberOfDaysInMonth);
  NSInteger dayIndex = 1;
  for (UIButton *dayButton in dayButtonArray) {
    
    // buttonTag 是从 1~42
    NSInteger buttonTag = dayButton.tag;
    if (NSLocationInRange(buttonTag, monthDayRange)) {
      dayButton.hidden = NO;
      
      DayBallTypeEnum dayBallTypeEnum = [self testDayBallTypeWithDayIndex:dayIndex];
      
      [self setDayButton:dayButton withDayIndex:dayIndex withDayBallType:dayBallTypeEnum];
      
      dayIndex++;
    } else {
      
      // 不在有效的月份日期内
      dayButton.hidden = YES;
    }
    
  }
}

-(void)initCalendarWithDefaultSelectedDate:(NSDate *)defaultSelectedDate{
  
  self.dateForToday = [NSDate todayDate];
  
  NSDate *currentMonth = defaultSelectedDate;
  if (currentMonth == nil) {
    currentMonth = [NSDate todayDate];
  }
  self.dateForCurrentMonth = currentMonth;
  
}

#pragma mark -
#pragma mark 方便构造
+(id)roomCalendarWithTitleName:(NSString *)titleName
                      delegate:(id)delegate
           defaultSelectedDate:(NSDate *)defaultSelectedDate { 
  
  NSArray *nibObjects = [[self nib] instantiateWithOwner:nil options:nil];
  
  RoomCalendar *roomCalendar = [nibObjects objectAtIndex:0];
  
  //
  roomCalendar.delegate = delegate;
  roomCalendar.defaultSelectedDate = defaultSelectedDate;
  
  //
  [roomCalendar initCalendarWithDefaultSelectedDate:defaultSelectedDate];
  
  return roomCalendar;
}


-(void)showInView:(UIView*)view {
  
  //////// 这里是对 "入住日期" 的特殊处理
  // 如果当前月的所有日期都不可选了, 就自动翻到下个月
  if (_dataSourceForUnselectableDate != nil) {
    
  }
  
  //////// 这里是对 "退房日期" 的特殊处理
  // 如果 "入住时间" 选择的是 一个月的最后一天, 那么 "退房时间" 要从下一个月开始
  if (_selectableDayMarkForStart != nil) {
    
    NSDate *laterDate = [_selectableDayMarkForStart laterDate:_defaultSelectedDate];
    if (laterDate == _selectableDayMarkForStart) {
      
      // 如果 可选日期的起始日期 大于 默认的日期, 就证明 "入住日期" 大于 "退房日期" 了, 此时要更新 "退房日期"
      self.dateForCurrentMonth = [_selectableDayMarkForStart offsetDay:1];
    
    } else if ([_selectableDayMarkForStart numberOfDaysInMonth] == [_selectableDayMarkForStart dateComponents].day) {
    
      // 如果 "入住时间" 选择的 Day 是当前月的 最后一天, 那么 "退房日期" 就要从 入住日期 的下一个月开始.
      self.dateForCurrentMonth = [_selectableDayMarkForStart offsetMonth:1];
    }
  }
  
  //
  [self updateCalendar];
  
  [view addSubview:self];
}

-(void)dismiss {
  [self cancelButtonOnClickListener:nil];
}

// "Day" 按钮
- (IBAction)dayButtonOnClickListener:(id)sender {
  
  UIButton *dayButton = (UIButton *)sender;
  
  NSString *dayString = dayButton.titleLabel.text;
  NSInteger dayInteger = [dayString integerValue];
	NSDate *dayDate = [NSDate dayDateFromMonthDate:_dateForCurrentMonth dayIndex:dayInteger];
	
  if ([_delegate conformsToProtocol:@protocol(RoomCalendarDelegate)]) {
    if ([_delegate respondsToSelector:@selector(calendarView:dateSelected:)]) {
      [_delegate calendarView:self dateSelected:dayDate];
    }
  }
  
  [self removeFromSuperview];
}

// "取消" 按钮
- (IBAction)cancelButtonOnClickListener:(id)sender {
  if ([_delegate conformsToProtocol:@protocol(RoomCalendarDelegate)]) {
    if ([_delegate respondsToSelector:@selector(closeCalendar:)]) {
      [_delegate closeCalendar:self];
    }
  }
  
  [self removeFromSuperview];
}

// "上个月" 按钮
- (IBAction)lastMonthButtonOnClickListener:(id)sender {
  
  do {
    
    if ([_dateForCurrentMonth isEqualToDate:_dateForToday withDateFormat:@"yyyyMM"]) {
      // 不能选取当前月的前一个月
      break;
    }
    
    NSDate *laterDate = [_dateForCurrentMonth laterDate:_dateForToday];
    if (laterDate != _dateForCurrentMonth) {
      //
      break;
    }
    
    self.dateForCurrentMonth = [_dateForCurrentMonth offsetMonth:-1];
    
    [self updateCalendar];
  } while (NO);
  
}

// "下个月" 按钮
- (IBAction)nextMonthButtonOnClickListener:(id)sender {
  
  do {
    if (_maxDayDate == nil) {
      // 没有限制
      break;
    }
    
    NSDate *currentMonthFirstDay = [NSDate dayDateFromMonthDate:_dateForCurrentMonth dayIndex:1];
    
    NSDate *maxMonthFirstDay = [NSDate dayDateFromMonthDate:_maxDayDate dayIndex:1];
    
    NSDate *laterDate = [currentMonthFirstDay laterDate:maxMonthFirstDay];
    if (laterDate == maxMonthFirstDay) {
      // 当前月 已经是限制月了
      break;
    }
    
    return;
  } while (NO);
  
  //
  self.dateForCurrentMonth = [_dateForCurrentMonth offsetMonth:1];
  [self updateCalendar];
}


@end
