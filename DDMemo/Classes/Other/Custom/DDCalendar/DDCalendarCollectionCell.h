//
//  DDCalendarCollectionCell.h
//  DDMemo
//
//  Created by duodian on 2018/5/18.
//  Copyright © 2018年 丁远帅. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDCalendarDayItem.h"

@interface DDCalendarCollectionCell : UICollectionViewCell
@property (nonatomic,strong) DDCalendarDayItem *item;
@property (nonatomic,assign) BOOL isSelected;
@end
