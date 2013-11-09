//
//  ShelfItem.m
//  CollectionViewRecords
//
//  Created by Andrew Poes on 3/15/13.
//  Copyright (c) 2013 Neon. All rights reserved.
//

#import "ShelfItem.h"

@implementation ShelfItem

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.label = [[UILabel alloc] initWithFrame:(CGRect) { CGPointZero, frame.size }];
        self.label.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:12.f];
        self.label.textColor = [UIColor whiteColor];
        self.label.shadowColor = [UIColor blackColor];
        self.label.shadowOffset = CGSizeMake(0.f, 2.f);
        self.label.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
        self.label.backgroundColor = [UIColor clearColor];
        self.label.numberOfLines = 0;
        self.label.textAlignment = NSTextAlignmentCenter;
        
        self.image = [[UIImageView alloc] initWithFrame:(CGRect) { CGPointZero, frame.size }];
        self.image.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
        self.image.contentMode = UIViewContentModeScaleAspectFit;
        
        [self addSubview:self.image];
        [self addSubview:self.label];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
