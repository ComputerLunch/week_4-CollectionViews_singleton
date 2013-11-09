//
//  NEUILightboxSortableCellsManager.m
//  NeonEngine
//
//  Created by Andrew Poes on 2/13/13.
//  Copyright (c) 2013 groupneon. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "NEUILightboxSortableCellsManager.h"
#import "UIView+Snapshot.h"

#define kNEUITablveViewSortableCellsSnapshotViewTag 1234
#define kMinTouchYForDrag MAX((self.collectionView.contentOffset.y + 4.f), FLT_EPSILON)

@interface NEUILightboxSortableCellsManager()<UIGestureRecognizerDelegate>

@property (nonatomic, strong) UILongPressGestureRecognizer *longPressRecognizer;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSIndexPath *activeIndexPath;

@property (nonatomic, assign) CGFloat scrollingRate;
@property (nonatomic, strong) dispatch_source_t updateTimer;
@property (nonatomic, assign) CGPoint locationOfTouch;
@property (nonatomic, assign) CGPoint initialContentOffset;
@property (nonatomic, assign) CGFloat touchOffsetForScroll;

@property (nonatomic, assign) CGFloat targetOffsetY;
@property (nonatomic, assign) CGFloat currentOffsetY;

@end

@implementation NEUILightboxSortableCellsManager

/**
 *
 */
- (id)initWithCollectionView:(UICollectionView *)cv
{
    self = [super init];
    if (self)
    {
        self.collectionView = cv;
        
        self.longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(onLongPressGesture:)];
        [self.longPressRecognizer setMinimumPressDuration:0.2f];
        [self.longPressRecognizer setAllowableMovement:20.f]; // default is 10.f
        [self.longPressRecognizer setDelaysTouchesBegan:NO];
        [self.longPressRecognizer setDelegate:self];
        
        [self.collectionView addGestureRecognizer:self.longPressRecognizer];
        
        self.initialContentOffset = self.collectionView.contentOffset;
        self.touchOffsetForScroll = (fabsf(self.initialContentOffset.y) + UIApplication.sharedApplication.statusBarFrame.size.height);
    }
    return self;
}

/**
 *
 */
