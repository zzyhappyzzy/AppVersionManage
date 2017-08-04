//
//  ZZYAppVersionManager.m
//  ZZYAppleLinkDemo
//
//  Created by zhenzhaoyang on 2017/8/1.
//  Copyright © 2017年 zhenchy. All rights reserved.
//

#import "ZZYAppVersionManager.h"
#import <UIKit/UIKit.h>

#define iOSVersion [[[UIDevice currentDevice] systemVersion] floatValue]

static NSString *const lastAlertTimeKey = @"zzyNewestVersionLastTime";

@interface ZZYAppVersionManager()<UIAlertViewDelegate>

@property (nonatomic, copy) NSString *appVersion;
@property (nonatomic, copy) NSString *bundleId;
@property (nonatomic, copy) NSString *appstoreUrl;

@end

@implementation ZZYAppVersionManager

+ (instancetype)sharedInstance {
    static ZZYAppVersionManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self basicInit];
    }
    return self;
}

- (void)basicInit {
    //default interval
#if DEBUG
    self.minimalInterval = 1;
#else
    self.minimalInterval = 24 * 3600;
#endif
    //country
    self.appstoreCountry = [(NSLocale *)[NSLocale currentLocale] objectForKey:NSLocaleCountryCode];
    if ([self.appstoreCountry isEqualToString:@"150"]) {
        self.appstoreCountry = @"eu";
    }
    else if ([[self.appstoreCountry stringByReplacingOccurrencesOfString:@"[A-Za-z]{2}" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, 2)] length]) {
        self.appstoreCountry = @"us";
    }
    else if ([self.appstoreCountry isEqualToString:@"GI"]) {
        self.appstoreCountry = @"GB";
    }
    
    if (!self.appstoreCountry) {
        self.appstoreCountry = @"us";
    }
    
    //version
    self.appVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    if ([self.appVersion length] == 0) {
        self.appVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:(__bridge NSString *)kCFBundleVersionKey];
    }
    
    //bundle id
    self.bundleId = [[NSBundle mainBundle] bundleIdentifier];
}

#pragma mark ---Methods---

- (void)start {
    [self registerNotifications];
}

- (void)checkVersionAccordingToAppstoreInfo {
    NSString *appUrl = nil;
    if (self.appstoreId) {
        appUrl = [NSString stringWithFormat:@"https://itunes.apple.com/%@/lookup?id=%@",self.appstoreCountry,self.appstoreId];
    }else {
        appUrl = [NSString stringWithFormat:@"https://itunes.apple.com/%@/lookup?bundleId=%@",self.appstoreCountry,self.bundleId];
    }
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:appUrl]];
    NSURLSessionDataTask *sessionTask = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * data, NSURLResponse * response, NSError *error) {
        if (error != nil) {
            NSLog(@"get appstore info failed %@",error.description);
            return;
        }
        NSInteger statusCode = ((NSHTTPURLResponse *)response).statusCode;
        if (data && statusCode == 200) {
            NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            if (responseDict) {
                int resultCount = [responseDict[@"resultCount"] intValue];
                if (resultCount == 1) {
                    NSDictionary *detailDic = responseDict[@"results"][0];
                    NSString *bundleId = detailDic[@"bundleId"];
                    NSString *version  = detailDic[@"version"];
                    NSString *releaseNote = detailDic[@"releaseNotes"];
                    NSString *trackUrl = detailDic[@"trackViewUrl"];
                    if (trackUrl.length) {
                        self.appstoreUrl = trackUrl;
                    }
                    [self checkWithVersion:version bundleId:bundleId note:releaseNote];
                }
            }
        }
    }];
    
    [sessionTask resume];
}

- (void)checkWithVersion:(NSString *)version bundleId:(NSString *)bundleId note:(NSString *)note {
    if (!bundleId || !version) return;
#if NDEBUG
    //方便测试，debug暂不校验bundleId
    if (![bundleId isEqualToString:self.bundleId]) return;
#endif
    if (![self checkMinimalInterval]) return;
    
    if ([self.appVersion compare:version options:NSNumericSearch] == NSOrderedAscending) {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            if (self.versionHandle != NULL) {
                //外部自定义处理
                self.versionHandle(note);
            }else {
                //默认
                [self showNewVersionAlert:note];
            }
        }];
    }
}

- (BOOL)checkMinimalInterval {
    BOOL showAlert = NO;
    NSNumber *last = [[NSUserDefaults standardUserDefaults] objectForKey:lastAlertTimeKey];
    if (!last) {
        showAlert = YES;
    }
    int nowInterval = [[NSDate date] timeIntervalSince1970];
    if (last && nowInterval - [last intValue] > self.minimalInterval) {
        showAlert = YES;
    }
    
    if (showAlert) {
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:nowInterval] forKey:lastAlertTimeKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    return showAlert;
}

- (void)showNewVersionAlert:(NSString *)detail {
    UIViewController *topController = [UIApplication sharedApplication].delegate.window.rootViewController;
    while (topController.presentedViewController) {
        topController = topController.presentedViewController;
    }
    if (!topController) return;
    NSString *title = @"有新的可用版本";
    if (iOSVersion >= 8.0) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:detail preferredStyle:UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"忽略" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }]];

        [alert addAction:[UIAlertAction actionWithTitle:@"去下载" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self openAppInAppstore];
        }]];
        
        [topController presentViewController:alert animated:YES completion:NULL];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                        message:detail
                                                       delegate:(id<UIAlertViewDelegate>)self
                                              cancelButtonTitle:nil
                                              otherButtonTitles:nil];

        [alert addButtonWithTitle:@"忽略"];
        [alert addButtonWithTitle:@"去下载"];
        
        [alert show];
    }
}

#pragma mark ---Notifications
- (void)registerNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidFinishLaunching:) name:UIApplicationDidFinishLaunchingNotification object:nil];
}

- (void)applicationWillEnterForeground:(NSNotification *)noti {
    [self checkVersionAccordingToAppstoreInfo];
}

- (void)applicationDidFinishLaunching:(NSNotification *)noti {
    [self checkVersionAccordingToAppstoreInfo];
}

#pragma mark ---Open url---
- (void)openAppInAppstore {
    if (!self.appstoreUrl && self.appstoreId) {
        self.appstoreUrl = [NSString stringWithFormat:@"https://itunes.apple.com/%@/app/id%@?mt=8",self.appstoreCountry,self.appstoreId];
    }
    if (!self.appstoreUrl) return;
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.appstoreUrl]];
}

- (void)openAppInAppstoreWithReviewPage {
    if (!self.appstoreId) return;
    NSString *url = [NSString stringWithFormat:@"https://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=%@&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8",self.appstoreId];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

#pragma mak ---Alertview delegate---
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [self openAppInAppstore];
    }
}

#pragma mark ---Memmory---
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
