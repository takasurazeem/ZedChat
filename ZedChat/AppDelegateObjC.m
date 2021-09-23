#import "AppDelegateObjC.h"
#import "SINCallKitProvider.h"

@interface AppDelegateObjC () <SINClientDelegate, SINCallClientDelegate, SINManagedPushDelegate>
@property (nonatomic, readwrite, strong) id<SINManagedPush> push;
@property (nonatomic, readwrite, strong) SINCallKitProvider *callKitProvider;
@end

@implementation AppDelegateObjC

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  NSLog(@"didFinishLaunchingWithOptions:");

  [Sinch setLogCallback:^(SINLogSeverity severity, NSString *area, NSString *message, NSDate *timestamp) {
    NSLog(@"[%@] %@", area, message);
  }];

  self.push = [Sinch managedPushWithAPSEnvironment:SINAPSEnvironmentAutomatic];
  self.push.delegate = self;
  [self.push setDesiredPushType:SINPushTypeVoIP];

  self.callKitProvider = [[SINCallKitProvider alloc] init];

  void (^onUserDidLogin)(NSString *) = ^(NSString *userId) {
    [self initSinchClientWithUserId:userId];
  };

  [[NSNotificationCenter defaultCenter]
      addObserverForName:@"UserDidLoginNotification"
                  object:nil
                   queue:nil
              usingBlock:^(NSNotification *note) {
                NSString *userId = note.userInfo[@"userId"];
                [[NSUserDefaults standardUserDefaults] setObject:userId forKey:@"userId"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                onUserDidLogin(userId);
              }];

  [[NSNotificationCenter defaultCenter] addObserverForName:@"UserDidLogoutNotification"
                                                    object:nil
                                                     queue:nil
                                                usingBlock:^(NSNotification *note) {
                                                  self.client = nil;
                                                }];

    return YES;
}

- (void)classAlloc {
    NSLog(@"didFinishLaunchingWithOptions:");

//    [Sinch setLogCallback:^(SINLogSeverity severity, NSString *area, NSString *message, NSDate *timestamp) {
//      NSLog(@"[%@] %@", area, message);
//    }];

    self.push = [Sinch managedPushWithAPSEnvironment:SINAPSEnvironmentAutomatic];
    self.push.delegate = self;
    [self.push setDesiredPushType:SINPushTypeVoIP];

    self.callKitProvider = [[SINCallKitProvider alloc] init];

    void (^onUserDidLogin)(NSString *) = ^(NSString *userId) {
      [self initSinchClientWithUserId:userId];
    };

    [[NSNotificationCenter defaultCenter]
        addObserverForName:@"UserDidLoginNotification"
                    object:nil
                     queue:nil
                usingBlock:^(NSNotification *note) {
                  NSString *userId = note.userInfo[@"userId"];
                  [[NSUserDefaults standardUserDefaults] setObject:userId forKey:@"userId"];
                  [[NSUserDefaults standardUserDefaults] synchronize];
                  onUserDidLogin(userId);
                }];

    [[NSNotificationCenter defaultCenter] addObserverForName:@"UserDidLogoutNotification"
                                                      object:nil
                                                       queue:nil
                                                  usingBlock:^(NSNotification *note) {
                                                    self.client = nil;
                                                  }];
}



- (void)applicationWillEnterForeground:(UIApplication *)application {
  id<SINCall> call = [_callKitProvider currentEstablishedCall];

  // If there is one established call, show the callView of the current call when
  // the App is brought to foreground. This is mainly to handle the UI transition
  // when clicking the App icon on the lockscreen CallKit UI.
  if (call) {
    UIViewController *top = self.window.rootViewController;
    while (top.presentedViewController) {
      top = top.presentedViewController;
    }

    // When entering the application via the App button on the CallKit lockscreen,
    // and unlocking the device by PIN code/Touch ID, applicationWillEnterForeground:
    // will be invoked twice, and "top" will be CallViewController already after
    // the first invocation.
//    if (![top isMemberOfClass:[CallViewController class]]) {
//      [top performSegueWithIdentifier:@"callView" sender:call];
//    }
  }
}

#pragma mark -

- (void)initSinchClientWithUserId:(NSString *)userId {
  if (!_client) {
 
    _client = [Sinch clientWithApplicationKey:@"d7d43371-ba83-4742-b226-38c7e9cab583"
                            applicationSecret:@"NwXfZaWsyUmKroZKOKdAKA=="
                              environmentHost:@"clientapi.sinch.com"
                                       userId:userId];

    _client.delegate = self;
    _client.callClient.delegate = self;

    [_client setSupportCalling:YES];
    [_client enableManagedPushNotifications];

    _callKitProvider.client = _client;
    [_client start];
  }
}

- (void)handleRemoteNotification:(NSDictionary *)userInfo {
  if (!_client) {
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
    if (userId) {
      [self initSinchClientWithUserId:userId];
    }
  }

  [self.client relayRemotePushNotification:userInfo];
}

#pragma mark - SINManagedPushDelegate

- (void)managedPush:(id<SINManagedPush>)managedPush
    didReceiveIncomingPushWithPayload:(NSDictionary *)payload
                              forType:(NSString *)pushType {
  NSLog(@"didReceiveIncomingPushWithPayload: %@", payload.description);

  // Since iOS 13 the application must report an incoming call to CallKit if a
  // VoIP push notification was used, and this must be done within the same run
  // loop as the push is received (i.e. GCD async dispatch must not be used).
  // See https://developer.apple.com/documentation/pushkit/pkpushregistrydelegate/2875784-pushregistry .
  //[self.callKitProvider didReceivePushWithPayload:payload];
    [self.callKitProvider didReceivePushWithPayload:payload callidentifier:@"03460754392"];

  dispatch_async(dispatch_get_main_queue(), ^{
    [self handleRemoteNotification:payload];
    [self.push didCompleteProcessingPushPayload:payload];
  });
}



#pragma mark - SINCallClientDelegate

- (void)client:(id<SINCallClient>)client didReceiveIncomingCall:(id<SINCall>)call {
  // Find MainViewController and present CallViewController from it.
  UIViewController *top = self.window.rootViewController;
  while (top.presentedViewController) {
    top = top.presentedViewController;
  }
  [top performSegueWithIdentifier:@"callView" sender:call];
}

- (void)client:(id<SINClient>)client willReceiveIncomingCall:(id<SINCall>)call {
  [self.callKitProvider willReceiveIncomingCall:call];
}

#pragma mark - SINClientDelegate

- (void)clientDidStart:(id<SINClient>)client {
  NSLog(@"Sinch client started successfully (version: %@)", [Sinch version]);
}

- (void)clientDidFail:(id<SINClient>)client error:(NSError *)error {
  NSLog(@"Sinch client error: %@", [error localizedDescription]);
}

@end
