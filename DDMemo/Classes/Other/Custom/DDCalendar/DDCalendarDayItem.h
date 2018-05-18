//
//  DDCalendarDayItem.h
//  DDMemo
//
//  Created by duodian on 2018/5/18.
//  Copyright © 2018年 丁远帅. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDCalendarDayItem : NSObject
@property (nonatomic,strong)NSDate *date;
@property (nonatomic,assign)BOOL isOtherMonth;
@property (nonatomic,assign)BOOL isSelected;
@property (nonatomic,strong)UIColor *eventDotColor;
@property (nonatomic,assign)BOOL showEventDot;
@end
