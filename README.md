# AppVersionManage
[![Build Status](https://travis-ci.org/zzyhappyzzy/AppVersionManage.svg?branch=master)](https://travis-ci.org/zzyhappyzzy/AppVersionManage)

Check iOS app newest version according to appstore automatically. It works on iOS 6.0+ and requires ARC to build.
# How to use
1. directly add the ZZYAppVersionManager.h and ZZYAppVersionManager.m source files to your project
2. in AppDelegate class 
```objc
#import "ZZYAppVersionManager.h"
```
3. in AppDelegate.m didFinishLaunchingWithOptions's method 
```objc
[[ZZYAppVersionManager sharedInstance] start];
```
# Addition
* you can implemetion `NewVersionHandle` block yourself with a custom alert view.
```objc
[ZZYAppVersionManager sharedInstance].versionHandle = ^(NSString *releaseNote) {
    //TODO:: 实现自定义弹窗的方法（推荐用默认的弹窗即可）
    NSLog(@"release note is %@",releaseNote);
};
[[ZZYAppVersionManager sharedInstance] start];
```
* set the minimal alert time interval
```objc
[ZZYAppVersionManager sharedInstance].minimalInterval = 24 * 3600;
```
# Note
Instead of running the project on simulator, you should run it on device.

