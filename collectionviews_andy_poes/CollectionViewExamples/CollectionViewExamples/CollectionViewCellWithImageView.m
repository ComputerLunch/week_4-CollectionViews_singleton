//
//  CollectionViewCellWithImageView.m
//  CollectionViewExamples
//
//  Created by Andrew Poes on 3/3/13.
//  Copyright (c) 2013 Neon. All rights reserved.
//

#import "CollectionViewCellWithImageView.h"

@implementation CollectionViewCellWithImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _cellImage = [[UIImageView alloc] initWithFrame:(CGRect){ CGPointZero, frame.size }];
        _cellImage.contentMode = UIViewContentModeScaleAspectFill;
        _cellImage.autoresizingMask = (UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth);
        [self.contentView addSubview:_cellImage];
        
        self.clipsToBounds = YES;
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
