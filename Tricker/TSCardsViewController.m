//
//  TSCardsViewController.m
//  Tricker
//
//  Created by Mac on 24.11.16.
//  Copyright © 2016 Mac. All rights reserved.
//

#import "TSCardsViewController.h"
#import "TSFireUser.h"
#import "TSFireBase.h"
#import "ZLSwipeableView.h"
#import "TSSwipeView.h"
#import "TSAlertViewCard.h"
#import "TSSettingsTableViewController.h"
#import "TSTrickerPrefixHeader.pch"

@interface TSCardsViewController () <ZLSwipeableViewDataSource, ZLSwipeableViewDelegate>

@property (strong, nonatomic) ZLSwipeableView *swipeableView;
@property (weak, nonatomic) TSSwipeView *swipeView;

@property (assign, nonatomic) NSInteger counterIndexPath;

@end

@implementation TSCardsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self configureController];
}


- (void)configureController
{
    
    CGRect frame = CGRectMake(0, - 20, self.view.bounds.size.width, self.view.bounds.size.height);
    
    self.swipeableView = [[ZLSwipeableView alloc] initWithFrame:self.view.frame];
    self.swipeableView.frame = frame;
    [self.view addSubview:self.swipeableView];
    
    self.swipeableView.dataSource = self;
    self.swipeableView.delegate = self;
    
    [self.swipeableView swipeTopViewToLeft];
    [self.swipeableView swipeTopViewToRight];
    
    [self.swipeableView discardAllViews];
    [self.swipeableView loadViewsIfNeeded];
    
    self.counterIndexPath = 0;
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[[[self.tabBarController tabBar] items] objectAtIndex:2] setEnabled:NO];
}


- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[[[self.tabBarController tabBar] items] objectAtIndex:2] setEnabled:YES];
    [self.tabBarItem setImage:[UIImage imageNamed:@"cards_click"]];
}


#pragma mark - ZLSwipeableViewDataSource


- (UIView *)nextViewForSwipeableView:(ZLSwipeableView *)swipeableView
{
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.counterIndexPath inSection:0];
    
    if (self.selectedUsers.count > 0) {
        
        NSInteger indexPathRow = indexPath.row;
        NSDictionary *selectedUser = [self.selectedUsers objectAtIndex:indexPathRow];
        
        self.swipeView = [TSSwipeView initProfileView];
        
        NSInteger max = [self.selectedUsers count];
        
        NSDictionary *selectedUserData = [selectedUser objectForKey:@"userData"];
        NSDictionary *parametersUser = [selectedUser objectForKey:@"parameters"];
        NSMutableArray *photosUser = [selectedUser objectForKey:@"photos"];
        NSString *photoURL = [selectedUserData objectForKey:@"photoURL"];
        NSString *displayName = [selectedUserData objectForKey:@"displayName"];
        NSString *age = [selectedUserData objectForKey:@"age"];
        NSString *online = [selectedUserData objectForKey:@"online"];
        
        self.swipeView.nameLabel.text = displayName;
        self.swipeView.ageLabel.text = age;
        
        
        if ([online isEqualToString:@"оффлайн"]) {
            self.swipeView.onlineView.backgroundColor = [UIColor redColor];
        } else if ([online isEqualToString:@"онлайн"]) {
            self.swipeView.onlineView.backgroundColor = [UIColor greenColor];
        }
            
        NSURL *url = [NSURL URLWithString:photoURL];
        
        if (url && url.scheme && url.host) {
            
            NSData *dataImage = [NSData dataWithContentsOfURL:url];
            self.swipeView.backgroundImageView.image = [UIImage imageWithData:dataImage];
            self.swipeView.avatarImageView.image = [UIImage imageWithData:dataImage];
            
        } else {
            
            if (!photoURL) {
                photoURL = @"";
            }
            
            NSData *data = [[NSData alloc]initWithBase64EncodedString:photoURL options:NSDataBase64DecodingIgnoreUnknownCharacters];
            UIImage *convertImage = [UIImage imageWithData:data];
            self.swipeView.backgroundImageView.image = convertImage;
            self.swipeView.avatarImageView.image = convertImage;
        }
        
        NSString *firstString = [photosUser firstObject];
        if ([firstString isEqualToString:@""]) {
            [photosUser removeObjectAtIndex:0];
        }
        
        self.swipeView.avatarImageView.layer.cornerRadius = 110;
        
        self.swipeView.parameterUser = parametersUser;
    
        self.swipeView.photos = photosUser;
        
        self.counterIndexPath++;
        
        if (self.counterIndexPath == max) {
            
//            [UIView animateWithDuration:0.35
//                                  delay:0.0
//                 usingSpringWithDamping:1.5
//                  initialSpringVelocity:0.9
//                                options:UIViewAnimationOptionAllowUserInteraction
//                             animations:^{
//                                 TSAlertViewCard *alertViewCard = [TSAlertViewCard initAlertViewCard];
//                                 alertViewCard.frame = CGRectOffset(alertViewCard.frame, 0, 150);
//                                 [self.view addSubview:alertViewCard];
//                             } completion:^(BOOL finished) {
//                                 
//                             }];
            
            self.counterIndexPath = 0;
        }
        
    } else {
        
        
    }
    
    return self.swipeView;
}


- (void)changeActionAlertView
{
    NSLog(@"changeActionAlertView");
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"SettingStoryboard" bundle:[NSBundle mainBundle]];
    TSSettingsTableViewController *controller =
    [storyboard instantiateViewControllerWithIdentifier:@"SettingStoryboard"];
    [self.navigationController pushViewController:controller animated:YES];
}


- (void)repeatActionAlertView
{
    NSLog(@"repeatActionAlertView");
}


- (void)rotationViewToClockwise
{

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
