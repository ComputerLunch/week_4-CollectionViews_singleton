#import <Foundation/Foundation.h>

@interface Singleton : NSObject{
 
}

// Add property to make accessible from outside this class
@property(nonatomic,retain) NSMutableArray * arrayOfStrings;
@property(nonatomic,retain) NSString * userName;
@property float rating;

// Get instance get object which has are data
+ (Singleton *)getInstance;


@end
