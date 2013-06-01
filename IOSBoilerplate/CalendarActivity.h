//
//  CalendarActivity.h
//  airizu
//
//  Created by 唐志华 on 13-3-7.
//
//

#import "Activity.h"
#import "CustomControlDelegate.h"
#import "RoomCalendar.h"

// 日历类型
UIKIT_EXTERN NSString *const kIntentExtraTagForCalendarActivity_CalendarType;
// 这个用于 "选择入住时间" 界面, 传入的是目标房间的 3个月内 不可预订的时间数组
UIKIT_EXTERN NSString *const kIntentExtraTagForCalendarActivity_DataSourceForUnselectableDate;
// 设置房间日历 可选范围, 这里是对 "入住时间" 和 "退房时间" 业务逻辑的体现.
UIKIT_EXTERN NSString *const kIntentExtraTagForCalendarActivity_SelectableDayMarkForStart;
// 设置房间日历的最大有效时间跨度(目前业务规定 : 目前房东仅接受60天之内的入住请求)
UIKIT_EXTERN NSString *const kIntentExtraTagForCalendarActivity_MaxNumberOfDaysSpanInteger;


// 房间日历的类型
typedef NS_ENUM(NSInteger, CalendarTypeEnum) {
  // 入住时间
  kCalendarTypeEnum_CheckInDate = 0,
  // 退房时间
  kCalendarTypeEnum_CheckOutDate = 1
};

@interface CalendarActivity : Activity <CustomControlDelegate, RoomCalendarDelegate> {
  
}

@property (retain, nonatomic) IBOutlet UIView *titleBarPlaceholder;

@property (retain, nonatomic) IBOutlet UIView *bodyLayout;

@end
