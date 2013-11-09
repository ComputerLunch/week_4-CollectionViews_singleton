//
//  CollectionViewController.h
//  CollectionViewExamples
//
//  Created by Andrew Poes on 3/3/13.
//  Copyright (c) 2013 Neon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, assign) IBOutlet UIToolbar *toolbar;
@property (nonatomic, assign) IBOutlet UICollectionView *collectionView;

@end
