//
//  DDCalendarScrollView.m
//  DDMemo
//
//  Created by duodian on 2018/5/18.
//  Copyright © 2018年 丁远帅. All rights reserved.
//

#import "DDCalendarScrollView.h"
#import "DDCalendarAppearance.h"
#import "EventCell.h"
#import "AppDelegate.h"

@interface DDCalendarScrollView()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UIView *line;
@property (nonatomic,strong)UIImageView *noDataView;
@end

@implementation DDCalendarScrollView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}

- (void)setBgColor:(UIColor *)bgColor{
    _bgColor = bgColor;
    self.backgroundColor = bgColor;
    self.tableView.backgroundColor = bgColor;
    self.line.backgroundColor = bgColor;
}

- (void)initUI{
    self.delegate = self;
    self.bounces = false;
    self.showsVerticalScrollIndicator = NO;
    self.backgroundColor = [DDCalendarAppearance share].scrollBgcolor;
    DDCalendarContentView *calendarView = [[DDCalendarContentView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, [DDCalendarAppearance share].weekDayHeight*[DDCalendarAppearance share].weeksToDisplay)];
    calendarView.currentDate = [NSDate date];
    [self addSubview:calendarView];
    self.calendarView = calendarView;
    self.line = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(calendarView.frame), CGRectGetWidth(self.frame),0.5)];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(calendarView.frame), CGRectGetWidth(self.frame) - 20, CGRectGetHeight(self.frame)-CGRectGetMaxY(calendarView.frame))];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"EventCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.contentInset = UIEdgeInsetsMake(10, 0, 0, 0);
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.scrollEnabled = [DDCalendarAppearance share].isShowSingleWeek;
    
    [self addSubview:self.tableView];
    self.line.backgroundColor = self.backgroundColor;
    [self addSubview:self.line];
    [DDCalendarAppearance share].isShowSingleWeek ? [self scrollToSingleWeek]:[self scrollToAllWeek];
}

- (void)setDataArray:(NSMutableArray *)dataArray {
    _dataArray = dataArray;
    if (_dataArray.count != 0) {
        if (_noDataView) {
            [_noDataView removeFromSuperview];
            _noDataView = nil;
        }
    } else {
        [self configNoDataView];
    }
    [self.tableView reloadData];
}

