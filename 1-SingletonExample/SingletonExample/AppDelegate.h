//
//  AppDelegate.h
//  SingletonExample
//
//  Created by Andrew Garrahan on 7/19/12.
//  Copyright (c) 2012 Gutpela. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property(nonatomic,retain) NSString * myString;
@property float myNumber;

@end
