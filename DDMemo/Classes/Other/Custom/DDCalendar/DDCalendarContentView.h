//
//  DDCalendarContentView.h
//  DDMemo
//
//  Created by duodian on 2018/5/18.
//  Copyright © 2018年 丁远帅. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDCalendarAppearance.h"
#import "DDCalendarCollectionViewFlowLayout.h"
#import "DDCalendarEventSource.h"

@interface DDCalendarContentView : UIView
@property (nonatomic,strong) DDCalendarCollectionViewFlowLayout *flowLayout;

@property (nonatomic,strong) UICollectionView *collectionView;
//遮罩
@property (nonatomic,strong)UIView *maskView;
//事件代理
@property (weak, nonatomic) id<DDCalendarEventSource> eventSource;

@property (nonatomic,strong)NSDate *currentDate;
///滚动到单周需要的offset
@property (nonatomic,assign)CGFloat singleWeekOffsetY;
- (void)setSingleWeek:(BOOL)singleWeek;
///下一页
- (void)getDateDatas;
- (void)loadNextPage;
- (void)loadPreviousPage;
- (void)reloadAppearance;
///更新遮罩镂空的位置
- (void)setUpVisualRegion;
- (void)goBackToday;

- (void)reloadDefaultDate;
@end
