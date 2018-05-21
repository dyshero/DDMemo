//
//  AddMemoView.h
//  DDMemo
//
//  Created by duodian on 2018/5/19.
//  Copyright © 2018年 丁远帅. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^AddMemoCloseBlock)();

@interface AddMemoView : UIView
@property (nonatomic,strong) AddMemoCloseBlock closeBlock;
@end
