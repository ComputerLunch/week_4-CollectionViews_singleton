//
//  CollectionViewController.m
//  CollectionViewExamples
//
//  Created by Andrew Poes on 3/3/13.
//  Copyright (c) 2013 Neon. All rights reserved.
//

#import "CollectionViewController.h"
#import "CollectionViewCellWithImageView.h"
#import "TableViewStyleLayout.h"
#import "GridStyleLayout.h"
#import "CoverFlowStyleLayout.h"
#import "RadialLayout.h"
#import "TransformLayout.h"

#define kCollectionViewCellWithImageView @"CollectionViewCellWithImageView"

@interface CollectionViewController ()

@property (nonatomic, assign) NSInteger cellCount;
@property (nonatomic, strong) NSArray *assets;
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;

@property (nonatomic, strong) TableViewStyleLayout *tableViewStyleLayout;
@property (nonatomic, strong) GridStyleLayout *gridStyleLayout;
@property (nonatomic, strong) CoverFlowStyleLayout *coverFlowLayout;
@property (nonatomic, strong) RadialLayout *radialLayout;
@property (nonatomic, strong) TransformLayout *transformLayout;

@property (nonatomic, assign) BOOL firstTime;

@end

@implementation CollectionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.collectionView.delegate = self;
    
    _tableViewStyleLayout = [[TableViewStyleLayout alloc] init];
    _gridStyleLayout = [[GridStyleLayout alloc] init];
    _coverFlowLayout = [[CoverFlowStyleLayout alloc] init];
    _radialLayout = [[RadialLayout alloc] init];
    _transformLayout = [[TransformLayout alloc] init];
    
    [self.collectionView setCollectionViewLayout:_tableViewStyleLayout];
    [self.collectionView setContentOffset:CGPointZero];
    
    // set background color
    [self.collectionView setBackgroundColor:[UIColor blackColor]];
    
    // load all the assets from the images folder into an array we can reference later
    NSMutableArray *theAssets = [NSMutableArray array];
	NSURL *theURL = [[[NSBundle mainBundle] resourceURL] URLByAppendingPathComponent:@"Images"];
	NSEnumerator *theEnumerator = [[NSFileManager defaultManager] enumeratorAtURL:theURL includingPropertiesForKeys:NULL options:NSDirectoryEnumerationSkipsPackageDescendants | NSDirectoryEnumerationSkipsHiddenFiles errorHandler:NULL];
	for (theURL in theEnumerator)
    {
        if ([[theURL pathExtension] isEqualToString:@"jpg"])
        {
            [theAssets addObject:theURL];
        }
    }
    
    
	self.assets = theAssets;
	self.cellCount = self.assets.count;
    
    // register the cell class(s)
    [self.collectionView registerClass:[CollectionViewCellWithImageView class] forCellWithReuseIdentifier:kCollectionViewCellWithImageView];
    
    _firstTime = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)layout1:(id)sender
{
    [self.collectionView setCollectionViewLayout:_tableViewStyleLayout animated:YES];
}

- (IBAction)layout2:(id)sender
{
    [self.collectionView setCollectionViewLayout:_gridStyleLayout animated:YES];
}

- (IBAction)layout3:(id)sender
{
    [self.collectionView setCollectionViewLayout:_transformLayout animated:YES];
    [self.collectionView.collectionViewLayout performSelector:@selector(invalidateLayout) withObject:nil afterDelay:0.4f];
}

- (IBAction)layout4:(id)sender
{
    [self.collectionView setCollectionViewLayout:_radialLayout animated:YES];
    [self.collectionView.collectionViewLayout performSelector:@selector(invalidateLayout) withObject:nil afterDelay:0.4f];
}

- (IBAction)layout5:(id)sender
{
    [self.collectionView setCollectionViewLayout:_coverFlowLayout animated:YES];
    [self.collectionView setContentOffset:CGPointZero animated:YES];
}

#pragma mark UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    _selectedIndexPath = indexPath;
    

    [self.collectionView performBatchUpdates:^{
        
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.cellCount;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger imageIndex = indexPath.row % self.cellCount;
    
    NSLog(@"img index - %i",imageIndex);
    
    NSURL *theURL = [self.assets objectAtIndex:imageIndex];
    
    CollectionViewCellWithImageView *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCollectionViewCellWithImageView forIndexPath:indexPath];
    cell.cellImage.image = [UIImage imageWithContentsOfFile:theURL.path];
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

#pragma mark UICollectionViewDelegateFlowLayout

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    CGSize size = CGSizeZero;
//    switch (_currentLayout) {
//        case CollectionViewLayoutList :
//            size = [_tableViewStyleLayout itemSize];
//            break;
//        case CollectionViewLayoutGrid :
//            size = [_gridStyleLayout itemSize];
//            break;
//    }
//    
//    if (_selectedIndexPath &&
//        _selectedIndexPath.row == indexPath.row &&
//        _selectedIndexPath.section == indexPath.section)
//    {
//        size.height = size.width * 0.7f;
//    }
//    
//    return size;
//}

@end
