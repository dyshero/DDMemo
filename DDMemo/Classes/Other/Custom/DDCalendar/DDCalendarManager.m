//
//  DDCalendarManager.m
//  DDMemo
//
//  Created by duodian on 2018/5/18.
//  Copyright © 2018年 丁远帅. All rights reserved.
//

#import "DDCalendarManager.h"

@implementation DDCalendarManager
- (void)setCalenderScrollView:(DDCalendarScrollView *)calenderScrollView{
    _calenderScrollView = calenderScrollView;
    calenderScrollView.calendarView.eventSource = self.eventSource;
    
}
- (void)setEventSource:(id<DDCalendarEventSource>)eventSource{
    _eventSource = eventSource;
    self.calenderScrollView.calendarView.eventSource = self.eventSource;
    
}

- (void)goToDate:(NSDate *)date{
    [DDCalendarAppearance share].defaultDate = date;
    [self.calenderScrollView.calendarView reloadDefaultDate];
    [self.calenderScrollView.calendarView reloadAppearance];
}

/// 重新加载外观和数据
- (void)reloadAppearanceAndData{
    [self.weekDayView reloadAppearance];
    [self.calenderScrollView.calendarView reloadAppearance];
}

- (void)showSingleWeek{
    [self.calenderScrollView scrollToSingleWeek];
}

- (void)showAllWeek{
    [self.calenderScrollView scrollToAllWeek];
}

///  前一页。上个月
- (void)loadPreviousPage{
    [self.calenderScrollView.calendarView loadPreviousPage];
}
///   下一页 下一个月

- (void)loadNextPage{
    [self.calenderScrollView.calendarView loadNextPage];
}
- (NSDate *)currentSelectedDate{
    return self.calenderScrollView.calendarView.currentDate;
}

@end
