#import <Foundation/Foundation.h>

@interface MySharedObject : NSObject


+ (MySharedObject *)getIt;

@property(nonatomic,retain)NSString * myString;

@end
