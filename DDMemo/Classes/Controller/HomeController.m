//
//  HomeController.m
//  DDMemo
//
//  Created by duodian on 2018/5/17.
//  Copyright © 2018年 丁远帅. All rights reserved.
//

#import "HomeController.h"
#import "DDCalendarManager.h"

@interface HomeController ()<DDCalendarEventSource>
{
    NSMutableDictionary *eventsByDate;
}
@property (nonatomic,strong)DDCalendarManager *manager;
@end

@implementation HomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    [self initView];
}

- (void)initView {
    self.manager = [DDCalendarManager new];
    self.manager.eventSource = self;
    self.manager.weekDayView = [[DDCalendarWeekDayView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
    [self.view addSubview:self.manager.weekDayView];
    
    self.manager.calenderScrollView = [[DDCalendarScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.manager.weekDayView.frame), CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-CGRectGetMaxY(self.manager.weekDayView.frame))];
    self.manager.calenderScrollView.bgColor = [UIColor clearColor];
    [self.view addSubview:self.manager.calenderScrollView];
    [self createRandomEvents];
}

- (void)createRandomEvents {
    eventsByDate = [NSMutableDictionary new];
    for(int i = 0; i < 30; ++i){
        NSDate *randomDate = [NSDate dateWithTimeInterval:(rand() % (3600 * 24 * 60)) sinceDate:[NSDate date]];
        NSString *key = [[self dateFormatter] stringFromDate:randomDate];
        if(!eventsByDate[key]){
            eventsByDate[key] = [NSMutableArray new];
        }
        
        [eventsByDate[key] addObject:randomDate];
    }
    [self.manager reloadAppearanceAndData];
}

// 该日期是否有事件
- (BOOL)calendarHaveEventWithDate:(NSDate *)date {
    NSString *key = [[self dateFormatter] stringFromDate:date];
    if(eventsByDate[key] && [eventsByDate[key] count] > 0){
        return YES;
    }
    return NO;
}
//当前 选中的日期  执行的方法
- (void)calendarDidSelectedDate:(NSDate *)date {
    
    NSString *key = [[self dateFormatter] stringFromDate:date];
//    self.label.text =  key;
    NSArray *events = eventsByDate[key];
    self.title = key;
    if (events.count>0) {
        //该日期有事件    tableView 加载数据
    }
}

- (NSDateFormatter *)dateFormatter
{
    static NSDateFormatter *dateFormatter;
    if(!dateFormatter){
        dateFormatter = [NSDateFormatter new];
        dateFormatter.dateFormat = @"yyyy.MM.dd";
    }
    return dateFormatter;
}

@end
