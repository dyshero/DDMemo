//
//  UIBarButtonItem+Extension.h
//  DDMemo
//
//  Created by duodian on 2018/5/21.
//  Copyright © 2018年 丁远帅. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Extension)
+ (instancetype)itemWithFrame:(CGRect)frame norImage:(NSString *)image title:(NSString *)title target:(id)target action:(SEL)action;
@end
