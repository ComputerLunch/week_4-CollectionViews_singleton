#import <UIKit/UIKit.h>
#import "ClassWithProtocol.h"
#import "DownloadClass.h"

@interface ViewController : UIViewController<ExampleProtocolDelegate , DownloadDelegate>



@end
