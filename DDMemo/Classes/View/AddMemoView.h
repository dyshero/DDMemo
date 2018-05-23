//
//  AddMemoView.h
//  DDMemo
//
//  Created by duodian on 2018/5/19.
//  Copyright © 2018年 丁远帅. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^AddMemoCloseBlock)(void);
typedef void(^SaveMemoBlock)(NSString *date);

@interface AddMemoView : UIView
@property (nonatomic,strong) AddMemoCloseBlock closeBlock;
@property (nonatomic,strong) SaveMemoBlock saveBlock;
@end
