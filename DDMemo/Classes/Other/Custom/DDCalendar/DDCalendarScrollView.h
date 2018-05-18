//
//  DDCalendarScrollView.h
//  DDMemo
//
//  Created by duodian on 2018/5/18.
//  Copyright © 2018年 丁远帅. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDCalendarContentView.h"
#import "DDCalendarWeekDayView.h"

@interface DDCalendarScrollView : UIScrollView
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) DDCalendarContentView *calendarView;
@property (nonatomic,strong) UIColor *bgColor;
- (void)scrollToSingleWeek;
- (void)scrollToAllWeek;
@end
