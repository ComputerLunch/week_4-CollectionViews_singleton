//
//  FlickerPhotoCell.h
//  Flickr Search
//
//  Created by Andrew Garrahan on 8/11/13.
//  Copyright (c) 2013 Andrew Garrahan. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <QuartzCore/QuartzCore.h>
@class FlickrPhoto;

@interface FlickerPhotoCell : UICollectionViewCell


@property (nonatomic, strong) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) FlickrPhoto *photo;
@end
