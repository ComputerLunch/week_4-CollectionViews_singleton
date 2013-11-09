//
//  GridStyleLayout.m
//  CollectionViewExamples
//
//  Created by Andrew Poes on 3/3/13.
//  Copyright (c) 2013 Neon. All rights reserved.
//

#import "GridStyleLayout.h"

@implementation GridStyleLayout

- (id)init
{
    self = [super init];
    if (self) {
        
        CGFloat itemSize = ([UIScreen mainScreen].bounds.size.width/6) - 5.f;
        self.minimumLineSpacing = 5.f;
        self.minimumInteritemSpacing = 5.f;
        self.itemSize = CGSizeMake(itemSize, itemSize);
        self.scrollDirection = UICollectionViewScrollDirectionVertical;
    }
    return self;
}

@end
