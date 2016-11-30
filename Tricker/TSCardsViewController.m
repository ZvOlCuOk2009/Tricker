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

@property (assign, nonatomic) NSInteger counter;

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
    
    self.counter = 0;
    
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
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.counter inSection:0];
    
    if (self.selectedUsers.count > 0) {
        
        NSInteger indexPathRow = indexPath.row;
        NSDictionary *selectedUser = [self.selectedUsers objectAtIndex:indexPathRow];
        
        self.swipeView = [TSSwipeView initProfileView];
        
        NSInteger max = [self.selectedUsers count];
        
        NSDictionary *selectedUserData = [selectedUser objectForKey:@"userData"];
        NSDictionary *parametersUser = [selectedUser objectForKey:@"parameters"];
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
        
        self.swipeView.avatarImageView.layer.cornerRadius = 110;
        
        UIColor *invertColor = [self invertColor:[self averageColor]];
        self.swipeView.nameLabel.textColor = invertColor;
        self.swipeView.ageLabel .textColor = invertColor;
        
        self.swipeView.parameterUser = parametersUser;
        
        self.counter++;
        
        if (self.counter == max) {
            
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
            
            self.counter = 0;
        }
        
    } else {
        //alert!!!
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


#pragma mark - inversion color


- (UIColor *)averageColor {
    
    UIImage *image = self.swipeView.backgroundImageView.image;
    struct CGImage *convertImage = image.CGImage;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char rgba[4];
    CGContextRef context = CGBitmapContextCreate(rgba, 1, 1, 8, 4, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    
    CGContextDrawImage(context, CGRectMake(0, 0, 1, 1), convertImage);
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    
    if(rgba[3] > 0)
    {
        CGFloat alpha = ((CGFloat)rgba[3])/255.0;
        CGFloat multiplier = alpha/255.0;
        return [UIColor colorWithRed:((CGFloat)rgba[0])*multiplier
                               green:((CGFloat)rgba[1])*multiplier
                                blue:((CGFloat)rgba[2])*multiplier
                               alpha:alpha];
    } else {
        return [UIColor colorWithRed:((CGFloat)rgba[0])/255.0
                               green:((CGFloat)rgba[1])/255.0
                                blue:((CGFloat)rgba[2])/255.0
                               alpha:((CGFloat)rgba[3])/255.0];
    }
}


- (UIColor *)invertColor:(UIColor *)color
{
    CGFloat red, green, blue, alpha;
    [color getRed:&red green:&green blue:&blue alpha:&alpha];
    
    CGFloat newRed = (1.0f - red);
    CGFloat newGreen = (1.0f - green);
    CGFloat newBlue = (1.0f - blue);
    
    return [UIColor colorWithRed:newRed green:newGreen blue:newBlue alpha:alpha];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
