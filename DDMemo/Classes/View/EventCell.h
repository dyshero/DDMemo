//
//  EventCell.h
//  DDMemo
//
//  Created by duodian on 2018/5/21.
//  Copyright © 2018年 丁远帅. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Memo+CoreDataProperties.h"

@interface EventCell : UITableViewCell
@property (nonatomic,weak) Memo *memo;
@end
