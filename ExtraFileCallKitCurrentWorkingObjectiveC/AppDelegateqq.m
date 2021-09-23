////03–07-2019
////working fine with push notification and backgroud calll
//
//
//
////VOIP
//
//
////
////  AppDelegate.swift
////  ZedChat
////
////  Created by MacBook Pro on 13/02/2019.
////  Copyright © 2019 MacBook Pro. All rights reserved.
////
//
//
//import CoreFoundation
//
//
//
//import UIKit
//import CoreData
//
//import GooglePlaces
//import GoogleMaps
//import Firebase
//import FirebaseMessaging
//
//import UserNotifications
//import UserNotificationsUI
//
//import Sinch
////For Call
//import CallKit
//import PushKit
//
//
//var sinmessage: SINMessage?
//var sincall: SINCall?
//var sinclientG: SINClient?
//var sinAudioController: SINAudioController?
//var sinVideoController: SINVideoController?
//var playerCall: AVAudioPlayer?
//var v = 0
//
//
//let callManager = CallManager()
//var providerDelegate: ProviderDelegate!
//@UIApplicationMain class AppDelegate: UIResponder, MessagingDelegate,UIApplicationDelegate, SINClientDelegate, SINCallClientDelegate, SINCallDelegate, SINAudioControllerDelegate, UNUserNotificationCenterDelegate, SINManagedPushDelegate, SINMessageClientDelegate, PKPushRegistryDelegate, CXProviderDelegate {
//    
//    var window: UIWindow?
//    
//    
//    class var shared: AppDelegate {
//        return UIApplication.shared.delegate as! AppDelegate
//    }
//    
//    
//    func displayIncomingCall(
//                             uuid: UUID,
//                             handle: String,
//                             hasVideo: Bool = false,
//                             completion: ((Error?) -> Void)?
//                             ) {
//        
//        providerDelegate.reportIncomingCall(
//                                            uuid: uuid,
//                                            handle: handle,
//                                            hasVideo: hasVideo,
//                                            completion: completion)
//        
//    }
//    var sinclient: SINClient?
//    var push: SINManagedPush?
//    
//    var tempapplication : UIApplication?
//    
//    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//        //        defaults.setValue("+923460754392", forKey: "userphone")
//        // defaults.setValue("1", forKey: "autologin")
//        
//        
//        
//        
//        
//        
//        // Override point for customization after application launch.
//        tempapplication = application
//        //Google Map Api
//        GMSServices.provideAPIKey("AIzaSyA-TXMTIe_VCg0gvPYQMjPw18ZlawVfW80")
//        //Google Places Api
//        GMSPlacesClient.provideAPIKey("AIzaSyA-TXMTIe_VCg0gvPYQMjPw18ZlawVfW80")
//        
//        if #available(iOS 10.0, *) {
//            // For iOS 10 display notification (sent via APNS)
//            UNUserNotificationCenter.current().delegate = self
//            
//            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
//            UNUserNotificationCenter.current().requestAuthorization(
//                                                                    options: authOptions,
//                                                                    completionHandler: {_, _ in
//                                                                        //register for voip notifications
//                                                                        
//                                                                    })
//        } else {
//            let settings: UIUserNotificationSettings =
//            UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
//            application.registerUserNotificationSettings(settings)
//            //register for voip notifications
//        }
//        
//        application.registerForRemoteNotifications()
//        // [END register_for_notifications]
//        
//        //MARK:- Firebase Configration
//        FirebaseApp.configure()
//        Messaging.messaging().delegate = self
//        Messaging.messaging().isAutoInitEnabled = true
//        // Add observer for InstanceID token refresh callback.
//        NotificationCenter.default.addObserver(self,
//                                               selector: #selector(self.tokenRefreshNotification),
//                                               name: NSNotification.Name.InstanceIDTokenRefresh,
//                                               object: nil)
//        
//        InstanceID.instanceID().instanceID { (result, error) in
//            if let error = error {
//                print("Error fetching remote instange ID: \(error)")
//            } else if let result = result {
//                print("Remote instance ID token: \(result.token)")
//                defaults.setValue(result.token, forKey: "fcmtoken")
//                defaults.setValue(result.instanceID, forKey: "fcmid")
//            }
//        }
//        connectToFcm()
//        // [END FireBase]
//        defaults.setValue("0", forKey: "sinclientG")
//        
//        ////////////--Notification Permisson End --- //////////////
//        
//        ////////////--Sinch Start Login Logout---//////////////
//        //Sinch User Logout Observer
//        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "SinchLogout"), object: nil, queue: nil, using: { (note: Notification?) in
//            
//            self.sinclient!.stop()
//            return
//        })
//        //Sinch User Login Observer
//        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "UserDidLoginNotification"), object: nil, queue: nil, using: { (note: Notification?) in
//            
//            let userID = note!.userInfo!["userID"] as! String
//            //userID = "pak"
//            if userID == ""
//            {
//                return
//            }
//            UserDefaults.standard.set(userID, forKey: "userID")
//            UserDefaults.standard.synchronize()
//            
//            self.initClient(userID: userID)
//            return
//        })
//        
//        //When Click on Sinch Call Notification Tap
//        var remotePush = launchOptions?[.remoteNotification] as? [AnyHashable: Any]
//        if remotePush != nil {
//            // Extract the Sinch-specific payload from the Apple Remote Push Notification
//            let payload = remotePush?["SIN"] as? String
//            // Get previously initiated Sinch client
//            weak var client: SINClient? = sinclient
//            weak var result: SINNotificationResult? = client?.relayRemotePushNotificationPayload(payload)
//            if ((result?.isCall) != nil) && (result?.call().isTimedOut)! {
//                // Present alert notifying about missed call
//                
//                
//            }
//            else if result?.isValid == nil {
//                // Handle error
//            }
//        }
//        ////////////////////////-- END SINCH ---/////////////////////////
//        
//        // allInstalledApp()
//        //MARK:- Save User Profile
//        saveUserProfileData(completion: { profileDict in
//            self.tempdic = profileDict!
//        })
//        
//        
//        //Call when click on Notification Tap
//        let remoteNotif = launchOptions?[UIApplication.LaunchOptionsKey.remoteNotification] as? [String: Any]
//        if remoteNotif != nil {
//            let aps = remoteNotif!["aps"] as? [String:AnyObject]
//            NSLog("\n Custom: \(String(describing: aps))")
//            
//            // scheduleNotification(event: "Incoming call", body: "test call notificaion", interval: 0.0)
//        }
//        else {
//            NSLog("//////////////////////////Normal launch")
//        }
//        // handleNotificationWhenAppIsKilled(launchOptions)
//        
//        //End Call from Call Kit User Login Observer
//        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "endCallAppDelegate"), object: nil, queue: nil, using: { (note: Notification?) in
//            playerCall?.stop()
//            sincall?.hangup()
//            return
//        })
//        
//        return true
//    }
//    
//    //        func handleNotificationWhenAppIsKilled(_ launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
//    //            // Check if launched from the remote notification and application is close
//    //            if let remoteNotification = launchOptions?[.remoteNotification] as?  [AnyHashable : Any] {
//    //                // Handle your app navigation accordingly and update the webservice as per information on the app.
//    //                 scheduleNotification(event: "Incoming call 15", body: "test call notificaion", interval: 0.5)
//    //            }
//    //            scheduleNotification(event: "Incoming call 15", body: "test call notificaion", interval: 0.5)
//    //        }
//    //        func SBSCopyApplicationDisplayIdentifiers(onlyActive: Bool, debuggable: Bool) -> CFArray? {
//    //
//    //        }
//    //
//    //    func main() -> Int {
//    //        let buf = [Int8](repeating: 0, count: 1024)
//    //        let ary = SBSCopyApplicationDisplayIdentifiers(onlyActive: false, debuggable: false)
//    //        for i in 0..<CFArrayGetCount(ary) {
//    //            CFStringGetCString(CFArrayGetValueAtIndex(ary, i), buf, MemoryLayout<buf>.size, CFStringBuiltInEncodings.UTF8)
//    //            print("\(buf)\n")
//    //        }
//    //        return 0
//    //    }
//    //
//    
//    var tempdic = NSMutableDictionary()
//    func applicationWillResignActive(_ application: UIApplication) {
//        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
//        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
//        
//    }
//    
//    func applicationDidEnterBackground(_ application: UIApplication) {
//        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
//        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
//        //Hide Keyboard
//        self.window?.endEditing(true)
//        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "stopPlayer"), object: nil)
//        if let tempuid = defaults.value(forKey: "uid") as? String
//        {
//            let timespam = Date().currentTimeMillis()!
//            
//            let tempkeyarray = tempdic.allKeys as NSArray
//            if tempkeyarray.contains("onLine")
//            {
//                tempdic.setValue(timespam, forKey: "onLine")
//            }
//            if tempkeyarray.contains("onLineUpdatedAt")
//            {
//                tempdic.setValue(timespam, forKey: "onLineUpdatedAt")
//            }
//            UserDB.child(tempuid).updateChildValues(tempdic as! [AnyHashable : Any])
//            print(tempdic)
//        }
//    }
//    
//    func applicationWillEnterForeground(_ application: UIApplication) {
//        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
//    }
//    
//    func applicationDidBecomeActive(_ application: UIApplication) {
//        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
//        
//        if let tempuid = defaults.value(forKey: "uid") as? String
//        {
//            var timespam = Date().currentTimeMillis()!
//            
//            let tempkeyarray = tempdic.allKeys as NSArray
//            if tempkeyarray.contains("onLineUpdatedAt")
//            {
//                tempdic.setValue(timespam, forKey: "onLineUpdatedAt")
//            }
//            timespam = 1
//            if tempkeyarray.contains("onLine")
//            {
//                tempdic.setValue(timespam, forKey: "onLine")
//            }
//            UserDB.child(tempuid).updateChildValues(tempdic as! [AnyHashable : Any])
//            print(tempdic)
//        }
//    }
//    
//    func applicationWillTerminate(_ application: UIApplication) {
//        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
//        // Saves changes in the application's managed object context before the application terminates.
//        self.saveContext()
//        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "stopPlayer"), object: nil)
//        if let tempuid = defaults.value(forKey: "uid") as? String
//        {
//            UserDB.child(tempuid).updateChildValues(self.tempdic as! [AnyHashable : Any])
//        }
//    }
//    
//    // MARK: - Core Data stack
//    lazy var persistentContainer: NSPersistentContainer = {
//        /*
//         The persistent container for the application. This implementation
//         creates and returns a container, having loaded the store for the
//         application to it. This property is optional since there are legitimate
//         error conditions that could cause the creation of the store to fail.
//         */
//        let container = NSPersistentContainer(name: "ZedChat")
//        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
//            if let error = error as NSError? {
//                // Replace this implementation with code to handle the error appropriately.
//                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//                
//                /*
//                 Typical reasons for an error here include:
//                 * The parent directory does not exist, cannot be created, or disallows writing.
//                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
//                 * The device is out of space.
//                 * The store could not be migrated to the current model version.
//                 Check the error message to determine what the actual problem was.
//                 */
//                fatalError("Unresolved error \(error), \(error.userInfo)")
//            }
//        })
//        return container
//    }()
//    
//    // MARK: - Core Data Saving support
//    
//    func saveContext () {
//        let context = persistentContainer.viewContext
//        if context.hasChanges {
//            do {
//                try context.save()
//            } catch {
//                // Replace this implementation with code to handle the error appropriately.
//                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//                let nserror = error as NSError
//                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
//            }
//        }
//    }
//    
//    
//    
//    
//    func handleRemoteNotification(_ userInfo: [AnyHashable : Any]?) {
//        if (self.sinclient == nil) {
//            if let userID = defaults.value(forKey: "userID") as? String
//            {
//                UserDefaults.standard.set(userID, forKey: "userID")
//                UserDefaults.standard.synchronize()
//                self.initClient(userID: userID)
//            }
//            else{
//                return
//            }
//        }
//        //sinclient!.relayRemotePushNotification(userInfo)
//        self.sinclient!.relayRemotePushNotification(userInfo)
//    }
//    
//    
//    //Local API Hit for Save User data in Firebase DB
//    func saveUserProfileData(completion: @escaping (_ profileDict: NSMutableDictionary?) -> Void)
//    {
//        if let tempuid = defaults.value(forKey: "uid") as? String
//        {
//            
//            UserDB.child(tempuid).observe(.value, with:{(snapshot) in
//                
//                UserDB.child(snapshot.key).removeAllObservers()
//                var timespam = Date().currentTimeMillis()!
//                
//                self.tempdic = snapshot.value as! NSMutableDictionary
//                let tempkeyarray = self.tempdic.allKeys as NSArray
//                if tempkeyarray.contains("onLine")
//                {
//                    self.tempdic.setValue(timespam, forKey: "onLine")
//                }
//                if tempkeyarray.contains("onLineUpdatedAt")
//                {
//                    self.tempdic.setValue(timespam, forKey: "onLineUpdatedAt")
//                }
//                
//                print(snapshot)
//                completion(self.tempdic)
//                timespam = 1
//                if tempkeyarray.contains("onLine")
//                {
//                    self.tempdic.setValue(timespam, forKey: "onLine")
//                }
//                UserDB.child(tempuid).updateChildValues(self.tempdic as! [AnyHashable : Any])
//            })
//        }
//    }
//    ////////End Local API Hit
//    ////////----Fire Base Handling----////////
//    func connectToFcm() {
//        Messaging.messaging().shouldEstablishDirectChannel = true
//    }
//    //MARK:- When Firebase Token Refresh
//    @objc func tokenRefreshNotification(_ notification: Notification)
//    {
//        InstanceID.instanceID().instanceID { (result, error) in
//            if let error = error {
//                print("Error fetching remote instange ID: \(error)")
//            } else if let result = result {
//                print("Remote instance ID token: \(result.token)")
//                defaults.setValue(result.token, forKey: "fcmtoken")
//                defaults.setValue(result.instanceID, forKey: "fcmid")
//            }
//        }
//        // Connect to FCM since connection may have failed when attempted before having a token.
//        connectToFcm()
//    }
//    /// This method will be called whenever FCM receives a new, default FCM token for your
//    /// Firebase project's Sender ID.
//    /// You can send this token to your application server to send notifications to this device.
//    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
//        defaults.set(fcmToken, forKey: "fcmtoken")
//        print(fcmToken)
//    }
//    //Firebase Message Receive when app in fore Ground Working
//    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
//        scheduleNotification(event: "ZedChat Call", body: callUser_Name + " is calling... 12", interval: 0.5)
//    }
//    ////////----End Fire Base Handling----////////
//    
//    open func relayRemotePushNotification(_ userInfo: [AnyHashable : Any]) {
//        DispatchQueue.main.async {
//            guard let result = self.sinclient?.relayRemotePushNotification(userInfo) else { return }
//            guard result.isCall() else { return }
//            debugPrint("result.isCall()", result.isCall())
//        }
//        scheduleNotification(event: "ZedChat Call", body: callUser_Name + " is calling... 12", interval: 0.5)
//    }
//    
//    //    func pushRegistry(_ registry: PKPushRegistry, didReceiveIncomingPushWith payload: PKPushPayload, for type: PKPushType, completion: @escaping () -> Void) {
//    //        guard type == .voIP else { return }
//    //        debugPrint("VOIPmanager didReceiveIncomingPushWith")
//    //        DispatchQueue.global(qos: .default).async {
//    //            //SinchManager.default.relayRemotePushNotification(payload.dictionaryPayload)
//    //        }
//    //    }
//    
//    
//    
//    
//    ///////////
//    func userNotificationCenter(_ center: UNUserNotificationCenter, openSettingsFor notification: UNNotification?) {
//        
//    }
//    
//    //MARK:- Remote Notification Registration Setting
//    var tempdevicetoken = Data()
//    func application(_ application: UIApplication,
//                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
//        Messaging.messaging().apnsToken = deviceToken as Data
//        
//        tempdevicetoken = deviceToken as Data
//        if (sinclient != nil)
//        {
//            
//        }
//        //        if (sinclient == nil){
//        //            let client = SINClient()
//        //
//        //        }
//        //        let client = SINClient()
//        self.push?.application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
//#if DEBUG
//        sinclient?.registerPushNotificationDeviceToken(deviceToken, type: "SINPushTypeVoIP", apsEnvironment: .development)
//        sinclientG?.registerPushNotificationDeviceToken(deviceToken, type: "SINPushTypeVoIP", apsEnvironment: .development)
//        // sinclient?.registerPushNotificationDeviceToken(deviceToken, type: "SINPushTypeVoIP", apsEnvironment: .development)
//#else
//        sinclient?.registerPushNotificationDeviceToken(deviceToken, type: "SINPushTypeVoIP", apsEnvironment: .production)
//        sinclientG?.registerPushNotificationDeviceToken(deviceToken, type: "SINPushTypeVoIP", apsEnvironment: .production)
//#endif
//        
//        
//        sinclient?.registerPushNotificationData(deviceToken)
//        sinclientG?.registerPushNotificationData(deviceToken)
//        
//        
//        //  self.sinclient?.registerPushNotificationData(deviceToken)
//    }
//    
//    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
//        //MARK:- If fail for Register Remote notification
//        print("application:didFailToRegisterForRemoteNotificationsWithError: %@", error)
//    }
//    
//    
//    
//    
//    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
//        //When tap on notification
//        scheduleNotification(event: "ZedChat Call", body: callUser_Name + " is calling... 11111", interval: 0.5)
//    }
//    
//    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
//        //scheduleNotification(event: "ZedChat Call", body: callUser_Name + " is calling... 13", interval: 0.1)
//        //       print("willPresent: \(notification.request.content.userInfo)")
//        completionHandler([.alert, .badge, .sound])
//    }
//    override func performSelector(inBackground aSelector: Selector, with arg: Any?) {
//        scheduleNotification(event: "ZedChat Call", body: callUser_Name + " is calling... 14", interval: 0.1)
//    }
//    
//    func application(_ application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: @escaping () -> Void) {
//        
//    }
//    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
//        
//    }
//    
//    //MARK:- Sinch Code Start
//    func clientDidStart(_ client: SINClient!) {
//        print("Sinch client started successfully\(String(describing: Sinch.version()))")
//        
//    }
//    
//    func clientDidFail(_ client: SINClient!, error: Error!) {
//        print("Sinch client error : \(error.localizedDescription)")
//    }
//    
//    func managedPush(_ managedPush: SINManagedPush!, didReceiveIncomingPushWithPayload payload: [AnyHashable : Any]!, forType pushType: String!) {
//        //scheduleNotification(event: "Incoming call 17", body: "test call notificaion", interval: 0.5)
//        let dic = payload as [AnyHashable : Any]
//        let sinchinfo = dic["sin"] as? String
//        if sinchinfo == nil {
//            // return
//        }
//        
//        //       let notif = UILocalNotification()
//        //        notif.alertBody = "incoming call"
//        //
//        //        UIApplication.shared.presentLocalNotificationNow(notif)
//        DispatchQueue.main.async{
//            // self.showCallNotification(payload: payload)
//        }
//        // scheduleNotification(event: "Incoming miscall 11", body: "", interval: 0.5)
//        
//        // self.sinclient!.relayRemotePushNotification(payload)
//        self.handleRemoteNotification(payload)
//        
//        // weak var client: SINClient? // get previously created client
//        
//        weak var result = sinclient?.relayRemotePushNotification(payload)
//        if result?.isCall() != nil && result?.call()?.isCallCanceled != nil {
//            // present a local notification for the missed call.
//            scheduleNotification(event: "ZedChat miss call", body: "", interval: 0.5)
//        }
//    }
//    
//    
//    
//    
//    func showCallNotification(payload: [AnyHashable : Any]!)
//    {
//        let datadic = payload! as NSDictionary
//        let type = ((datadic.value(forKey: "aps") as! NSDictionary).value(forKey: "alert") as! NSDictionary).value(forKey: "loc-key") as! String
//        
//        if type == "SIN_CANCEL_CALL"
//        {
//            if playerCall != nil
//            {
//                if playerCall!.isPlaying
//                {
//                    
//                }
//            }
//            stopAudio()
//            
//            for call in callManager.calls {
//                //call.end()
//                callManager.end(call: call)
//            }
//            callManager.removeAllCalls()
//        }
//        else if type == "SIN_INCOMING_CALL"
//        {
//            let sindatastr = datadic.value(forKey: "sin") as! String
//            
//            
//            let dict = convertToDictionary(text: sindatastr)
//            let tempcurrentnumber = (dict!["public_headers"] as! NSDictionary).value(forKey: "phoneNumber") as! String
//            
//            playSound()
//            if arrGuserphone.contains(tempcurrentnumber) == true
//            {
//                let index = arrGuserphone.index(of: tempcurrentnumber)
//                callUser_Name = arrGusername[index] as! String
//            }
//            else
//            {
//                callUser_Name = tempcurrentnumber
//            }
//            scheduleNotification(event: "ZedChat Call", body: callUser_Name + " is calling...", interval: 0.5)
//            
//            var bool = false
//            for _ in callManager.calls {
//                //call.end()
//                bool = true
//            }
//            if bool == true{
//                
//            }
//            else{
//                let state = UIApplication.shared.applicationState
//                if state != .active {
//                    //scheduleNotification(event: "Incoming call 00", body: "test call notificaion", interval: 0.5)
//                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "receiveBackGroundcall"), object: nil)
//                }
//            }
//        }
//    }
//    
//    
//    
//    
//    func convertToDictionary(text: String) -> [String: Any]? {
//        if let data = text.data(using: .utf8) {
//            do {
//                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
//            } catch {
//                print(error.localizedDescription)
//            }
//        }
//        return nil
//    }
//    
//    
//    
//    func messageClient(_ messageClient: SINMessageClient!, didReceiveIncomingMessage message: SINMessage!) {
//        
//    }
//    
//    func messageSent(_ message: SINMessage!, recipientId: String!) {
//        
//    }
//    
//    func messageDelivered(_ info: SINMessageDeliveryInfo!) {
//        
//    }
//    
//    func messageFailed(_ message: SINMessage!, info messageFailureInfo: SINMessageFailureInfo!) {
//        
//    }
//    
//    
//    
//    func call(_ call: SINCall!, shouldSendPushNotifications pushPairs: [Any]!) {
//        
//    }
//    func message(_ message: SINMessage!, shouldSendPushNotifications pushPairs: [Any]!) {
//        
//    }
//    
//    func client(_ client: SINCallClient!, localNotificationForIncomingCall call: SINCall!) -> SINLocalNotification! {
//        
//        
//        ///scheduleNotification(event: "Incoming miscall", body: "", interval: 0.5)
//        
//        
//        DispatchQueue.main.async{
//            // self.showCallNotification(payload: payload)
//        }
//        var bool = false
//        for _ in callManager.calls {
//            //call.end()
//            bool = true
//        }
//        if bool == true{
//            
//        }
//        else{
//            let state = UIApplication.shared.applicationState
//            if state != .active {
//                //scheduleNotification(event: "Incoming call 00", body: "test call notificaion", interval: 0.5)
//                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "receiveBackGroundcall"), object: nil)
//            }
//        }
//        
//        let datadic = call.headers as NSDictionary
//        if datadic.count != 0
//        {
//            callUser_Name = datadic.value(forKey: "current_username") as! String
//        }
//        
//        
//        let notification = SINLocalNotification()
//        notification.alertAction = "Answer"
//        notification.alertBody = "Incomming call"
//        //triggerNotification(countNo: "1")
//        return notification
//    }
//    
//    func client(_ client: SINCallClient!, willReceiveIncomingCall call: SINCall!) {
//        var bool = false
//        
//        print("will receive call")
//        for _ in callManager.calls {
//            //call.end()
//            bool = true
//        }
//        if bool == true{
//            
//        }
//        else{
//            let state = UIApplication.shared.applicationState
//            if state != .active {
//                //scheduleNotification(event: "Incoming call 00", body: "test call notificaion", interval: 0.5)
//                //   NotificationCenter.default.post(name: NSNotification.Name(rawValue: "receiveBackGroundcall"), object: nil)
//            }
//        }
//    }
//    func client(_ client: SINCallClient!, didReceiveIncomingCall call: SINCall!) {
//        let state = UIApplication.shared.applicationState
//        
//        sincall = call
//        sinVideoController = sinclientG?.videoController()
//        sinAudioController = sinclientG?.audioController()
//        
//        playSound()
//        
//        if state == .background {
//            print("App in Background")
//            //            let notification = UILocalNotification()
//            //            notification.fireDate = NSDate(timeIntervalSinceNow: 0) as Date
//            //            notification.alertBody = "Hey you! Yeah you! Swipe to unlock !8"
//            //            notification.alertAction = "be awesome!"
//            //            notification.soundName = UILocalNotificationDefaultSoundName
//            //            notification.userInfo = ["CustomField1": "w00t"]
//            //            UIApplication.shared.scheduleLocalNotification(notification)
//            var bool = false
//            for _ in callManager.calls {
//                //call.end()
//                bool = true
//            }
//            if bool == true{
//                
//            }
//            else{
//                let state = UIApplication.shared.applicationState
//                if state != .active {
//                    //scheduleNotification(event: "Incoming call 00", body: "test call notificaion", interval: 0.5)
//                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "receiveBackGroundcall"), object: nil)
//                }
//            }
//            
//        }
//        else if state == .inactive
//        {
//            let notification = UILocalNotification()
//            notification.fireDate = NSDate(timeIntervalSinceNow: 0) as Date
//            notification.alertBody = "Hey you! Yeah you! Swipe to unlock ! Inactiwe"
//            notification.alertAction = "be awesome!"
//            notification.soundName = UILocalNotificationDefaultSoundName
//            notification.userInfo = ["CustomField1": "w00t"]
//            UIApplication.shared.scheduleLocalNotification(notification)
//            //scheduleNotification(event: call.remoteUserId, body: ".inactive", interval: 0.5)
//        }
//        else if state == .active
//        {
//            //            DispatchQueue.main.async {
//            //                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "receivecall"), object: nil)
//            //            }
//            let app =  UIApplication.shared.delegate as! AppDelegate
//            DispatchQueue.main.async {
//                app.applicationDidBecomeActive(UIApplication.shared)
//            }
//            //playSound()
//            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "receivecall"), object: nil)
//            
//            // scheduleNotification(event: call.remoteUserId, body: ".active", interval: 0.5)
//            
//            
//            
//        }
//        else
//        {
//            //let top = self.window?.rootViewController
//            //        while ((top?.presentedViewController) != nil) {
//            //            sincall = call
//            //            sinclientG = client as? SINClient
//            //            sinVideoController = sinclient?.videoController()
//            //            sinAudioController = sinclient?.audioController()
//            //            playSound()
//            //            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "receivecall"), object: nil)
//            //        }
//            
//            // scheduleNotification(event: call.remoteUserId, body: ".active else", interval: 0.5)
//            
//        }
//    }
//    
//    
//    
//    // MARK: Required Stuff
//    func initClient(userID:String){
//        //ZedChat id
//        //self.sinclient = Sinch.client(withApplicationKey: "349a5b43-8741-4872-b936-2415995f2520",
//        //            applicationSecret: "Vu0lxlYe4UuYvZPYv2U/jw==",
//        //             environmentHost: "clientapi.sinch.com",
//        //environmentHost: "sandbox.sinch.com",
//        //                userId: userID)
//        
//        //Mohsin Javaid Account \(APPBUILDNAME) Key
//        self.sinclient = Sinch.client(withApplicationKey: "d7d43371-ba83-4742-b226-38c7e9cab583",
//                                      applicationSecret: "NwXfZaWsyUmKroZKOKdAKA==",
//                                      environmentHost: "clientapi.sinch.com",
//                                      //environmentHost: "sandbox.sinch.com",
//                                      userId: userID)
//        //Zeeshan Key
//        //        self.sinclient = Sinch.client(withApplicationKey: "349a5b43-8741-4872-b936-2415995f2520",
//        //                                      applicationSecret: "Vu0lxlYe4UuYvZPYv2U/jw==",
//        //                                      environmentHost: "clientapi.sinch.com",
//        //                                      //environmentHost: "sandbox.sinch.com",
//        //            userId: userID)
//        
//        sincall?.delegate = self
//        sinclient!.call().delegate = self
//        //sinclient?.messageClient().delegate = self
//        if defaults.value(forKey: "sinclientG") as? String == "0"
//        {
//            defaults.setValue("1", forKey: "sinclientG")
//            // sinclientG?.call().delegate = self
//        }
//        sinclient!.setSupportCalling(true)
//        //sinclient!.setSupportMessaging(true)
//        sinclient!.setSupportPushNotifications(true)
//        sinclient!.setPushNotificationDisplayName("Test Name")
//        sinclient!.enableManagedPushNotifications()
//        self.sinclient!.start()
//        
//        //self.sinclient!.setSupportActiveConnectionInBackground(true)
//        
//        
//        
//        
//        
//        
//        DispatchQueue.main.async(execute: {
//            DispatchQueue.main.async{
//                sinclientG = self.sinclient!
//                sinclientG?.call().delegate = self
//                // sinclientG?.messageClient().delegate = self
//                
//                self.sinclient!.startListeningOnActiveConnection()
//                sinclientG?.startListeningOnActiveConnection()
//                
//                providerDelegate = ProviderDelegate(callManager: callManager)
//                
//                DispatchQueue.main.async {
//                    self.registerForVoIPPushes()
//                }
//            }
//        })
//    }
//    ///////////////////////////////////////////////////
//    //    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
//    //       // scheduleNotification(event: "", body: "didReceiveIncomingPushWith payload", interval: 0.5)
//    //       //  scheduleNotification(event: notification.request.content.title, body: notification.request.content.body, interval: 0.5)
//    //    }
//    //MARK:- Apple Push Receive code in BackGround
//    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
//                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
//        // If you are receiving a notification message while your app is in the background,
//        // this callback will not be fired till the user taps on the notification launching the application.
//        // TODO: Handle data of notification
//        
//        // With swizzling disabled you must let Messaging know about the message, for Analytics
//        // Messaging.messaging().appDidReceiveMessage(userInfo)
//        var bool = false
//        for _ in callManager.calls {
//            //call.end()
//            bool = true
//        }
//        if bool == true{
//            
//        }
//        else{
//            let state = UIApplication.shared.applicationState
//            if state != .active {
//                //scheduleNotification(event: "Incoming call 00", body: "test call notificaion", interval: 0.5)
//                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "receiveBackGroundcall"), object: nil)
//            }
//        }
//        
//        // Print message ID.
//        print("Message ID: 2")
//        if let messageID = userInfo[""] {
//            print("Message ID: \(messageID)")
//        }
//        
//        // Print full message.
//        print(userInfo)
//        
//        completionHandler(UIBackgroundFetchResult.newData)
//    }
//    
//    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
//        // If you are receiving a notification message while your app is in the background,
//        // this callback will not be fired till the user taps on the notification launching the application.
//        // TODO: Handle data of notification
//        
//        // With swizzling disabled you must let Messaging know about the message, for Analytics
//        print("Message ID:")
//        Messaging.messaging().appDidReceiveMessage(userInfo)
//        scheduleNotification(event: "Incoming call", body: "test call notificaion 1", interval: 0.0)
//        // Print message ID.
//        if let messageID = userInfo[""] {
//            print("Message ID: \(messageID)")
//        }
//        
//        // Print full message.
//        print(userInfo)
//        if push != nil
//        {
//            
//        }
//        push!.application(application, didReceiveRemoteNotification: userInfo)
//    }
//    
//    
//    
//    //MARK:- Handle Message for foreground
//    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
//        // Let FCM know about the message for analytics etc.
//        Messaging.messaging().appDidReceiveMessage(userInfo)
//        // handle your message
//        // scheduleNotification(event: "Incoming call", body: "test call notificaion 2", interval: 0.0)
//        // NotificationCenter.default.post(name: NSNotification.Name(rawValue: "receiveBackGroundcall"), object: nil)
//        completionHandler(UIBackgroundFetchResult.newData)
//    }
//    /////////////
//    //MARK:- Apple Push Receive code in ForeGround
//    
//    
//    private func application(_ application: UIApplication, didReceive notification: UNNotification) {
//        
//        scheduleNotification(event: "Incoming call", body: "test call notificaion 3", interval: 0.0)
//    }
//    //    //MARK:- Push Kit
//    //    func pushRegistry(_ registry: PKPushRegistry, didReceiveIncomingPushWith payload: PKPushPayload, for type: PKPushType, completion: @escaping () -> Void) {
//    //        let datadic = payload.dictionaryPayload
//    //        //scheduleNotification(event: "", body: "didReceiveIncomingPushWith payload completion", interval: 0.5)
//    //        showCallNotification(payload: datadic)
//    //    }
//    
//    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
//        
//        return true
//    }
//    
//    
//    
//    //MARK:- Local Function
//    func playSound() {
//        guard let url = Bundle.main.url(forResource: "incomming", withExtension: "mp3") else { return }
//        
//        do {
//            
//            do {
//                try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
//                try AVAudioSession.sharedInstance().setActive(true)
//            } catch {
//                print(error)
//            }
//            //MARK:- Old Version
//            //
//            //            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category(rawValue: convertFromAVAudioSessionCategory(AVAudioSession.Category.playback)), mode: .default)
//            //            try AVAudioSession.sharedInstance().setActive(true)
//            
//            /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
//            playerCall = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
//            
//            /* iOS 10 and earlier require the following line:
//             player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3) */
//            
//            guard let playerCall = playerCall else { return }
//            playerCall.play()
//            
//        } catch let error {
//            print(error.localizedDescription)
//        }
//    }
//    
//    //    func scheduleNotification (event : String, body: String, interval: TimeInterval) {
//    //        // self.playSound()
//    //        let content = UNMutableNotificationContent()
//    //
//    //        content.title = event
//    //        content.body = body
//    //        content.sound = UNNotificationSound.default
//    //        content.categoryIdentifier = "CALLINNOTIFICATION"
//    //        let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: interval, repeats: false)
//    //        let identifier = "id_"+event
//    //        let request = UNNotificationRequest.init(identifier: identifier, content: content, trigger: trigger)
//    //
//    //        let center = UNUserNotificationCenter.current()
//    //        center.add(request, withCompletionHandler: { (error) in
//    //            print(request)
//    //            print(error)
//    //        })
//    //
//    //    }
//    //
//    func scheduleNotification (event : String, body: String, interval: TimeInterval) {
//        // self.playSound()
//        let content = UNMutableNotificationContent()
//        
//        content.title = event
//        if body == ""{
//            content.body = ""
//        }
//        else{
//            content.body = body
//        }
//        //  content.sound = .default
//        content.sound = UNNotificationSound.init(named: UNNotificationSoundName(rawValue: "incomming.mp3")) // .default //
//        
//        //scheduleNotification(event: "Incoming miscall 11", body: "", interval: 0.5)
//        content.categoryIdentifier = "CALLINNOTIFICATION"
//        let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: interval, repeats: false)
//        let identifier = "id_"+event
//        let request = UNNotificationRequest.init(identifier: identifier, content: content, trigger: trigger)
//        
//        let center = UNUserNotificationCenter.current()
//        center.add(request, withCompletionHandler: { (error) in
//            print(request)
//            print(error as Any)
//            
//        })
//        
//    }
//    //  Converted to Swift 5 by Swiftify v5.0.24923 - https://objectivec2swift.com/
//    static let allInstalledAppCacheFileName = "com.apple.mobile.installation.plist"
//    
//    func allInstalledApp() {
//        
//        //  Converted to Swift 5 by Swiftify v5.0.24923 - https://objectivec2swift.com/
//        var appList: [String]? = nil
//        do {
//            
//            let appFolderContents = try FileManager.default.subpathsOfDirectory(atPath: "/private/var/mobile/Applications")
//            
//            let appFolderContents2 = FileManager.default.currentDirectoryPath
//            let appFolderContents3 = try FileManager.default.contentsOfDirectory(atPath: "/Applications")
//            
//            appList = try FileManager.default.contentsOfDirectory(atPath: AppDelegate.allInstalledAppCacheFileName)
//            print(appList)
//        } catch {
//            
//        }
//        
//        
//        /////
//        //        var cacheDict: [AnyHashable : Any]
//        //
//        //        var user: [AnyHashable : Any]
//        //
//        //        let relativeCachePath = URL(fileURLWithPath: URL(fileURLWithPath: "Library").appendingPathComponent("Caches").absoluteString).appendingPathComponent(AppDelegate.allInstalledAppCacheFileName).absoluteString
//        //
//        //        let path = URL(fileURLWithPath: URL(fileURLWithPath: NSHomeDirectory()).appendingPathComponent("../..").absoluteString).appendingPathComponent(relativeCachePath).absoluteString
//        //
//        //        cacheDict = NSDictionary(contentsOfFile: path) as! [AnyHashable : Any]
//        //
//        //        if let object = cacheDict["User"] as? [AnyHashable : Any] {
//        //            user = object
//        //        }
//        //
//        //        let systemApp = cacheDict["System"] as? [AnyHashable : Any]
//    }
//    
//    
//    //    func SBSCopyApplicationDisplayIdentifiers(onlyActive: Bool, debuggable: Bool) -> CFArray? {
//    //    }
//    
//    //    func main() -> Int {
//    //        let buf = [1024]
//    //        let ary = SBSCopyApplicationDisplayIdentifiers(onlyActive: false, debuggable: false)
//    //        for i in 0..<CFArrayGetCount(ary) {
//    //            CFStringGetCString(CFArrayGetValueAtIndex(ary, i), buf, MemoryLayout<buf>.size, CFStringBuiltInEncodings.UTF8)
//    //            print("\(buf)\n")
//    //        }
//    //        return 0
//    //    }
//    
//    
//    
//    
//    
//    //End PushKit
//    ////////////////////
//    func registerForVoIPPushes() {
//        
//        let mainQueue = DispatchQueue.main
//        let voipRegistry = PKPushRegistry(queue: mainQueue)
//        // Create a push registry object
//        // Set the registry's delegate to self
//        voipRegistry.delegate = self
//        // Set the push type to VoIP
//        voipRegistry.desiredPushTypes = [PKPushType.voIP]
//        
//#if DEBUG
//        self.push = Sinch.managedPush(with: SINAPSEnvironment.development)
//#else
//        self.push = Sinch.managedPush(with: SINAPSEnvironment.production)
//#endif
//        self.push?.delegate = self
//        self.push?.setDesiredPushTypeAutomatically()
//        self.push?.registerUserNotificationSettings()
//    }
//    
//    func providerDidReset(_ provider: CXProvider) {
//        
//    }
//    
//    func provider(_ provider: CXProvider, perform action: CXAnswerCallAction) {
//        // configure audio session
//        for call in callManager.calls {
//            //call.end()
//            callManager.end(call: call)
//        }
//        action.fulfill()
//    }
//    func provider(_ provider: CXProvider, perform action: CXEndCallAction) {
//        playerCall?.stop()
//        sincall?.hangup()
//        DispatchQueue.main.async {
//            NotificationCenter.default.post(name: Notification.Name("callendnotficication"), object: nil, userInfo: nil)
//        }
//        action.fulfill()
//    }
//    
//    func client(_ client: SINClient!, requiresRegistrationCredentials registrationCallback: SINClientRegistration!) {
//        
//    }
//    
//    //    func pushRegistry(_ registry: PKPushRegistry, didUpdate pushCredentials: PKPushCredentials, for type: PKPushType) {
//    //        print(pushCredentials.token.map { String(format: "%02.2hhx", $0) }.joined())
//    //    }
//    
//    
//    func pushRegistry(_ registry: PKPushRegistry, didUpdate pushCredentials: PKPushCredentials, for type: PKPushType) {
//        
//        if type == PKPushType.voIP {
//            sinclient?.registerPushNotificationData(pushCredentials.token as Data?)
//            sinclientG?.registerPushNotificationData(pushCredentials.token as Data?)
//            
//            DispatchQueue.main.async {
//                //                sinclientG = self.sinclient!
//                //                sinclientG?.call().delegate = self
//                
//                self.sinclient!.startListeningOnActiveConnection()
//                sinclientG?.startListeningOnActiveConnection()
//                
//                //  self.registerForVoIPPushes()
//            }
//            
//        }
//        push?.application(UIApplication.shared, didRegisterForRemoteNotificationsWithDeviceToken: pushCredentials.token as Data?)
//    }
//    
//    func pushRegistry(_ registry: PKPushRegistry, didReceiveIncomingPushWith payload: PKPushPayload, for type: PKPushType) {
//        // report new incoming call
//        var bool = false
//        for _ in callManager.calls {
//            //call.end()
//            bool = true
//        }
//        if bool == true{
//            
//        }
//        else{
//            let state = UIApplication.shared.applicationState
//            if state != .active {
//                //scheduleNotification(event: "Incoming call 00", body: "test call notificaion", interval: 0.5)
//                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "receiveBackGroundcall"), object: nil)
//            }
//        }
//        triggerNotification(countNo: "2")
//        if (self.sinclient == nil) {
//            if let userID = defaults.value(forKey: "userID") as? String
//            {
//                UserDefaults.standard.set(userID, forKey: "userID")
//                UserDefaults.standard.synchronize()
//                self.initClient(userID: userID)
//            }
//            else{
//                return
//            }
//        }
//        //sinclient!.relayRemotePushNotification(userInfo)
//        self.sinclient!.relayRemotePushNotification(payload.dictionaryPayload)
//    }
//    
//    // @available(iOS 11.0, *)
//    //    func pushRegistry(_ registry: PKPushRegistry, didReceiveIncomingPushWith payload: PKPushPayload, for type: PKPushType, completion: @escaping () -> Void) {
//    //        // scheduleNotification(event: "", body: "didReceiveIncomingPushWith payload", interval: 0.5)
//    //        //Working Code
//    ////        let config = CXProviderConfiguration(localizedName: "ZedChat")
//    ////        config.iconTemplateImageData = UIImage(named: "user")!.pngData()
//    ////        config.ringtoneSound = "incomming.mp3"
//    ////        config.includesCallsInRecents = false;
//    ////        config.supportsVideo = true;
//    ////        let provider = CXProvider(configuration: config)
//    ////        provider.setDelegate(self, queue: nil)
//    ////        let update = CXCallUpdate()
//    ////        update.remoteHandle = CXHandle(type: .generic, value: "Pete Za")
//    ////        update.hasVideo = true
//    ////        provider.reportNewIncomingCall(with: UUID(), update: update, completion: { error in })
//    ////
//    //        /////
//    //        let datadic = payload.dictionaryPayload
//    //        //scheduleNotification(event: "", body: "didReceiveIncomingPushWith payload completion", interval: 0.5)
//    //        // showCallNotification(payload: datadic)
//    //        var bool = false
//    //        for _ in callManager.calls {
//    //            //call.end()
//    //            bool = true
//    //        }
//    //        if bool == true{
//    //
//    //        }
//    //        else{
//    //            let state = UIApplication.shared.applicationState
//    //            if state != .active {
//    //                //scheduleNotification(event: "Incoming call 00", body: "test call notificaion", interval: 0.5)
//    //                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "receiveBackGroundcall"), object: nil)
//    //            }
//    //        }
//    //        //scheduleNotification(event: "Incoming call", body: "test call notificaion 3", interval: 0.0)
//    //        DispatchQueue.main.async{
//    //            self.showCallNotification(payload: payload.dictionaryPayload)
//    //        }
//    //    }
//    
//    func pushRegistry(_ registry: PKPushRegistry, didInvalidatePushTokenFor type: PKPushType) {
//        // scheduleNotification(event: "", body: "didInvalidatePushTokenFor type", interval: 0.5)
//    }
//    
//    ////////////////////--------User Notification--------///////////////////
//    func triggerNotification(countNo: String){
//        let content = UNMutableNotificationContent()
//        content.title = NSString.localizedUserNotificationString(forKey: "Elon said: \(countNo)", arguments : nil)
//        content.body = NSString.localizedUserNotificationString(forKey: "Hello Tom！Get up, let's play with Jerry!", arguments: nil)
//        content.sound = UNNotificationSound.default
//        content.badge = UIApplication.shared.applicationIconBadgeNumber + 1 as NSNumber;
//        content.categoryIdentifier = "com.elonchan.localNotification"
//        // Deliver the notification in 60 seconds.
//        let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: 5.0, repeats: false)
//        let request = UNNotificationRequest.init(identifier: "FiveSecond", content: content, trigger: trigger)
//        
//        // Schedule the notification.
//        let center = UNUserNotificationCenter.current()
//        center.add(request)
//    }
//    
//    func stopNotification(_ sender: AnyObject) {
//        let center = UNUserNotificationCenter.current()
//        center.removeAllPendingNotificationRequests()
//        // or you can remove specifical notification:
//        // center.removePendingNotificationRequests(withIdentifiers: ["FiveSecond"])
//    }
//    
//}
//
////  The converted code is limited to 1 KB.
////  Please Sign Up (Free!) to double this limit.
////
////  Converted to Swift 5 by Swiftify v5.0.24923 - https://objectivec2swift.com/
//private let installedAppListPath = "/private/var/mobile/Library/Caches/com.apple.mobile.installation.plist"
////
//
////
////  The converted code is limited to 1 KB.
////  Please Sign Up (Free!) to double this limit.
////
////  %< ----------------------------------------------------------------------------------------- %<
//
////extension SinchManager {
////
////    open func activeAudioSession(_ provider: CXProvider, audioSession: AVAudioSession) {
////        sinclientG?.call().provider(provider, didActivate: audioSession)
////    }
////
////}
