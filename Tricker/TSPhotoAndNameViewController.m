//
//  TSPhotoAndNameViewController.m
//  Tricker
//
//  Created by Mac on 08.11.16.
//  Copyright © 2016 Mac. All rights reserved.
//

#import "TSPhotoAndNameViewController.h"
#import "TSRegistrationViewController.h"
#import "TSTabBarViewController.h"
#import "TSTrickerPrefixHeader.pch"

@import Firebase;
@import FirebaseAuth;
@import FirebaseDatabase;

@interface TSPhotoAndNameViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UIButton *cameraButton;
@property (weak, nonatomic) IBOutlet UIImage *image;

@property (strong, nonatomic) FIRDatabaseReference *ref;
@property (strong, nonatomic) IBOutlet UIImagePickerController *picker;

@end

@implementation TSPhotoAndNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.ref = [[FIRDatabase database] reference];
    [self configureController];
}


#pragma mark - configure controller


- (void)configureController
{
    self.title = @"Регистрация";
    
    self.ref = [[FIRDatabase database] reference];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] init];
    [leftItem setImage:[UIImage imageNamed:@"back"]];
    [leftItem setTintColor:DARK_GRAY_COLOR];
    self.navigationItem.leftBarButtonItem = leftItem;
    [leftItem setTarget:self];
    [leftItem setAction:@selector(cancelInteraction)];
    
    self.cameraButton.layer.cornerRadius = 65;
    self.cameraButton.clipsToBounds = YES;
    
}


- (void)cancelInteraction
{
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0]
                                          animated:YES];
}


#pragma mark - Actions


- (IBAction)tapSelectCameraButton:(id)sender
{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Выберите фото"
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *camera = [UIAlertAction actionWithTitle:@"Камера"
                                                     style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * _Nonnull action) {
                                                       [self makePhoto];
                                                   }];
    
    UIAlertAction *galery = [UIAlertAction actionWithTitle:@"Галерея"
                                                     style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * _Nonnull action) {
                                                       [self selectPhoto];
                                                   }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Отменить"
                                                     style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * _Nonnull action) {

                                                   }];
    
    UIView *subview = alertController.view.subviews.firstObject;
    UIView *alertContentView = subview.subviews.firstObject;
    alertContentView.backgroundColor = YELLOW_COLOR;
    alertContentView.layer.cornerRadius = 10;
    alertController.view.tintColor = DARK_GRAY_COLOR;

    
    NSMutableAttributedString *hogan = [[NSMutableAttributedString alloc] initWithString:@"Выберите фото"];
    [hogan addAttribute:NSFontAttributeName
                  value:[UIFont systemFontOfSize:20.0]
                  range:NSMakeRange(0, 13)];
    [alertController setValue:hogan forKey:@"attributedTitle"];
    
    [alertController addAction:camera];
    [alertController addAction:galery];
    [alertController addAction:cancel];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}


- (void)makePhoto {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.navigationBar.barStyle = UIBarStyleBlack;
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:picker animated:YES completion:NULL];
    
}


- (void)selectPhoto {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.navigationBar.barStyle = UIBarStyleBlack;
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
    
    
}


- (void)imagePickerController:(UIImagePickerController *) Picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    [Picker dismissViewControllerAnimated:YES completion:nil];
    self.image = [info objectForKey:UIImagePickerControllerEditedImage];
    [self.cameraButton setImage:self.image forState:UIControlStateNormal];
    
}


- (IBAction)saveUserButton:(id)sender
{
    
    if (![self.nameTextField.text isEqualToString:@""]) {
        
        CGSize newSize = CGSizeMake(300, 300);
        
        UIGraphicsBeginImageContext(newSize);
        [self.image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        
        NSData *dataImage = UIImagePNGRepresentation(newImage);
        NSString *stringImage = [dataImage base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
        
        
        NSString *email = self.email;
        NSString *password = self.password;
        NSString *displayName = self.nameTextField.text;
        
        [[FIRAuth auth] createUserWithEmail:email
                                   password:password
                                 completion:^(FIRUser * _Nullable user, NSError * _Nullable error) {
                                     if (!error) {
                                         
                                         if (user.uid) {
                                             
                                             NSString *dateOfBirth = @"";
                                             NSString *location = @"";
                                             NSString *gender = @"";
                                             NSString *age = @"";
                                             NSString *online = @"";
                                             
                                             NSDictionary *userData = @{@"userID":user.uid,
                                                                        @"displayName":displayName,
                                                                        @"email":email,
                                                                        @"photoURL":stringImage,
                                                                        @"dateOfBirth":dateOfBirth,
                                                                        @"location":location,
                                                                        @"gender":gender,
                                                                        @"age":age,
                                                                        @"online":online};
                                             
                                             NSString *token = user.uid;
                                             
                                             [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"token"];
                                             [[NSUserDefaults standardUserDefaults] synchronize];
                                             
                                             [[[[[self.ref child:@"dataBase"] child:@"users"] child:user.uid] child:@"userData"] setValue:userData];
                                             
                                         }
                                         
                                         TSTabBarViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"TSTabBarViewController"];
                                         [self presentViewController:controller animated:YES completion:nil];
                                         
                                     } else {
                                         NSLog(@"Error - %@", error.localizedDescription);
                                         
//                                         [self alertControllerEmail];
                                     }
                                 }];
        
    } else {
        
//        [self alertControllerTextFieldNil];
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}


@end
