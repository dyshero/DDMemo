//
//  NSDate+Extension.h
//  DDMemo
//
//  Created by duodian on 2018/5/22.
//  Copyright © 2018年 丁远帅. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Extension)
+ (NSDate *)dateFromStr:(NSString *)str;
+ (NSDate *)totalDateFromStr:(NSString *)str;
@end
