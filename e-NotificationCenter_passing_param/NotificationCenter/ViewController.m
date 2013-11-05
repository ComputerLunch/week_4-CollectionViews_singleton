#import "ViewController.h"
#import "BugView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    for (int i = 0 ;  i < 10; i ++) {
        BugView * bug = [[BugView alloc]initWithFrame:CGRectMake(0, 0, 10, 10)];
        bug.center = CGPointMake(arc4random() % 320 , arc4random() % 480);
        
        [self.view addSubview:bug];
    }
}

- (IBAction)onRight:(id)sender {
     NSDictionary * passPars = @{ @"key1" : @"value2", @"name" : @"andrew" };
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"right" object:passPars ];
}

- (IBAction)onUp:(id)sender {
    [[NSNotificationCenter defaultCenter]postNotificationName:@"up" object:nil];
}

- (IBAction)onLeft:(id)sender {
    [[NSNotificationCenter defaultCenter]postNotificationName:@"left" object:nil];
}

- (IBAction)onDown:(id)sender {
    [[NSNotificationCenter defaultCenter]postNotificationName:@"down" object:nil];
}
@end
