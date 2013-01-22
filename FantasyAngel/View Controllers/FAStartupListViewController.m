//
//  FAStartupListViewController.m
//  FantasyAngel
//
//  Created by Yusuf Sobh on 1/18/13.
//  Copyright (c) 2013 ProductX. All rights reserved.
//

#import "FAStartupListViewController.h"
#import "FAStartupDetailController.h"
#import "FAStartupCell.h"
#import "FALoginViewController.h"

@interface FAStartupListViewController ()

@end

@implementation FAStartupListViewController

@synthesize startupList = _startupList;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadStartupList
{
    // Load the object model via RestKit
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    [objectManager getObjectsAtPath:@"tags/1/startups?order=popularity&page=1&per_page=10"
                         parameters:nil
                            success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                NSArray* startups = [mappingResult array];
                                NSLog(@"Loaded startups: %@", startups);
                                self.startupList = startups;
                                if(self.isViewLoaded)
                                    [self.tableView reloadData];
                            }
                            failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                                message:[error localizedDescription]
                                                                               delegate:nil
                                                                      cancelButtonTitle:@"OK"
                                                                      otherButtonTitles:nil];
                                [alert show];
                                NSLog(@"Hit error: %@", error);
                            }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if([[NSUserDefaults standardUserDefaults] stringForKey:@"token"] == nil)
    {
        FALoginViewController *loginController = [[FALoginViewController alloc] init];
        [self presentViewController:loginController animated:NO completion:nil];
    }
    
    /*
    // Setup View and Table View
    self.title = @"Startups";
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleBlackTranslucent;
    //self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(loadTimeline)];
    */
    self.tableView.rowHeight = 70.0f;
    
    [self loadStartupList];
}

#pragma mark UITableViewDelegate methods


#pragma mark - UITableViewDelegate
/*
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return [FAStartupCell heightForCellWithPost:[self.startupList objectAtIndex:indexPath.row]];
}
*/
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //[tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    FAStartupDetailController *startupDetailController =[[FAStartupDetailController alloc] initWithStartup:[self.startupList objectAtIndex:indexPath.row]];
        
    UINavigationController *startupController = [[UINavigationController alloc] initWithRootViewController:startupDetailController];
        
    [self presentViewController:startupController animated:YES completion: nil];
    
}

#pragma mark UITableViewDataSource methods

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{
    return [self.startupList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Startup Cell";
    
    FAStartupCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[FAStartupCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    cell.startup = [self.startupList objectAtIndex:indexPath.row];
    
    return cell;
}

@end
