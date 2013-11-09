#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    
    ClassWithProtocol * classSendingProtocolEvents = [[ClassWithProtocol alloc]init];
    classSendingProtocolEvents.delegate = self;
    [classSendingProtocolEvents callProtocol];
    
    
    DownloadClass * downloader = [[DownloadClass alloc]init];
    
    downloader.delegate = self;
    [downloader startMyDownload];
}


-(void)downloadComplete{
    
    NSLog(@"NEW download complete");
}


-(void)myDownloadComplete{
    
    NSLog(@"my download complete");
}

-(void)myOptionalMethod{
    
    
}

-(void)protocolMethod{

    NSLog(@"Protocol Method Called with it View Controller");
    
}


@end
