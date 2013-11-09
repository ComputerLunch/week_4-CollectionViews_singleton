//
//  ConferenceHeader.m
//  IntroducingCollectionViews
//
//  Created by Mark Pospesel on 10/8/12.
//  Copyright (c) 2012 Mark Pospesel. All rights reserved.
//

#import "SectionHeader.h"
#import <QuartzCore/QuartzCore.h>
#import "MaskingTapeView.h"

#define MARGIN_HORIZONTAL_LARGE 20
#define MARGIN_HORIZONTAL_SMALL 10
#define MARGIN_VERTICAL_LARGE 5
#define MARGIN_VERTICAL_SMALL 3

@interface SectionHeader()

@property (strong, nonatomic) IBOutlet UILabel *headerTitle;
@property (nonatomic, assign, getter = isBackgroundSet) BOOL backgroundSet;
@property (nonatomic, assign, getter = isSmall) BOOL small;
@property (nonatomic, assign) BOOL centerText;
@property (nonatomic, strong) MaskingTapeView *backgroundView;

@end

@implementation SectionHeader

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.headerTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 6, frame.size.width, 13)];
        CGFloat fontSize = [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad ? 40 : 20;
        self.headerTitle.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:fontSize ];
        self.headerTitle.textColor = [UIColor blackColor];
        self.headerTitle.textAlignment = NSTextAlignmentCenter;
        [self setBackground];
        [self addSubview:self.headerTitle];
        _small = NO;
        _centerText = NO;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
        _small = NO;
        _centerText = NO;
    }
    return self;
}

- (void)setBackground
{
    if (self.isBackgroundSet)
        return;
    
    _backgroundView = [[MaskingTapeView alloc] initWithFrame:self.headerTitle.bounds];
    [self insertSubview:_backgroundView belowSubview:self.headerTitle];
    [self.headerTitle setBackgroundColor:[UIColor clearColor]];
    
    [self setBackgroundSet:YES];
}

- (CGFloat)horizontalMargin
{
    return self.isSmall? MARGIN_HORIZONTAL_SMALL : MARGIN_HORIZONTAL_LARGE;
}

- (CGFloat)verticalMargin
{
    return self.isSmall? MARGIN_VERTICAL_SMALL : MARGIN_VERTICAL_LARGE;
}

- (void)layoutSubviews
{
    [self.headerTitle sizeToFit];
    CGRect labelBounds = CGRectInset(self.headerTitle.bounds, -[self horizontalMargin], -[self verticalMargin]);
    
    if (self.centerText)
    {
        self.headerTitle.bounds = (CGRect){CGPointZero, labelBounds.size};
        self.headerTitle.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    }
    else
    {
        CGFloat leftMargin = [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad? 20 : 5;
        self.headerTitle.frame = (CGRect){{leftMargin, roundf((self.bounds.size.height - labelBounds.size.height)/2)}, labelBounds.size};
    }
    
    [self.backgroundView setFrame:self.headerTitle.frame];
}

#pragma mark - Properties

- (void)setCenterText:(BOOL)centerText
{
    _centerText = centerText;
    [self setNeedsLayout];
}

- (void)setTitle:(NSString *)title
{
    [self setBackground];
    self.headerTitle.text = title;
    [self layoutSubviews];        
}

@end
