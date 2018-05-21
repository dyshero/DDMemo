//
//  NSObject+Initializtion.m
//  DDMemo
//
//  Created by duodian on 2018/5/19.
//  Copyright © 2018年 丁远帅. All rights reserved.
//

#import "NSObject+Initializtion.h"

@implementation NSObject (Initializtion)
+ (id)classInitializtion{
    return [[self alloc] init];
}

+ (id)nibInitializtion{
    return [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([self class])
                                         owner:nil
                                       options:nil]
            firstObject];
}

+ (id)nibCtrInitialiation {
    
    return [[self alloc] initWithNibName:NSStringFromClass([self class]) bundle:[NSBundle mainBundle]];
}

@end
