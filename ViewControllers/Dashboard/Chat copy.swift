//
//  Chats.swift
//  ZedChat
//
//  Created by MacBook Pro on 13/02/2019.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import Firebase
import FirebaseDatabase
import Kingfisher

class Chats: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    var uid = defaults.value(forKey: "uid") as! String
    
    
    var refreshControl = UIRefreshControl()
    
    var tableviewframe = CGFloat()
    var ifScreenOpenOtherUserId = String()
    
    var arrMsgUnSeenCount = NSMutableArray()
    var arrMsgFomUid = NSMutableArray()
    var arrMsgOtherUid = NSMutableArray()
    var arrMsgLast = NSMutableArray()
    var arrMsgStatus = NSMutableArray()
    var arrMsgType = NSMutableArray()
    var arrMsgTime = NSMutableArray()
    var arrMsgProfilePic = NSMutableArray()
    var arrMsgPicThumb = NSMutableArray()
    var arrMsgLat = NSMutableArray()
    var arrMsgLong = NSMutableArray()
    var arrMsgSeen = NSMutableArray()
    var arrMsgNumber = NSMutableArray()
    var arrMsgUserName = NSMutableArray()
    var arrUserPhoneNumber = NSMutableArray()
    var arrMsgTyping = NSMutableArray()
    var arrMsgGroupType = NSMutableArray()
    var arrMsgLastMsgId = NSMutableArray()
    var arrMsgGroupId = NSMutableArray()
    var arrUserUserId = NSMutableArray()
    //MARK:- Privacy Arrays
    var arrMsgShowLastSeen = NSMutableArray()
    var arrMsgShowProfilePhoto = NSMutableArray()
    var arrMsgShowSeeAbout = NSMutableArray()
    
    @IBOutlet weak var lblsearching: UILabel!
    @IBOutlet weak var txtsearch: UITextField!
    @IBOutlet weak var btnchat: UIButton!
    @IBAction func btnchat(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "taponuserscreen"), object: nil)
    }
    
    @IBOutlet weak var bgchat: UIView!
    
    let arrtype = ["text","location", "photo", "voice", "text","voice", "photo", "location"]
    @IBOutlet weak var andicator: UIActivityIndicatorView!
    @IBOutlet weak var tablev: UITableView!
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltered == true
        {
            return arrSearchIndex.count
        }
        else
        {
            return arrMsgUserName.count
        }
    }
    //    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    //        return true
    //    }
    //
    //    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    //        if editingStyle == .delete {
    //            print("Deleted")
    //            self.tablev.deleteRows(at: [indexPath], with: .automatic)
    //        }
    //    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var index = indexPath.row
        if isFiltered == true
        {
            index = arrSearchIndex[indexPath.row] as! Int
        }
        let myuid = defaults.value(forKey: "uid") as! String
        var statutype = Int()
        if let status = arrMsgStatus[index] as? String
        {
            statutype = Int(status)!
        }
        else if let status = arrMsgStatus[index] as? Int
        {
            statutype = status
        }
        var type = Int()
        if let temptype = arrMsgType[index] as? String
        {
            type = Int(temptype)!
        }
        else if let temptype = arrMsgType[index] as? Int
        {
            type = temptype
        }
        var unseencount = Int()
        if let tempunseen = arrMsgUnSeenCount[index] as? String
        {
            unseencount = Int(tempunseen)!
        }
        else if let tempunseen = arrMsgUnSeenCount[index] as? Int
        {
            unseencount = tempunseen
        }
        var showprofilephoto = ""
        if let tempprofilephoto = arrMsgShowProfilePhoto[index] as? String
        {
            showprofilephoto = tempprofilephoto
        }
        
        let grouptype = arrMsgGroupType[index] as! String
        let timestring = obj.convertTimespamIntoTime(timestring: "\(arrMsgTime[index] as! Int)")
        let fromuid = arrMsgFomUid[index] as! String
        //MARK:- If Message Delete
        if statutype == MESSAGE_DELETED
        {
            //MARK:- Self Messages
            let cell = tablev.dequeueReusableCell(withIdentifier: "InboxPhotoCell") as! InboxMsgCell
            cell.imgvtype.image = UIImage.init(named: "deletedmsg")
            cell.lbltitle.text = (arrMsgUserName[index] as! String)
            cell.lblcount.isHidden = true
            if arrMsgTyping[index] as? Int == TYPING{
                cell.lbltextmsg.text = "Typing ..."
                cell.lbltextmsg.textColor = appclr
            }
            else if arrMsgTyping[index] as? Int == RECORDING{
                cell.lbltextmsg.text = "Recording ..."
                cell.lbltextmsg.textColor = appclr
            }
            else{
                cell.lbltextmsg.textColor = .lightGray
                if arrMsgFomUid[index] as! String == myuid
                {
                    cell.lbltextmsg.text = "You deleted this message"
                }
                else
                {
                    cell.lbltextmsg.text = "User deleted this message"
                }
            }
            return cell
        }
        if type == TEXT
        {
            if fromuid == myuid && grouptype == "Private Chat"
            {
                return outGoingCell(index: index, type: type, statutype: statutype, timestring: timestring, grouptype: grouptype, unseencount: unseencount, showprofilephoto: showprofilephoto)
            }
            else
            {
                return inCommingCell(index: index, type: type, statutype: statutype, timestring: timestring, grouptype: grouptype, unseencount: unseencount, showprofilephoto: showprofilephoto)
            }
        }
        else {
            
            if fromuid == myuid && grouptype == "Private Chat"
            {
                return outGoingCell(index: index, type: type, statutype: statutype, timestring: timestring, grouptype: grouptype, unseencount: unseencount, showprofilephoto: showprofilephoto)
            }
            else
            {
                return inCommingCell(index: index, type: type, statutype: statutype, timestring: timestring, grouptype: grouptype, unseencount: unseencount, showprofilephoto: showprofilephoto)
            }
        }
    }
    
    func outGoingCell(index: Int, type: Int, statutype: Int, timestring: String, grouptype: String, unseencount: Int, showprofilephoto: String) -> UITableViewCell
    {
        if type == TEXT
        {
            //MARK:- Self Messages
            let cell = tablev.dequeueReusableCell(withIdentifier: "OutGoingMsgCell") as! OutGoingMsgCell
            cell.lbltitle.text = (arrMsgUserName[index] as! String)
            
            cell.lbltime.text = timestring
            
            if showprofilephoto == "Nobody"
            {
                if grouptype == "Public Group"
                {
                    cell.imgvprofile.image = UIImage.init(named: "groupicon")
                }
                else
                {
                    cell.imgvprofile.image = UIImage.init(named: "user")
                }
            }
            else if let imgurl = arrMsgProfilePic[index] as? String
            {
                if imgurl != ""
                {
                    loadimage(imgv: cell.imgvprofile, imgurl: USER_IMAGE_PATH + imgurl)
                }
                else
                {
                    cell.imgvprofile.image = UIImage.init(named: "user")
                }
                
                //cell.imgvprofile.kf.setImage(with: URL(string: imgurl))
            }
            else
            {
                cell.imgvprofile.image = UIImage.init(named: "user")
            }
            
            //MARK:- Message Status Set
            self.setMessageStatusForCell(msgStatus: statutype, imageview: cell.imgvstatus)
            obj.setimageCircle(image: cell.imgvprofile, viewcontroller: self)
            
            if arrMsgTyping[index] as? Int == TYPING
            {
                cell.lbltextmsg.text = "Typing ..."
                cell.lbltextmsg.textColor = appclr
            }
            else if arrMsgTyping[index] as? Int == RECORDING
            {
                cell.lbltextmsg.text = "Recording ..."
                cell.lbltextmsg.textColor = appclr
            }
            else
            {
                cell.lbltextmsg.text = arrMsgLast[index] as? String
                cell.lbltextmsg.textColor = .darkGray
            }
            return cell
        }
        else{
            //MARK:- Self Messages
            let cell = tablev.dequeueReusableCell(withIdentifier: "OutGoingPhotoMsgCell") as! OutGoingMsgCell
            
            cell.lbltitle.text = (arrMsgUserName[index] as! String)
            
            cell.lbltime.text = timestring
            if showprofilephoto == "Nobody"
            {
                if grouptype == "Public Group"
                {
                    cell.imgvprofile.image = UIImage.init(named: "groupicon")
                }
                else
                {
                    cell.imgvprofile.image = UIImage.init(named: "user")
                }
            }
            else if let imgurl = arrMsgProfilePic[index] as? String
            {
                if imgurl != ""
                {
                    loadimage(imgv: cell.imgvprofile, imgurl: USER_IMAGE_PATH + imgurl)
                }
                else
                {
                    cell.imgvprofile.image = UIImage.init(named: "user")
                }
                //cell.imgvprofile.kf.setImage(with: URL(string: imgurl))
            }
            else
            {
                cell.imgvprofile.image = UIImage.init(named: "user")
            }
            //MARK:- Message Status Set
            self.setMessageStatusForCell(msgStatus: statutype, imageview: cell.imgvstatus)
            obj.setimageCircle(image: cell.imgvprofile, viewcontroller: self)
            
            switch type {
            case LOCATION:
                cell.imgvtype.image = UIImage.init(named: "locimg")
                cell.lbltextmsg.text = "Location"
                break
            case IMAGE:
                cell.imgvtype.image = UIImage.init(named: "photoimg")
                cell.lbltextmsg.text = "Photo"
                break
            case AUDIO:
                cell.imgvtype.image = UIImage.init(named: "voiceimg")
                cell.lbltextmsg.text = "Audio"
                break
            case VIDEO:
                cell.imgvtype.image = UIImage.init(named: "videoimg")
                cell.lbltextmsg.text = "Video"
                break
            default:
                break
            }
            if arrMsgTyping[index] as? Int == TYPING
            {
                cell.lbltextmsg.text = "Typing ..."
                cell.lbltextmsg.textColor = appclr
            }
            else if arrMsgTyping[index] as? Int == RECORDING
            {
                cell.lbltextmsg.text = "Recording ..."
                cell.lbltextmsg.textColor = appclr
            }
            else
            {
                cell.lbltextmsg.textColor = UIColor.lightGray
            }
            return cell
        }
    }
    
    func inCommingCell(index: Int, type: Int, statutype: Int, timestring: String, grouptype: String, unseencount: Int, showprofilephoto: String) -> UITableViewCell
    {
        if type == TEXT
        {
            let cell = tablev.dequeueReusableCell(withIdentifier: "InboxMsgCell") as! InboxMsgCell
            
            if unseencount != 0
            {
                cell.lblcount.text = "\(unseencount)"
                cell.lblcount.isHidden = false
                obj.setLabelCircle(label: cell.lblcount, viewcontroller: self)
            }
            else
            {
                cell.lblcount.isHidden = true
            }
            cell.lbltitle.text = (arrMsgUserName[index] as! String)
            
            cell.lbltime.text = timestring
            if showprofilephoto == "Nobody"
            {
                if grouptype == "Public Group"
                {
                    cell.imgvprofile.image = UIImage.init(named: "groupicon")
                }
                else
                {
                    cell.imgvprofile.image = UIImage.init(named: "user")
                }
            }
            else
            {
                if let imgurl = arrMsgProfilePic[index] as? String
                {
                    if imgurl != ""
                    {
                        var path = USER_IMAGE_PATH
                        if grouptype == "Public Group"
                        {
                            path = GROUP_IMAGE_PATH
                        }
                        loadimage(imgv: cell.imgvprofile, imgurl: path + imgurl)
                    }
                    else if grouptype == "Public Group"
                    {
                        obj.setimageCircle(image: cell.imgvprofile, viewcontroller: self)
                        cell.imgvprofile.layer.borderColor = UIColor.lightGray.cgColor
                        cell.imgvprofile.layer.borderWidth = 1
                        cell.imgvprofile.image = UIImage.init(named: "groupicon")
                    }
                    else
                    {
                        cell.imgvprofile.image = UIImage.init(named: "user")
                    }
                    
                    //cell.imgvprofile.kf.setImage(with: URL(string: imgurl))
                }
            }
            
            obj.setimageCircle(image: cell.imgvprofile, viewcontroller: self)
            if arrMsgTyping[index] as? Int == TYPING
            {
                cell.lbltextmsg.text = "Typing ..."
                cell.lbltextmsg.textColor = appclr
            }
            else if arrMsgTyping[index] as? Int == RECORDING
            {
                cell.lbltextmsg.text = "Recording ..."
                cell.lbltextmsg.textColor = appclr
            }
            else
            {
                cell.lbltextmsg.text = arrMsgLast[index] as? String
                cell.lbltextmsg.textColor = .darkGray
            }
            return cell
        }
        else
        {
            let cell = tablev.dequeueReusableCell(withIdentifier: "InboxPhotoCell") as! InboxMsgCell
            
            cell.lbltitle.text = (arrMsgUserName[index] as! String)
            
            cell.lbltime.text = timestring
            if showprofilephoto == "Nobody"
            {
                if grouptype == "Public Group"
                {
                    cell.imgvprofile.image = UIImage.init(named: "groupicon")
                }
                else
                {
                    cell.imgvprofile.image = UIImage.init(named: "user")
                }
            }
            else
            {
                if let imgurl = arrMsgProfilePic[index] as? String
                {
                    if imgurl != ""
                    {
                        var path = USER_IMAGE_PATH
                        if grouptype == "Public Group"
                        {
                            path = GROUP_IMAGE_PATH
                        }
                        loadimage(imgv: cell.imgvprofile, imgurl: path + imgurl)
                    }
                    else if grouptype == "Public Group"
                    {
                        obj.setimageCircle(image: cell.imgvprofile, viewcontroller: self)
                        cell.imgvprofile.layer.borderColor = UIColor.lightGray.cgColor
                        cell.imgvprofile.layer.borderWidth = 1
                        cell.imgvprofile.image = UIImage.init(named: "groupicon")
                    }
                    else
                    {
                        cell.imgvprofile.image = UIImage.init(named: "user")
                    }
                    
                    //cell.imgvprofile.kf.setImage(with: URL(string: imgurl))
                }
            }
            
            cell.imgvtype.image = UIImage.init(named: "locimg")
            obj.setimageCircle(image: cell.imgvprofile, viewcontroller: self)
            if unseencount != 0
            {
                cell.lblcount.text = "\(unseencount)"
                cell.lblcount.isHidden = false
                obj.setLabelCircle(label: cell.lblcount, viewcontroller: self)
            }
            else
            {
                cell.lblcount.isHidden = true
            }
            switch type {
            case LOCATION:
                cell.imgvtype.image = UIImage.init(named: "locimg")
                cell.lbltextmsg.text = "Location"
                break
            case IMAGE:
                cell.imgvtype.image = UIImage.init(named: "photoimg")
                cell.lbltextmsg.text = "Photo"
                break
            case AUDIO:
                cell.imgvtype.image = UIImage.init(named: "voiceimg")
                cell.lbltextmsg.text = "Audio"
                break
            case VIDEO:
                cell.imgvtype.image = UIImage.init(named: "videoimg")
                cell.lbltextmsg.text = "Video"
                break
            default:
                break
            }
            if arrMsgTyping[index] as? Int == TYPING
            {
                cell.lbltextmsg.text = "Typing ..."
                cell.lbltextmsg.textColor = appclr
            }
            else if arrMsgTyping[index] as? Int == RECORDING
            {
                cell.lbltextmsg.text = "Recording ..."
                cell.lbltextmsg.textColor = appclr
            }
            else
            {
                cell.lbltextmsg.textColor = UIColor.lightGray
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var index = indexPath.row
        var imagestring = arrMsgProfilePic[index] as! String
        let imagename = imagestring
        if isFiltered == true
        {
            index = arrSearchIndex[indexPath.row] as! Int
        }
        if arrMsgGroupType[index] as! String == "Public Group"
        {
            if imagestring != ""
            {
                imagestring = GROUP_IMAGE_PATH + imagestring
            }
        }
        else
        {
            if imagestring != ""
            {
                imagestring = USER_IMAGE_PATH + imagestring
            }
            if let tempprofilephoto = arrMsgShowProfilePhoto[index] as? String
            {
                if tempprofilephoto == "Nobody"
                {
                    imagestring = ""
                }
            }
        }
        
        ifScreenOpenOtherUserId = arrMsgOtherUid[index] as! String
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "taponuser"), object: ["touid": ifScreenOpenOtherUserId, "fromuid": defaults.value(forKey: "uid") as! String,
                                                                                                   "useridserver": arrUserUserId[index],
                                                                                                   "userprofilepic":imagestring,
                                                                                                   "imagename": imagename,
                                                                                                   "username": arrMsgUserName[index],
                                                                                                   "groupid": arrMsgGroupId[index],
                                                                                                   "otherUserPhone_Number":arrUserPhoneNumber[index],
                                                                                                   "grouptype" : arrMsgGroupType[index]])
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if IPAD
        {
            return 150
        }
        return 75
    }
    
    func loadimage(imgv: UIImageView, imgurl : String)
    {
        DispatchQueue.main.async {
            imgv.kf.setImage(with: URL(string: imgurl))
        }
    }
    
    func setMessageStatusForCell(msgStatus: Int, imageview: UIImageView)
    {
        if msgStatus == NOT_DELIVERED
        {
            imageview.image = UIImage.init(named: "msgsent")
        }
        else if msgStatus == SENT
        {
            imageview.image = UIImage.init(named: "msgsent")
        }
        else if msgStatus == DELIVERED
        {
            imageview.image = UIImage.init(named: "msgdeliver")
        }
        else if msgStatus == SEEN
        {
            imageview.image = UIImage.init(named: "msgseen")
        }
        else if msgStatus == MESSAGE_DELETED
        {
            imageview.image = UIImage.init(named: "deletedmsg")
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        //fetchAllUsers()
        removeValue()
        uid = defaults.value(forKey: "uid") as! String
        ChatDB.child(uid).removeAllObservers()
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "tapOnButtons"), object: ["screen": "chat"])
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateLastOnlineTime"), object: nil)
        DispatchQueue.main.async {
            self.retreiveMessages()
        }
    }
    //MARK:- REmove any value
    func removeValue()
    {
        
        ChatDB.child("-LeAQIbL0OLM_OJ6jg2_").removeValue(completionBlock: { error, snapshot in
            print(snapshot)
        })
    }
    override func viewDidAppear(_ animated: Bool) {
        
    }
    override func didReceiveMemoryWarning() {
        
    }
    
    func funDeleteValue(grouptype: String)
    {
        if grouptype == "public"
        {
            GroupsDB.child("-LaxXA1JlluqNJYU1M0A").removeValue(completionBlock: { error, snapshot in
                
                if error != nil
                {
                    obj.showToast(message: "Not Delete", viewcontroller: self)
                   
                }
                else
                {
                    obj.showToast(message: "Value Delete", viewcontroller: self)
                }
                
            })
        }
        else if grouptype == "private"
        {
            ChatDB.child(defaults.value(forKey: "uid") as! String).child("-LaxXA1JlluqNJYU1M0A").removeValue(completionBlock: { error, snapshot in
                
                if error != nil
                {
                    obj.showToast(message: "Not Delete", viewcontroller: self)
                    
                }
                else
                {
                    obj.showToast(message: "Value Delete", viewcontroller: self)
                }
                
            })
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //MARK:- if want to delte some values
//        funDeleteValue(grouptype: "public")
        //funDeleteValue(grouptype: "private")
       // return
//
        ///////
        btnchat.isUserInteractionEnabled = false
        andicator.startAnimating()
        // Do any additional setup after loading the view.
        self.tablev.register(UINib(nibName: "InboxMsgCell", bundle: nil), forCellReuseIdentifier: "InboxMsgCell")
        self.tablev.register(UINib(nibName: "InboxPhotoCell", bundle: nil), forCellReuseIdentifier: "InboxPhotoCell")
        self.tablev.register(UINib(nibName: "OutGoingMsgCell", bundle: nil), forCellReuseIdentifier: "OutGoingMsgCell")
        self.tablev.register(UINib(nibName: "OutGoingPhotoMsgCell", bundle: nil), forCellReuseIdentifier: "OutGoingPhotoMsgCell")
        
        //fetchAllUsers()
        ChatDB.child(uid).removeAllObservers()
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "tapOnButtons"), object: ["screen": "chat"])
        if defaults.value(forKey: "autologin") as! String == "1"
        {
            DispatchQueue.main.async {
                //obj.showToast(message: "Account Created Successfully.", viewcontroller: self)
            }
        }
        //MARK:- Notification when tap on some user
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.addObserver(self, selector: #selector(searchshowhide), name: NSNotification.Name(rawValue: "searchshowhide"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(searchhide), name: NSNotification.Name(rawValue: "searchhide"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(searchshowhide), name: NSNotification.Name(rawValue: "clearchat"), object: nil)
        
        obj.putImgInButtonWithOutLabel(button: btnchat, imgname: "chaticon")
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateLastOnlineTime"), object: nil)
        
        self.retreiveMessages()
        DispatchQueue.main.async {
            
            obj.setbuttonHeighWidth4Pad(button: self.btnchat, viewcontroller: self)
            DispatchQueue.main.async {
                self.btnchat.layer.cornerRadius = self.btnchat.frame.size.height / 2
            }
        }
        funSearchSetting()
        
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: UIControl.Event.valueChanged)
        tablev.addSubview(refreshControl) // not required when using UITableViewController
    }
    @objc func refresh(sender:AnyObject) {
        //retreiveMessages()
        Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { timer in
            print("Fire timer \(timer)")
            self.tablev.reloadData()
            self.refreshControl.endRefreshing()
        }
        // Code to refresh table view
        
    }
    @objc func searchshowhide(notification: Notification)
    {
        if txtsearch.isHidden == true
        {
            txtsearch.isHidden = false
            tablev.frame.origin.y = txtsearch.frame.maxY
            tablev.frame.size.height = self.view.frame.size.height - (6 + txtsearch.frame.size.height)
        }
        else
        {
            self.view.endEditing(true)
            txtsearch.isHidden = true
            tablev.frame.origin.y = 0
            tablev.frame.size.height = self.view.frame.size.height - 6
        }
    }
    
    //MARK:- New Message Receive when the user is not in Inbox Screen
    func retreiveNewUserMessages(){
        ChatDB.child(uid).observe(.childAdded) { (snapshot) in
            if let snapShot = snapshot.children.allObjects as? [DataSnapshot] {
                if snapShot.count > 0
                {
                    if self.arrMsgGroupId.contains(snapshot.key) != true
                    {
                        //MARK:- If new Child Added
                        let datadic = (snapshot.value as! NSDictionary)
                        //MARK:- Insert User New Message on Top of Array
                        if datadic.count > 12
                        {
                            
                        }
                        else
                        {
                            return
                        }
                        if datadic.value(forKey: "otherUserId") as? String == ""
                        {
                            return
                        }
                        self.funInsertMessageOnTop(datadic: datadic, key: snapshot.key)
                        //MARK:- Get index when recevie new message after changing in array
                        let indexofchild = self.arrMsgGroupId.index(of: snapshot.key)
                        //MARK:- Message Delivery Status Update When App Receive New Message
                        if (snapshot.value as! NSDictionary).value(forKey: "groupType") as! String == "Private Chat"
                        {
                            self.funMessageStatusUpdateRunTime(indexofchild: indexofchild)
                            if self.arrMsgOtherUid.count > self.arrUserPhoneNumber.count
                            {
                                //MARK:- Add only one user in array
                                let uid = datadic.value(forKey: "otherUserId") as! String
                                print(uid as Any)
                                UserDB.child(uid).observe(.value, with: { (subsnapshot) in
                                    UserDB.child(uid).removeAllObservers()
                                    print(subsnapshot)
                                    if subsnapshot.childrenCount > 0
                                    {
                                        self.arrMsgProfilePic.insert((subsnapshot.value as! NSDictionary).value(forKey: "UserLink") as! String, at: 0)
                                        self.arrMsgUserName.insert((subsnapshot.value as! NSDictionary).value(forKey: "UserName") as! String, at: 0)
                                        self.arrUserPhoneNumber.insert((subsnapshot.value as! NSDictionary).value(forKey: "UserPhoneNumber") as! String, at: 0)
                                        
                                        self.arrUserUserId.insert((subsnapshot.value as! NSDictionary).value(forKey: "user_id") as! String, at: 0)
                                        
                                        if let tempLastSeen = (subsnapshot.value as! NSDictionary).value(forKey: "Last Seen") as? String
                                        {
                                            self.arrMsgShowLastSeen.insert(tempLastSeen, at: 0)
                                        }
                                        else
                                        {
                                            self.arrMsgShowLastSeen.insert("", at: 0)
                                        }
                                        if let tempProfilePhoto = (subsnapshot.value as! NSDictionary).value(forKey: "Profile Photo") as? String
                                        {
                                            self.arrMsgShowProfilePhoto.insert(tempProfilePhoto, at: 0)
                                        }
                                        else
                                        {
                                            self.arrMsgShowProfilePhoto.insert("", at: 0)
                                        }
                                        
                                        if let tempSeeAbout = (subsnapshot.value as! NSDictionary).value(forKey: "See About") as? String
                                        {
                                            self.arrMsgShowSeeAbout.insert(tempSeeAbout, at: 0)
                                        }
                                        else
                                        {
                                            self.arrMsgShowSeeAbout.insert("", at: 0)
                                        }
                                    }
                                    self.tablev.beginUpdates()
                                    self.tablev.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
                                    self.tablev.endUpdates()
                                    //  self.tablev.reloadData()
                                })
                            }//End of IF Check
                        }
                        else if (snapshot.value as! NSDictionary).value(forKey: "groupType") as! String == "Public Group"
                        {
                            let tempgroupid = snapshot.key
                            GroupsDB.child(tempgroupid).observe(.value, with: { (subsnapshot) in
                                GroupsDB.child(tempgroupid).removeAllObservers()
                                print(subsnapshot)
                                if subsnapshot.childrenCount > 0
                                {
                                    self.arrMsgProfilePic.insert((subsnapshot.value as! NSDictionary).value(forKey: "groupImage") as! String, at: 0)
                                    self.arrMsgUserName.insert((subsnapshot.value as! NSDictionary).value(forKey: "groupName") as! String, at: 0)
                                    self.arrUserPhoneNumber.insert("", at: 0)
                                    self.arrUserUserId.insert("" , at: 0)
                                    
                                    self.arrMsgShowLastSeen.insert("" , at: 0)
                                    self.arrMsgShowProfilePhoto.insert("" , at: 0)
                                    self.arrMsgShowSeeAbout.insert("" , at: 0)
                                    
                                    self.tablev.beginUpdates()
                                    self.tablev.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
                                    self.tablev.endUpdates()
                                }
                            })
                        }//End of Else IF Check
                    }
                }
            }
        }
    }
    //MARK:- Insert User Message on Top
    func funInsertMessageOnTop(datadic: NSDictionary, key: String)
    {
        if datadic.value(forKey: "otherUserId") as? String == ""
        {
            return
        }
        self.arrMsgGroupId.insert(key, at: 0)
        
        self.arrMsgFomUid.insert(datadic.value(forKey: "lastMessageUserId") as Any, at: 0)
        self.arrMsgOtherUid.insert(datadic.value(forKey: "otherUserId") as Any, at: 0)
        self.arrMsgLast.insert(datadic.value(forKey: "lastMessage") as Any, at: 0)
        self.arrMsgStatus.insert(datadic.value(forKey: "lastMessageStatus") as Any, at: 0)
        self.arrMsgType.insert(datadic.value(forKey: "lastMessageType") as Any, at: 0)
        self.arrMsgTime.insert(datadic.value(forKey: "lastMessageTime") as Any, at: 0)
        self.arrMsgSeen.insert(datadic.value(forKey: "seen") as Any, at: 0)
        self.arrMsgNumber.insert(datadic.value(forKey: "userPhoneNumber") as Any, at: 0)
        self.arrMsgTyping.insert(datadic.value(forKey: "typing") as Any, at: 0)
        self.arrMsgGroupType.insert(datadic.value(forKey: "groupType") as Any, at: 0)
        self.arrMsgLastMsgId.insert(datadic.value(forKey: "lastMessageId") as Any, at: 0)
        self.arrMsgUnSeenCount.insert(datadic.value(forKey: "unSeenCount") as Any, at: 0)
//        self.arrMsgShowLastSeen.insert(datadic.value(forKey: "Last Seen") as Any, at: 0)
//        self.arrMsgShowProfilePhoto.insert(datadic.value(forKey: "Profile Photo") as Any, at: 0)
//        self.arrMsgShowSeeAbout.insert(datadic.value(forKey: "See About") as Any, at: 0)
    }
    
    //MARK:- Insert User Message on Top
    func funInsertMessageInArrays(datadic: NSDictionary, key: String)
    {
        if datadic.value(forKey: "otherUserId") as? String == ""
        {
            if datadic.value(forKey: "groupType") as? String == "Public Group"
            {
                
            }
            else
            {
                return
            }
        }
        self.arrMsgGroupId.add(key)
        self.arrMsgFomUid.add(datadic.value(forKey: "lastMessageUserId") as Any)
        self.arrMsgOtherUid.add(datadic.value(forKey: "otherUserId") as Any)
        self.arrMsgLast.add(datadic.value(forKey: "lastMessage") as Any)
        self.arrMsgStatus.add(datadic.value(forKey: "lastMessageStatus") as Any)
        self.arrMsgType.add(datadic.value(forKey: "lastMessageType") as Any)
        self.arrMsgTime.add(datadic.value(forKey: "lastMessageTime") as Any)
        self.arrMsgSeen.add(datadic.value(forKey: "seen") as Any)
        self.arrMsgNumber.add(datadic.value(forKey: "userPhoneNumber") as Any)
        self.arrMsgTyping.add(datadic.value(forKey: "typing") as Any)
        self.arrMsgGroupType.add(datadic.value(forKey: "groupType") as Any)
        self.arrMsgLastMsgId.add(datadic.value(forKey: "lastMessageId") as Any)
        self.arrMsgUnSeenCount.add(datadic.value(forKey: "unSeenCount") as Any)
//        self.arrMsgShowLastSeen.add(datadic.value(forKey: "Last Seen") as Any)
//        self.arrMsgShowProfilePhoto.add(datadic.value(forKey: "Profile Photo") as Any)
//        self.arrMsgShowSeeAbout.add(datadic.value(forKey: "See About") as Any)
        
    }
    //MARK:- Retreive Messages from db and add observer When This screen run first time
    @objc func retreiveMessages(){
        self.andicator.startAnimating()
        //MARK:- If Child Added Means if new user messaged you then this will call!
        DispatchQueue.main.async {
            ChatDB.child(self.uid).queryOrderedByValue().observe(.value) { (snapshot) in
                ChatDB.child(self.uid).removeAllObservers()
                self.retreiveNewUserMessages()
                if let snapShot = snapshot.children.allObjects as? [DataSnapshot] {
                    if snapShot.count > 0
                    {
                        //let temparr = ((snapShot as NSArray).value(forKey: "value") as! NSArray)[0]
                        //                    if snapShot.count > self.arrMsgGroupId.count && (temparr as AnyObject).count > 1
                        //                    {
                        if snapShot.count > self.arrMsgGroupId.count{
                            if self.arrMsgGroupId.count != 0
                            {
                                
                            }
                            else{
                                //MARK:- Retreive Data if App first time run so Fetch the Complete Data
                                let datadic = (snapshot.value as! NSDictionary)
                                if datadic.count > 0
                                {
                                    for tempdatadic in datadic
                                    {
                                        self.funInsertMessageInArrays(datadic: tempdatadic.value as! NSDictionary, key: tempdatadic.key as! String)
                                    }
                                    if self.arrMsgGroupId.count > self.arrUserPhoneNumber.count
                                    {
                                        var tempcount = 0
                                        var tempcountGroup = 0
                                        //Add complete User which retreive 1st time
                                        DispatchQueue.main.async{
                                            for uid in self.arrMsgOtherUid
                                            {
                                                //                                        if uid as! String == ""
                                                //                                        {
                                                //                                            tempcount = tempcount + 1
                                                //                                        }
                                                if self.arrMsgGroupType[tempcountGroup] as? String == "Private Chat"
                                                {
                                                    UserDB.child(uid as! String).observe(.value, with: { (subsnapshot) in
                                                        UserDB.child(uid as! String).removeAllObservers()
                                                        print(subsnapshot)
                                                        if subsnapshot.childrenCount > 0
                                                        {
                                                            
                                                            tempcount = tempcount + 1
                                                            self.arrMsgProfilePic.add((subsnapshot.value as! NSDictionary).value(forKey: "UserLink") as! String)
                                                            
                                                            self.arrUserPhoneNumber.add((subsnapshot.value as! NSDictionary).value(forKey: "UserPhoneNumber") as! String)
                                                            
                                                            //self.arrMsgUserName.add((subsnapshot.value as! NSDictionary).value(forKey: "UserName") as! String)
                                                            
                                                            
                                                            
                                                            var tempphone = (subsnapshot.value as! NSDictionary).value(forKey: "UserPhoneNumber") as! String
                                                            
                                                            tempphone = tempphone.replacingOccurrences(of: " ", with: "")
                                                            tempphone = tempphone.replacingOccurrences(of: "+", with: "")
                                                            
                                                            if tempphone.first == "0" || tempphone.first == "+"
                                                            {
                                                                tempphone.removeFirst()
                                                            }
                                                            if tempphone.first == "0"
                                                            {
                                                                tempphone.removeFirst()
                                                            }
                                                            
                                                            let string = "hello Swift"
                                                            if string.contains("Swift") {
                                                                print("exists")
                                                            }
                                                            
                                                            if arrGnumber.contains(tempphone)
                                                            {
                                                                let tempindex = arrGnumberWithoutSpaces.index(of: tempphone)
                                                                self.arrMsgUserName.add(arrGfullname[tempindex])
                                                            }
                                                            else
                                                            {
                                                                self.arrMsgUserName.add((subsnapshot.value as! NSDictionary).value(forKey: "UserPhoneNumber") as! String)
                                                            }
                                                            
                                                            
                                                            self.arrUserUserId.add((subsnapshot.value as! NSDictionary).value(forKey: "user_id") as! String)
                                                            
                                                            self.arrMsgShowLastSeen.add((subsnapshot.value as! NSDictionary).value(forKey: "Last Seen") as Any)
                                                            self.arrMsgShowProfilePhoto.add((subsnapshot.value as! NSDictionary).value(forKey: "Profile Photo") as Any)
                                                            self.arrMsgShowSeeAbout.add((subsnapshot.value as! NSDictionary).value(forKey: "See About") as Any)
                                                            
                                                            if self.arrMsgOtherUid.count == tempcount
                                                            {
                                                                self.tablev.reloadData()
                                                                DispatchQueue.main.async {
                                                                    self.tablev.reloadData()
                                                                    self.lblsearching.isHidden = true
                                                                    self.tablev.reloadData {
                                                                        self.andicator.stopAnimating()
                                                                    }
                                                                    
                                                                }
                                                            }
                                                        }
                                                    })
                                                }
                                                else if self.arrMsgGroupType[tempcountGroup] as? String == "Public Group"
                                                {
                                                    let tempgroupid = self.arrMsgGroupId[tempcountGroup] as! String
                                                    GroupsDB.child(tempgroupid).observe(.value, with: { (subsnapshot) in
                                                        GroupsDB.child(tempgroupid).removeAllObservers()
                                                        print(subsnapshot)
                                                        if subsnapshot.childrenCount > 0
                                                        {
                                                            tempcount = tempcount + 1
                                                            self.arrMsgProfilePic.add((subsnapshot.value as! NSDictionary).value(forKey: "groupImage") as! String)
                                                            self.arrMsgUserName.add((subsnapshot.value as! NSDictionary).value(forKey: "groupName") as! String)
                                                            self.arrUserPhoneNumber.add("")
                                                            self.arrUserUserId.add("")
                                                            self.arrMsgShowLastSeen.add("")
                                                            self.arrMsgShowProfilePhoto.add("")
                                                            self.arrMsgShowSeeAbout.add("")
                                                            
                                                            if self.arrMsgOtherUid.count == tempcount
                                                            {
                                                                self.tablev.reloadData()
                                                                DispatchQueue.main.async {
                                                                    self.tablev.reloadData {
                                                                        DispatchQueue.main.async {
                                                                            if arrGusername.count == 0
                                                                            {
                                                                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "fetchAllContacts"), object: nil)
                                                                            }
                                                                        }
                                                                    }
                                                                    self.lblsearching.isHidden = true
                                                                    self.andicator.stopAnimating()
                                                                }
                                                            }
                                                        }
                                                    })
                                                }
                                                tempcountGroup = tempcountGroup + 1
                                            }//MARK:- End for loop
                                            //MARK:- Message Delivery Status Update When App Run This Screen  First Time
                                            self.lblsearching.isHidden = true
                                            self.andicator.stopAnimating()
                                            DispatchQueue.main.async {
                                                self.funMessageStatusUpdateWhenAppRun()
                                                DispatchQueue.main.async {
                                                    self.funTypingNewMessageUserValueChange()
                                                }
                                            }
                                        }//MARK:- End of Dispatch Queue
                                    }//MARK:- End if
                                }
                                self.btnchat.isUserInteractionEnabled = true
                            }//End Else Check
                        }
                        else{
                            //MARK:- When new user not Added only observer observe the value in DB
                            //MARK:- If user contact not fetch this will call
                            if arrGusername.count == 0
                            {
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "fetchAllContacts"), object: nil)
                            }
                            self.btnchat.isUserInteractionEnabled = true
                            self.lblsearching.isHidden = true
                            self.andicator.stopAnimating()
                            return
                        }
                    }
                    else
                    {
                        self.btnchat.isUserInteractionEnabled = true
                        self.lblsearching.isHidden = true
                        self.andicator.stopAnimating()
                        DispatchQueue.main.async {
                            self.funTypingNewMessageUserValueChange()
                        }
                        //MARK:- If user contact not fetch this will call
                        if arrGusername.count == 0
                        {
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "fetchAllContacts"), object: nil)
                        }
                    }
                    //MARK:- This observer is use for if other use is typing or recording or send message then we will change the values of inbox
                }
            }
        }
    }
    
    //MARK:- Other User Typing Status and New Message Receive
    func funTypingNewMessageUserValueChange()
    {
        ChatDB.child(uid).observe(.childChanged) { (snapshot) in
            //print(snapshot)
            let groupid = (snapshot.key)
            //MARK:- Update value in Chat DB when other user send us a message
            if self.arrMsgGroupId.contains(groupid) == true
            {
                let indexofchild = self.arrMsgGroupId.index(of: groupid)
                let indexPath = IndexPath(row: indexofchild, section: 0)
                if self.arrMsgLastMsgId[indexofchild] as! String != (snapshot.value as! NSDictionary).value(forKey: "lastMessageId") as! String
                {
                    //MARK:- Receive New Message
                    //MARK:- Check
                    //MARK:- If Typing Recording or Delivery Status Changes This will Call
                    self.arrMsgFomUid[indexofchild] = (snapshot.value as! NSDictionary).value(forKey: "lastMessageUserId") as! String
                    self.arrMsgOtherUid[indexofchild] = (snapshot.value as! NSDictionary).value(forKey: "otherUserId") as! String
                    self.arrMsgLast[indexofchild] = (snapshot.value as! NSDictionary).value(forKey: "lastMessage") as! String
                    self.arrMsgStatus[indexofchild] = (snapshot.value as! NSDictionary).value(forKey: "lastMessageStatus") as Any
                    self.arrMsgType[indexofchild] = (snapshot.value as! NSDictionary).value(forKey: "lastMessageType") as Any
                    self.arrMsgTime[indexofchild] = (snapshot.value as! NSDictionary).value(forKey: "lastMessageTime") as Any
                    self.arrMsgSeen[indexofchild] = (snapshot.value as! NSDictionary).value(forKey: "seen") as Any
                    self.arrMsgNumber[indexofchild] = (snapshot.value as! NSDictionary).value(forKey: "userPhoneNumber") as Any
                    self.arrMsgTyping[indexofchild] = (snapshot.value as! NSDictionary).value(forKey: "typing") as Any
                    self.arrMsgGroupType[indexofchild] = (snapshot.value as! NSDictionary).value(forKey: "groupType") as! String
                    self.arrMsgLastMsgId[indexofchild] = (snapshot.value as! NSDictionary).value(forKey: "lastMessageId") as! String
                    self.arrMsgUnSeenCount[indexofchild] = (snapshot.value as! NSDictionary).value(forKey: "unSeenCount") as Any
                    
                    self.arrMsgShowLastSeen[indexofchild] = (snapshot.value as! NSDictionary).value(forKey: "Last Seen") as Any
                    self.arrMsgShowProfilePhoto[indexofchild] = (snapshot.value as! NSDictionary).value(forKey: "Profile Photo") as Any
                    self.arrMsgShowSeeAbout[indexofchild] = (snapshot.value as! NSDictionary).value(forKey: "See About") as Any
                    
                    
                    //MARK:- Insert new row in table view
                    self.tablev.reloadRows(at: [indexPath], with: .none)
                    //MARK:- Message Delivery Status Update When App Receive New Message
                    if (snapshot.value as! NSDictionary).value(forKey: "groupType") as! String == "Private Chat"
                    {
                        self.funMessageStatusUpdateRunTime(indexofchild: indexofchild)
                    }
                    
                    //MARK:- Need to delete row and show in top
                    let profilepic = self.arrMsgProfilePic[indexofchild]
                    let username = self.arrMsgUserName[indexofchild]
                    let usernumber = self.arrUserPhoneNumber[indexofchild]
                    let useriddd = self.arrUserUserId[indexofchild]
                    
                    self.arrMsgFomUid.removeObject(at: indexofchild)
                    self.arrMsgOtherUid.removeObject(at: indexofchild)
                    self.arrMsgLast.removeObject(at: indexofchild)
                    self.arrMsgStatus.removeObject(at: indexofchild)
                    self.arrMsgType.removeObject(at: indexofchild)
                    self.arrMsgTime.removeObject(at: indexofchild)
                    self.arrMsgSeen.removeObject(at: indexofchild)
                    self.arrMsgNumber.removeObject(at: indexofchild)
                    self.arrMsgTyping.removeObject(at: indexofchild)
                    self.arrMsgGroupType.removeObject(at: indexofchild)
                    self.arrMsgLastMsgId.removeObject(at: indexofchild)
                    self.arrMsgUnSeenCount.removeObject(at: indexofchild)
                    self.arrMsgGroupId.removeObject(at: indexofchild)
                    
                    self.arrMsgProfilePic.removeObject(at: indexofchild)
                    self.arrMsgUserName.removeObject(at: indexofchild)
                    self.arrUserPhoneNumber.removeObject(at: indexofchild)
                    self.arrUserUserId.removeObject(at: indexofchild)
                    
                    self.arrMsgShowLastSeen.removeObject(at: indexofchild)
                    self.arrMsgShowProfilePhoto.removeObject(at: indexofchild)
                    self.arrMsgShowSeeAbout.removeObject(at: indexofchild)
                    
                    self.funInsertMessageOnTop(datadic: snapshot.value as! NSDictionary, key: snapshot.key)
                    let lastmsg = (snapshot.value as! NSDictionary).value(forKey: "lastMessage") as! String
                    let grouptype = (snapshot.value as! NSDictionary).value(forKey: "groupType") as! String
                    if lastmsg == "Group icon has been update" || lastmsg == "Group name has been update" || lastmsg == "Group have been update" || lastmsg == "You have been update this group" && grouptype == "Public Group"
                    {
                        GroupsDB.child(snapshot.key).observe(.value, with: { (subsnapshot) in
                            print(subsnapshot)
                            GroupsDB.child(snapshot.key).removeAllObservers()
                            if subsnapshot.childrenCount > 0
                            {
                                self.arrMsgProfilePic.insert((subsnapshot.value as! NSDictionary).value(forKey: "groupImage") as! String, at: 0)
                                self.arrMsgUserName.insert((subsnapshot.value as! NSDictionary).value(forKey: "groupName") as! String, at: 0)
                                
                                self.arrUserPhoneNumber.insert("", at: 0)
                                self.arrUserUserId.insert("", at: 0)
                                
                                self.arrMsgShowLastSeen.insert("", at: 0)
                                self.arrMsgShowProfilePhoto.insert("", at: 0)
                                self.arrMsgShowSeeAbout.insert("", at: 0)

                                // Move the corresponding row in the table view to reflect this change
                                self.tablev.moveRow(at: indexPath, to: NSIndexPath(row: 0, section: 0) as IndexPath)
                                self.tablev.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .none)
                                DispatchQueue.main.async {
                                    
                                }
                            }
                        })
                    }
                    else
                    {
                        self.arrMsgProfilePic.insert(profilepic, at: 0)
                        self.arrMsgUserName.insert(username, at: 0)
                        self.arrUserPhoneNumber.insert(usernumber, at: 0)
                        self.arrUserUserId.insert(useriddd, at: 0)
                        
                        // Move the corresponding row in the table view to reflect this change
                        self.tablev.moveRow(at: indexPath, to: NSIndexPath(row: 0, section: 0) as IndexPath)
                    }
                }
                else
                {
                    //MARK:- Check
                    //MARK:- If Typing Recording or Delivery Status Changes This will Call
                    self.arrMsgFomUid[indexofchild] = (snapshot.value as! NSDictionary).value(forKey: "lastMessageUserId") as! String
                    self.arrMsgOtherUid[indexofchild] = (snapshot.value as! NSDictionary).value(forKey: "otherUserId") as! String
                    self.arrMsgLast[indexofchild] = (snapshot.value as! NSDictionary).value(forKey: "lastMessage") as! String
                    self.arrMsgStatus[indexofchild] = (snapshot.value as! NSDictionary).value(forKey: "lastMessageStatus") as Any
                    self.arrMsgType[indexofchild] = (snapshot.value as! NSDictionary).value(forKey: "lastMessageType") as Any
                    self.arrMsgTime[indexofchild] = (snapshot.value as! NSDictionary).value(forKey: "lastMessageTime") as Any
                    self.arrMsgSeen[indexofchild] = (snapshot.value as! NSDictionary).value(forKey: "seen") as Any
                    self.arrMsgNumber[indexofchild] = (snapshot.value as! NSDictionary).value(forKey: "userPhoneNumber") as Any
                    self.arrMsgTyping[indexofchild] = (snapshot.value as! NSDictionary).value(forKey: "typing") as Any
                    self.arrMsgGroupType[indexofchild] = (snapshot.value as! NSDictionary).value(forKey: "groupType") as! String
                    self.arrMsgLastMsgId[indexofchild] = (snapshot.value as! NSDictionary).value(forKey: "lastMessageId") as! String
                    self.arrMsgUnSeenCount[indexofchild] = (snapshot.value as! NSDictionary).value(forKey: "unSeenCount") as Any
                    
                    self.arrMsgShowLastSeen[indexofchild] = (snapshot.value as! NSDictionary).value(forKey: "Last Seen") as Any
                    self.arrMsgShowProfilePhoto[indexofchild] = (snapshot.value as! NSDictionary).value(forKey: "Profile Photo") as Any
                    self.arrMsgShowSeeAbout[indexofchild] = (snapshot.value as! NSDictionary).value(forKey: "See About") as Any
                    
                    //MARK:-
                    DispatchQueue.main.async {
                        
                    }
                    self.tablev.reloadRows(at: [indexPath], with: .none)
                    // self.tablev.reloadData()
                }
            }
        }
    }
    //MARK:- Message Delivery Status Update When App Receive New Message
    func funMessageStatusUpdateRunTime(indexofchild: Int)
    {
        //MARK:- Last Message Delivery Status Update against send messages from other user
        if self.arrMsgOtherUid.count > 0
        {
            let groupid = self.arrMsgGroupId[indexofchild] as! String
            let otheruid = self.arrMsgOtherUid[indexofchild] as! String
            let lastmsgid = self.arrMsgLastMsgId[indexofchild] as! String
            
            var tempMsgStatus = Int()
            //MARK:- Check
            if defaults.value(forKey: "is_chatscreen") as? String == "1" && self.ifScreenOpenOtherUserId == otheruid
            {
                ChatDB.child(uid).child(groupid).observe(.value, with: { (snapshot) in
                    ChatDB.child(self.uid).child(groupid).removeAllObservers()
                    if let snapShot = snapshot.children.allObjects as? [DataSnapshot] {
                        if snapShot.count > 0{
                            ChatDB.child(self.uid).child(groupid).updateChildValues(["unSeenCount":0])
                        }
                    }
                })
            }
            else
            {
                tempMsgStatus = DELIVERED
            }
            tempMsgStatus = DELIVERED
            if otheruid != ""
            {
                ChatDB.child(otheruid).child(groupid).observe(.value, with: { (snapshot) in
                    ChatDB.child(otheruid).child(groupid).removeAllObservers()
                    if let snapShot = snapshot.children.allObjects as? [DataSnapshot] {
                        if snapShot.count > 0{
                            if let lastmessagestatus = (snapshot.value as! NSDictionary).value(forKey: "lastMessageStatus") as? Int
                            {
                                if lastmessagestatus != SEEN && lastmessagestatus != DELIVERED
                                {
                                    ChatDB.child(otheruid).child(groupid).updateChildValues(["lastMessageStatus":tempMsgStatus])
                                }
                            }
                        }
                    }
                })
                
                MessagesDB.child(groupid).child(otheruid).child(lastmsgid).observe(.value) { (snapshot) in
                    MessagesDB.child(groupid).child(otheruid).child(lastmsgid).removeAllObservers()
                    if let snapShot = snapshot.children.allObjects as? [DataSnapshot] {
                        if snapShot.count > 0
                        {
                            if let lastmessagestatus = (snapshot.value as! NSDictionary).value(forKey: "messageStatus") as? Int
                            {
                                if lastmessagestatus != tempMsgStatus
                                {
                                    //MARK:- Check
                                    if defaults.value(forKey: "is_chatscreen") as? String == "1" && self.ifScreenOpenOtherUserId == otheruid
                                    {
                                        
                                    }
                                    else
                                    {
                                         MessagesDB.child(groupid).child(otheruid).child(lastmsgid).updateChildValues(["messageStatus": tempMsgStatus])
                                    }
                                }
                            }
                            else if let lastmessagestatus = (snapshot.value as! NSDictionary).value(forKey: "messageStatus") as? String
                            {
                                if lastmessagestatus != "\(tempMsgStatus)"
                                {
                                    //MARK:- Check
                                    if defaults.value(forKey: "is_chatscreen") as? String == "1" && self.ifScreenOpenOtherUserId == otheruid
                                    {
                                        
                                    }
                                    else
                                    {
                                        
                                        MessagesDB.child(groupid).child(otheruid).child(lastmsgid).observe(.value) { (snapshot) in
                                            MessagesDB.child(groupid).child(otheruid).child(lastmsgid).removeAllObservers()
                                            if let snapShot = snapshot.children.allObjects as? [DataSnapshot] {
                                                if snapShot.count > 0
                                                {
                                                    MessagesDB.child(groupid).child(otheruid).child(lastmsgid).updateChildValues(["messageStatus": tempMsgStatus])
                                                }
                                                
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    //MARK:- Message Delivery Status Update When App This Screen Run First Time
    func funMessageStatusUpdateWhenAppRun()
    {
        //MARK:- Last Message Delivery Status Update against send messages from other user
        if arrMsgOtherUid.count > 0
        {
            for index in 0...self.arrMsgOtherUid.count - 1 {
                let groupid = self.arrMsgGroupId[index] as! String
                let otheruid = self.arrMsgOtherUid[index] as! String
                let lastmsgid = self.arrMsgLastMsgId[index] as! String
                let lastmsgstatus = self.arrMsgStatus[index] as! Int
                let grouptype = self.arrMsgGroupType[index] as! String
                if grouptype == "Private Chat"{
                    ChatDB.child(otheruid).child(groupid).observe(.value, with: { (snapshot) in
                        ChatDB.child(otheruid).child(groupid).removeAllObservers()
                        if let snapShot = snapshot.children.allObjects as? [DataSnapshot] {
                            if snapShot.count > 0{
                                if lastmsgstatus != SEEN && lastmsgstatus != DELIVERED && lastmsgstatus != MESSAGE_DELETED
                                {
                                    ChatDB.child(otheruid).child(groupid).updateChildValues(["lastMessageStatus":DELIVERED])
                                }
                            }
                        }
                    })
                    MessagesDB.child(groupid).child(otheruid).child(lastmsgid).observe(.value) { (snapshot) in
                        MessagesDB.child(otheruid).child(groupid).child(lastmsgid).removeAllObservers()
                        if let snapShot = snapshot.children.allObjects as? [DataSnapshot] {
                            if snapShot.count > 0{
                                if let lastmessagestatus = (snapshot.value as! NSDictionary).value(forKey: "messageStatus") as? Int
                                {
                                    if lastmessagestatus != SEEN && lastmessagestatus != DELIVERED && lastmsgstatus != MESSAGE_DELETED
                                    {
                                        MessagesDB.child(groupid).child(otheruid).child(lastmsgid).updateChildValues(   ["messageStatus": DELIVERED])
                                    }
                                }
                                else if let lastmessagestatus = (snapshot.value as! NSDictionary).value(forKey: "messageStatus") as? String
                                {
                                    if lastmessagestatus != "\(SEEN)" && lastmessagestatus != "\(DELIVERED)"
                                    {
                                        MessagesDB.child(groupid).child(otheruid).child(lastmsgid).updateChildValues(   ["messageStatus": DELIVERED])
                                    }
                                }
                                
                            }
                        }
                    }
                }
            }//Loop End
        }
    }
    
    //MARK:- Function table view scroll to bottom
    func scrolltobottom(indexpath: IndexPath)
    {
        if arrMsgOtherUid.count > 0
        {
            self.tablev.scrollToRow(at: indexpath, at: .bottom, animated: true)
        }
    }
    
    //MARK:- Search Section
    var isFiltered = Bool()
    var count = Int()
    var arrSearchIndex = NSMutableArray()
    
    func funSearchSetting()
    {
        // search textfield func
        let btncancelSearch = UIButton(type: .custom)
        obj.putRightButtoninTextField(btn: btncancelSearch, txtfield: txtsearch, imgname: "cross", x: 20, width: 15, height: 15)
        btncancelSearch.addTarget(self, action: #selector(btncancelSearch(sender:)), for: .touchUpInside)
        
        obj.setTextFieldShade(textfield: txtsearch)
        
        txtsearch.layer.borderColor = UIColor.lightGray.cgColor
        txtsearch.layer.borderWidth = 1
        txtsearch.delegate = self
        txtsearch.addTarget(self, action: #selector(change), for: .editingChanged)
    }
    @objc func change()
    {
        let length = txtsearch.text
        if length?.count == 0
        {
            isFiltered = false
            //searchBar.responds(to: Selector(resignFirstResponder()))
            //txtsearch.resignFirstResponder()
            arrSearchIndex = NSMutableArray()
            tablev.reloadData()
        }
        else
        {
            isFiltered = true
            arrSearchIndex = NSMutableArray()
            count = 0;
            for name in arrMsgUserName
            {
                //print(name)
                // alternative: case sensitive
                if (name as! String).range(of:self.txtsearch.text!) != nil || (name as! String).lowercased().range(of:self.txtsearch.text!) != nil{
                    
                    self.arrSearchIndex.add(self.count)
                }
                // alternative: not case sensitive
                //                if name.lowercased().range(of:txtsearch.text!) != nil {
                //
                //                    arrSearchIndex.add(count)
                //                }
                self.count += 1
            }
            DispatchQueue.main.async {
                DispatchQueue.main.async {
                    self.tablev?.reloadData()
                }
            }
        }
    }
    
    var btncancelSearch = UIButton(type: .custom)
    @IBAction func btncancelSearch(sender: UIButton){
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "searchhide"), object: nil)
        searchhide()
    }
    
    @objc func searchhide()
    {
        self.view.endEditing(true)
        txtsearch.isHidden = true
        isFiltered = false
        tablev.reloadData()
        tablev.frame.origin.y = 0
        tablev.frame.size.height = self.view.frame.size.height - 6
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        eview.dismiss()
        self.view.endEditing(true)
        return true
    }
}

// MARK: - IndicatorInfoProvider for page controller like android
extension Chats: IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        let itemInfo = IndicatorInfo(title: "Chats")
        return itemInfo
    }
    
    
    func indicatorInfoForPagerTabStrip(pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        let itemInfo = IndicatorInfo(title: "Chats")
        return itemInfo
    }
}
extension NSMutableArray {
    func remove(at indexes: [Int]) {
        var lastIndex: Int? = nil
        for index in indexes.sorted(by: >) {
            guard lastIndex != index else {
                continue
            }
            remove(at: [index])
            lastIndex = index
        }
    }
}
