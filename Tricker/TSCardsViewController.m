//
//  TSCardsViewController.m
//  Tricker
//
//  Created by Mac on 24.11.16.
//  Copyright © 2016 Mac. All rights reserved.
//

#import "TSCardsViewController.h"
#import "TSFireUser.h"

@import Firebase;
@import FirebaseAuth;
@import FirebaseDatabase;

@interface TSCardsViewController ()

@property (strong, nonatomic) FIRDatabaseReference *ref;
@property (strong, nonatomic) TSFireUser *fireUser;

@end

@implementation TSCardsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    
    self.ref = [[FIRDatabase database] reference];
    [self.ref observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        
        self.fireUser = [TSFireUser initWithSnapshot:snapshot];
        [self configureController];
    }];
}



#pragma mark - configure the controller


- (void)configureController
{
   
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
