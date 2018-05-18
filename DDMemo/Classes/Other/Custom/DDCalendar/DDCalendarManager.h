//
//  DDCalendarManager.h
//  DDMemo
//
//  Created by duodian on 2018/5/18.
//  Copyright © 2018年 丁远帅. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DDCalendarScrollView.h"
#import "DDCalendarEventSource.h"
#import "DDCalendarWeekDayView.h"

@interface DDCalendarManager : NSObject
@property (nonatomic,strong) DDCalendarScrollView *calenderScrollView;
@property (nonatomic,strong) DDCalendarWeekDayView *weekDayView;
@property (weak, nonatomic) id<DDCalendarEventSource> eventSource;
@property (nonatomic,strong,readonly) NSDate *currentSelectedDate;

///回到固定某天
- (void)goToDate:(NSDate *)date;

/// 重新加载外观
- (void)reloadAppearanceAndData;

///  前一页。上个月
- (void)loadPreviousPage;

///   下一页 下一个月
- (void)loadNextPage;
- (void)showSingleWeek;
- (void)showAllWeek;
@end
