//
//  TSPhotoView.m
//  Tricker
//
//  Created by Mac on 01.12.16.
//  Copyright © 2016 Mac. All rights reserved.
//

#import "TSPhotoView.h"
#import "TSSwipeView.h"

@implementation TSPhotoView


- (void)drawRect:(CGRect)rect {

}


- (IBAction)cancelPhotoViewAction:(id)sender
{
//    [self addSubview:self.photoView];
    [self setFrame:CGRectMake(0.0f, 0.0f, self.frame.size.width, self.frame.size.height)];
    [UIView beginAnimations:@"animateView" context:nil];
    [UIView setAnimationDuration:0.3];
    [self setFrame:CGRectMake(0.0f, self.frame.size.height,
                              self.frame.size.width, self.frame.size.height)];
    [UIView commitAnimations];
}


@end
