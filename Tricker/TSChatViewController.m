//
//  TSChatViewController.m
//  Tricker
//
//  Created by Mac on 06.12.16.
//  Copyright © 2016 Mac. All rights reserved.
//

#import "TSChatViewController.h"
#import "TSFireUser.h"

@import Firebase;
@import FirebaseDatabase;

@interface TSChatViewController () 

@property (strong, nonatomic) FIRUser *user;
@property (strong, nonatomic) TSFireUser *fireUser;

@end

@implementation TSChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
