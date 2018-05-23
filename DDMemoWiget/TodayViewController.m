//
//  TodayViewController.m
//  DDMemoWiget
//
//  Created by duodian on 2018/5/21.
//  Copyright © 2018年 丁远帅. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>
#import "Memo+CoreDataProperties.h"

#define kWidgetWidth ([UIScreen mainScreen].bounds.size.width - 16)
#define isIOS10 [[UIDevice currentDevice].systemVersion doubleValue] >= 10.0


@interface TodayViewController () <NCWidgetProviding>
@property (nonatomic,strong) UILabel *noDataLabel;
@property (nonatomic,weak) Memo *memo;
@end

@implementation TodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.preferredContentSize = CGSizeMake(kWidgetWidth, 110);
    
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"DDMemo" withExtension:@"momd"];
    NSManagedObjectModel *model = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    
    NSPersistentStoreCoordinator *store = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    
    NSString *containerPath = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"group.ddmemo"].path;
    NSString *sqlitePath = [NSString stringWithFormat:@"%@/%@", containerPath, @"coreData.sqlite"];
    NSURL *sqlUrl = [NSURL fileURLWithPath:sqlitePath];
    
    NSError *error = nil;
    [store addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:sqlUrl options:nil error:&error];
    
    NSManagedObjectContext *context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    context.persistentStoreCoordinator = store;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Memo"];
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"dateInterval >= %lf", [NSDate date].timeIntervalSince1970];
    request.predicate = pre;
    NSArray *resArray = [context executeFetchRequest:request error:nil];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"dateInterval" ascending:YES];
    NSArray *tempArray = [resArray sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    
    if (resArray.count == 0 || resArray == nil) {
        _noDataLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, kWidgetWidth, 20)];
        _noDataLabel.textAlignment = NSTextAlignmentCenter;
        _noDataLabel.text = @"暂无待办事项";
        _noDataLabel.font = [UIFont boldSystemFontOfSize:17];
        [self.view addSubview:_noDataLabel];
        [self addbtn];
        return;
    }

    Memo *memo = [tempArray firstObject];
    _memo = memo;
    UILabel *nextLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, kWidgetWidth, 25)];
    nextLabel.text = @"下一个待办事项";
    nextLabel.font = [UIFont systemFontOfSize:20];
    [self.view addSubview:nextLabel];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(nextLabel.frame) + 5, 5, 50)];
    lineView.backgroundColor = [UIColor colorWithRed:222/255.0 green:210/255.0 blue:154/255.0 alpha:1];
    [self.view addSubview:lineView];
    
    UILabel *titLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(lineView.frame) + 5, 5 + CGRectGetMaxY(nextLabel.frame), kWidgetWidth - (CGRectGetMaxX(lineView.frame) + 5 + 5), 25)];
    titLabel.font = [UIFont boldSystemFontOfSize:17];
    titLabel.text = memo.title;
    [self.view addSubview:titLabel];
    
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(lineView.frame) + 5, 5 + CGRectGetMaxY(titLabel.frame), kWidgetWidth - (CGRectGetMaxX(lineView.frame) + 5 + 5), 25)];
    timeLabel.font = [UIFont systemFontOfSize:13];
    timeLabel.text = [NSString stringWithFormat:@"%@ %@",memo.date,memo.time];
    [self.view addSubview:timeLabel];
    [self addbtn];
    
    if (_memo.content.length != 0) {
        UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 110, kWidgetWidth - 20, [self heightWithFont:[UIFont systemFontOfSize:17] withinWidth:kWidgetWidth - 20 str:memo.content])];
        contentLabel.text = memo.content;
        contentLabel.numberOfLines = 0;
        [self.view addSubview:contentLabel];
        
        if (isIOS10)
        {
            self.extensionContext.widgetLargestAvailableDisplayMode = NCWidgetDisplayModeExpanded;
        }
    }
}

- (void)addbtn {
    UIButton *btn = [[UIButton alloc] initWithFrame:self.view.bounds];
    [btn addTarget:self action:@selector(btnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)btnClicked {
    [self.extensionContext openURL:[NSURL URLWithString:@"ddmemoWidget://"]
                 completionHandler:^(BOOL success) {
                     NSLog(@"open url result:%d",success);
    }];
}

- (float)heightWithFont:(UIFont *)font withinWidth: (float) width str:(NSString *)str{
    CGRect textRect = [str boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                         options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                      attributes:@{NSFontAttributeName:font}
                                         context:nil];
    return ceil(textRect.size.height);
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    completionHandler(NCUpdateResultNewData);
}

- (void)widgetActiveDisplayModeDidChange:(NCWidgetDisplayMode)activeDisplayMode withMaximumSize:(CGSize)maxSize
{
    if (activeDisplayMode == NCWidgetDisplayModeCompact)
    {  
        self.preferredContentSize = CGSizeMake(maxSize.width, 110);
    } else {
        self.preferredContentSize = CGSizeMake(maxSize.width,[self heightWithFont:[UIFont systemFontOfSize:13] withinWidth:kWidgetWidth - 20 str:_memo.content] + 110 + 40);
    }
}

- (UIEdgeInsets)widgetMarginInsetsForProposedMarginInsets:(UIEdgeInsets)defaultMarginInsets
{
    return UIEdgeInsetsMake(0, 10, 0, 10);
}

@end
