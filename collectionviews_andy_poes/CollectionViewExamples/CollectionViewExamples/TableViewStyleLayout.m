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
        
        self.minimumLineSpacing = 10.f;
        self.minimumInteritemSpacing = 0.f;
        self.itemSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height / 25.5);
        self.scrollDirection = UICollectionViewScrollDirectionVertical;
    }
    return self;
}

@end
