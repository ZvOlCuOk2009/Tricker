//
//  TSSwipeView.m
//  Tricker
//
//  Created by Mac on 24.11.16.
//  Copyright © 2016 Mac. All rights reserved.
//

#import "TSSwipeView.h"
#import "TSCardsViewController.h"
#import "TSViewCell.h"
#import "TSPhotoView.h"
#import "TSTrickerPrefixHeader.pch"

@interface TSSwipeView () <UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate>

@property (strong, nonatomic) NSArray *dataSource;
@property (strong, nonatomic) NSArray *allKeys;

@property (strong, nonatomic) NSMutableArray *updateDataSource;
@property (strong, nonatomic) NSMutableArray *getParameters;

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIVisualEffectView *backgroundTableView;

@property (strong, nonatomic) UITapGestureRecognizer *tapGesture;
@property (strong, nonatomic) TSPhotoView *photoView;

@property (assign, nonatomic) NSInteger counter;

@end

@implementation TSSwipeView

- (void)drawRect:(CGRect)rect {
    
    //[self awakeFromNib];
    
    self.dataSource = @[@"Ищу", @"Возраст", @"С целью", @"Рост", @"Вес", @"Фигура", @"Глаза", @"Волосы", @"Отношения", @"Дети", @"Доход", @"Образование", @"Жильё", @"Автомобиль", @"Курение", @"Алкоголь"];
    self.counter = 0;
    
    self.updateDataSource = [NSMutableArray array];
    self.getParameters = [NSMutableArray array];
    
    self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                              action:@selector(handleSingleTap:)];
    self.tapGesture.delegate = self;
    self.tapGesture.enabled = NO;
    [self addGestureRecognizer:self.tapGesture];
    
    [self.tableView setShowsVerticalScrollIndicator:NO];
    
    self.allKeys = [self.parameterUser allKeys];
    
    //наполнение массивов заголовками и данными
    
    [self.updateDataSource addObject:@"Анкета"];
    
    for (int i = 0; i < [self.parameterUser count]; i++) {
        
        NSString *key = [self.allKeys objectAtIndex:i];
        NSString *parameter = [self.parameterUser objectForKey:key];
        
        if ([parameter isEqualToString:@"man"]) {
            parameter = @"Парня";
        } else if ([parameter isEqualToString:@"woman"]) {
            parameter = @"Девушку";
        } else if ([parameter isEqualToString:@"man woman"]) {
            parameter = @"Парня и девушку";
        }
        
        [self.getParameters addObject:parameter];
        
        NSString *shortKey = [key substringFromIndex:3];
        NSInteger index = [shortKey integerValue];
        [self.updateDataSource addObject:[self.dataSource objectAtIndex:index - 1]];
    }
    
    [self setup];
}


- (void)setup {
   
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOpacity = 0.33;
    self.layer.shadowOffset = CGSizeMake(0, 1.5);
    self.layer.shadowRadius = 7.0;
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


- (IBAction)likeActionButton:(id)sender
{
    self.photoView = [[[NSBundle mainBundle] loadNibNamed:@"TSPhotoView" owner:self options:nil] firstObject];
    
    [self addSubview:self.photoView];
    [self.photoView setFrame:CGRectMake(0.0f, self.photoView.frame.size.height,
                                   self.photoView.frame.size.width, self.photoView.frame.size.height)];
    [UIView beginAnimations:@"animateView" context:nil];
    [UIView setAnimationDuration:0.3];
    [self.photoView setFrame:CGRectMake(0.0f, 0.0f, self.photoView.frame.size.width, self.photoView.frame.size.height)];
    [UIView commitAnimations];

}


- (IBAction)chatActionButton:(id)sender
{
    
}


- (void)cancelPhotoView
{
    
}


//разворот карточки на 180 градусов

- (IBAction)parametersActionButton:(id)sender
{
    
    self.backgroundTableView.hidden = NO;
    self.tableView.hidden = NO;
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationTransition: UIViewAnimationTransitionFlipFromRight forView:self cache:YES];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.5];
    [UIView commitAnimations];
    
    [self.tableView reloadData];
    
    self.tapGesture.enabled = YES;
    
}


//возвращение карточки в исходное положение

- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer
{
    
    self.backgroundTableView.hidden = YES;
    self.tableView.hidden = YES;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationTransition: UIViewAnimationTransitionFlipFromLeft forView:self cache:YES];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.5];
    [UIView commitAnimations];
    
    self.tapGesture.enabled = NO;
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.getParameters count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *identifier = @"cell";
    
    TSViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TSViewCell" owner:self options:nil] firstObject];
    }
    
    cell.titleLabel.text = [NSString stringWithFormat:@"%@", [self.updateDataSource objectAtIndex:indexPath.row]];
    
    if (indexPath.row == 0) {
        cell.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:20.f];
        cell.parameterLabel.text = @"";
    } else {
        
        NSInteger index = indexPath.row;
        cell.parameterLabel.text = [NSString stringWithFormat:@"%@", [self.getParameters objectAtIndex:index - 1]];
    }
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        
        [self addSubview:self.photoView];
    }
}


@end
