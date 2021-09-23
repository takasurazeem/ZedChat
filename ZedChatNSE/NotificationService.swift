//
//  NotificationService.swift
//  ServiceExtension
//
//  Created by Jayesh Thanki on 26/12/18.
//  Copyright © 2018 Logistic Infotech Pvt. Ltd. All rights reserved.
//

import UserNotifications
import UIKit
import Contacts
import Firebase
import FirebaseDatabase
import FirebaseAuth
import Alamofire


var BASEURL_IMAGES = "https://chatapi.aonechat.com/Media/"
public var USER_IMAGE_PATH = BASEURL_IMAGES + "UserImages/";
public var GROUP_IMAGE_PATH = BASEURL_IMAGES + "GroupImages/";
public var GROUPNAME = "group.Zaryans.ZedChat"
let group_defaults = UserDefaults(suiteName: GROUPNAME)!
var CONTACTKEY = [CNContactFormatter.descriptorForRequiredKeys(for: CNContactFormatterStyle.fullName), CNContactGivenNameKey,CNContactFamilyNameKey,CNContactMiddleNameKey,CNContactEmailAddressesKey,CNContactPhoneNumbersKey,CNContactImageDataAvailableKey,CNContactThumbnailImageDataKey] as! [CNKeyDescriptor]
var UID = group_defaults.value(forKey: "uid") as! String
var USERID = group_defaults.value(forKey: "userid") as? String
var CUSTOM_AUTHENTICATION = "https://chatapi.aonechat.com/api/user/GetToken?userid=\(group_defaults.object(forKey: "phoneNumber") as! String)&uid=\(group_defaults.object(forKey: "uid") as! String)"
//
var refFireBase = Database.database().reference()
let MessagesDB = refFireBase.child("Messages")
let ChatDB = refFireBase.child("Chat")
let DELIVERED = 3;
var GlobalFireBaseverficationID = String()









class NotificationService: UNNotificationServiceExtension {
    var contentHandler: ((UNNotificationContent) -> Void)?
    var receivedRequest: UNNotificationRequest!
    var bestAttemptContent: UNMutableNotificationContent?
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        print("Notification being triggered")
        completionHandler( [.alert,.sound,.badge])
    }
    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
    
     //   let useruid = UserDefaults(suiteName: "group.Zaryans.ZedChat")?.value(forKey: "uid") as! String
        
//        do {
//            
//           // try Auth.auth().useUserAccessGroup(GROUPNAME)
//        } catch let error as NSError {
//            
//        }
        FirebaseApp.app()
        //MARK:- Firebase Configration
        if let _ = FirebaseApp.app() { } else {
            FirebaseApp.configure()
        }
        
        self.receivedRequest = request;
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)

        if bestAttemptContent!.title == "audioservice" || bestAttemptContent!.title == "videoservice" {
            return
        }
        if bestAttemptContent!.title == "DeviceAuthentication"{
            funDeviceRegister()
            return
        }
        guard let content = (request.content.mutableCopy() as? UNMutableNotificationContent) else {
            contentHandler(request.content)
            return
        }

        guard let apnsData = content.userInfo as? [String: Any] else {
           contentHandler(request.content)
            return
        }

        var tempSenderImage = ""
        let MessagerNumber = apnsData["gcm.notification.froma"] as? String ?? ""
        
        if let temp = apnsData["gcm.notification.profilePic"] as? String{
            tempSenderImage = temp
        }
        let tempGroupType = apnsData["gcm.notification.groupType"] as? String ?? ""
        let tempLastMessageID = apnsData["gcm.notification.messageId"] as? String ?? ""
        let tempGroupId = apnsData["gcm.notification.groupFireBaseId"] as? String ?? ""
        let tempMessegerId = apnsData["gcm.notification.firebaseId"] as? String ?? ""

        let data = ["messageId":tempLastMessageID,
                    "groupType":tempGroupType,
                    "groupId":tempGroupId,
                    "messegerId":tempMessegerId]
        //MARK:- Update Delivery Status
        let userid = Auth.auth().currentUser?.uid
        if userid == nil {
            self.funGetCustomeTokenForAuthentication() { authCustomToken in
                guard let authCustomToken = authCustomToken else { return }
                if authCustomToken != "error"{
                    Auth.auth().signIn(withCustomToken: authCustomToken) { (user, error) in
                        // ...
                        self.isdeliver(datadic: data as NSDictionary)
                    }
                }
            }
//           // funDeviceRegister()
//            let decoded = group_defaults.object(forKey: "firebasecredential") as! Data
//            let credential = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! PhoneAuthCredential
//            print(credential)
//            Auth.auth().addStateDidChangeListener { (auth, user) in
//                // ...
//                print(auth as Any)
//                print(user as Any)
//            }
//            Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
//                print(error as Any)
//                 if error != nil {
//
//                    return
//                }
//                else
//                {
//                    self.isdeliver(datadic: data as NSDictionary)
//                }
//            }
            
        }else{
            self.isdeliver(datadic: data as NSDictionary)
        }
        var imageUrl = ""
        if tempGroupType == "Private Chat" {
            
            imageUrl = USER_IMAGE_PATH + tempSenderImage
        }
        else if tempGroupType == "Public Group" {
            
            imageUrl = GROUP_IMAGE_PATH + tempSenderImage
        }
        else{

        }
