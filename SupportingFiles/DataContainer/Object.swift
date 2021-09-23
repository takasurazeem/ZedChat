////
////  Object.swift
////  Property
////
////  Created by IOS Dev on 28/02/2018.
////  Copyright © 2018 IOS Dev. All rights reserved.
////
//
import UIKit
import EasyTipView
import FirebaseDatabase
import Firebase
import Contacts
import CoreData

let defaults = UserDefaults.standard
let group_defaults = UserDefaults(suiteName: GROUPNAME)!
let obj = DataContainer()
let objG = GlobelSetting()
let objCDB = CoreDataClass()
let baseurl = DataContainer.baseUrl()
var eview = EasyTipView(text: "", preferences: EasyTipView.globalPreferences)

//MARK: - App Color
let appclr = UIColor(red: 8/255, green: 127/255, blue: 255/255, alpha: 1.0)
let appclrProfileBG = UIColor(red: 122/255, green: 206/255, blue: 228/255, alpha: 1.0)

let appclrtxtbottomline = UIColor(red: 15.0/255, green: 97.0/255, blue: 186.0/255, alpha: 1.0)
let appclrlabellLightGray = UIColor(red: 120.0/255, green: 120.0/255, blue: 120.0/255, alpha: 1.0)
let appclrtextfield = UIColor(red: 41.0/255, green: 182.0/255, blue: 233.0/255, alpha: 1.0)
let appclrstatusbar = UIColor(red: 41.0/255, green: 112/255, blue: 231/255, alpha: 1.0)
let appclrnavbar = UIColor(red: 0.0/255, green: 105.0/255, blue: 162.0/255, alpha: 1.0)
let appclrtabbar = UIColor(red: 15.0/255, green: 97.0/255, blue: 186.0/255, alpha: 1.0)
let appclrbtnbg = UIColor(red: 8/255, green: 127/255, blue: 255/255, alpha: 1.0)
let appclrbottomline = UIColor(red: 80/255, green: 181/255, blue: 229/255, alpha: 1.0)

let appclrstatusbardarkblue = UIColor(red: 15.0/255, green: 97.0/255, blue: 186.0/255, alpha: 1.0)

let appclrOwnMessageBg = UIColor(red: 8/255, green: 127/255, blue: 255/255, alpha: 1.0)
let appclrOtherMessageBg = UIColor(red: 228/255, green: 228/255, blue: 228/255, alpha: 1.0)

//201, 108, 249
//168, 153, 204
//96, 148, 231
//MARK:- Contact Backgroud Circle Color
let appclrContact10 = UIColor(red: 201/255, green: 108/255, blue: 249/255, alpha: 1.0)
let appclrContact11 = UIColor(red: 168/255, green: 153/255, blue: 204/255, alpha: 1.0)
let appclrContact12 = UIColor(red: 96/255, green: 148/255, blue: 231/255, alpha: 1.0)

//255, 51, 90
//231, 128, 205
//255, 3, 213
let appclrContact21 = UIColor(red: 255/255, green: 51/255, blue: 90/255, alpha: 1.0)
let appclrContact22 = UIColor(red: 231/255, green: 128/255, blue: 205/255, alpha: 1.0)
let appclrContact23 = UIColor(red: 255/255, green: 3/255, blue: 213/255, alpha: 1.0)

//38, 255, 0
//128, 231, 210
//3, 196, 255
let appclrContact31 = UIColor(red: 38/255, green: 255/255, blue: 0/255, alpha: 1.0)
let appclrContact32 = UIColor(red: 128/255, green: 231/255, blue: 210/255, alpha: 1.0)
let appclrContact33 = UIColor(red: 3/255, green: 196/255, blue: 255/255, alpha: 1.0)

//255, 0, 0
//255, 152, 0
//255, 218, 0
let appclrContact41 = UIColor(red: 255/255, green: 0/255, blue: 0/255, alpha: 1.0)
let appclrContact42 = UIColor(red: 255/255, green: 152/255, blue: 0/255, alpha: 1.0)
let appclrContact43 = UIColor(red: 255/255, green: 218/255, blue: 0/255, alpha: 1.0)

//255, 51, 90
//231, 128, 205
//255, 3, 213
let appclrContact51 = UIColor(red: 255/255, green: 51/255, blue: 90/255, alpha: 1.0)
let appclrContact52 = UIColor(red: 231/255, green: 128/255, blue: 205/255, alpha: 1.0)
let appclrContact53 = UIColor(red: 255/255, green: 3/255, blue: 213/255, alpha: 1.0)

let appclrContact6 = UIColor(red: 1.0/255, green: 183.0/255, blue: 233.0/255, alpha: 1.0)




let baseimgurl = "http://property1.com.pk/upload/property_f/"
//
//

let AppTextFieldBorderColor = UIColor(red: 228.0/255, green: 228.0/255, blue: 228.0/255, alpha: 1.0)

