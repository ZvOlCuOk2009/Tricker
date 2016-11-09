//
//  TSProfileUserViewController.m
//  Tricker
//
//  Created by Mac on 05.11.16.
//  Copyright © 2016 Mac. All rights reserved.
//

#import "TSProfileUserViewController.h"
#import "TSSocialNetworkLoginViewController.h"
#import "TSFacebookManager.h"
#import "TSFireUser.h"
#import "TSTrickerPrefixHeader.pch"

#import <SVProgressHUD.h>

@import Firebase;
@import FirebaseAuth;
@import FirebaseDatabase;

@interface TSProfileUserViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *name;

@property (strong, nonatomic) FIRDatabaseReference *ref;
@property (strong, nonatomic) TSFireUser *fireUser;

@end

@implementation TSProfileUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.ref = [[FIRDatabase database] reference];
    [self configureController];
}


#pragma mark - configure controller


- (void)configureController
{
    
    [self.ref observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        
        [SVProgressHUD show];
        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleCustom];
        [SVProgressHUD setBackgroundColor:YELLOW_COLOR];
        [SVProgressHUD setForegroundColor:DARK_GRAY_COLOR];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            self.fireUser = [TSFireUser initWithSnapshot:snapshot];
            
            NSURL *urlPhoto = [NSURL URLWithString:self.fireUser.photoURL];
            
            UIImage *imagePhoto = [UIImage imageWithData:[NSData dataWithContentsOfURL:urlPhoto]];
            
            
            if (urlPhoto && urlPhoto.scheme && urlPhoto.host) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    self.avatarImageView.image = imagePhoto;
                    self.backgroundImageView.image = imagePhoto;
                    self.name.text = self.fireUser.displayName;
                    
                    [SVProgressHUD dismiss];
                });
                
            } else {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    NSData *data = [[NSData alloc]initWithBase64EncodedString:self.fireUser.photoURL options:NSDataBase64DecodingIgnoreUnknownCharacters];
                    UIImage *convertImage = [UIImage imageWithData:data];
                    self.avatarImageView.image = convertImage;
                    self.backgroundImageView.image = convertImage;
                    self.name.text = self.fireUser.displayName;
                    
                    [SVProgressHUD dismiss];
                });
                
            }
            
        });
        
    }];
    
}



- (BOOL)verificationURL:(NSString *)url
{
    BOOL verification;
    NSArray *component = [url componentsSeparatedByString:@"."];
    NSString *firstComponent = [component firstObject];
    
    if ([firstComponent isEqualToString:@"https://scontent"]) {
        verification = YES;
    } else {
        verification = NO;
    }
    return verification;
}


#pragma mark - Actions


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
