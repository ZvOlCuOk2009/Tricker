//
//  TSPhotoView.h
//  Tricker
//
//  Created by Mac on 01.12.16.
//  Copyright © 2016 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TSPhotoView : UIView

@property (strong, nonatomic) NSMutableArray *photos;
@property (assign, nonatomic) BOOL isCellSelected;

- (IBAction)cancelPhotoViewAction:(id)sender;

@end
