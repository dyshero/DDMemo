//
//  AppDelegate.m
//  DDMemo
//
//  Created by duodian on 2018/5/17.
//  Copyright © 2018年 丁远帅. All rights reserved.
//

#import "AppDelegate.h"
#import <SVProgressHUD/SVProgressHUD.h>

//NSError *err = nil;
//NSURL *containerURL = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"group.ddmemo"];
//containerURL = [containerURL URLByAppendingPathComponent:@"Library/Caches/ widget"];
////    [self dddd];

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window.backgroundColor = ThemeColor;
    [[UINavigationBar appearance]  setBackgroundImage:[[UIImage alloc] init] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
    [self registerPush:application];
    [SVProgressHUD setMaximumDismissTimeInterval:0.5];
    return YES;
}

- (void)registerPush:(UIApplication *)application {
    if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_7_1) {
        UIUserNotificationType types =
        UIUserNotificationTypeBadge|
        UIUserNotificationTypeSound|
        UIUserNotificationTypeAlert;
        UIUserNotificationSettings *mySettings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        [application registerUserNotificationSettings:mySettings];
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    if (application.applicationIconBadgeNumber != 0) {
        application.applicationIconBadgeNumber = 0;
    }
}

@end
