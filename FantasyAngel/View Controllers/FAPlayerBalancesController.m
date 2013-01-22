//
//  FAPlayerBalancesController.m
//  FantasyAngel
//
//  Created by Yusuf Sobh on 1/21/13.
//  Copyright (c) 2013 ProductX. All rights reserved.
//

#import "FAPlayerBalancesController.h"
#import "FAInvestmentListViewController.h"
#import "FAPlayerBalanceCell.h"
#import "FAAppDelegate.h"

@interface FAPlayerBalancesController ()

@end

@implementation FAPlayerBalancesController

@synthesize playerList = _playerList;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadplayerList
{
    
    
    // Load the object model via RestKit
    RKObjectManager *objectManager = ((FAAppDelegate*)[[UIApplication sharedApplication]delegate]).railsObjectManager;
    [objectManager getObjectsAtPath:@"/users"
                         parameters:nil
                            success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                NSArray* investments = [mappingResult array];
                                NSLog(@"Loaded users: %@", investments);
                                self.playerList = investments;
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
    
    self.tableView.rowHeight = 70.0f;
    
    [self loadplayerList];
}

#pragma mark UITableViewDelegate methods


#pragma mark - UITableViewDelegate
/*
 - (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
 
 return [FAStartupCell heightForCellWithPost:[self.startupList objectAtIndex:indexPath.row]];
 }
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark UITableViewDataSource methods

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{
    return [self.playerList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Startup Cell";
    
    FAPlayerBalanceCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[FAPlayerBalanceCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    cell.user = [self.playerList objectAtIndex:indexPath.row];
    
    return cell;
}

@end
