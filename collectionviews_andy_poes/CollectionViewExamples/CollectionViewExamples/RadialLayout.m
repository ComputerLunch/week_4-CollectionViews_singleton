//
//  RadialLayout.m
//  CollectionViewExamples
//
//  Created by Andrew Poes on 3/14/13.
//  Copyright (c) 2013 Neon. All rights reserved.
//

#import "RadialLayout.h"

#define ITEM_SIZE 70

@interface RadialLayout()

@property (nonatomic, assign) NSUInteger cellCount;
@property (nonatomic, assign) CGPoint center;
@property (nonatomic, assign) CGFloat radius;

@end

@implementation RadialLayout

- (CGSize)collectionViewContentSize
{
    return CGSizeMake(self.collectionView.frame.size.width, self.collectionView.frame.size.height * 3);
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}

-(void)prepareLayout
{
    [super prepareLayout];
    
    CGSize size = self.collectionView.frame.size;
    _cellCount = [[self collectionView] numberOfItemsInSection:0];
    _center = CGPointMake(size.width / 2.f, size.height / 2.f + self.collectionView.contentOffset.y);
    _radius = MIN(size.width, size.height) / 2.5;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat offset = self.collectionView.contentOffset.y / ([self collectionViewContentSize].height - self.collectionView.frame.size.height) * M_PI * 2.f;
    
    UICollectionViewLayoutAttributes* attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attributes.size = CGSizeMake(ITEM_SIZE, ITEM_SIZE);
    attributes.center = CGPointMake(_center.x + _radius * cosf(2 * indexPath.item * M_PI / _cellCount + offset),
                                    _center.y + _radius * sinf(2 * indexPath.item * M_PI / _cellCount + offset));
    return attributes;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *attributes = [NSMutableArray array];
    for (NSUInteger i = 0; i < [self.collectionView numberOfItemsInSection:0]; ++i)
    {
        [attributes addObject:[self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]]];
    }
    
    return attributes;
}

@end
