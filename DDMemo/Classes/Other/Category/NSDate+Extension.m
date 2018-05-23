//
//  NSDate+Extension.m
//  DDMemo
//
//  Created by duodian on 2018/5/22.
//  Copyright © 2018年 丁远帅. All rights reserved.
//

#import "NSDate+Extension.h"

@implementation NSDate (Extension)
+ (NSDate *)dateFromStr:(NSString *)str {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    return [formatter dateFromString:str];
}

+ (NSDate *)totalDateFromStr:(NSString *)str {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm";
    return [formatter dateFromString:str];
}
@end
