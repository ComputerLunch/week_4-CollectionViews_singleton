#import "ClassWithProtocol.h"

@implementation ClassWithProtocol

-(void)callProtocol{
    
    
    [_delegate myDownloadComplete];
    
    [_delegate protocolMethod];
}

@end
