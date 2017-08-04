//
//  AppDelegate.m
//  CheckAppNewVersion
//
//  Created by zhenzhaoyang on 2017/8/1.
//  Copyright © 2017年 zhenchy. All rights reserved.
//

#import "AppDelegate.h"
#import "ZZYAppVersionManager.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //如果app还未上架appStore，appstoreId可以不传。默认用bundleId获取app的信息
    [ZZYAppVersionManager sharedInstance].appstoreId = @"989673964";  //王者荣耀的id
    [ZZYAppVersionManager sharedInstance].appstoreCountry = @"cn";   //中国appstore(由于王者荣耀美国us的appstore没有，此处暂传cn)
    [ZZYAppVersionManager sharedInstance].minimalInterval = 10;  //提醒的最小间隔（秒）
    //实际上，上架到appstore的包完全无需设置appstoreId和appstoreCountry，直接用默认值即可
    
    
//    [ZZYAppVersionManager sharedInstance].versionHandle = ^(NSString *releaseNote) {
//        //TODO:: 实现自定义弹窗的方法（推荐用默认的弹窗即可）
//        NSLog(@"release note is %@",releaseNote);
//    };
    
    [[ZZYAppVersionManager sharedInstance] start];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
