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
#import "NSString+Extension.h"
#import "AppDelegate.h"
#import "Memo+CoreDataProperties.h"
#import "NSDate+Extension.h"

@interface HomeController ()<DDCalendarEventSource>
{
    NSMutableDictionary *eventsByDate;
}
@property (nonatomic,strong)DDCalendarManager *manager;
@property (nonatomic,strong)AddMemoView *addMemoView;
@property (nonatomic,strong)NSMutableArray *dateArray;
@property (nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic,strong) NSManagedObjectContext *context;
@end

@implementation HomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self dddd];
    
    self.view.backgroundColor = ThemeColor;
    [self initView];
    [self createNav];
}

- (void)createNav {
    UIBarButtonItem *leftItem = [UIBarButtonItem itemWithFrame:CGRectMake(0, 0, 30, 30) norImage:@"list" title:nil target:self action:@selector(leftClicked)];
//    self.navigationItem.leftBarButtonItem = leftItem;
    
    UIBarButtonItem *rightItem = [UIBarButtonItem itemWithFrame:CGRectMake(0, 0, 60, 44) norImage:nil title:@"Today" target:self action:@selector(rightClicked)];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)dddd {
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"DDMemo" withExtension:@"momd"];
    NSManagedObjectModel *model = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    
    NSPersistentStoreCoordinator *store = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    
    NSString *containerPath = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"group.ddmemo"].path;
    NSString *sqlitePath = [NSString stringWithFormat:@"%@/%@", containerPath, @"coreData.sqlite"];
    NSURL *sqlUrl = [NSURL fileURLWithPath:sqlitePath];
    
    NSError *error = nil;
    [store addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:sqlUrl options:nil error:&error];
    if (error) {
        NSLog(@"添加数据库失败:%@",error);
    } else {
        NSLog(@"添加数据库成功");
    }
    
    NSManagedObjectContext *context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    context.persistentStoreCoordinator = store;
    _context = context;
    AppDelegate *appDelete = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appDelete.context = context;
}

- (void)leftClicked {
    
}

- (void)rightClicked {
    [self.manager goToDate:[NSDate date]];
}

- (void)initView {
    self.manager = [DDCalendarManager new];
    self.manager.eventSource = self;
    self.manager.weekDayView = [[DDCalendarWeekDayView alloc] initWithFrame:CGRectMake(0, NAVBAR_HEIGHT, self.view.frame.size.width, 30)];
    [self.view addSubview:self.manager.weekDayView];
    
    self.manager.calenderScrollView = [[DDCalendarScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.manager.weekDayView.frame), CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-CGRectGetMaxY(self.manager.weekDayView.frame))];
    __weak typeof(self) ws = self;
    self.manager.calenderScrollView.delteMemoBlock = ^(Memo *memo) {
        [ws.dataArray removeObject:memo];
        if (ws.dataArray.count == 0) {
            [ws loadData];
        }
    };
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.manager.calenderScrollView.bgColor = ThemeColor;
    [self.view addSubview:self.manager.calenderScrollView];
    [self.view insertSubview:self.manager.calenderScrollView atIndex:0];
    [self loadData];
}

- (void)loadData {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Memo" inManagedObjectContext:appDelegate.context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    NSArray *dataArray = [appDelegate.context executeFetchRequest:request error:nil];
    _dateArray = [NSMutableArray array];
    if (dataArray) {
        for (Memo *memo in dataArray) {
            if (![_dateArray containsObject:memo.date]) {
                [_dateArray addObject:memo.date];
            }
        }
    }
    [self.manager reloadAppearanceAndData];
}

// 该日期是否有事件
- (BOOL)calendarHaveEventWithDate:(NSDate *)date {
    NSString *key = [NSString dateStringFromDate:date];
    if ([_dateArray containsObject:key]) {
        return YES;
    }
    return NO;
}

//当前 选中的日期  执行的方法
- (void)calendarDidSelectedDate:(NSDate *)date {
    self.title = [NSString shortDateStringFromDate:date];
    NSString *key = [NSString dateStringFromDate:date];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Memo"];
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"date = %@", key];
    request.predicate = pre;
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    _dataArray = [[NSMutableArray alloc] initWithArray: [appDelegate.context executeFetchRequest:request error:nil]];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"dateInterval" ascending:YES];
    [_dataArray sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    self.manager.calenderScrollView.dataArray = [_dataArray mutableCopy];
}


- (IBAction)addClicked:(id)sender {
    [self.view addSubview:self.addMemoView];
    self.addMemoView.transform = CGAffineTransformMakeScale(0.001, 0.001);
    [UIView animateWithDuration:0.5 animations:^{
        self.addMemoView.transform = CGAffineTransformMakeScale(1, 1);
    }];
}

- (AddMemoView *)addMemoView {
    if (!_addMemoView) {
        _addMemoView = [AddMemoView nibInitializtion];
        _addMemoView.frame = CGRectMake(10, 40 + NAVBAR_HEIGHT, kScreenWidth - 20, kScreenHeight - NAVBAR_HEIGHT - 40 - 10 - DD_SafeAreaBottom);
        dd_weakify(self);
        _addMemoView.closeBlock = ^{
            [weakSelf removeMemoView];
        };
        _addMemoView.saveBlock = ^(NSString *date) {
            weakSelf.title = [NSString shortDateStringFromDate:[NSDate dateFromStr:date]];
            [weakSelf.manager goToDate:[NSDate dateFromStr:date]];
            [weakSelf loadData];
            [weakSelf removeMemoView];
        };
    }
    return _addMemoView;
}

- (void)removeMemoView {
    [UIView animateWithDuration:0.5 animations:^{
        self.addMemoView.transform = CGAffineTransformMakeScale(0.001, 0.001);
    } completion:^(BOOL finished) {
        [self.addMemoView removeFromSuperview];
        _addMemoView = nil;
    }];
}

@end
