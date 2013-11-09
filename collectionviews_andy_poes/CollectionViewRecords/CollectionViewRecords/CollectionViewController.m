//
//  ViewController.m
//  CollectionViewRecords
//
//  Created by Andrew Poes on 3/15/13.
//  Copyright (c) 2013 Neon. All rights reserved.
//

#import "CollectionViewController.h"
#import "ShelfItem.h"
#import "SectionHeader.h"

#import "GridLayout.h"
#import "StacksLayout.h"

#define ShelfItemReuseIdentifier @"ShelfItem"
#define ShelfItemHeaderIdentifier @"ShelfItemHeaderIdentifier"
#define ShelfItemHeaderKind @"ShelfItemHeaderKind"

typedef enum Sections {
    SectionVinyl,
    SectionBooks,
    SectionGames,
    SectionCassettes,
    SectionDvds,
    SectionVHS
} Sections;

@interface CollectionViewController ()<UIGestureRecognizerDelegate>

@property (nonatomic, assign) IBOutlet UICollectionView *collectionView;

@property (nonatomic, strong) NSArray *sectionTitles;
@property (nonatomic, strong) NSArray *vinyl;
@property (nonatomic, strong) NSArray *books;
@property (nonatomic, strong) NSArray *games;
@property (nonatomic, strong) NSArray *cassettes;
@property (nonatomic, strong) NSArray *dvds;
@property (nonatomic, strong) NSArray *vhs;

@property (nonatomic, strong) GridLayout *gridLayout;
@property (nonatomic, strong) StacksLayout *stacksLayout;

@end

@implementation CollectionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.collectionView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"assets/cherry"]];
    
    self.sectionTitles = @[ @"Vinyl", @"Books", @"Video Games", @"Cassettes", @"DVDs", @"VHS" ];
    self.vinyl = @[ @"Etta James", @"Billy Holiday", @"Elvis Presley", @"Rolling Stones", @"Jimi Hendrix", @"The Doors", @"Buddy Holly" ];
    self.books = @[ @"The Oddyssey", @"The Bible", @"World History Vol 1", @"iOS Programming Guide", @"Algebra 101", @"Learning Spanish", @"The Davinci Code", @"The Good Singer", @"New York Trilogy" ];
    self.games = @[ @"Air Defender", @"Spy Hunter", @"Tetris", @"Othello", @"Guardians of Middle Earth", @"Submarine", @"Night Driver", @"Chess" ];
    self.cassettes = @[ @"Madonna", @"Bach Greatest Hits", @"Salt N Peppa", @"Beastie Boys", @"Books on Tape", @"Learning French", @"Chromeo" ];
    self.dvds = @[ @"The Departed", @"The Fifth Element", @"Batman Begins", @"Planet Earth", @"The Village", @"Mad About You", @"Twister" ];
    self.vhs = @[ @"Bambi", @"Aladin", @"Dumbo", @"Gremlins", @"Terminator T2", @"Newsies", @"The Bumble Bee Club", @"5 Minute Abs", @"Home Movies Vol 1" ];
    
    [self.collectionView registerClass:[ShelfItem class] forCellWithReuseIdentifier:ShelfItemReuseIdentifier];
    [self.collectionView registerClass:[SectionHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:ShelfItemHeaderIdentifier];
    
    _gridLayout = [[GridLayout alloc] init];
    _stacksLayout = [[StacksLayout alloc] init];
    [self.collectionView setCollectionViewLayout:_gridLayout animated:NO];
    
    self.collectionView.contentInset = UIEdgeInsetsMake(44.f, 0, 0, 0);
    self.collectionView.scrollIndicatorInsets = self.collectionView.contentInset;
    
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
    pinch.delegate = self;
    [self.collectionView addGestureRecognizer:pinch];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)setShowGrid:(id)sender
{
    [self.collectionView setCollectionViewLayout:_gridLayout animated:YES];
}

