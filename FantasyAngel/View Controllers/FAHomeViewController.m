//
//  FAHomeViewController.m
//  FantasyAngel
//
//  Created by Yusuf Sobh on 1/18/13.
//  Copyright (c) 2013 ProductX. All rights reserved.
//

#import "FAHomeViewController.h"
#import "FAStartupListViewController.h"
#import "FAInvestmentListViewController.h"
#import "FAPlayerBalancesController.h"

@implementation FAHomeViewController

- (id)init
{
    self = [super init];
    if (self) {
        
        FAStartupListViewController *startupListController = [[FAStartupListViewController alloc] init];
        FAInvestmentListViewController *investListController = [[FAInvestmentListViewController alloc] init];
        FAPlayerBalancesController *balancesController = [[FAPlayerBalancesController alloc] init];
        
        startupListController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Startups" image:[UIImage imageNamed:@"deals_icon.png"] tag:0];
        
        balancesController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Players" image:[UIImage imageNamed:@"share_icon.png"] tag:1];
        
        investListController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Investments" image:[UIImage imageNamed:@"my_purchases_icon.png"] tag:2];
        
        
        NSArray* controllers = [NSArray arrayWithObjects:startupListController, balancesController, investListController, nil];
        
        self.viewControllers = controllers;
        
        //HomeViewController will handle tab changes
        self.delegate = self;
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

#pragma mark - TabBarDelegate methods
/*- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    [((A50WebViewController *)viewController) reload];
}*/

@end
