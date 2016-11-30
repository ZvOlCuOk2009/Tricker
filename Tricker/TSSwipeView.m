//
//  TSSwipeView.m
//  Tricker
//
//  Created by Mac on 24.11.16.
//  Copyright © 2016 Mac. All rights reserved.
//

#import "TSSwipeView.h"
#import "TSCardsViewController.h"
#import "TSTrickerPrefixHeader.pch"

@interface TSSwipeView () <UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate>

@property (strong, nonatomic) NSArray *dataSource;
@property (strong, nonatomic) NSArray *allKeys;

@property (strong, nonatomic) NSMutableArray *updateDataSource;
@property (strong, nonatomic) NSMutableArray *getParameters;

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIVisualEffectView *backgroundTableView;

@property (strong, nonatomic) IBOutlet UIView *photoView;

@property (strong, nonatomic) UITapGestureRecognizer *tapGesture;

@property (assign, nonatomic) NSInteger counter;

@end

@implementation TSSwipeView

- (void)drawRect:(CGRect)rect {
    
    //[self awakeFromNib];
    
    self.dataSource = @[@"Ищу", @"Возрастом", @"С целью", @"Рост", @"Вес", @"Фигура", @"Глаза", @"Волосы", @"Отношения", @"Дети", @"Доход", @"Образование", @"Жильё", @"Автомобиль", @"Курение", @"Алкоголь"];
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
    
    for (int i = 0; i < [self.parameterUser count]; i++) {
        
        NSString *key = [self.allKeys objectAtIndex:i];
        NSString *parameter = [self.parameterUser objectForKey:key];
        
        if ([parameter isEqualToString:@"man"]) {
            parameter = @"мужчину";
        } else if ([parameter isEqualToString:@"woman"]) {
            parameter = @"женщину";
        } else if ([parameter isEqualToString:@"man woman"]) {
            parameter = @"мужчину и женщину";
        }
        
        [self.getParameters addObject:parameter];
        
        NSString *shortKey = [key substringFromIndex:3];
        NSInteger index = [shortKey integerValue];
        [self.updateDataSource addObject:[self.dataSource objectAtIndex:index - 1]];
    }
    
}

- (NSString *)determineGender:(NSString *)getGenderParameter
{
    NSString *gender = nil;
    
    
    
    return gender;
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


- (IBAction)likeActionButton:(id)sender
{
    
}

//разворот карточки на 180 градусов

- (IBAction)parametersActionButton:(id)sender
{
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationTransition: UIViewAnimationTransitionFlipFromRight forView:self cache:YES];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.5];
    [UIView commitAnimations];
    
    self.backgroundTableView.hidden = NO;
    self.tableView.hidden = NO;
    
    [self.tableView reloadData];
    
    self.tapGesture.enabled = YES;
    
}


- (IBAction)chatActionButton:(id)sender
{
    
}


//возвращение карточки в исходное положение

- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationTransition: UIViewAnimationTransitionFlipFromLeft forView:self cache:YES];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.5];
    [UIView commitAnimations];
    
    self.backgroundTableView.hidden = YES;
    self.tableView.hidden = YES;
    
    self.tapGesture.enabled = NO;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.getParameters count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    UILabel *detailLabel = nil;
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        detailLabel = [[UILabel alloc] init];
        detailLabel.frame = CGRectMake(cell.bounds.size.width - 200.0, 0.0, 150.0, 38.0);
        [cell addSubview:detailLabel];
    }

    detailLabel.text = [NSString stringWithFormat:@"%@", [self.getParameters objectAtIndex:indexPath.row]];
    detailLabel.textColor = [UIColor darkGrayColor];
    detailLabel.font = [UIFont fontWithName:@"System Light" size:18.f];
    
    detailLabel.textAlignment = NSTextAlignmentRight;
    detailLabel.numberOfLines = 0;
    
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.textLabel.text = [NSString stringWithFormat:@"%@", [self.updateDataSource objectAtIndex:indexPath.row]];
    cell.textLabel.textColor = [UIColor darkGrayColor];
    cell.textLabel.font = [UIFont fontWithName:@"System-Light" size:18.f];
    
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
