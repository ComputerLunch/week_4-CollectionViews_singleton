//
//  CoverFlowStyleLayout.m
//  CollectionViewExamples
//
//  Created by Andrew Poes on 3/3/13.
//  Copyright (c) 2013 Neon. All rights reserved.
//

#import "CoverFlowStyleLayout.h"

@interface CoverFlowStyleLayout()

@property (nonatomic, assign) CGSize cellSize;
@property (nonatomic, assign) CGFloat cellSpacing;
@property (nonatomic, assign) CGFloat centerOffset;

@end

static inline CGFloat lerp(CGFloat a, CGFloat b, CGFloat p)
{
    return a + (b - a) * p;
}

@implementation CoverFlowStyleLayout

- (id)init
{
    self = [super init];
    if (self)
    {
        
        self.cellSize = (CGSize){ 200.0f, 200.0f };
        self.cellSpacing = 40.0f;

    }
    return self;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)oldBounds
{
    return YES;
}

- (void)prepareLayout
{
    [super prepareLayout];
    
    self.centerOffset = (self.collectionView.bounds.size.width - self.cellSpacing) * 0.5f;
}

- (CGSize)collectionViewContentSize
{
    NSUInteger totalCells = [self.collectionView numberOfItemsInSection:0];
    
    const CGSize theSize = {
        .width = self.cellSpacing * totalCells + self.centerOffset * 2.0f,
        .height = self.collectionView.bounds.size.height,
    };
    
    return theSize;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSUInteger totalCells = [self.collectionView numberOfItemsInSection:0];
    
    NSMutableArray *layoutAttributes = [NSMutableArray array];
    
    NSUInteger start = MIN(MAX((NSInteger)floorf(CGRectGetMinX(rect) / self.cellSpacing) - 3, 0), totalCells);
    NSUInteger end = MIN(MAX((NSInteger)ceilf(CGRectGetMaxX(rect) / self.cellSpacing) + 3, 0), totalCells);
    
    for (NSUInteger i = start; i != end; ++i)
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:indexPath];
        [layoutAttributes addObject:attributes];
    }
    
    return layoutAttributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attributes = [super layoutAttributesForItemAtIndexPath:indexPath];
    attributes.size = self.cellSize;
    
	// Delta is distance from center of the view in cellSpacing units...
	CGFloat delta = ((indexPath.row + 0.5f) * self.cellSpacing + self.centerOffset - self.collectionView.bounds.size.width * 0.5f - self.collectionView.contentOffset.x) / self.cellSpacing;
    delta = MAX(MIN(delta, 1.f), -1.f);
    
    CGFloat position = (indexPath.row + 0.5f) * self.cellSpacing + lerp(0, self.cellSpacing * 2, delta);
    attributes.center = (CGPoint){ position + self.centerOffset, CGRectGetMidY(self.collectionView.bounds) };
    
	CATransform3D transform = CATransform3DIdentity;
	transform.m34 = 1.0f / -850.0f; // set the view angle
    
    CGFloat scale = 1.f + (-0.1f * fabsf(lerp(0.f, 1.f, delta))); // interpolate
    
    transform = CATransform3DScale(transform, scale, scale, 1.0f);
    
    CGFloat rotation = lerp(0, -50, delta); // interpolate
    transform = CATransform3DTranslate(transform, self.cellSize.width * (delta > 0.0f ? 0.5f : -0.5f), 0.0f, 0.0f);
    transform = CATransform3DRotate(transform, rotation * (CGFloat)M_PI / 180.f, 0.f, 1.f, 0.f);
    transform = CATransform3DTranslate(transform, self.cellSize.width * (delta > 0.0f ? -0.5f : 0.5f), 0.0f, 0.0f);
    
    attributes.transform3D = transform;
    
    return attributes;
}

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
{
    NSUInteger totalCells = [self.collectionView numberOfItemsInSection:0];
    CGPoint targetContentOffset = proposedContentOffset;
    targetContentOffset.x = roundf(targetContentOffset.x / self.cellSpacing) * self.cellSpacing;
    targetContentOffset.x = MIN(targetContentOffset.x, (totalCells - 1) * self.cellSpacing);
    return targetContentOffset;
}

@end
