//
//  TSTabBarViewController.m
//  Tricker
//
//  Created by Mac on 05.11.16.
//  Copyright © 2016 Mac. All rights reserved.
//

#import "TSTabBarViewController.h"
#import "TSTrickerPrefixHeader.pch"

@interface TSTabBarViewController ()

@end

@implementation TSTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.viewControllers enumerateObjectsUsingBlock:^(UIViewController *vc, NSUInteger idx, BOOL *stop) {
        vc.title = nil;
        
    }];

    
    UITabBarItem *tabBarItem1 = [self.tabBar.items objectAtIndex:0];
    UITabBarItem *tabBarItem2 = [self.tabBar.items objectAtIndex:1];
    UITabBarItem *tabBarItem3 = [self.tabBar.items objectAtIndex:2];
    UITabBarItem *tabBarItem4 = [self.tabBar.items objectAtIndex:3];
    UITabBarItem *tabBarItem5 = [self.tabBar.items objectAtIndex:4];
    
    
    tabBarItem1.selectedImage = [[UIImage imageNamed:@"user_click"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    tabBarItem1.image = [[UIImage imageNamed:@"user_no"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    tabBarItem2.selectedImage = [[UIImage imageNamed:@"map_click"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    tabBarItem2.image = [[UIImage imageNamed:@"map_no"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    tabBarItem3.selectedImage = [[UIImage imageNamed:@"cards_click"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    tabBarItem3.image = [[UIImage imageNamed:@"cards_no"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    tabBarItem4.selectedImage = [[UIImage imageNamed:@"chat_click"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    tabBarItem4.image = [[UIImage imageNamed:@"chat_no"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    tabBarItem5.selectedImage = [[UIImage imageNamed:@"settings_click"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    tabBarItem5.image = [[UIImage imageNamed:@"settings_no"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}



@end
