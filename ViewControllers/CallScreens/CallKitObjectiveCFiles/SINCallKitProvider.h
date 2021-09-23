//#import <CallKit/CallKit.h>
//#import <Foundation/Foundation.h>
//
//@protocol SINClient;
//@protocol SINCall;
//
//@interface SINCallKitProvider : NSObject <CXProviderDelegate>
//
//- (instancetype)initWithClient:(id<SINClient>)client;
//
//- (void)reportNewIncomingCall: (NSString*)identifier CallClientID:(id<SINCall>)call;
//
//- (void)didReceivePushWithPayload:(NSDictionary*)payload callidentifier: (NSString*)identifier;
//
//- (BOOL)callExists:(NSString*)callId;
//
//- (id<SINCall>)currentEstablishedCall;
//
//@end


#import <CallKit/CallKit.h>
#import <Foundation/Foundation.h>

@protocol SINClient;
@protocol SINCall;
@protocol SINCallNotificationResult;

@interface SINCallKitProvider : NSObject <CXProviderDelegate>

@property (strong, nonatomic) id<SINClient> client;

// This method can be used should be used since iOS 13 to comply with iOS 13 changes w.r.t VoIP push and requirement to
// report an incoming call to CallKit within the scope of the delegate method -[PKPushRegistryDelegte
// pushRegistry:didReceiveIncomingPushWith:forType:]. See
// https://developer.apple.com/documentation/pushkit/pkpushregistrydelegate/2875784-pushregistry for details.

  @property(strong, nonatomic)  NSMutableString *CallerNumber;
- (void)didReceivePushWithPayload:(NSDictionary*)payload callidentifier: (NSString*)identifier;

- (void)willReceiveIncomingCall:(id<SINCall>)call;

- (BOOL)callExists:(NSString*)callId;

- (id<SINCall>)currentEstablishedCall;

@end
