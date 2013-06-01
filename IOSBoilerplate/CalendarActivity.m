//
//  CalendarActivity.m
//  airizu
//
//  Created by 唐志华 on 13-3-7.
//
//

#import "CalendarActivity.h"
#import "TitleBar.h"

#import "RoomCalendar.h"
#import "NSDate+Convenience.h"








static const NSString *const TAG = @"<CalendarActivity>";



// 日历类型
NSString *const kIntentExtraTagForCalendarActivity_CalendarType = @"CalendarType";
// 这个用于 "选择入住时间" 界面, 传入的是目标房间的 3个月内 不可预订的时间数组
NSString *const kIntentExtraTagForCalendarActivity_DataSourceForUnselectableDate = @"DataSourceForUnselectableDate";
// 设置房间日历 可选范围, 这里是对 "入住时间" 和 "退房时间" 业务逻辑的体现.
NSString *const kIntentExtraTagForCalendarActivity_SelectableDayMarkForStart = @"SelectableDayMarkForStart";
// 设置房间日历的最大有效时间跨度(目前业务规定 : 目前房东仅接受60天之内的入住请求)
NSString *const kIntentExtraTagForCalendarActivity_MaxNumberOfDaysSpanInteger = @"MaxNumberOfDaysSpanInteger";






@interface CalendarActivity ()
///
@property (nonatomic, assign) BOOL isIncomingIntentValid;
@property (nonatomic, assign) TitleBar *titleBar;

/// 外部传入的数据
//
@property (nonatomic, assign) CalendarTypeEnum calendarTypeEnum;

// 这个用于 "选择入住时间" 界面, 传入的是目标房间的 3个月内 不可预订的时间数组
@property (nonatomic, copy) NSArray *dataSourceForUnselectableDate;
// 设置房间日历 可选范围, 这里是对 "入住时间" 和 "退房时间" 业务逻辑的体现.
// selectableDayMarkForStart 之后的日期才是可选日期 (用于 "退房时间")
@property(nonatomic, copy) NSDate *selectableDayMarkForStart;
// selectableDayMarkForEnd 之前的日期才是可选日期 (用于 "入住时间")
@property(nonatomic, copy) NSDate *selectableDayMarkForEnd;

// 设置房间日历的最大有效时间跨度(目前业务规定 : 目前房东仅接受60天之内的入住请求)
@property(nonatomic, assign) NSInteger maxNumberOfDaysSpanInteger;


///
@property (nonatomic, copy) NSDate *dateForCheckIn; // "入住时间"
@property (nonatomic, copy) NSDate *dateForCheckOut;// "退房时间"
@end














@implementation CalendarActivity

