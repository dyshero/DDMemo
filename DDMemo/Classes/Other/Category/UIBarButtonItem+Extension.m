//
//  UIBarButtonItem+Extension.m
//  DDMemo
//
//  Created by duodian on 2018/5/21.
//  Copyright © 2018年 丁远帅. All rights reserved.
//

#import "UIBarButtonItem+Extension.h"

@implementation UIBarButtonItem (Extension)
+ (instancetype)itemWithFrame:(CGRect)frame norImage:(NSString *)image title:(NSString *)title target:(id)target action:(SEL)action {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    if (image) {
        [btn setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    }
    [btn setTitle:title forState:UIControlStateNormal];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    return [[UIBarButtonItem alloc] initWithCustomView:btn];
}
@end
