//
//  TSFireUser.m
//  Tricker
//
//  Created by Mac on 06.11.16.
//  Copyright © 2016 Mac. All rights reserved.
//

#import "TSFireUser.h"

@implementation TSFireUser


+ (TSFireUser *)initWithSnapshot:(FIRDataSnapshot *)snapshot
{

    TSFireUser *user = [[TSFireUser alloc] init];

    NSString *token = [[NSUserDefaults standardUserDefaults] valueForKey:@"token"];
    FIRUser *fireUser = [FIRAuth auth].currentUser;
    
    if(token)
    {
        
        NSString *key = [NSString stringWithFormat:@"dataBase/users/%@/userData", fireUser.uid];
        
        FIRDataSnapshot *fireUser = [snapshot childSnapshotForPath:key];
        
        FIRDataSnapshot *userIdent = fireUser.value[@"userID"];
        FIRDataSnapshot *userName = fireUser.value[@"displayName"];
        FIRDataSnapshot *userEmail = fireUser.value[@"email"];
        FIRDataSnapshot *userPhoto = fireUser.value[@"photoURL"];
        
        
        user.uid = (NSString *)userIdent;
        user.displayName = (NSString *)userName;
        user.email = (NSString *)userEmail;
        user.photoURL = (NSString *)userPhoto;
    }
    
    return user;
}

@end
