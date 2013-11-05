#ifndef SingletonExample_Const_h
#define SingletonExample_Const_h


#import "AppDelegate.h"
#import "MySharedObject.h"

#define Globals [MySharedObject getIt]

#define MyApp ((AppDelegate *)[UIApplication sharedApplication].delegate)

#define kMyButtonType 2



#endif
