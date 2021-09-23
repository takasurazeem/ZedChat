#import <UIKit/UIKit.h>
#import <Sinch/Sinch.h>


@class SINCallKitProvider;

@interface AppDelegateObjC : NSObject <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) id<SINClient> client;
@property (strong, nonatomic, readonly) SINCallKitProvider *callKitProvider;
- (void)classAlloc;
@end
