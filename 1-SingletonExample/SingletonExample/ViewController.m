#import "ViewController.h"
#import "Singleton.h"        // Import singleton class

#import "Const.h"
#import "MySharedObject.h"

#define S [Singleton getInstance]

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    
    Globals.myString = @"place the string";
    
    [MySharedObject getIt].myString = @"new String";
    
    
  /*  AppDelegate * myApp = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    NSLog(@"From the App Delegate - %@", myApp.myString);
    myApp.myNumber = 56;
    
    MyApp.myString = @"hello";*/
    
    S.rating = 56;
    

    ///////////////////////////////////////////
    // Print out current data from the singleton   
    ///////////////////////////////////////////
    NSLog(@"RATING: %f", [[Singleton getInstance] rating]);
    NSLog(@"NAME: %@", [[Singleton getInstance] userName]);
    
    for (int i = 0; i < [Singleton getInstance].arrayOfStrings.count ; i++ ) {
        
        //Loop through array and print out each item
        NSLog(@"array[ %i ]= %@", i , [[[Singleton getInstance] arrayOfStrings] objectAtIndex:i]);
    }
   
    
    ///////////////////////////////////////////
    // Change the data
    ///////////////////////////////////////////
    [Singleton getInstance].rating = 75;
    
    [Singleton getInstance].userName = @"A New Name";
    
    [[[Singleton getInstance] arrayOfStrings] addObject:@"NEW item 1"];
    [[[Singleton getInstance] arrayOfStrings] addObject:@"NEW itme 2"];
    
    
    
    
    ///////////////////////////////////////////
    // Print new out the changes
    ///////////////////////////////////////////
    NSLog(@"\n\n\n NEW DATA \n");
    
    
    NSLog(@"RATING: %f", [[Singleton getInstance] rating]);
    NSLog(@"NAME: %@", [[Singleton getInstance] userName]);
    
    for (int i = 0; i < [Singleton getInstance].arrayOfStrings.count ; i++ ) {
        
        //Loop through array and print out each item
        NSLog(@"array[ %i ]= %@", i , [[[Singleton getInstance] arrayOfStrings] objectAtIndex:i]);
    }
}


@end
