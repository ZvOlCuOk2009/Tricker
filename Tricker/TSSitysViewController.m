//
//  TSSitysViewController.m
//  Tricker
//
//  Created by Mac on 10.11.16.
//  Copyright © 2016 Mac. All rights reserved.
//

#import "TSSitysViewController.h"
#import "TSTrickerPrefixHeader.pch"

#import <CoreLocation/CoreLocation.h>

#define YANDEX_MAPS_API_DOMAIN @"http://geocode-maps.yandex.ru/1.x/"

@interface TSSitysViewController () <CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;

@end

@implementation TSSitysViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationController.navigationBar.topItem.title = @"";
    
//    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:[UIImage imageNamed:@"back"]
//                                                      forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];

    UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, self.navigationController.navigationBar.frame.size.width, 21.0)];
    textField.backgroundColor = [UIColor whiteColor];
    self.navigationItem.titleView = textField;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}


@end
