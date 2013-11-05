#import "ViewController.h"
#import "BugView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    for (int i = 0 ;  i < 50; i ++) {
        BugView * bug = [[BugView alloc]initWithFrame:CGRectMake(0, 0, 10, 10)];
        bug.center = CGPointMake(arc4random() % 320 , arc4random() % 480);
        
        [self.view addSubview:bug];
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"moveBug" object:nil];
}

// Broadcast event on touch
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
   
    
    
    //... somewhere else in another class ...
    [[NSNotificationCenter defaultCenter] 
         postNotificationName:@"TestNotification" 
         object:nil];
}

@end
