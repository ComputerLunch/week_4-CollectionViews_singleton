#import <Foundation/Foundation.h>

@protocol ExampleProtocolDelegate
@required
- (void)protocolMethod;
- (void)myDownloadComplete;
@optional
-(void)myOptionalMethod;

@end


@interface ClassWithProtocol : NSObject

-(void)callProtocol;

@property (nonatomic, assign) id delegate;

@end
