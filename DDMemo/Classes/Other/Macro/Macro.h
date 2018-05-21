//
//  Macro.h
//  DDMemo
//
//  Created by duodian on 2018/5/19.
//  Copyright © 2018年 丁远帅. All rights reserved.
//

#ifndef Macro_h
#define Macro_h

//主题色
#define ThemeColor [UIColor colorWithHexString:@"DED29A"]

//状态栏高度
#define STATUEBAR_HEIGHT [[UIApplication sharedApplication] statusBarFrame].size.height

//导航栏高度
#define NAVBAR_HEIGHT (STATUEBAR_HEIGHT + 44)

#define dd_weakify(var)   __weak typeof(var) weakSelf = var
#define dd_strongify(var) __strong typeof(var) strongSelf = var

#define DD_IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define DD_IS_IPHONE_X (DD_IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 812.0f)
#define DD_SafeAreaBottom (DD_IS_IPHONE_X ? 34 : 0)

#endif /* Macro_h */
