//
//  AddMemoView.m
//  DDMemo
//
//  Created by duodian on 2018/5/19.
//  Copyright © 2018年 丁远帅. All rights reserved.
//

#import "AddMemoView.h"

@implementation AddMemoView
- (void)awakeFromNib {
    [super awakeFromNib];
    [self setCornerRadius:15];
}

- (IBAction)closeClicked:(id)sender {
    if (self.closeBlock) {
        self.closeBlock();
    }
}

@end
