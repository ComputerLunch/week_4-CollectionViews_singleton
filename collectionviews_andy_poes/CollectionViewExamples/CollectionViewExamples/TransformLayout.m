//
//  TransformLayout.m
//  CollectionViewExamples
//
//  Created by Andrew Poes on 3/15/13.
//  Copyright (c) 2013 Neon. All rights reserved.
//

#import "TransformLayout.h"

#define ACTIVE_DISTANCE 200
#define ZOOM_FACTOR 0.3

@implementation TransformLayout

- (id)init
{
    self = [super init];
    if (self)
    {
        BOOL iPad = [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad;
        self.scrollDirection = UICollectionViewScrollDirectionVertical;
        self.itemSize = (CGSize){160, 160};
        self.minimumLineSpacing = 50.0;
        self.minimumInteritemSpacing = 200;
        self.headerReferenceSize = iPad? (CGSize){50, 50} : (CGSize){43, 43};
    }
    return self;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)oldBounds
{
    return YES;
}

-(NSArray*)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray* array = [super layoutAttributesForElementsInRect:rect];
    CGRect visibleRect;
    visibleRect.origin = self.collectionView.contentOffset;
    visibleRect.size = self.collectionView.bounds.size;
    
    for (UICollectionViewLayoutAttributes* attributes in array) {
        if (attributes.representedElementCategory == UICollectionElementCategoryCell)
        {
            if (CGRectIntersectsRect(attributes.frame, rect)) {
                [self setLineAttributes:attributes visibleRect:visibleRect];
            }
        }
        else if (attributes.representedElementCategory == UICollectionElementCategorySupplementaryView)
        {
            [self setHeaderAttributes:attributes];
        }
    }
    return array;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attributes = [super layoutAttributesForItemAtIndexPath:indexPath];
    CGRect visibleRect;
    visibleRect.origin = self.collectionView.contentOffset;
    visibleRect.size = self.collectionView.bounds.size;
    [self setLineAttributes:attributes visibleRect:visibleRect];
    return attributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attributes = [super layoutAttributesForSupplementaryViewOfKind:kind atIndexPath:indexPath];
    
    [self setHeaderAttributes:attributes];
    
    return attributes;
}

- (void)setHeaderAttributes:(UICollectionViewLayoutAttributes *)attributes
{
    attributes.transform3D = CATransform3DMakeRotation(-90 * M_PI / 180, 0, 0, 1);
    attributes.size = CGSizeMake(attributes.size.height, attributes.size.width);
}

- (void)setLineAttributes:(UICollectionViewLayoutAttributes *)attributes visibleRect:(CGRect)visibleRect
{
    CGFloat distance = CGRectGetMidY(visibleRect) - attributes.center.y;
    CGFloat normalizedDistance = distance / [UIScreen mainScreen].bounds.size.height;

    if (ABS(distance) < [UIScreen mainScreen].bounds.size.height) {
        CGFloat zoom = 1 + ZOOM_FACTOR*(1 - ABS(normalizedDistance));
        
        CGFloat angle = normalizedDistance * M_PI * -1.f;
        
        CATransform3D transformScale = CATransform3DMakeScale(zoom, zoom, 1.0);
        CATransform3D transformRotation = CATransform3DMakeRotation(angle, 0.2f, 1.f, 0.4f);
        CATransform3D finalTransform = CATransform3DConcat(transformRotation, transformScale);
        
        attributes.transform3D = finalTransform;
        attributes.zIndex = 1;
    }
    else
    {
        attributes.transform3D = CATransform3DIdentity;
        attributes.zIndex = 0;
    }
}

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
{
    CGFloat offsetAdjustment = MAXFLOAT;
    CGFloat horizontalCenter = proposedContentOffset.x + (CGRectGetWidth(self.collectionView.bounds) / 2.0);
    
    CGRect targetRect = CGRectMake(proposedContentOffset.x, 0.0, self.collectionView.bounds.size.width, self.collectionView.bounds.size.height);
    NSArray* array = [super layoutAttributesForElementsInRect:targetRect];
    
    for (UICollectionViewLayoutAttributes* layoutAttributes in array) {
        if (layoutAttributes.representedElementCategory != UICollectionElementCategoryCell)
            continue; // skip headers
        
        CGFloat itemHorizontalCenter = layoutAttributes.center.x;
        if (ABS(itemHorizontalCenter - horizontalCenter) < ABS(offsetAdjustment)) {
            offsetAdjustment = itemHorizontalCenter - horizontalCenter;
        }
    }
    return CGPointMake(proposedContentOffset.x + offsetAdjustment, proposedContentOffset.y);
}

@end
