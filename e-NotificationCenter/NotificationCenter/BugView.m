#import "BugView.h"

@implementation BugView



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(moveBugUp:)
                                                     name:@"moveBug"
                                                   object:nil ];
        
        // Register Listener
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(receiveTestNotification:)
                                                     name:@"TestNotification"
                                                   object:nil];
        
        self.backgroundColor = [UIColor blueColor];
    }
    return self;
}

-(void)moveBugUp{
    
    self.center = CGPointMake(self.center.x,self.center.y + 10);
    
}


-(void)receiveTestNotification:( NSNotification *) notification
{
        // [notification name] should always be @"TestNotification"
        // unless you use this method for observation of other notifications
        // as well.

    if ([[notification name] isEqualToString:@"TestNotification"]){
    
            self.backgroundColor = [UIColor redColor];
        
           // NSLog (@"Successfully received the test notification!");
    }
}





@end
