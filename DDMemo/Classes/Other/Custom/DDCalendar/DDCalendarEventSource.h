//
//  DDCalendarEventSource.h
//  DDMemo
//
//  Created by duodian on 2018/5/18.
//  Copyright © 2018年 丁远帅. All rights reserved.
//

#import <Foundation/Foundation.h>
@class DDCalendarManager;

@protocol DDCalendarEventSource <NSObject>
/**
 该日期是否有事件
 @param date  NSDate
 @return BOOL
 */
@optional
- (BOOL)calendarHaveEventWithDate:(NSDate *)date;
- (UIColor *)calendarHaveEventDotColorWithDate:(NSDate *)date;

/**
 点击 日期后的执行的操作
 @param date 选中的日期
 */
- (void)calendarDidSelectedDate:(NSDate *)date;


/**
 翻页完成后的操作
 
 */
- (void)calendarDidLoadPageCurrentDate:(NSDate *)date;
@end
