//
//  AppDelegate.m
//  aires
//
//  Created by Gautham on 04/04/13.
//  Copyright (c) 2013 Imaginea. All rights reserved.
//

#import "AppDelegate.h"
#import "AiresSingleton.h"
#import "LoginViewController.h"

#define mSingleton 	((AiresSingleton *) [AiresSingleton getSingletonInstance])

#pragma mark -
@interface AppDelegate (private)

-(void)loadLoginView;

@end

#pragma mark -
@implementation AppDelegate
@synthesize navigationController;

#pragma mark -
#pragma mark AppDelegate Callbacks

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[mSingleton getWebServiceManager] getEnvironment];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    [self loadLoginView];
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

#pragma mark -
#pragma mark Private Methods
-(void)loadLoginView
{
    self.mLoginViewController= [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    if ([mSingleton isValidAccessToken])
    {
        //Show loading and take to dashboard
        self.mLoginViewController.isLoggingIn = TRUE;
    }
    else
    {
        self.mLoginViewController.isLoggingIn = FALSE;
        //Reset CoreData
        [[mSingleton getPersistentStoreManager] resetCoreData];
    }
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:self.mLoginViewController];
	[navController.navigationBar setBarStyle:UIBarStyleBlack];
	self.navigationController = navController;
    [self.navigationController setNavigationBarHidden:TRUE];
    self.window.rootViewController = self.navigationController;
    self.window.backgroundColor = [UIColor blackColor];
    [self.window makeKeyAndVisible];
}


@end

