//
//  AppDelegate.m
//  iMojiMaker
//
//  Created by Lucky on 4/5/18.
//  Copyright © 2018 Lucky. All rights reserved.
//

#import "Products.h"
#import "IAPManager.h"
#import "AppDelegate.h"
#import <AdMobServices/AdMobServices.h>

@interface AppDelegate ()

@end

@implementation AppDelegate

+ (UIViewController *)topViewController
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    UIViewController *mainViewController = appDelegate.window.rootViewController;
    
    if ([mainViewController presentedViewController])
    {
        return [mainViewController presentedViewController];
    }
    
    return mainViewController;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    
    [Products loadProducts];
    
    IAPManager *manager = [IAPManager sharedManager];
    [manager isReadyForPurchasing];
    
    [self configureApplicationSettings];
    [self configureAdMobWithLaunchOptions:launchOptions];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
}

- (void)applicationWillTerminate:(UIApplication *)application
{
}

- (void)configureApplicationSettings
{
    NSBundle *bundle = [NSBundle mainBundle];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSString *version = [bundle infoDictionary][@"CFBundleVersion"];
    [userDefaults setObject:version forKey:@"version_preference"];
}

- (void)configureAdMobWithLaunchOptions:(NSDictionary *)launchOptions
{
    [AdMobService setTestDevices:@[@"device_id"]];
    [AdMobService setInterstitialIdentifier:kAdMobInterstitialIdentifier];
    [AdMobService setInterstitialInterval:kAdMobInterstitialInterval];
    [AdMobService didFinishLaunchingWithOptions:launchOptions];
}

@end
