
#import <Foundation/Foundation.h>

@protocol DownloadDelegate <NSObject>
@required

-(void)downloadComplete;

@optional
@end


@interface DownloadClass : NSObject

-(void)startMyDownload;

@property(nonatomic, retain)id delegate;

@end
