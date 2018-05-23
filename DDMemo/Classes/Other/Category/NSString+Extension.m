//
//  NSString+Extension.m
//  DDMemo
//
//  Created by duodian on 2018/5/22.
//  Copyright © 2018年 丁远帅. All rights reserved.
//

#import "NSString+Extension.h"

@implementation NSString (Extension)
+ (NSString *)timeStringFromDate:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"HH:mm";
    return [formatter stringFromDate:date];
}

+ (NSString *)dateStringFromDate:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    return [formatter stringFromDate:date];
}

+ (NSString *)totalDateStringFromDate:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    return [formatter stringFromDate:date];
}

+ (NSString *)shortDateStringFromDate:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"MM · yyyy";
    return [formatter stringFromDate:date];
}
@end
