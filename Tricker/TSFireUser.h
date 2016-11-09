//
//  TSFireUser.h
//  Tricker
//
//  Created by Mac on 06.11.16.
//  Copyright © 2016 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@import FirebaseAuth;
@import FirebaseDatabase;

@interface TSFireUser : NSObject

@property (strong, nonatomic) NSString *displayName;
@property (strong, nonatomic) NSString *uid;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *photoURL;

+ (TSFireUser *)initWithSnapshot:(FIRDataSnapshot *)snapshot;

@end
