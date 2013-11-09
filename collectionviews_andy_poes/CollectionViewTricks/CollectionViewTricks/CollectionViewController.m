//
//  ViewController.m
//  CollectionViewTricks
//
//  Created by Andrew Poes on 3/16/13.
//  Copyright (c) 2013 Neon. All rights reserved.
//

#import "CollectionViewController.h"
#import "NEUILightboxSortableCellsManager.h"
#import "UICollectionViewWaterfallLayout.h"
#import <QuartzCore/QuartzCore.h>

@interface CollectionViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, NEUILightboxSortableCellsDelegate, UICollectionViewDelegateWaterfallLayout>

@property (nonatomic, assign) IBOutlet UICollectionView *collectionView;

@property (nonatomic, assign) NSUInteger numberOfItems;
@property (nonatomic, strong) NSIndexPath *activeIndexPath;
@property (nonatomic, strong) NEUILightboxSortableCellsManager *sortingManager;
@property (nonatomic, strong) NSMutableArray *variableHeights;

@end

@implementation CollectionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _numberOfItems = 10;
    _variableHeights = [NSMutableArray array];
    for (NSInteger i = 0; i < _numberOfItems; ++i) {
        [self.variableHeights addObject:[self randomHeight]];
    }
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    _sortingManager = [[NEUILightboxSortableCellsManager alloc] initWithCollectionView:self.collectionView];
    _sortingManager.delegate = self;
    
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"ReuseIdentifier"];
    
    UICollectionViewWaterfallLayout *waterfall = [[UICollectionViewWaterfallLayout alloc] init];
    waterfall.columnCount = 2;
    waterfall.itemWidth = self.collectionView.frame.size.width / 2.f - 14.f;
    waterfall.sectionInset = UIEdgeInsetsMake(10.f, 7.f, 10.f, 7.f);
    waterfall.delegate = self;
    
    [self.collectionView setCollectionViewLayout:waterfall animated:NO];
    [self.collectionView.collectionViewLayout invalidateLayout];
}
//
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addItems:(id)sender
{
    NSArray *visibleIndexPaths = self.collectionView.indexPathsForVisibleItems;
    NSInteger middle = visibleIndexPaths.count / 2.f;
    
    _numberOfItems += 1;
    
    [self.variableHeights addObject:[self randomHeight]];
    
    [self.collectionView performBatchUpdates:^{
        [self.collectionView insertItemsAtIndexPaths:@[visibleIndexPaths[middle]]];
    } completion:^(BOOL finished) {
        [self.collectionView.collectionViewLayout invalidateLayout];
    }];
    
}

- (IBAction)deleteItem:(id)sender
{
    NSArray *visibleIndexPaths = self.collectionView.indexPathsForVisibleItems;
    NSInteger middle = visibleIndexPaths.count / 2.f;
    
    _numberOfItems -= 1;
    
    [self.variableHeights removeObjectAtIndex:[visibleIndexPaths[middle] row]];
    
    [self.collectionView performBatchUpdates:^{
        [self.collectionView deleteItemsAtIndexPaths:@[visibleIndexPaths[middle]]];
    } completion:^(BOOL finished) {
        [self.collectionView.collectionViewLayout invalidateLayout];
    }];
}

- (NSNumber *)randomHeight
{
    NSInteger rand = arc4random()%100;
    if (rand < 33)
    {
        return @100.f;
    }
    else if (rand < 66)
    {
        return @150.f;
    }
    else
    {
        return @200.f;
    }
}

#pragma mark UICollectionViewDelegateWaterfallLayout

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewWaterfallLayout *)collectionViewLayout
 heightForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_activeIndexPath != nil && indexPath.row == _activeIndexPath.row)
    {
        return 400.f;
    }
    return [_variableHeights[indexPath.row] intValue];
}

#pragma mark UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{    
    if (_activeIndexPath != nil && indexPath.row == _activeIndexPath.row)
    {
        _activeIndexPath = nil;
    }
    else
    {
        _activeIndexPath = indexPath;
    }
    
    [self.collectionView performBatchUpdates:^{
        // magic beans
    } completion:^(BOOL finished) {
        
    }];
    
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:YES];
}

#pragma mark UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _numberOfItems;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat r = indexPath.row / (_numberOfItems  * 1.f) * 0.9f + 0.1f;
    CGFloat b = indexPath.row / (_numberOfItems  * 1.f) * 0.7f + 0.3f;
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ReuseIdentifier" forIndexPath:indexPath];
    cell.contentView.backgroundColor = [UIColor colorWithRed:r green:0.f blue:1.f-b alpha:1.f];
    
    cell.contentView.layer.cornerRadius = 6.f;
    cell.contentView.layer.shadowColor = [UIColor blackColor].CGColor;
    cell.contentView.layer.shadowOffset = CGSizeMake(0.f, 1.f);
    cell.contentView.layer.shadowRadius = 3.f;
    cell.contentView.layer.shadowOpacity = 0.5f;
    
    return cell;
}

#pragma mark NEUILightboxSortableCellsDelegate

- (BOOL)sortingManager:(NEUILightboxSortableCellsManager *)sortingManager canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (BOOL)sortingManager:(NEUILightboxSortableCellsManager *)sortingManager canSwapIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{    
    return YES;
}

- (void)sortingManager:(NEUILightboxSortableCellsManager *)sortingManager needsCreatePlaceholderForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)sortingManager:(NEUILightboxSortableCellsManager *)sortingManager needsMoveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    
}

- (void)sortingManager:(NEUILightboxSortableCellsManager *)sortingManager needsReplacePlaceholderForRowAtIndexPath:(NSIndexPath *)indexPath
{

}

@end
