//
//  FAAppDelegate.m
//  FantasyAngel
//
//  Created by Yusuf Sobh on 1/15/13.
//  Copyright (c) 2013 ProductX. All rights reserved.
//

#import "FAAppDelegate.h"

#import "FAViewController.h"
#import "FAStartup.h"
#import "FAStartupListViewController.h"
#import "FALoginViewController.h"

#define TESTFLIGHT_TEAM_TOKEN @"d0efc0e53acc88ebd2cc5e8e39df7b13_MTc1NjU3MjAxMy0wMS0xNSAxNjozODoyMS4wNzY0Mzg"

@implementation FAAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [TestFlight takeOff:TESTFLIGHT_TEAM_TOKEN];
    
    [self setupRestkit];
    
    FAStartupListViewController *startupListController = [[FAStartupListViewController alloc] init];
    FALoginViewController *loginController = [[FALoginViewController alloc] init];
    
    [[UINavigationBar appearance] setTintColor:[UIColor blackColor]];
    
    UINavigationController *controller = [[UINavigationController alloc] initWithRootViewController:loginController];
    self.window = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    self.window.rootViewController = loginController;
    [self.window makeKeyAndVisible];

    return YES;
}

- (void) setupRestkit
{
    RKLogConfigureByName("RestKit/Network*", RKLogLevelTrace);
    RKLogConfigureByName("RestKit/ObjectMapping", RKLogLevelTrace);
    
    //let AFNetworking manage the activity indicator
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    
    // Initialize HTTPClient
    NSURL *baseURL = [NSURL URLWithString:@"https://api.angel.co/1/"];
    AFHTTPClient* client = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
    //we want to work with JSON-Data
    [client setDefaultHeader:@"Accept" value:RKMIMETypeJSON];
    
    // Initialize RestKit
    RKObjectManager *objectManager = [[RKObjectManager alloc] initWithHTTPClient:client];
    
    // Setup our object mappings
    /*RKObjectMapping *userMapping = [RKObjectMapping mappingForClass:[RKTUser class]];
    [userMapping addAttributeMappingsFromDictionary:@{
     @"id" : @"userID",
     @"screen_name" : @"screenName",
     @"name" : @"name"
     }];*/
    
    RKObjectMapping *startupMapping = [RKObjectMapping mappingForClass:[FAStartup class]];
    [startupMapping addAttributeMappingsFromDictionary:@{
     @"id" : @"id",
     @"name" : @"name",
     @"high_concept" : @"high_concept",
     @"product_desc" : @"product_desc",
     @"logo_url" : @"logo_url",
     @"thumb_url" : @"thumb_url",
     }];
    /*RKRelationshipMapping* relationShipMapping = [RKRelationshipMapping relationshipMappingFromKeyPath:@"user"
                                                                                             toKeyPath:@"user"
                                                                                           withMapping:userMapping];
    [statusMapping addPropertyMapping:relationShipMapping];*/
    
    // Update date format so that we can parse Twitter dates properly
    // Wed Sep 29 15:31:08 +0000 2010
    [RKObjectMapping addDefaultDateFormatterForString:@"E MMM d HH:mm:ss Z y" inTimeZone:nil];
    
    // Register our mappings with the provider using a response descriptor
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:startupMapping
                                                                                       pathPattern:@"tags/1/startups"
                                                                                           keyPath:@"startups"
                                                                                       statusCodes:[NSIndexSet indexSetWithIndex:200]];
    [objectManager addResponseDescriptor:responseDescriptor];
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
