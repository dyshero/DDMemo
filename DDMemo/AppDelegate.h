//
//  AppDelegate.h
//  DDMemo
//
//  Created by duodian on 2018/5/17.
//  Copyright © 2018年 丁远帅. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

//@property (readonly, strong) NSPersistentContainer *persistentContainer;

//- (void)saveContext;

@property (nonatomic,strong) NSManagedObjectContext *context;

@end

