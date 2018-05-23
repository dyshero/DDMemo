//
//  NSString+Extension.h
//  DDMemo
//
//  Created by duodian on 2018/5/22.
//  Copyright © 2018年 丁远帅. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extension)
+ (NSString *)timeStringFromDate:(NSDate *)date;
+ (NSString *)dateStringFromDate:(NSDate *)date;
+ (NSString *)totalDateStringFromDate:(NSDate *)date;
+ (NSString *)shortDateStringFromDate:(NSDate *)date;
@end
