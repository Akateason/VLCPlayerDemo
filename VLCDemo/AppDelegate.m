//
//  AppDelegate.m
//  VLCDemo
//
//  Created by teason23 on 2018/2/26.
//  Copyright © 2018年 teason23. All rights reserved.
//

#import "AppDelegate.h"
#import <XTlib.h>
#import "FileModel.h"
#import "XTColor+MyColors.h"
#import "XTVLC.h"


@interface AppDelegate ()

@end


@implementation AppDelegate

- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    if (self.orientationsOnlyRotate) {
        return UIInterfaceOrientationMaskPortrait;
    }
    else if (self.orientationsOnlyLandScape) {
        return UIInterfaceOrientationMaskLandscape;
    }

    return UIInterfaceOrientationMaskAllButUpsideDown;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // setup db
    [XTFMDBBase sharedInstance].isDebugMode = YES;
    [[XTFMDBBase sharedInstance] configureDB:@"xtcPlayer"];

    [[XTFMDBBase sharedInstance] dbUpgradeTable:FileModel.class
                                      paramsAdd:@[ @"msPlayTime" ]
                                        version:2];


    // setup
    [XTColor configCustomPlistName:@"kobeColor"];

    // nav
    UINavigationBar *navBar = [UINavigationBar appearance];
    UIImage *img            = [UIImage imageWithColor:[XTColor text1]
                                      size:CGSizeMake(320.0, 64.0)];
    [navBar setBackgroundImage:img forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [XTColor whiteColor]}];
    [navBar setTintColor:[XTColor whiteColor]];
    [navBar setTranslucent:NO];
    navBar.translucent = YES;

    UITabBar *tabbar = [UITabBar appearance];
    tabbar.tintColor = [XTColor text1];

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
