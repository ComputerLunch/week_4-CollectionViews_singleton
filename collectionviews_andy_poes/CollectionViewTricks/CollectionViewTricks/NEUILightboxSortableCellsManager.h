//
//  NEUILightboxSortableCellsManager.h
//  NeonEngine
//
//  Created by Andrew Poes on 2/13/13.
//  Copyright (c) 2013 groupneon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol NEUILightboxSortableCellsDelegate;

@interface NEUILightboxSortableCellsManager : NSObject

@property (nonatomic, weak) id<NEUILightboxSortableCellsDelegate> delegate;

- (id)initWithCollectionView:(UICollectionView *)collectionView;
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
- (void)updateLocationOfTouch;

@end

@protocol NEUILightboxSortableCellsDelegate <NSObject>
@required

- (BOOL)sortingManager:(NEUILightboxSortableCellsManager *)sortingManager canMoveRowAtIndexPath:(NSIndexPath *)indexPath;
- (BOOL)sortingManager:(NEUILightboxSortableCellsManager *)sortingManager canSwapIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath;
- (void)sortingManager:(NEUILightboxSortableCellsManager *)sortingManager needsCreatePlaceholderForRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)sortingManager:(NEUILightboxSortableCellsManager *)sortingManager needsMoveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath;
- (void)sortingManager:(NEUILightboxSortableCellsManager *)sortingManager needsReplacePlaceholderForRowAtIndexPath:(NSIndexPath *)indexPath;

@end