- (void)dealloc {
  
  ///
  [_dataSourceForUnselectableDate release];
  [_selectableDayMarkForStart release];
  [_selectableDayMarkForEnd release];
  
  
  
  /// UI
  [_titleBarPlaceholder release];
  [_bodyLayout release];
  [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  if ([DeviceInformation isIPhone5]) {
    // 这里决不能设成 autorelease 的, 网上的代码就是 autorelease的, 4.3系统会崩溃, 因为被自动释放了
    self = [super initWithNibName:@"CalendarActivity_iphone5" bundle:nibBundleOrNil];
  } else {
    self = [super initWithNibName:@"CalendarActivity" bundle:nibBundleOrNil];
  }
  if (self) {
    // Custom initialization
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  // Do any additional setup after loading the view from its nib.
  
  [self initTitleBar];
  
  if (_isIncomingIntentValid) {
    
    if (kCalendarTypeEnum_CheckInDate == _calendarTypeEnum) {
      /// 入住时间
      RoomCalendar *roomCalendarForCheckInDate
      = [RoomCalendar roomCalendarWithTitleName:@"入住时间"
                                       delegate:self defaultSelectedDate:_dateForCheckIn];
      roomCalendarForCheckInDate.tag = kCalendarTypeEnum_CheckInDate;
      roomCalendarForCheckInDate.maxNumberOfDaysSpanInteger = _maxNumberOfDaysSpanInteger;
      [roomCalendarForCheckInDate showInView:self.bodyLayout];
      
      
      _titleBar.titleLabel.text = @"入住时间";
    } else {
      /// 退房时间
      RoomCalendar *roomCalendarForCheckOutDate
      = [RoomCalendar roomCalendarWithTitleName:@"退房时间"
                                       delegate:self defaultSelectedDate:_dateForCheckOut];
      roomCalendarForCheckOutDate.tag = kCalendarTypeEnum_CheckOutDate;
      roomCalendarForCheckOutDate.selectableDayMarkForStart = self.selectableDayMarkForStart;
      [roomCalendarForCheckOutDate showInView:self.bodyLayout];
      
    
      _titleBar.titleLabel.text = @"退房时间";
    }
    
  } else {
    
    // 传入的 Intent 数据无效
    [_titleBar setTitleByString:kIncomingIntentValid];
    
  }
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
  
  //
  self.titleBar = nil;
  
  /// UI
  [self setTitleBarPlaceholder:nil];
  [self setBodyLayout:nil];
  [super viewDidUnload];
}

#pragma mark -
#pragma mark Activity 生命周期

-(BOOL)parseIncomingIntent:(Intent *)intent {
  
  do {
    if (intent == nil) {
      break;
    }
    
    ///
    id calendarTypeTest = [intent.extras objectForKey:kIntentExtraTagForCalendarActivity_CalendarType];
    if (![calendarTypeTest isKindOfClass:[NSNumber class]]) {
      NSAssert(NO, @"外传传入的Intent中有错误参数 : CalendarType");
      break;
    }
    self.calendarTypeEnum = [calendarTypeTest integerValue];
    if (_calendarTypeEnum < kCalendarTypeEnum_CheckInDate || _calendarTypeEnum > kCalendarTypeEnum_CheckOutDate) {
      NSAssert(NO, @"外传传入的Intent中有错误参数 : CalendarType");
      break;
    }
    
    ///
    id dataSourceForUnselectableDateTest = [intent.extras objectForKey:kIntentExtraTagForCalendarActivity_DataSourceForUnselectableDate];
    if (dataSourceForUnselectableDateTest != nil
        && ![dataSourceForUnselectableDateTest isKindOfClass:[NSArray class]]) {
      NSAssert(NO, @"外传传入的Intent中有错误参数 : ");
      break;
    }
    self.dataSourceForUnselectableDate = [NSArray arrayWithArray:dataSourceForUnselectableDateTest];
    
    ///
    id selectableDayMarkForStartTest = [intent.extras objectForKey:kIntentExtraTagForCalendarActivity_SelectableDayMarkForStart];
    if (selectableDayMarkForStartTest != nil
        && ![selectableDayMarkForStartTest isKindOfClass:[NSDate class]]) {
      NSAssert(NO, @"外传传入的Intent中有错误参数 : ");
      break;
    }
    self.selectableDayMarkForStart = selectableDayMarkForStartTest;
    
    ///
    id maxNumberOfDaysSpanIntegerTest = [intent.extras objectForKey:kIntentExtraTagForCalendarActivity_MaxNumberOfDaysSpanInteger];
    if (maxNumberOfDaysSpanIntegerTest != nil
        && ![maxNumberOfDaysSpanIntegerTest isKindOfClass:[NSNumber class]]) {
      NSAssert(NO, @"外传传入的Intent中有错误参数 : ");
      break;
    }
    self.maxNumberOfDaysSpanInteger = [maxNumberOfDaysSpanIntegerTest integerValue];
    
    
    // 一切OK
    return YES;
  } while (false);
  
  // 出现问题
  
  return NO;
}


-(void)onCreate:(Intent *)intent {
  PRPLog(@"%@ --> onCreate ", TAG);
  
  self.isIncomingIntentValid = [self parseIncomingIntent:intent];
  
}

-(void)onPause {
  PRPLog(@"%@ --> onPause ", TAG);
}

-(void)onResume {
  PRPLog(@"%@ --> onResume ", TAG);
  
}

#pragma mark -
#pragma mark 初始化UI
//
- (void) initTitleBar {
  if (_titleBar != nil) {
    NSAssert(NO, @"initTitleBar 方法只能被调用一次.");
    return;
  }
  
  TitleBar *titleBar = [TitleBar titleBar];
  titleBar.delegate = self;
  [titleBar setTitleByString:@"房间日历"];
  [titleBar hideLeftButton:NO];
  [self.titleBarPlaceholder addSubview:titleBar];
  
  self.titleBar = titleBar;
}

-(void)finishActivity {
  
  Intent *intent = [Intent intent];
  
  // 入住时间
  if (_dateForCheckIn != nil) {
    [intent.extras setObject:_dateForCheckIn forKey:[NSNumber numberWithInteger:kCalendarTypeEnum_CheckInDate]];
  }
  // 退房时间
  if (_dateForCheckOut != nil) {
    [intent.extras setObject:_dateForCheckOut forKey:[NSNumber numberWithInteger:kCalendarTypeEnum_CheckOutDate]];
  }

  [self setResult:kActivityResultCode_RESULT_OK data:intent];
  [self finish];
}

#pragma mark -
#pragma mark 实现 CustomControlDelegate 接口
-(void)customControl:(id)control onAction:(NSUInteger)action {
  switch (action) {
      
    case kTitleBarActionEnum_LeftButtonClicked:{
      [self finishActivity];
    }break;
      
    default:
      break;
  }
}

#pragma mark -
#pragma mark 实现 RoomCalendarDelegate 接口

-(void)calendarView:(RoomCalendar *)calendarView dateSelected:(NSDate *)date {
  
  switch (calendarView.tag) {
      
    case kCalendarTypeEnum_CheckInDate:{// "入住时间"
      self.dateForCheckIn = date;
      
      // 当更新 "入住时间" 后, 要及时更新 "退房时间"
      RoomCalendar *roomCalendarForCheckOutDate = [RoomCalendar roomCalendarWithTitleName:@"退房时间" delegate:self defaultSelectedDate:_dateForCheckOut];
      roomCalendarForCheckOutDate.tag = kCalendarTypeEnum_CheckOutDate;
      roomCalendarForCheckOutDate.selectableDayMarkForStart = self.dateForCheckIn;
      [roomCalendarForCheckOutDate showInView:self.bodyLayout];
      
      _titleBar.titleLabel.text = @"退房时间";
    }break;
      
    case kCalendarTypeEnum_CheckOutDate:{// "退房时间"
      self.dateForCheckOut = date;
      
      ///
      [self finishActivity];
    }break;
      
    default:
      break;
  }
}

-(void)closeCalendar:(RoomCalendar *)calendarView {
  
  switch (calendarView.tag) {
      
    case kCalendarTypeEnum_CheckInDate:{// "入住时间"
      
    }break;
      
    case kCalendarTypeEnum_CheckOutDate:{// "退房时间"
      if (_dateForCheckIn != nil && _dateForCheckOut != nil) {
        NSDate *laterDate = [_dateForCheckIn laterDate:_dateForCheckOut];
        if (laterDate != _dateForCheckOut || [_dateForCheckIn isEqualToDate:_dateForCheckOut withDateFormat:@"yyyyMMdd"]) {
          self.dateForCheckOut = [_dateForCheckIn offsetDay:1];
        }
      }
      
      
    }break;
      
    default:
      break;
  }
  
}

@end
