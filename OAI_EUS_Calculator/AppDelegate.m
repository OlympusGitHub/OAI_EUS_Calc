//
//  AppDelegate.m
//  OAI_EUS_Calculator
//
//  Created by Steve Suranie on 2/11/13.
//  Copyright (c) 2013 Olympus. All rights reserved.
//

#import "AppDelegate.h"

#import "ViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.viewController = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    
    //analytics
    fileManager = [[OAI_FileManager alloc] init];
    
    //get the name of the device owner
    ownerName = [[UIDevice currentDevice] name];
    
    //get the app name
    NSString* appName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
    
    //define a date variable
	NSDate* dateStarted;
    
	//initialise it:
	dateStarted = [[NSDate alloc] init];
    
    //set a date formatter
    NSDateFormatter* myDateManager = [[NSDateFormatter alloc] init];
    [myDateManager setDateFormat:@"MM/dd/yyyy HH:mm"];
        
    NSString* appLaunchedAt = [myDateManager stringFromDate:dateStarted];
    
    //check to see if the user has filled out account data
    NSString* strAccountFile = @"userAccount.plist";
    NSDictionary* accountData = [fileManager readPlist:strAccountFile];
    NSString* strUserName;
    NSString* strUserTitle;
    NSString* strUserEmail;
    NSString* strUserPhone;
    
    if(accountData) {
        
        strUserName = [accountData objectForKey:@"User Name"];
        strUserTitle = [accountData objectForKey:@"User Title"];
        strUserEmail = [accountData objectForKey:@"User Email"];
        strUserPhone = [accountData objectForKey:@"User Phone"];
    }
    
    NSLog(@"%@ launched the %@ at %@\n\nUser Name:%@\nUser Title:%@\nUser Email:%@\nUser Phone:%@", ownerName, appName, appLaunchedAt, strUserName, strUserTitle, strUserEmail, strUserPhone);
    
    
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
    
    //analytics
    
    //get the name of the device owner
    ownerName = [[UIDevice currentDevice] name];
    
    //get the app name
    NSString* appName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
    
    //define a date variable
	NSDate* dateStarted;
    
	//initialise it:
	dateStarted = [[NSDate alloc] init];
    
    //set a date formatter
    NSDateFormatter* myDateManager = [[NSDateFormatter alloc] init];
    [myDateManager setDateFormat:@"MM/dd/yyyy HH:mm"];
    
    NSString* appLaunchedAt = [myDateManager stringFromDate:dateStarted];
    
    NSLog(@"%@ closed the %@ at %@", ownerName, appName, appLaunchedAt);
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
   
}

@end