- (void)onLongPressGesture:(UIPanGestureRecognizer *)gestureRecognizer
{
    id<NEUILightboxSortableCellsDelegate> __strong s_delegate = self.delegate;
	
    CGPoint oldLocation = self.locationOfTouch;
    CGPoint location = [gestureRecognizer locationInView:self.collectionView];
    location.y = MIN(MAX(location.y, kMinTouchYForDrag), self.collectionView.contentSize.height-1);
    self.locationOfTouch = location;
    
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:location];
    if (!indexPath)
    {
        indexPath = _activeIndexPath;
    }
    NSAssert(indexPath, @"onLongPressGesture: IndexPath not found for location:%@ in tableview", NSStringFromCGPoint(self.locationOfTouch));
    
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan)
    {
        self.scrollingRate = 0.f;
        self.targetOffsetY = self.collectionView.contentOffset.y;
        self.currentOffsetY = self.collectionView.contentOffset.y;
        
        UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];
        
        UIImageView *cellSnapShotView = (UIImageView *)[self.collectionView viewWithTag:kNEUITablveViewSortableCellsSnapshotViewTag];
        if (!cellSnapShotView)
        {
            cellSnapShotView = [[UIImageView alloc] initWithImage:[cell snapshot]];
            cellSnapShotView.tag = kNEUITablveViewSortableCellsSnapshotViewTag;
            [self.collectionView addSubview:cellSnapShotView];
            UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];
            CGRect rect = cell.frame;
            cellSnapShotView.frame = CGRectOffset(cellSnapShotView.bounds, rect.origin.x, rect.origin.y);
        }
        
        cell.contentView.hidden = YES;
        
        if (isnan(self.locationOfTouch.x) || isnan(self.locationOfTouch.y))
            return;
        
        [UIView animateWithDuration:0.2f animations:^(void) {
            [self updatePositionOfDraggableCellWithPosition:self.locationOfTouch];
        }];
        
        // update the data for the tableview
        NSAssert([s_delegate respondsToSelector:@selector(sortingManager:needsCreatePlaceholderForRowAtIndexPath:)], @"TableView delegate must implement gestureRecognizer:needsCreatePlaceholderForRowAtIndexPath:");
        [s_delegate sortingManager:self needsCreatePlaceholderForRowAtIndexPath:indexPath];
        self.activeIndexPath = indexPath;
        
        UIEdgeInsets contentInset = self.collectionView.contentInset;
        contentInset.bottom = [UIScreen mainScreen].bounds.size.height;
        self.collectionView.contentInset = contentInset;
    }
    else if (gestureRecognizer.state == UIGestureRecognizerStateEnded)
    {
        // while long press ends, remove the snapshot imageView
        UIImageView *cellSnapShotView = (UIImageView *)[self.collectionView viewWithTag:kNEUITablveViewSortableCellsSnapshotViewTag];
        
        // we use self.activeIndexPath directly to make sure we dropped on a valid indexPath
        // which we already ensure while UIGestureRecognizerStateChanged
        NSIndexPath *keptIndexPath = self.activeIndexPath;
        
        UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:keptIndexPath];
        
        // stop the timer;
        if (self.updateTimer != nil)
        {
            dispatch_source_cancel(self.updateTimer);
            self.updateTimer = nil;
        }
        
        self.scrollingRate = 0.f;
        self.targetOffsetY = self.collectionView.contentOffset.y;
        self.currentOffsetY = self.collectionView.contentOffset.y;
        
        [UIView animateWithDuration:0.2f animations:^(void) {
            UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];
            CGRect rect = cell.frame;
            cellSnapShotView.transform = CGAffineTransformIdentity;
            cellSnapShotView.frame = CGRectOffset(CGRectMake(cellSnapShotView.bounds.origin.x, cellSnapShotView.bounds.origin.y, rect.size.width, rect.size.height), rect.origin.x, rect.origin.y);
        } completion:^(BOOL finished) {
            [cellSnapShotView removeFromSuperview];
            [s_delegate sortingManager:self needsReplacePlaceholderForRowAtIndexPath:keptIndexPath];
            // update state and clear instance variables
            self.activeIndexPath = nil;
            
            cell.contentView.hidden = NO;
            self.collectionView.contentInset = UIEdgeInsetsZero;
        }];
    }
    else if (gestureRecognizer.state == UIGestureRecognizerStateChanged)
    {
        if (isnan(location.x) || isnan(location.y))
            return;
        // while our finger moves, we also move the snapshot imageView
        [self updatePositionOfDraggableCellWithPosition:location];
        
        UIView *mainView = UIApplication.sharedApplication.keyWindow;
        
        CGFloat dy = self.locationOfTouch.y - oldLocation.y;
        
        CGPoint pressLocation = [gestureRecognizer locationInView:mainView];
        CGFloat scaledTouchY = ((pressLocation.y-self.touchOffsetForScroll) / (mainView.bounds.size.height-self.touchOffsetForScroll-30.f));
        scaledTouchY = MAX(MIN(scaledTouchY, 1), 0);
        static float_t offsetPercent = 0.16667f;
        if (scaledTouchY < (1 * offsetPercent))
        {
            if (dy <= -1.f)
                self.scrollingRate = -pow((1-scaledTouchY/offsetPercent) * 1.3f, 4);
        }
        else if (scaledTouchY > (1 - offsetPercent))
        {
            if (dy >= 1.f)
                self.scrollingRate = pow(((scaledTouchY-(1-offsetPercent))/offsetPercent) * 1.3f, 4);
        }
        else
        {
            self.scrollingRate = 0;
        }
        
#if (TARGET_IPHONE_SIMULATOR)
        self.scrollingRate *= 5;
#endif
        if (self.updateTimer == nil && self.collectionView.contentSize.height > self.collectionView.frame.size.height)
        {
            self.updateTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
            dispatch_source_set_timer(self.updateTimer, DISPATCH_TIME_NOW, NSEC_PER_MSEC, NSEC_PER_SEC);
            dispatch_source_set_event_handler(self.updateTimer, ^{
                [self autoScrollCollectionView];
            });
            dispatch_resume(self.updateTimer);
        }
        
        [self updateIndexPathForCurrentLocation];
    }
}

/**
 *
 */
