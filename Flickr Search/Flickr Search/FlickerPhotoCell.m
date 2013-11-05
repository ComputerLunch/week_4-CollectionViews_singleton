//
//  FlickerPhotoCell.m
//  Flickr Search
//
//  Created by Andrew Garrahan on 8/11/13.
//  Copyright (c) 2013 Andrew Garrahan. All rights reserved.
//

#import "FlickrPhoto.h"
#import "FlickerPhotoCell.h"

@implementation FlickerPhotoCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void) setPhoto:(FlickrPhoto *)photo {
    
    if(_photo != photo) {
        _photo = photo;
    }
    self.imageView.image = _photo.thumbnail;
}

@end