//var arrcountry = [String]()
//var arrcode = [String]()
//var arrflag = [String]()
//var arrimages = [UIImage]()
//var counter = 50
//
//
//class Object: UIViewController {
//
//    
//   
//}

//MARK:- if Wifi
let WIFI = obj.isWifi()

//MARK:- if ipad
let IPAD = UIDevice().userInterfaceIdiom == .pad
let IPHONE = UIDevice().userInterfaceIdiom == .phone
//MARK:- For Getting Version Build or Build Name
var APPVERSION_ON_APPLE = ""
let APPVERSIONNUMBER = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
let APPBUILDNUMBER = Bundle.main.infoDictionary?["CFBundleVersion"] as? String
let APPBUILDNAME = Bundle.main.infoDictionary?["CFBundleName"] as? String
var IPHONESOSVERSION = UIDevice.current.systemVersion
let DEVICEID = UIDevice.current.identifierForVendor!.uuidString
let BUNDLEID = Bundle.main.infoDictionary!["CFBundleIdentifier"] as! String
let APPUNIQUEIDENTIFIER = UIDevice.current.identifierForVendor?.uuidString

let LOGOUTMESSAGE = "You phone number is no longer registered on this phone. This is likely because you registered your phone number with \(APPBUILDNAME ?? "") on a different phone."
let EMPTY_CHAT_INBOX_START = "To start messaging contacts who have \(APPBUILDNAME ?? ""), tap  "
let EMPTY_CHAT_INBOX_END = "  at the right bottom of your screen"



let STATUSBAR_HEIGHT = UIApplication.shared.statusBarFrame.height
var PopUpVC: UIViewController?
//MARK:- Story Board Declare
//let main = UIStoryboard(name: "Main", bundle: nil)
//let storyboard = UIStoryboard(name: "Storyboard", bundle: nil)

//MARK:- Firebase Auth Verification id
var GlobalFireBaseverficationID = String()
var refFireBase = Database.database().reference()
var refStorageFireBase = Storage.storage().reference()

//MARK:- Firebase DataBase
let PrivateChatDB = refFireBase.child("PrivateChat")
let GroupsDB = refFireBase.child("Groups")
let MessagesDB = refFireBase.child("Messages")
let ChatDB = refFireBase.child("Chat")
let UserDB = refFireBase.child("Users")
let ParticipantsDB = refFireBase.child("Participants")
let IOSVersion = refFireBase.child("Version")
let BlockListMeDB = refFireBase.child("BlockListMe")
let BlockListMyDB = refFireBase.child("BlockListMy")

//Participants

var isAndroidUser = Bool()

var userid2 = String()
var username = String()
var useremail = String()
var usertype = String()
var arrcity = [String]()

var Globalusername = String()
var Globalimage = String()
var Globalemail = String()
var Globalname = String()
var Globaluserid = String()
var Globalphoneno = String()
var Globalcompany_name = String()
var Globalaccount_type = String()
var GLastSeen = String()
var GOtherUserSeeAbout = String()
var ALLCONTACTS = [CNContact]()
var MEDIAPROGRESS = Float()
var USERDATA = NSMutableDictionary()

var NOT_DELIVERED = 2;
var SENT = 2;
var DELIVERED = 3;
var SEEN = 4;
var TEXT = 5;
var AUDIO = 6;
var IMAGE = 7;
var VIDEO = 8;
var LOCATION = 9;
var DOCUMENT = 10;
var CONTACT = 11;
var CREATE_GROUP = 12;
var MESSAGE_DELETED = 13;
var LEFT_GROUP = 14;
var ADD_MEMBER = 15;
var REMOVE_MEMBER = 16;
var GROUP_ADMIN = 17;
var GROUP_INFO_MESSAGE = 18;
var AUDIO_CALL = 21;
var VIDEO_CALL = 22;
var MISSED_CALL = 23;
var MISSED_VIDEO_CALL = 24;
var INCOMING_AUDIO = 25;
var INCOMING_VIDEO = 26;
var TYPING = 27
var RECORDING = 28
var STOP_TYPING_RECORDING = 29
var VIDEOIMAGE = 30
var CELLINCOMMING = 31
var CELLINCOMMINGWITHPIC = 32
var CELLOUTGOING = 33
var CELLOUTGOINGWITHPIC = 34
var PROFILEPIC = 11111111

//MARK:- Data and Storage Variables
var WIFI_DATA = String()
var MOBILE_DATA = String()
var ROAMING_DATA = String()
var LOW_DATAUSAGE = Bool()
var READ_RECEIPT = Bool()
/////////Sinch Variables


var SinCallDataDic = [String: AnyObject]()

//Core Data

//Singlton instance
// MARK: Variables declearations of App Delegate for Core Data
let appDelegate = UIApplication.shared.delegate as! AppDelegate
var context:NSManagedObjectContext! = appDelegate.persistentContainer.viewContext


