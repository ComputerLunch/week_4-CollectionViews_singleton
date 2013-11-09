#import "BugView.h"

@implementation BugView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        NSDictionary * passPars = @{ @"key1" : @"value2", @"name" : @"andrew" };
       
        // Register Listener
        [[NSNotificationCenter defaultCenter]addObserver:self
                                                 selector:@selector(receiveTestNotification:) 
                                                     name:@"right"
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter]addObserver:self
                                                selector:@selector(receiveTestNotification:) 
                                                    name:@"left"
                                                  object:nil];
        
        [[NSNotificationCenter defaultCenter]addObserver:self
                                                selector:@selector(receiveTestNotification:) 
                                                    name:@"up"
                                                  object:nil];
        
        [[NSNotificationCenter defaultCenter]addObserver:self
                                                selector:@selector(receiveTestNotification:) 
                                                    name:@"down"
                                                  object:nil];
        
        
        self.backgroundColor = [UIColor blueColor];
    }
    return self;
}


-(void)receiveTestNotification:( NSNotification *) notification
{
   
    if ([notification name]  == @"right"){
        self.center = CGPointMake( self.center.x + 5  , self.center.y );
    }
    
    if ([notification name]  == @"left"){
        self.center = CGPointMake( self.center.x - 5  , self.center.y );
    }
    
    if ([notification name]  == @"up"){
        self.center = CGPointMake( self.center.x  , self.center.y - 5);
    }
    
    if ([notification name]  == @"down"){
        self.center = CGPointMake( self.center.x , self.center.y + 5 );
    }
    
    if(notification.object != nil){
        
        NSDictionary * passedObject = (NSDictionary *)notification.object;
        //NSLog(@"print ");
        NSLog(@"object %@", [passedObject objectForKey:@"name"]);
    }
    
    

    
}










@end