- (void)configNoDataView {
    if (!_noDataView) {
        _noDataView = [[UIImageView alloc] initWithFrame:CGRectMake((self.width - kScreenWidth*0.5)/2, 50, kScreenWidth*0.5, kScreenWidth*0.5*131/200)];
        _noDataView.image = [UIImage imageNamed:@"no_data"];
        [self.tableView addSubview:_noDataView];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    EventCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.memo = _dataArray[indexPath.row];
    return cell;
}

//先要设Cell可编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
//定义编辑样式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}
//修改编辑按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

//设置进入编辑状态时，Cell不会缩进
- (BOOL)tableView: (UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}
//点击删除
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    Memo *memo = _dataArray[indexPath.row];
    [self.dataArray removeObject:memo];
    if (self.dataArray.count == 0) {
        [self configNoDataView];
    }
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSFetchRequest *deleRequest = [NSFetchRequest fetchRequestWithEntityName:@"Memo"];
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"dateInterval = %lf", memo.dateInterval];
    deleRequest.predicate = pre;
    NSArray *deleArray = [appDelegate.context executeFetchRequest:deleRequest error:nil];
    
    for (Memo *memo in deleArray) {
        [appDelegate.context deleteObject:memo];
    }
    
    NSError *error = nil;
    if ([appDelegate.context save:&error]) {
        // 取消特定的通知
        NSArray *notificaitons = [[UIApplication sharedApplication] scheduledLocalNotifications];
        if (!notificaitons || notificaitons.count <= 0) {
            return;
        }
        
        for (UILocalNotification *notify in notificaitons) {
            if ([[notify.userInfo objectForKey:@"modelId"] isEqualToString:memo.memoId])
            {
                [[UIApplication sharedApplication] cancelLocalNotification:notify];
                break;
            }
        }
        
        if (self.delteMemoBlock) {
            self.delteMemoBlock(memo);
        }
    } else{
        NSLog(@"删除数据失败, %@", error);
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    Memo *memo = _dataArray[indexPath.row];
    CGFloat h = [memo.content heightForFont:[UIFont systemFontOfSize:12] width:kScreenWidth - 40];
    return 110 - 14.5 + h - (memo.content.length == 0?15:0);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offsetY = scrollView.contentOffset.y;
    if (scrollView != self) {
        return;
    }
    
    DDCalendarAppearance *appearce =  [DDCalendarAppearance share];
    ///表需要滑动的距离
    CGFloat tableCountDistance = appearce.weekDayHeight*(appearce.weeksToDisplay-1);
    ///日历需要滑动的距离
    CGFloat calendarCountDistance = self.calendarView.singleWeekOffsetY;
    
    CGFloat scale = calendarCountDistance/tableCountDistance;
    
    CGRect calendarFrame = self.calendarView.frame;
    self.calendarView.maskView.alpha = offsetY/tableCountDistance;
    calendarFrame.origin.y = offsetY-offsetY*scale;
    if(ABS(offsetY) >= tableCountDistance) {
        self.tableView.scrollEnabled = true;
    } else{
        self.tableView.scrollEnabled = false;
        if ([DDCalendarAppearance share].isShowSingleWeek) {
            [self.calendarView setSingleWeek:false];
        }
    }
    CGRect tableFrame = self.tableView.frame;
    tableFrame.size.height = CGRectGetHeight(self.frame)-CGRectGetHeight(self.calendarView.frame)+offsetY;
    self.tableView.frame = tableFrame;
    self.bounces = false;
    if (offsetY<=0) {
        self.bounces = true;
        calendarFrame.origin.y = offsetY;
        tableFrame.size.height = CGRectGetHeight(self.frame)-CGRectGetHeight(self.calendarView.frame);
        self.tableView.frame = tableFrame;
    }
    self.calendarView.frame = calendarFrame;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    DDCalendarAppearance *appearce =  [DDCalendarAppearance share];
    CGFloat tableCountDistance = appearce.weekDayHeight*(appearce.weeksToDisplay-1);
    if ( appearce.isShowSingleWeek) {
        if (self.contentOffset.y != tableCountDistance) {
            return  nil;
        }
    }
    if (!appearce.isShowSingleWeek) {
        if (self.contentOffset.y != 0 ) {
            return  nil;
        }
    }
    return  [super hitTest:point withEvent:event];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    if (self != scrollView) {
        return;
    }
    DDCalendarAppearance *appearce =  [DDCalendarAppearance share];
    CGFloat tableCountDistance = appearce.weekDayHeight*(appearce.weeksToDisplay-1);
    
    if (scrollView.contentOffset.y>=tableCountDistance) {
        [self.calendarView setSingleWeek:true];
    }
    
}


- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    if (self != scrollView) {
        return;
    }
    
    DDCalendarAppearance *appearce =  [DDCalendarAppearance share];
    ///表需要滑动的距离
    CGFloat tableCountDistance = appearce.weekDayHeight*(appearce.weeksToDisplay-1);
    //point.y<0向上
    CGPoint point =  [scrollView.panGestureRecognizer translationInView:scrollView];
    
    if (point.y<=0) {
        
        [self scrollToSingleWeek];
    }
    
    if (scrollView.contentOffset.y<tableCountDistance-20&&point.y>0) {
        [self scrollToAllWeek];
    }
}

//手指触摸完
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (self != scrollView) {
        return;
    }
    DDCalendarAppearance *appearce =  [DDCalendarAppearance share];
    ///表需要滑动的距离
    CGFloat tableCountDistance = appearce.weekDayHeight*(appearce.weeksToDisplay-1);
    //point.y<0向上
    CGPoint point =  [scrollView.panGestureRecognizer translationInView:scrollView];
    
    if (point.y<=0) {
        if (scrollView.contentOffset.y>=20) {
            if (scrollView.contentOffset.y>=tableCountDistance) {
                [self.calendarView setSingleWeek:true];
            }
            [self scrollToSingleWeek];
        } else{
            [self scrollToAllWeek];
        }
    } else{
        if (scrollView.contentOffset.y<tableCountDistance-20) {
            [self scrollToAllWeek];
        }else{
            [self scrollToSingleWeek];
        }
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (self != scrollView) {
        return;
    }
    [self.calendarView setUpVisualRegion];
}

- (void)scrollToSingleWeek{
    DDCalendarAppearance *appearce =  [DDCalendarAppearance share];
    CGFloat tableCountDistance = appearce.weekDayHeight*(appearce.weeksToDisplay-1);
    [self setContentOffset:CGPointMake(0, tableCountDistance) animated:true];
}

- (void)scrollToAllWeek{
    [self setContentOffset:CGPointMake(0, 0) animated:true];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.contentSize = CGSizeMake(0, CGRectGetHeight(self.frame)+[DDCalendarAppearance share].weekDayHeight*([DDCalendarAppearance share].weeksToDisplay-1));
}
@end