//        print(MessagerNumber)
//        print(apnsData)
        let MessagerName = getContactNameFromNumber(contactNumber: MessagerNumber)

        //MARK:- Attaching Phone number
        bestAttemptContent!.title = "\(String(describing: MessagerName))"

        do {
            let imageData = try Data(contentsOf: URL(string: imageUrl)!)
            guard let attachment = UNNotificationAttachment.create(imageFileIdentifier: tempSenderImage, data: imageData, options: nil) else {
                contentHandler(bestAttemptContent!)
                //contentHandler(request.content)
                return
            }
           // content.attachments = [attachment]
            bestAttemptContent!.attachments = [attachment]
            //MARK:- if the below code will not run then sender image will not show
          //  contentHandler(content.copy() as! UNNotificationContent)

        } catch {
            contentHandler(bestAttemptContent!)
            // contentHandler(request.content)
            print("Unable to load data: \(error)")
        }
        if let bestAttemptContent = bestAttemptContent {
            DispatchQueue.main.async {
                contentHandler(bestAttemptContent)
            }
            return
        }
        return
        ////////////////////////
    }
    
    override func serviceExtensionTimeWillExpire() {
        // Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }
    
    func funDeviceRegister(){
       // let phoneNumber = group_defaults.object(forKey: "phoneNumber") as! String
        
        // This test verification code is specified for the given test phone number in the developer console.
//        let testVerificationCode = "123456"
//        
//        Auth.auth().settings!.isAppVerificationDisabledForTesting = true
//        PhoneAuthProvider.provider()
//            .verifyPhoneNumber(phoneNumber, uiDelegate:nil) {
//            verificationID, error in
//            if ((error) != nil) {
//                // Handles error
//
//                return
//            }
//            let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID ?? "",
//                                                                     verificationCode: testVerificationCode)
//                
//            Auth.auth().signInAndRetrieveData(with: credential) { authData, error in
//                if ((error) != nil) {
//                    // Handles error
//                    return
//                }
//            }
//        }
        
        
       // Auth.auth().shouldGroupAccessibilityChildren = true

        let userid = Auth.auth().currentUser
        if userid == nil{
            if let decodedCurrentUser = group_defaults.object(forKey: "currentUser") as? Data {
                if let currentUser = NSKeyedUnarchiver.unarchiveObject(with: decodedCurrentUser) as? User {
                    let decoded = group_defaults.object(forKey: "firebasecredential") as! Data
                    let credential = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! PhoneAuthCredential
                    print(credential)
                    currentUser.reauthenticate(with: credential, completion: { (request, error) in
                        //print(request)
                        //print(error)
                    })
                }
            }
            
//            Auth.auth().currentUser?.linkAndRetrieveData(with: credential, completion: {
//                response, error in
//
//                print(response)
//                print(error)
//            })
            
            
//            Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
//                print(error as Any)
//                if error != nil {
//
//
//                }
//                else
//                {
//
//                }
//            }
        }
    }
    
    //MARK:- Find Contact Name from Number in Phone
    func getContactNameFromNumber(contactNumber: String) -> String {
        var contactName = String()
        let contactStore = CNContactStore()
        let t = CNPhoneNumber.init(stringValue: contactNumber)
        
        var predicate = CNContact.predicateForContacts(withIdentifiers: [contactNumber])
        if #available(iOS 11.0, *) {
            predicate = CNContact.predicateForContacts(matching: t)
        } else {
            // Fallback on earlier versions
            predicate = CNContact.predicateForContacts(matchingName: "\(t)")
        }
        var contacts = [CNContact]()
       // var message: String!
        
        do {
            contacts = try contactStore.unifiedContacts(matching: predicate, keysToFetch: CONTACTKEY)
            
            if contacts.count == 0 {
                //message = "No contacts were found matching the given name."
            }
        }
        catch {
           // message = "Unable to fetch contacts."
        }
        //print(message)
        if contacts.count > 0{
            print(contacts[0])
            let tempcontact = contacts[0]
            
            if let fullname = tempcontact.value(forKey: "fullName") as Any as? String
            {
                contactName = fullname
            }
            else{
                contactName =  (tempcontact.phoneNumbers.first?.value.stringValue)!
            }
        }
        if contactName == ""{
            contactName = contactNumber
        }
        return contactName
    }
    
    //MARK:- Run Time Message Delivery Status
    @objc func isdeliver(datadic: NSDictionary){
        
       // let datadic = notification.object as! NSDictionary
        let tempMessegerId = datadic.value(forKey: "messegerId") as? String ?? ""
        let tempLastMessageId = datadic.value(forKey: "messageId") as? String ?? ""
        let tempgroupId = datadic.value(forKey: "groupId") as? String ?? ""
        let tempGroupType = datadic.value(forKey: "groupType") as? String ?? ""
        if tempMessegerId == "" || tempLastMessageId == "" || tempgroupId == "" || tempGroupType == "" {
            return
        }
        if tempGroupType == "Private Chat" {
            
            
        }
        else if tempGroupType == "Public Group"{
            return
        }
        
        //MARK:- When message DELIVER or SEEN
//        guard let userID = Auth.auth().currentUser?.uid else {
//
//            return }
        MessagesDB.child(tempgroupId)
            .child(tempMessegerId)
            .child(tempLastMessageId)
            .observeSingleEvent(of: .value, with: {(snapshot) in
                if let snapShot = snapshot.children.allObjects as? [DataSnapshot] {
                    if snapShot.count > 0 {
                        let tempdic = snapshot.value as! NSMutableDictionary
                        //print(tempdic)
                        tempdic.setValue(DELIVERED, forKey: "messageStatus")
                        let tempkeyarray = tempdic.allKeys as NSArray
                        if tempkeyarray.contains("source") {
                            tempdic.setValue("IOS", forKey: "source")
                        }
                        else {
                            tempdic.setValue("IOS", forKey: "source")
                        }
                        //print(tempdic)
                        MessagesDB
                            .child(tempgroupId)
                            .child(tempMessegerId)
                            .child(snapshot.key)
                            .updateChildValues(tempdic as! [AnyHashable : Any])
                    }
                }
        })

        ChatDB.child(tempMessegerId)
            .child(tempgroupId)
            .child(tempLastMessageId)
            .observeSingleEvent(of: .value, with: {(snapshot) in
                if let snapShot = snapshot.children.allObjects as? [DataSnapshot] {
                    if snapShot.count > 0 {
                        if let lastmessagestatus = (snapshot.value as! NSDictionary).value(forKey: "lastMessageStatus") as? Int {
                            if lastmessagestatus != DELIVERED //&& lastmessagestatus != MESSAGE_DELETED
                            {
                                let tempdic = snapshot.value as! NSMutableDictionary
                                //print(tempdic)
                                tempdic.setValue(DELIVERED, forKey: "lastMessageStatus")
                                //print(tempdic)
                                ChatDB.child(tempMessegerId)
                                    .child(tempgroupId)
                                    .updateChildValues(tempdic as! [AnyHashable : Any], withCompletionBlock: {
                                        error, snapshot in
                                        if error != nil {
                                            print(error?.localizedDescription as Any)
                                            print("Error in  typing")
                                        }
                                        else { //ChatDB.child(self.touid).child(self.groupId).updateChildValues(["typing": istyping])
                                            print("is Deliver")
                                        }
                                    })
                            }
                        }
                    }
                }
            })
    }
    func funGetCustomeTokenForAuthentication(completion: @escaping (_ authCustomToken: String?) -> Void) {
        let parameters : Parameters =
            ["userid":USERID as Any,
             "uid": UID]
        
        webService2(url: CUSTOM_AUTHENTICATION, parameters: parameters, completionHandler:{ responseObject, error,responseObject2nd  in
            
            if error == nil
            {
                if let tempcustomtoken = (responseObject2nd! as NSDictionary).value(forKey: "customtoken") as? String
                {
                    completion(tempcustomtoken)
                }
                else
                {
                    completion("error")
                }
            }
            else
            {
               completion("error")
            }
        })
    }
    
    //MARK: - Post WebServices for fetching Server Data
    func webService2(url:String , parameters:Dictionary<String,Any>, completionHandler: @escaping ([NSDictionary]?, String?, [String:Any]?) -> ())
    {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 20
        
        let sessionManager = Alamofire.SessionManager(configuration: configuration)
        //        let headers: HTTPHeaders = [
        //            "Content-Type": "application/json",
        //       //     "Content-Type": "application/x-www-form-urlencoded",
        //            "Accept": "application/json"
        //        ]
        sessionManager.request(url, method: .post, parameters: parameters, encoding:URLEncoding.default , headers: nil).responseData(completionHandler: {
            
            response in
            if let json = response.result.value {
                print("JSON: \(json)") // serialized json response
            }
            var jsonstring = String()
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                // print("Data: \(utf8Text)") // original server data as UTF8 string
                jsonstring = utf8Text
                if jsonstring.count > 2
                {
                    do{
                        
                        let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:Any]
                        
                        print(json as Any)
                    }
                    catch let parseError {
                        print(parseError)
                        print(jsonstring)
                        print("Something went wrong")
                        print(response.description)
                        print(Error.self)
                        //print(url)
                    }
                }
            }
            
            let data = response.result
            switch(data)
            {
            case .success(let json):
                print(json)
                
                if let data = jsonstring.data(using: String.Encoding.utf8) {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [NSDictionary]
                        if json != nil
                        {
                            completionHandler(json! as [NSDictionary], nil, nil)
                            print(json!)
                        }
                        else
                        {
                            
                            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                                // print("Data: \(utf8Text)") // original server data as UTF8 string
                                jsonstring = utf8Text
                                if jsonstring.count > 2
                                {
                                    do{
                                        
                                        let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:Any]
                                        if json != nil
                                        {
                                            completionHandler([NSDictionary](), nil, json! as [String: Any])
                                        }
                                        print(json as Any)
                                    }
                                    catch let parseError {
                                        print(parseError)
                                        print(jsonstring)
                                        print("Something went wrong")
                                        print(response.description)
                                        print(Error.self)
                                        //print(url)
                                    }
                                }
                            }
                        }
                        
                    } catch let parseError {
                        print(parseError)
                        print(jsonstring)
                        print("Something went wrong")
                        print(response.description)
                        print(Error.self)
                        
                        completionHandler(nil, "Not JSON Data.", nil)
                    }
                }
                
                
                sessionManager.session.invalidateAndCancel()
                break
                
                //            case .success(let JSON):
                //                                    completionHandler(JSON as? NSDictionary, nil)
                //
                //                                    sessionManager.session.invalidateAndCancel()
            //                                break
            case .failure(let error):
                if error._code == NSURLErrorCannotParseResponse
                {
                    completionHandler(nil, "Not JSON Data.", nil)
                    
                }
                else if error._code == NSURLErrorTimedOut
                {
                    completionHandler(nil, "Server is not responding, request time out please try again.", nil)
                    
                }
                else if error._code == NSURLErrorCannotFindHost
                {
                    completionHandler(nil, error.localizedDescription, nil)
                    
                }
                else if error._code == NSURLErrorNotConnectedToInternet
                {
                    completionHandler(nil, error.localizedDescription, nil)
                    
                }
                else
                {
                    completionHandler(nil, error.localizedDescription, nil)
                    
                }
                sessionManager.session.invalidateAndCancel()
                break
            }
        })
    }
}
extension UNNotificationAttachment {
    static func create(imageFileIdentifier: String, data: Data, options: [NSObject : AnyObject]?)
        -> UNNotificationAttachment? {
            let fileManager = FileManager.default
            if let directory = fileManager.containerURL(forSecurityApplicationGroupIdentifier: GROUPNAME) {
                do {
                    let newDirectory = directory.appendingPathComponent("Images")
                    if (!fileManager.fileExists(atPath: newDirectory.path))
                    {
                        try? fileManager.createDirectory(at: newDirectory, withIntermediateDirectories: true, attributes: nil)
                    }
                    let fileURL = newDirectory.appendingPathComponent(imageFileIdentifier)
                    do {
                        try data.write(to: fileURL, options: [])
                    } catch {
                        print("Unable to load data: \(error)")
                    }
                    
                    group_defaults.set(data, forKey: "images")
                    group_defaults.synchronize()
                    let imageAttachment = try UNNotificationAttachment.init(identifier: imageFileIdentifier, url: fileURL, options: options)
                    return imageAttachment
                } catch let error {
                    print("error \(error)")
                }
            }
            return nil
    }
}


