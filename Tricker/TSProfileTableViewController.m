//
//  TSProfileTableViewController.m
//  Tricker
//
//  Created by Mac on 09.11.16.
//  Copyright © 2016 Mac. All rights reserved.
//

#import "TSProfileTableViewController.h"
#import "TSSocialNetworkLoginViewController.h"
#import "TSFacebookManager.h"
#import "TSFireUser.h"
#import "TSTrickerPrefixHeader.pch"

#import <SVProgressHUD.h>

@import Firebase;
@import FirebaseAuth;
@import FirebaseDatabase;

@interface TSProfileTableViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *name;

@property (strong, nonatomic) FIRDatabaseReference *ref;
@property (strong, nonatomic) TSFireUser *fireUser;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *valueYAvatarConstraint;

@property (weak, nonatomic) IBOutlet UIButton *manButton;
@property (weak, nonatomic) IBOutlet UIButton *womanButton;

@property (strong, nonatomic) UIImage *pointImage;
@property (strong, nonatomic) UIImage *circleImage;

@property (assign, nonatomic) BOOL positionButtonGender;

@end

@implementation TSProfileTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.ref = [[FIRDatabase database] reference];
    [self configureController];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}


- (void)configureController
{
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background"]];
    self.tableView.backgroundView = imageView;
    
    self.avatarImageView.layer.cornerRadius = 110;
    self.avatarImageView.clipsToBounds = YES;
    
    [self.tableView setSeparatorColor:DARK_GRAY_COLOR];
    
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

    
    self.pointImage = [UIImage imageNamed:@"click"];
    self.circleImage = [UIImage imageNamed:@"no_click"];

}


#pragma mark - Actions


- (IBAction)actionUserBoyButton:(UIButton *)sender
{
    
    self.positionButtonGender = YES;
    
    if (self.positionButtonGender == NO) {
        [sender setImage:self.circleImage forState:UIControlStateNormal];
        [self.womanButton setImage:self.pointImage forState:UIControlStateNormal];
        self.positionButtonGender = YES;
    } else {
        [sender setImage:self.pointImage forState:UIControlStateNormal];
        [self.womanButton setImage:self.circleImage forState:UIControlStateNormal];
        self.positionButtonGender = NO;
    }
    
}


- (IBAction)actionUserGirlButton:(UIButton *)sender
{
    
    self.positionButtonGender = NO;
    
    if (self.positionButtonGender == YES) {
        [sender setImage:self.circleImage forState:UIControlStateNormal];
        [self.manButton setImage:self.pointImage forState:UIControlStateNormal];
        self.positionButtonGender = NO;
    } else {
        [sender setImage:self.pointImage forState:UIControlStateNormal];
        [self.manButton setImage:self.circleImage forState:UIControlStateNormal];
        self.positionButtonGender = YES;
    }
    
}


#pragma mark - UITableViewDataSourse



//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return 0;
//}
//
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return nil;
//}


#pragma mark - UITableViewDelegate


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 0)
    {
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        {
            if (IS_IPHONE_4) {
                self.valueYAvatarConstraint.constant = 50;
                return 321;
            } else if (IS_IPHONE_5) {
                self.valueYAvatarConstraint.constant = 50;
                return 321;
            } else if (IS_IPHONE_6) {
                self.valueYAvatarConstraint.constant = 77;
                return 376;
            } else if (IS_IPHONE_6_PLUS) {
                self.valueYAvatarConstraint.constant = 97;
                return 415;
            }
        }
    }
    
    if (indexPath.row == 7)
    {
        return 65;
    }
    
    return 44;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


#pragma mark - UITextFieldDelegate


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
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
