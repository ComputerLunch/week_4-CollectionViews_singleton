#import "MySharedObject.h"

@implementation MySharedObject

+ (MySharedObject *)getIt
{
    // the instance of this class is stored here
    static MySharedObject *myInstance = nil;
    
    // check to see if an instance already exists
    if (nil == myInstance) {
        myInstance  = [[[self class] alloc] init];
    }
    
    // return the instance of this class
    return myInstance;
}



@end