- (void)autoScrollCollectionView
{    
    self.targetOffsetY += self.scrollingRate;
    
    if (self.targetOffsetY < self.initialContentOffset.y)
    {
        self.targetOffsetY = self.initialContentOffset.y;
    }
    else if (self.targetOffsetY > self.collectionView.contentSize.height - self.collectionView.bounds.size.height)
    {
        self.targetOffsetY = self.collectionView.contentSize.height - self.collectionView.bounds.size.height;
    }
    
    self.currentOffsetY += (self.targetOffsetY - self.currentOffsetY) * 0.03f;
    [self.collectionView setContentOffset:(CGPoint){.y=self.targetOffsetY}];
    
    CGPoint location = [self.longPressRecognizer locationInView:self.collectionView];
    if (isnan(location.x) || isnan(location.y))
        return;
    
    location.y = MIN(MAX(location.y, kMinTouchYForDrag), self.collectionView.contentSize.height-1);
    if (location.y >= 0)
    {
        [self updatePositionOfDraggableCellWithPosition:location];
    }
    
    [self updateIndexPathForCurrentLocation];
}

/**
 *
 */
- (void)updatePositionOfDraggableCellWithPosition:(CGPoint)position
{
    UIImageView *cellCopy = (UIImageView *)[self.collectionView viewWithTag:kNEUITablveViewSortableCellsSnapshotViewTag];
    NSAssert(cellCopy, @"The draggable tableview cell does not exist");
   
    CGRect frame = cellCopy.frame;
    if ((frame.size.width - 100.f) > FLT_EPSILON)
    {
        frame.size = CGSizeMake(100.f, 100.f);
        frame.origin = CGPointMake(position.x - 50.f, position.y - 50.f);
        cellCopy.frame = frame;
    }
    else
    {
        cellCopy.center = CGPointMake(position.x, position.y);
    }
}

/**
 *
 */
- (void)updateIndexPathForCurrentLocation
{
    NSIndexPath *indexPath = nil;
    CGPoint location = CGPointZero;
    
    location = [self.longPressRecognizer locationInView:self.collectionView];
    if (isnan(location.x) || isnan(location.y))
        return;
    
    location.y = MIN(MAX(location.y, kMinTouchYForDrag), self.collectionView.contentSize.height-1);
    indexPath = [self.collectionView indexPathForItemAtPoint:location];
    if (!indexPath)
    {
        return;
    }
    
    NSAssert(indexPath, @"updateIndexPathForCurrentLocation: IndexPath not found for location: %@, in collectionView", NSStringFromCGPoint(location));
    
    id<NEUILightboxSortableCellsDelegate> __strong s_delegate = self.delegate;
    
    if (indexPath &&
        (![indexPath isEqual:self.activeIndexPath]) &&
        [s_delegate sortingManager:self canSwapIndexPath:self.activeIndexPath toIndexPath:indexPath])
    {
        
        [s_delegate sortingManager:self needsMoveRowAtIndexPath:self.activeIndexPath toIndexPath:indexPath];
        
        [self.collectionView performBatchUpdates:^{
            [self.collectionView moveItemAtIndexPath:self.activeIndexPath toIndexPath:indexPath];
        } completion:^(BOOL finished) {
           
        }];
        
        self.activeIndexPath = indexPath;
    }
}

/**
 *
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint location = [self.longPressRecognizer locationInView:self.collectionView];
    if (isnan(location.x) || isnan(location.y))
        return;
    
    location.y = MIN(MAX(location.y, kMinTouchYForDrag), self.collectionView.contentSize.height-1);
    self.locationOfTouch = location;
    
    if (location.y >= 0 && [self.collectionView viewWithTag:kNEUITablveViewSortableCellsSnapshotViewTag])
    {
        [self updatePositionOfDraggableCellWithPosition:location];
    }
}

/**
 *
 */
- (void)updateLocationOfTouch
{
    [self updateIndexPathForCurrentLocation];
    self.scrollingRate = 0.f;
    self.targetOffsetY = self.collectionView.contentOffset.y;
    self.currentOffsetY = self.collectionView.contentOffset.y;
}

#pragma mark UIGestureRecognizerDelegate methods

/**
 *
 */
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    id<NEUILightboxSortableCellsDelegate> __strong s_delegate = self.delegate;
    
    CGPoint location = [gestureRecognizer locationInView:self.collectionView];
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:location];
    
    if (indexPath && [s_delegate respondsToSelector:@selector(sortingManager:canMoveRowAtIndexPath:)])
    {
        BOOL sortable = [s_delegate sortingManager:self canMoveRowAtIndexPath:indexPath];
        return sortable;
    }
    
    return NO;
}

@end
