//
//  TableViewStyleLayout.m
//  CollectionViewExamples
//
//  Created by Andrew Poes on 3/3/13.
//  Copyright (c) 2013 Neon. All rights reserved.
//

#import "TableViewStyleLayout.h"

@implementation TableViewStyleLayout

- (id)init
{
    self = [super init];
    if (self) {
        
        self.minimumLineSpacing = 5.f;
        self.minimumInteritemSpacing = 0.f;
        self.itemSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height / 10.0);
        self.scrollDirection = UICollectionViewScrollDirectionVertical;
    }
    return self;
}

@end