var CONTACTKEY = [CNContactFormatter.descriptorForRequiredKeys(for: CNContactFormatterStyle.fullName), CNContactGivenNameKey,CNContactFamilyNameKey,CNContactMiddleNameKey,CNContactEmailAddressesKey,CNContactPhoneNumbersKey,CNContactImageDataAvailableKey,CNContactThumbnailImageDataKey] as! [CNKeyDescriptor]
var SHAREMESSAGE = "Hey there, i am using \(APPBUILDNAME ?? "") for message and call.\n\n"
var SHARELINKANDROID = "https://play.google.com/store/apps/details?id=com.zaryans.zedchat\n\n"
var SHARELINKIOS = "https://apps.apple.com/us/app/zedchat/id1455971128?ls=1"

let arrcolor = [[appclrContact10, appclrContact11, appclrContact12],[appclrContact21, appclrContact22, appclrContact23],[appclrContact31, appclrContact32, appclrContact33],[appclrContact41, appclrContact42, appclrContact43],[appclrContact51, appclrContact52, appclrContact53],[appclrContact6, appclrContact6, appclrContact6]]

//BASE URL AND API's

var BASEURL = "https://chatapi.aonechat.com/api/"
var BASEURL_IMAGES = "https://chatapi.aonechat.com/Media/"

public var USER_IMAGE_PATH = BASEURL_IMAGES + "UserImages/";
public var GROUP_IMAGE_PATH = BASEURL_IMAGES + "GroupImages/";

var REGISTERATION = BASEURL + "User/RegisterUserV2"
var RECTIFYUSER = BASEURL + "User/RectifyUser"
var UPLOAD_USER_IMAGE = BASEURL + "User/PostFile?fcmId=&userId=\(USERID ?? "")&filename="
var SENDCURRENTLOCATION = "https://chatapi.aonechat.com/api/" + "Comm/postlocV2"
//PostFile?fcmId=&userId=&filename="

var USERID = defaults.value(forKey: "userid") as? String
var CUSTOM_AUTHENTICATION = "https://chatapi.aonechat.com/api/user/GetToken?userid=\(group_defaults.object(forKey: "phoneNumber") as! String)&uid=\(group_defaults.object(forKey: "uid") as! String)"

var UPLOAD_IMAGE = BASEURL + "Upload/Image/";
var UPLOAD_GROUP_THUMB = BASEURL + "Upload/GroupImage/?filename=";
var UPLOAD_VIDEO = BASEURL + "Upload/Video/";

var CONTACT_UPLOAD_API = "https://chatapi.aonechat.com/api/Comm/postct"
//Tariq jamil ki api
//var CONTACT_UPLOAD_API = "https://api2.aonechat.com/api/Comm/postct"
let FIREBASE_SERVERKEY = "AIzaSyDhEnbXJ4To2HfYM_eV8s77BADjUt8O4hA"
let FBASE_SEND_NOTIFICATION_URL = "https://fcm.googleapis.com/fcm/send"

let SINCH_KEY = "d7d43371-ba83-4742-b226-38c7e9cab583"
let SINCH_SECRET_KEY = "NwXfZaWsyUmKroZKOKdAKA=="
let SINCH_URL = "clientapi.sinch.com"

//let GOOGLE_SERVICES_KEY = "AIzaSyA-TXMTIe_VCg0gvPYQMjPw18ZlawVfW80"
//let GOOGLE_PLACES_KEY = "AIzaSyA-TXMTIe_VCg0gvPYQMjPw18ZlawVfW80"
//
let GOOGLE_SERVICES_KEY = "AIzaSyCdeNPJdY9W2eEajaKFXz9DR0Am2iqxOMU"
let GOOGLE_PLACES_KEY = "AIzaSyCdeNPJdY9W2eEajaKFXz9DR0Am2iqxOMU"





let CORE_DB_NAME = "ZedChatCoreDB"

let GROUPNAME = "group.Zaryans.ZedChat"

let MESSAGECELL_RADIUS = CGFloat(6)


let objUserDBM = UsersDBModel()
let objChatDBM = ChatDBModel()
let objMessageDBM = MessagesDBModel()
let objGroupsDBM = GroupsDBModel()
let objParticipantsDBM = ParticipantsDBModel()
let objPrivateChatDBM = PrivateChatDBModel()

let PRIVATECHAT = "Private Chat"
let PUBLICGROUP = "Public Group"
let SOURCECODE = "ios"
let USERUniqueID = defaults.value(forKey: "phoneno") as? String ?? ""
var USERUID = defaults.value(forKey: "uid") as? String ?? ""
let ALLDOCUMENTSTYPE = ["com.apple.iwork.pages.pages", "com.apple.iwork.numbers.numbers", "com.apple.iwork.keynote.key","public.image", "com.apple.application", "public.item","public.data", "public.content", "public.audiovisual-content", "public.movie", "public.video", "public.audio", "public.text", "public.zip-archive", "com.pkware.zip-archive", "public.composite-content", "public.pdf", "public.doc"]

