//
//  HomeController.m
//  DDMemo
//
//  Created by duodian on 2018/5/17.
//  Copyright © 2018年 丁远帅. All rights reserved.
//

#import "HomeController.h"
#import "DDCalendarManager.h"
#import "AddMemoView.h"
#import "UIBarButtonItem+Extension.h"

@interface HomeController ()<DDCalendarEventSource>
{
    NSMutableDictionary *eventsByDate;
}
@property (nonatomic,strong)DDCalendarManager *manager;
@property (nonatomic,strong)AddMemoView *addMemoView;
@end

@implementation HomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = ThemeColor;
    [self initView];
    [self createNav];
}

- (void)createNav {
    UIBarButtonItem *leftItem = [UIBarButtonItem itemWithFrame:CGRectMake(0, 0, 30, 30) norImage:@"list" title:nil target:self action:@selector(leftClicked)];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UIBarButtonItem *rightItem = [UIBarButtonItem itemWithFrame:CGRectMake(0, 0, 60, 44) norImage:nil title:@"Today" target:self action:@selector(rightClicked)];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)leftClicked {
    
}

- (void)rightClicked {
    [self.manager goToDate:[NSDate date]];
}

- (void)initView {
    self.manager = [DDCalendarManager new];
    self.manager.eventSource = self;
    self.manager.weekDayView = [[DDCalendarWeekDayView alloc]initWithFrame:CGRectMake(0, NAVBAR_HEIGHT, self.view.frame.size.width, 30)];
    [self.view addSubview:self.manager.weekDayView];
    
    self.manager.calenderScrollView = [[DDCalendarScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.manager.weekDayView.frame), CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-CGRectGetMaxY(self.manager.weekDayView.frame))];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.manager.calenderScrollView.bgColor = ThemeColor;
    [self.view addSubview:self.manager.calenderScrollView];
    [self.view insertSubview:self.manager.calenderScrollView atIndex:0];
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

- (NSDateFormatter *)dateFormatter {
    static NSDateFormatter *dateFormatter;
    if(!dateFormatter){
        dateFormatter = [NSDateFormatter new];
        dateFormatter.dateFormat = @"yyyy.MM.dd";
    }
    return dateFormatter;
}


- (IBAction)addClicked:(id)sender {
    [self.view addSubview:self.addMemoView];

//    [UIView animateWithDuration:0.4 animations:^{
//        self.view.transform = CGAffineTransformScale(CGAffineTransformIdentity,0.8,0.8);
//    } completion:^(BOOL finished) {
//
//
//    }];

}

- (AddMemoView *)addMemoView {
    if (!_addMemoView) {
        _addMemoView = [AddMemoView nibInitializtion];
        _addMemoView.frame = CGRectMake(10, 40 + NAVBAR_HEIGHT, kScreenWidth - 20, kScreenHeight - NAVBAR_HEIGHT - 40 - 10 - DD_SafeAreaBottom);
        dd_weakify(self);
        _addMemoView.closeBlock = ^{
            [weakSelf.addMemoView removeFromSuperview];
            weakSelf.addMemoView = nil;
        };
    }
    return _addMemoView;
}

//- (NewPagedFlowView *)pageFlowView {
//    if (!_pageFlowView) {
//        _pageFlowView = [[NewPagedFlowView alloc] initWithFrame:self.view.bounds];
//        _pageFlowView.delegate = self;
//        _pageFlowView.dataSource = self;
//        _pageFlowView.minimumPageAlpha = 0.36f;
//        _pageFlowView.minimumPageScale = 0.84f;
//        _pageFlowView.isCarousel = NO;
//        _pageFlowView.orientation = NewPagedFlowViewOrientationHorizontal;
//        _pageFlowView.isOpenAutoScroll = NO;
//        _pageFlowView.backgroundColor = [UIColor yellowColor];
//    }
//    return _pageFlowView;
//}

@end
