//
//  BCAppDelegate.m
//  BCWeiboShareActivity
//
//  Created by caiwenbo on 07/18/2016.
//  Copyright (c) 2016 caiwenbo. All rights reserved.
//

#import "BCAppDelegate.h"
#import "BCWBSocialHandler.h"

@implementation BCAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(nullable NSDictionary *)launchOptions NS_AVAILABLE_IOS(3_0)
{
    return [[BCWBSocialHandler sharedInstance] setWBAppKey:@"appKey" redirectURI:@"redirectURI"];
}


- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [[BCWBSocialHandler sharedInstance] handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [[BCWBSocialHandler sharedInstance] handleOpenURL:url];
}

@end
