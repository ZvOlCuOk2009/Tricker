//
//  TSSettingsTableViewController.m
//  Tricker
//
//  Created by Mac on 15.11.16.
//  Copyright © 2016 Mac. All rights reserved.
//

#import "TSSettingsTableViewController.h"
#import "TSSocialNetworkLoginViewController.h"
#import "TSFacebookManager.h"
#import "TSTrickerPrefixHeader.pch"

@import Firebase;
@import FirebaseAuth;
@import FirebaseDatabase;

@interface TSSettingsTableViewController ()

@end

@implementation TSSettingsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureController];
}


#pragma mark - configure the controller


- (void)configureController
{
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background"]];
    self.tableView.backgroundView = imageView;
    
}


#pragma mark - UITableViewDelegate


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 11)
    {
        return kHeightCellButtonSaveAndOut;
    }
    
    return kHeightCell;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}


#pragma mark - Action log out


- (IBAction)logOutAtionButton:(id)sender
{
    
    NSError *error;
    [[FIRAuth auth] signOut:&error];
    if (!error) {
        NSLog(@"Log out");
    }
    
    [[TSFacebookManager sharedManager] logOutUser];
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"token"];
    
    TSSocialNetworkLoginViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"TSSocialNetworkLoginViewController"];
    [self presentViewController:controller animated:YES completion:nil];
    
}

@end
