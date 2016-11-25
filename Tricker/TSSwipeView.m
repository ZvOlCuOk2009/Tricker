//
//  TSSwipeView.m
//  Tricker
//
//  Created by Mac on 24.11.16.
//  Copyright © 2016 Mac. All rights reserved.
//

#import "TSSwipeView.h"

@implementation TSSwipeView


- (void)drawRect:(CGRect)rect {
    // Drawing code
}


+ (instancetype)profileView
{
    
    TSSwipeView *view = nil;
    
    UINib *nib = [UINib nibWithNibName:@"TSSwipeView" bundle:nil];
    view = [nib instantiateWithOwner:self options:nil][0];
    view.frame = CGRectMake(20, 20, 280, 396);
    
    return view;
    
}


@end
