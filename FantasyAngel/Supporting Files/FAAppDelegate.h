//
//  FAAppDelegate.h
//  FantasyAngel
//
//  Created by Yusuf Sobh on 1/15/13.
//  Copyright (c) 2013 ProductX. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FAViewController;

@interface FAAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) FAViewController *viewController;

@property (nonatomic, strong) RKObjectManager *railsObjectManager;

@end
