//
//  TSIntermediateViewController.m
//  Tricker
//
//  Created by Mac on 26.11.16.
//  Copyright © 2016 Mac. All rights reserved.
//

#import "TSIntermediateViewController.h"
#import "TSFireUser.h"
#import "TSFireBase.h"

@import Firebase;
@import FirebaseAuth;
@import FirebaseDatabase;

@interface TSIntermediateViewController ()

@property (strong, nonatomic) NSDictionary *fireBase;
@property (strong, nonatomic) NSMutableArray *usersFoundOnTheGender;
@property (strong, nonatomic) NSMutableArray *usersFoundOnTheAge;
@property (strong, nonatomic) NSMutableArray *usersFoundOnGenderAndAge;

@property (strong, nonatomic) FIRDatabaseReference *ref;
@property (strong, nonatomic) TSFireUser *fireUser;

@end

@implementation TSIntermediateViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self configureController];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}


#pragma mark - configure the controller


- (void)configureController
{

    NSString *genderSearch = [self.fireUser.parameters objectForKey:@"key1"];
    NSString *ageSearch = [self.fireUser.parameters objectForKey:@"key2"];
    
    NSArray *keysTaBase = [self.fireBase allKeys];
    
    self.usersFoundOnTheGender = [NSMutableArray array];
    self.usersFoundOnTheAge = [NSMutableArray array];
    self.usersFoundOnGenderAndAge = [NSMutableArray array];
    
    if (genderSearch) {
        
        [self userSelectionOfGender:keysTaBase];
    }
    
    if (ageSearch) {
        
        [self userSelectionOfAge:keysTaBase];
    }
    
    if (genderSearch && ageSearch) {
        
        for (NSDictionary *selectedUserTheGender in self.usersFoundOnTheGender) {
            NSDictionary *userData = [selectedUserTheGender objectForKey:@"userData"];
            NSString *age = [userData objectForKey:@"age"];
            NSString *name = [userData objectForKey:@"displayName"];
            if ([self computationSearchAge:ageSearch receivedAge:age]) {
                [self.usersFoundOnGenderAndAge addObject:selectedUserTheGender];
                NSLog(@"name gender and age %@", name);
            }
        }
    }
    
    NSLog(@"Gender and count %ld", (long)[self.usersFoundOnGenderAndAge count]);
}


- (void)userSelectionOfGender:(NSArray *)allKeysTaBase
{
    
    NSString *genderSearch = [self.fireUser.parameters objectForKey:@"key1"];
    
    for (NSString *key in allKeysTaBase) {
        NSDictionary *anyUser = [self.fireBase objectForKey:key];
        NSDictionary *userData = [anyUser objectForKey:@"userData"];
        NSString *genderAnyUser = [userData objectForKey:@"gender"];
        
        if ([genderAnyUser isEqualToString:genderSearch] && ![self.fireUser.uid isEqualToString:key]) {
            [self.usersFoundOnTheGender addObject:anyUser];
        }
    }
}


- (void)userSelectionOfAge:(NSArray *)allKeysTaBase
{
    
    NSString *ageSearch = [self.fireUser.parameters objectForKey:@"key2"];
    
    for (NSString *key in allKeysTaBase) {
        NSDictionary *anyUser = [self.fireBase objectForKey:key];
        NSDictionary *userData = [anyUser objectForKey:@"userData"];
        NSString *ageAnyUser = [userData objectForKey:@"age"];
        
        if ([self computationSearchAge:ageSearch receivedAge:ageAnyUser] && ![self.fireUser.uid isEqualToString:key]) {
            [self.usersFoundOnTheAge addObject:anyUser];
        }
    }
}


- (BOOL)computationSearchAge:(NSString *)specifiedRange receivedAge:(NSString *)receivedAge
{
    
    NSArray *rangeDigit = [specifiedRange componentsSeparatedByString:@" "];
    NSInteger specRangeOne = [[rangeDigit objectAtIndex:0] intValue];
    NSInteger specRangeTwo = [[rangeDigit objectAtIndex:1] intValue];
    NSInteger getAge = [receivedAge intValue];
    
    BOOL totalValue;
    
    if (getAge >= specRangeOne && getAge <= specRangeTwo) {
        totalValue = YES;
    } else {
        totalValue = NO;
    }
    
    return totalValue;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}


@end
