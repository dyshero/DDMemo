//
//  BaseNavController.m
//  DDMemo
//
//  Created by duodian on 2018/5/17.
//  Copyright © 2018年 丁远帅. All rights reserved.
//

#import "BaseNavController.h"

@interface BaseNavController ()

@end

@implementation BaseNavController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.barTintColor = ThemeColor;
    self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
}
@end
