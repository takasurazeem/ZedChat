#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Sinch/SINExport.h>
#import <Sinch/SINAPSEnvironment.h>
#import <Sinch/Sinch.h>

@interface SINUIViewController : UIViewController

@property (nonatomic, readonly, assign) BOOL isAppearing;
@property (nonatomic, readonly, assign) BOOL isDisappearing;

- (void)dismiss;
- (id<SINNotificationResult>)handleRemoteNotificationResultManual: (NSDictionary*)userInfo CallClientID:(id<SINClient>)client;
@end




SIN_EXPORT SIN_EXTERN NSString *const SINPushTypeVoIP NS_AVAILABLE_IOS(8_0);
SIN_EXPORT SIN_EXTERN NSString *const SINPushTypeRemote NS_AVAILABLE_IOS(6_0);

// SINApplicationDidReceiveRemoteNotification is emitted for both VoIP and Remote Push Notifications.
// Also emitted for remote notifications received at application launched (i.e. via
// UIApplicationDidFinishLaunchingNotification with UIApplicationLaunchOptionsRemoteNotificationKey)
// SINApplicationDidReceiveRemoteNotification provides a unified way of listening for incoming remote notifications.
SIN_EXPORT SIN_EXTERN NSString *const SINApplicationDidReceiveRemoteNotification;

// SINRemoteNotificationKey
// userInfo contains NSDictionary with payload
SIN_EXPORT SIN_EXTERN NSString *const SINRemoteNotificationKey;

// SINPushTypeKey
// userInfo contains this key with value SINPushTypeVoIP or SINPushTypeRemote
SIN_EXPORT SIN_EXTERN NSString *const SINPushTypeKey;
