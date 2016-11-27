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
    
    //[self awakeFromNib];
}


- (void)setup {
   
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOpacity = 0.33;
    self.layer.shadowOffset = CGSizeMake(0, 1.5);
    self.layer.shadowRadius = 4.0;
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [UIScreen mainScreen].scale;
    
}


- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }    return self;
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}


+ (instancetype)initProfileView
{
    
    TSSwipeView *view = nil;
    
    UINib *nib = [UINib nibWithNibName:@"TSSwipeView" bundle:nil];
    view = [nib instantiateWithOwner:self options:nil][0];
    view.frame = CGRectMake(10, 30, 300, 396);
    
    return view;
    
}


@end
