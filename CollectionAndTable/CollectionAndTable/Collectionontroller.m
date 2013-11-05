#import "Collectionontroller.h"

#import "TableViewStyleLayout.h"

@interface Collectionontroller ()

@property (nonatomic, strong) TableViewStyleLayout *tableViewStyleLayout;

@end

@implementation Collectionontroller

#define kCollectionViewCellWithImageView @"CollectionViewCell"

-(void)viewDidLoad{
    
    // SET LAYOUT STYLE
    _tableViewStyleLayout = [[TableViewStyleLayout alloc] init];
    
    [self.collectionView setCollectionViewLayout:_tableViewStyleLayout];
    [self.collectionView setContentOffset:CGPointZero];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return 16;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //NSUInteger imageIndex = indexPath.row % self.cellCount;
    //NSLog(@"img index - %i",imageIndex);
    //NSURL *theURL = [self.assets objectAtIndex:imageIndex];
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCollectionViewCellWithImageView forIndexPath:indexPath];
    
    //cell.cellImage.image = [UIImage imageWithContentsOfFile:theURL.path];
    
    return cell;
}

@end
