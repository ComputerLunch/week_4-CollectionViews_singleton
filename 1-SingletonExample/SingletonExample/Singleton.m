#import "Singleton.h"

@implementation Singleton


+ (Singleton *)getInstance
{
    // the instance of this class is stored here
    static Singleton *myInstance = nil;
    
    // check to see if an instance already exists
    if (nil == myInstance) {
        myInstance  = [[[self class] alloc] init];
    }
    
    // return the instance of this class
    return myInstance;
}


// Init gets called once the first time you call getInstance
-(id) init {
	if (self=[super init]) {
		
        // Place initial variable values here
        _rating = 95;
        
        _userName = @"Your Name";
        
        _arrayOfStrings = [[NSMutableArray alloc]initWithObjects:@"item 1", @"item 2", @"item 3" , @"item 4", nil];
        
	}
	return self;
}


@end