- (IBAction)setShowStacks:(id)sender
{
    _stacksLayout.collapsing = YES;
    _stacksLayout.pinchedStackIndex = -1;
    _stacksLayout.pinchedStackScale = 1.0;
    
    [self.collectionView setCollectionViewLayout:_stacksLayout animated:YES];
    [self.collectionView setContentOffset:CGPointMake(0, -44.f) animated:YES];
}

- (void)handlePinch:(UIPinchGestureRecognizer *)gestureRecognizer
{
    StacksLayout *stacksLayout = (StacksLayout *)self.collectionView.collectionViewLayout;
    
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan)
    {
        CGPoint initialPinchPoint = [gestureRecognizer locationInView:self.collectionView];
        NSIndexPath* pinchedCellPath = [self.collectionView indexPathForItemAtPoint:initialPinchPoint];
        if (pinchedCellPath)
            [stacksLayout setPinchedStackIndex:pinchedCellPath.section];
    }
    else if (stacksLayout.pinchedStackIndex >= 0)
    {
        if (gestureRecognizer.state == UIGestureRecognizerStateChanged)
        {
            stacksLayout.pinchedStackScale = gestureRecognizer.scale;
            stacksLayout.pinchedStackCenter = [gestureRecognizer locationInView:self.collectionView];
        }
        
        else
        {
            if (stacksLayout.pinchedStackScale > 2.5)
            {
                // switch to GridLayout
                [self.collectionView setCollectionViewLayout:_gridLayout animated:YES];
            }
            else
            {
                
                stacksLayout.collapsing = YES;
                [self.collectionView performBatchUpdates:^{
                    stacksLayout.pinchedStackIndex = -1;
                    stacksLayout.pinchedStackScale = 1.0;
                } completion:^(BOOL finished) {
                    stacksLayout.collapsing = NO;
                }];
            }
        }
    }
}


#pragma mark - UIGestureRecognizerDelegate methods

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([gestureRecognizer isKindOfClass:[UIPinchGestureRecognizer class]] && [self.collectionView.collectionViewLayout isKindOfClass:[StacksLayout class]])
    {
        return YES;
    }
    
    return NO;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.sectionTitles.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    switch (section) {
        case SectionVinyl:
            return self.vinyl.count;
        case SectionBooks:
            return self.books.count;
        case SectionGames:
            return self.games.count;
        case SectionCassettes:
            return self.cassettes.count;
        case SectionDvds:
            return self.dvds.count;
        case SectionVHS:
            return self.vhs.count;
    }
    
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ShelfItem *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:ShelfItemReuseIdentifier forIndexPath:indexPath];
    
    switch (indexPath.section) {
        case SectionVinyl:
            cell.image.image = [UIImage imageNamed:@"assets/vinyl"];
            cell.label.text = self.vinyl[indexPath.row];
            break;
        case SectionBooks:
            cell.image.image = [UIImage imageNamed:@"assets/book"];
            cell.label.text = self.books[indexPath.row];
            break;
        case SectionGames:
            cell.image.image = [UIImage imageNamed:@"assets/game"];
            cell.label.text = self.games[indexPath.row];
            break;
        case SectionCassettes:
            cell.image.image = [UIImage imageNamed:@"assets/cassette"];
            cell.label.text = self.cassettes[indexPath.row];
            break;
        case SectionDvds:
            cell.image.image = [UIImage imageNamed:@"assets/dvd"];
            cell.label.text = self.dvds[indexPath.row];
            break;
        case SectionVHS:
            cell.image.image = [UIImage imageNamed:@"assets/vhs"];
            cell.label.text = self.vhs[indexPath.row];
            break;
    }
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    SectionHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:ShelfItemHeaderIdentifier forIndexPath:indexPath];
    
    switch (indexPath.section) {
        case SectionVinyl:
            [header setTitle:@"Records"];
            break;
        case SectionBooks:
            [header setTitle:@"Books"];
            break;
        case SectionGames:
            [header setTitle:@"Games"];
            break;
        case SectionCassettes:
            [header setTitle:@"Cassettes"];
            break;
        case SectionDvds:
            [header setTitle:@"DVD's"];
            break;
        case SectionVHS:
            [header setTitle:@"VHS's"];
            break;
    }
    
    return header;
}

@end
