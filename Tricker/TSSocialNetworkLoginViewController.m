//
//  TSSocialNetworkLoginViewController.m
//  Tricker
//
//  Created by Mac on 05.11.16.
//  Copyright © 2016 Mac. All rights reserved.
//

#import "TSSocialNetworkLoginViewController.h"
#import "TSTabBarViewController.h"
#import "TSRegistrationViewController.h"
#import "TSFacebookManager.h"
#import "TSTrickerPrefixHeader.pch"

#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
//#import <VKSdkFramework/VKSdkFramework.h>
#import <VKSdk.h>
#import <CBZSplashView.h>
#import <GoogleSignIn/GoogleSignIn.h>

@import Firebase;
@import FirebaseAuth;
@import FirebaseDatabase;

@interface TSSocialNetworkLoginViewController () <FBSDKLoginButtonDelegate, VKSdkDelegate, VKSdkUIDelegate, GIDSignInUIDelegate>

@property (strong, nonatomic) IBOutlet FBSDKLoginButton *loginButton;
@property (weak, nonatomic) IBOutlet GIDSignInButton *signInButton;

@property (strong, nonatomic) FIRDatabaseReference *ref;

@property (strong, nonatomic) NSArray *scope;

@end

@implementation TSSocialNetworkLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];


    
    self.ref = [[FIRDatabase database] reference];
    [self configureController];
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}


- (void)configureController
{
    
    self.loginButton = [[FBSDKLoginButton alloc] init];
    self.loginButton.hidden = YES;
    [self.view addSubview:self.loginButton];
    self.loginButton.delegate = self;
    
    
    VKSdk *sdkInstance = [VKSdk initializeWithAppId:APP_ID_VK];
    
    [sdkInstance registerDelegate:self];
    [sdkInstance setUiDelegate:self];
    
    self.scope = @[@"friends", @"email"];
    
    [VKSdk wakeUpSession:self.scope completeBlock:^(VKAuthorizationState state, NSError *err) {
        if (state == VKAuthorizationAuthorized) {
            NSLog(@"state %lu", (unsigned long)state);
        } else {
            NSLog(@"err %@", err.localizedDescription);
        }
    }];
    
    
    [GIDSignIn sharedInstance].uiDelegate = self;
    [[GIDSignIn sharedInstance] signInSilently]; 
    
}


#pragma mark - Actions


- (IBAction)registrtionActionButton:(id)sender
{
    
}


- (IBAction)autorizationActionButton:(id)sender
{
    
}


#pragma mark - Facebook autorization


- (IBAction)facebookButtonTouchUpInside:(id)sender
{
    [self.loginButton sendActionsForControlEvents:UIControlEventTouchUpInside];
}


- (void)loginButton:(FBSDKLoginButton *)loginButton didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result
              error:(NSError *)error
{
    
    NSString *tokenFB = [[FBSDKAccessToken currentAccessToken] tokenString];
    
    NSLog(@"tokenFB %@", tokenFB);
    
    
    if (tokenFB) {
        
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me"
                                           parameters:nil]
         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
             if (!error)
             {
                 NSLog(@"resultis:%@", result);
             } else {
                 NSLog(@"Error %@", error);
             }
         }];
        
    } else {
        
        FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
        [login logInWithReadPermissions:@[@"public_profile"]
                     fromViewController:self
                                handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
                                    if (error) {
                                        NSLog(@"Process error");
                                    } else if (result.isCancelled) {
                                        NSLog(@"Cancelled");
                                    } else {
                                        NSLog(@"Logged in");
                                    }
                                }];
        
        
    }
    
    FIRAuthCredential *credential = [FIRFacebookAuthProvider
                                     credentialWithAccessToken:[FBSDKAccessToken currentAccessToken].tokenString];
    
    [[FIRAuth auth] signInWithCredential:credential
                              completion:^(FIRUser *user, NSError *error) {
                                  
                                  [self saveUserToFirebase:user];
                                  
                              }];
    
}


- (void)saveUserToFirebase:(FIRUser *)user
{
    
    __block NSString *stringPhoto = nil;
    __block NSDictionary *userData = nil;
    
    [[TSFacebookManager sharedManager] requestUserDataTheServerFacebook:^(NSDictionary *dictioaryValues) {
        
        stringPhoto = [[[dictioaryValues objectForKey:@"picture"] objectForKey:@"data"] objectForKey:@"url"];
        
        NSString *userID = user.uid;
        NSString *name = user.displayName;
        NSString *photoURL = stringPhoto;
        NSString *email = user.email;
        
        if (!email) {
            email = @"email";
        }
        
        userData = @{@"userID":userID,
                     @"displayName":name,
                     @"photoURL":photoURL,
                     @"email":email};
        
        [[[[[self.ref child:@"dataBase"] child:@"users"] child:user.uid] child:@"userData"] setValue:userData];
        
        
        TSTabBarViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"TSTabBarViewController"];
        [self presentViewController:controller animated:YES completion:nil];
        
    }];
    
    
    NSString *token = user.uid;
    
    [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"token"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}



- (void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton
{
    NSLog(@"User log Out");
}


#pragma mark - VK autorization


- (IBAction)vkButtonTouchUpInside:(id)sender
{
    [VKSdk authorize:self.scope];
}


- (void)vkSdkAccessAuthorizationFinishedWithResult:(VKAuthorizationResult *)result
{
    if (result.token) {
        // Пользователь успешно авторизован
        NSLog(@"result %lu", (unsigned long)result);
    } else if (result.error) {
        // Пользователь отменил авторизацию или произошла ошибка
        NSLog(@"result %lu", (unsigned long)result);
    }
}


- (void)vkSdkShouldPresentViewController:(UIViewController *)controller
{
    [self presentViewController:controller animated:YES completion:nil];
}


- (void)vkSdkUserAuthorizationFailed
{
    
}


- (void)vkSdkNeedCaptchaEnter:(VKError *)captchaError
{
    
}


#pragma mark - Autorization Google


- (IBAction)gPlusButtonTouchUpInside:(id)sender
{
    [[GIDSignIn sharedInstance] signIn];
}


- (void)signInWillDispatch:(GIDSignIn *)signIn error:(NSError *)error
{
    
}


- (void)signIn:(GIDSignIn *)signIn presentViewController:(UIViewController *)viewController
{
    [self presentViewController:viewController animated:YES completion:nil];
}


- (void)signIn:(GIDSignIn *)signIn dismissViewController:(UIViewController *)viewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)signIn:(GIDSignIn *)signIn didSignInForUser:(GIDGoogleUser *)user withError:(NSError *)error
{
    
}


@end
