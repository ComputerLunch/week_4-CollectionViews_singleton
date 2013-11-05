//
//  ViewController.h
//  Flickr Search
//
//  Created by Andrew Garrahan on 8/11/13.
//  Copyright (c) 2013 Andrew Garrahan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
<UITextFieldDelegate , UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>




@property(nonatomic, weak) IBOutlet UIToolbar *toolbar;
@property(nonatomic, weak) IBOutlet UIBarButtonItem *shareButton;
@property(nonatomic, weak) IBOutlet UITextField *textField;
- (IBAction)shareButtonTapped:(id)sender;


@property(nonatomic, weak) IBOutlet UICollectionView *collectionView;


@end
