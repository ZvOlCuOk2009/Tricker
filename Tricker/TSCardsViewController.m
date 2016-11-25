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

//@import Firebase;
//@import FirebaseAuth;
//@import FirebaseDatabase;

@interface TSCardsViewController () <ZLSwipeableViewDataSource, ZLSwipeableViewDelegate>

//@property (strong, nonatomic) FIRDatabaseReference *ref;
//@property (strong, nonatomic) TSFireUser *fireUser;
@property (strong, nonatomic) ZLSwipeableView *swipeableView;
@property (weak, nonatomic) TSSwipeView *swipeView;

@property (assign, nonatomic) NSInteger counter;

@end

@implementation TSCardsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    
//    self.ref = [[FIRDatabase database] reference];
//    [self.ref observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
//        
//        self.fireUser = [TSFireUser initWithSnapshot:snapshot];
//        self.fireBase = [TSFireBase initWithSnapshot:snapshot];
    
        [self configureController];
//    }];
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
    
}


#pragma mark - ZLSwipeableViewDataSource


- (UIView *)nextViewForSwipeableView:(ZLSwipeableView *)swipeableView
{
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.counter inSection:0];
    
    if (self.selectedUsers.count > 0) {
        
        NSDictionary *selectedUser = [self.selectedUsers objectAtIndex:indexPath.row];
        
        self.swipeView = [TSSwipeView profileView];
        
        NSInteger max = [self.selectedUsers count];
        NSString *photoURL = [selectedUser objectForKey:@"photoURL"];
        
        self.swipeView.nameLabel.text = [selectedUser objectForKey:@"displayName"];
        self.swipeView.ageLabel.text = [selectedUser objectForKey:@"age"];
        
        
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
        
        
        ++self.counter;
        
        if (self.counter == max) {
            self.counter = 0;
        }
    } else {
        //alert!!!
    }
    
    return self.swipeView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
