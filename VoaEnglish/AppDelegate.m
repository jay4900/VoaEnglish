//
//  AppDelegate.m
//  VoaEnglish
//
//  Created by Wufei on 14-4-18.
//  Copyright (c) 2014年 Lion. All rights reserved.
//

#import "AppDelegate.h"
#import "ChannelsViewController.h"
#import "FavoritesViewController.h"
#import "PlayerViewController.h"
#import "WordsViewController.h"
#import "SettingViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
//    StopwatchViewController *watchView = [[StopwatchViewController alloc] init];
//    MapViewController *mapView = [[MapViewController alloc] init];
//    CalendarViewController *calView = [[CalendarViewController alloc] init];
//    HistoryViewController *historyView = [[HistoryViewController alloc] init];
//    MoreViewController *moreView = [[MoreViewController alloc] init];
//    UITabBarController *tabBarController = [[UITabBarController alloc] init];
//    watchView.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"StopWatch" image:[UIImage imageNamed:@"tabStopwatch.png"] tag:0];
//    mapView.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Map" image:[UIImage imageNamed:@"tabMap.png"] tag:1];
//    calView.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Calendar" image:[UIImage imageNamed:@"tabCalendar.png"] tag:2];
//    historyView.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"History" image:[UIImage imageNamed:@"tabHistory.png"] tag:3];
//    moreView.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemMore tag:4];
//    tabBarController.viewControllers = [[NSArray alloc] initWithObjects:watchView,mapView,calView,historyView,moreView, nil];
//    self.window.rootViewController = tabBarController;
    ChannelsViewController *chView = [[ChannelsViewController alloc] initWithStyle:UITableViewStylePlain];
    UINavigationController *nvChView = [[UINavigationController alloc] initWithRootViewController:chView];
    FavoritesViewController *faView = [[FavoritesViewController alloc] initWithStyle:UITableViewStylePlain];
    UINavigationController *nvFaView = [[UINavigationController alloc] initWithRootViewController:faView];
    PlayerViewController *plView = [[PlayerViewController alloc] init];
    UINavigationController *nvPlView = [[UINavigationController alloc] initWithRootViewController:plView];
    WordsViewController *woView = [[WordsViewController alloc] initWithStyle:UITableViewStylePlain];
    UINavigationController *nvWoView = [[UINavigationController alloc] initWithRootViewController:woView];
    SettingViewController *seView = [[SettingViewController alloc] initWithStyle:UITableViewStylePlain];
    UINavigationController *nvSeView = [[UINavigationController alloc] initWithRootViewController:seView];
    
    chView.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Home" image:[UIImage imageNamed:@"tabHome.png"] tag:1];
    faView.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Favorites" image:[UIImage imageNamed:@"tabFavorite.png"] tag:2];
    plView.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Player" image:[UIImage imageNamed:@"tabPlayer.png"] tag:3];
    woView.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Words" image:[UIImage imageNamed:@"tabWord.png"] tag:4];
    seView.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Setting" image:[UIImage imageNamed:@"tabSetting.png"] tag:5];

    
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    tabBarController.viewControllers = @[nvChView,nvFaView,nvPlView,nvWoView,nvSeView];
//    tabBarController.viewControllers = @[chView,faView,woView,seView];
    self.window.rootViewController = tabBarController;
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
