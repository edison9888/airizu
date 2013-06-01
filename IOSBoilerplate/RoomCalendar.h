//
//  RoomCalendar.h
//  airizu
//
//  Created by 唐志华 on 13-1-17.
//
//

#import <UIKit/UIKit.h>

@class RoomCalendar;
@protocol RoomCalendarDelegate<NSObject>
-(void)calendarView:(RoomCalendar *)calendarView dateSelected:(NSDate *)date;
@optional
-(void)closeCalendar:(RoomCalendar *)calendarView;
@end

@interface RoomCalendar : UIView {
  
}

// UI
@property (retain, nonatomic) IBOutlet UILabel *currentlyDateLabel;
@property (retain, nonatomic) IBOutlet UIView *weekBar;
@property (retain, nonatomic) IBOutlet UIView *dayBar;

#pragma mark -
#pragma mark 用于不同界面的房间日历设置参数
// 这个用于 "选择入住时间" 界面, 传入的是目标房间的 3个月内 不可预订的时间数组
@property (nonatomic, retain) NSArray *dataSourceForUnselectableDate;

// 设置房间日历 可选范围, 这里是对 "入住时间" 和 "退房时间" 业务逻辑的体现.
// selectableDayMarkForStart 之后的日期才是可选日期 (用于 "退房时间")
@property(nonatomic, retain) NSDate *selectableDayMarkForStart;
// selectableDayMarkForEnd 之前的日期才是可选日期 (用于 "入住时间")
@property(nonatomic, retain) NSDate *selectableDayMarkForEnd;

// 设置房间日历的最大有效时间跨度(目前业务规定 : 目前房东仅接受60天之内的入住请求)
@property(nonatomic, assign) NSInteger maxNumberOfDaysSpanInteger;


#pragma mark -
#pragma mark 方便构造
+(id)roomCalendarWithTitleName:(NSString *)titleName
                      delegate:(id<RoomCalendarDelegate>)delegate
           defaultSelectedDate:(NSDate *)defaultSelectedDate;

-(void)showInView:(UIView*)view;
-(void)dismiss;
@end
