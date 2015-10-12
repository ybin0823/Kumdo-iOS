//
//  AppDelegate.m
//  Kumdo
//
//  Created by Jang Young bin on 2015. 10. 1..
//  Copyright © 2015년 Jang Young bin. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //Network가 연결되어 있지 않으면 Alert 창을 띄운다
    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    //불필요한 Resource들을 해제해준다
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    //Network가 연결되어 있지 않으면 Alert 창을 띄운다
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
}

- (void)applicationWillTerminate:(UIApplication *)application
{
}

@end
