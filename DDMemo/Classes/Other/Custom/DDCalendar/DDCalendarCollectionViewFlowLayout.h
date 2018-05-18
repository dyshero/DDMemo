//
//  DDCalendarCollectionViewFlowLayout.h
//  DDMemo
//
//  Created by duodian on 2018/5/18.
//  Copyright © 2018年 丁远帅. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDCalendarCollectionViewFlowLayout : UICollectionViewFlowLayout
@property (nonatomic,assign) NSUInteger itemCountPerRow;
// 一页显示多少行
@property (nonatomic,assign) NSUInteger rowCount;
@end
