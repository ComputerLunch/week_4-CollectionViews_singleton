//
//  UIView+Snapshot.m
//  NeonEngine
//
//  Created by Andrew Poes on 1/9/13.
//  Copyright (c) 2013 groupneon. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "UIView+Snapshot.h"

@implementation UIView (Snapshot)

/**
 * get a screenshot of the current cell
 */
- (UIImage *)snapshot
{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, [UIScreen mainScreen].scale);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *screenShot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return screenShot;
}

@end
