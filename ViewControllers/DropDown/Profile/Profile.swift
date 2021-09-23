//
//  Profile.swift
//  ZedChat
//
//  Created by MacBook Pro on 12/03/2019.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit
import Alamofire
import FirebaseDatabase
class Profile: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    
    
    
    @IBOutlet weak var andicator: UIActivityIndicatorView!
    @IBOutlet weak var bgvtop: UIView!
    @IBOutlet weak var imgvprofile: UIImageView!
    @IBOutlet weak var btnedit: UIButton!
    @IBAction func btnedit(_ sender: Any) {
        funUploadImage(sender: sender)
    }
    
    @IBOutlet weak var bgvname: UIView!
    @IBOutlet weak var lblname: UILabel!
    @IBOutlet weak var lblstatus: UILabel!
    
    @IBOutlet weak var bgvmiddle: UIView!
    @IBOutlet weak var lbldesc: UILabel!
    @IBOutlet weak var bgvstatus: UIView!
    @IBOutlet weak var lblstatustitle: UILabel!
    @IBOutlet weak var bgvphone: UIView!
    @IBOutlet weak var lblphone: UILabel!
    
    @IBOutlet weak var btnchangename: UIButton!
    @IBAction func btnchangename(_ sender: Any) {
        objG.showProfilePopup(type: "name", viewController: self)
    }
    @IBOutlet weak var btnchangestatus: UIButton!
    @IBAction func btnchangestatus(_ sender: Any) {
        let vc = UIStoryboard.init(name: "DropDown", bundle: nil).instantiateViewController(withIdentifier: "OtherTableView") as! OtherTableView
        self.navigationController?.pushViewController(vc, animated: true)
       // objG.showProfilePopup(type: "status", viewController: self)
    }
    @IBOutlet weak var btnprofilepic: UIButton!
    @IBAction func btnprofilepic(_ sender: Any) {
        if imgvprofile.image != nil{
            self.funShowProfilePic()
        }
    }
    @IBOutlet weak var tablev: UITableView!
    
    override func viewDidAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        funSetting()
    }
    
    func funSetting()
    {
        self.title = "Profile"
       // bgvtop.backgroundColor = appclrProfileBG
        
        lblstatustitle.textColor = appclr
        
        //MARK:- Back Button
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "Back"), style: .plain, target: self, action: #selector(funback))
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.addObserver(self, selector: #selector(profileupdate), name: NSNotification.Name(rawValue: "profileupdate"), object: nil)
        
        obj.labelunlimitedtext(label: lblstatus)
        if let imgurl = defaults.value(forKey: "userimage") as? String {
            if imgurl != "" {
                imgvprofile.kf.setImage(with: URL(string: USER_IMAGE_PATH + imgurl), placeholder: nil, options: nil, progressBlock: nil, completionHandler: { image, error, cacheType, imageURL in
                    if (image != nil){
                        self.imgvprofile.image = image
                    }
                    else {
                        self.imgvprofile.image = UIImage(named: "user")
                    }
                })
            }else{
                imgvprofile.contentMode = .scaleAspectFit
                imgvprofile.image = UIImage(named: "user")
            }
        }
        
        lblname.text = (defaults.value(forKey: "username") as! String)
        lbldesc.text = "This name will be visible to your \(APPBUILDNAME ?? "") Contacts."
        lblphone.text = (USERUniqueID)
        lblstatus.text = (defaults.value(forKey: "userstatus") as! String)
        DispatchQueue.main.async {
            //Provile Image and Name Background Setting
            obj.setImageHeighWidth4Pad(image: self.imgvprofile, viewcontroller: self)
            obj.setbuttonHeighWidth4Pad(button: self.btnedit, viewcontroller: self)
            DispatchQueue.main.async {
                self.imgvprofile.layer.cornerRadius = self.imgvprofile.frame.size.height / 2
            }
            self.lbldesc.sizeToFit()
            self.lblstatus.sizeToFit()
            self.lbldesc.frame.origin.y = 12
            self.bgvstatus.frame.origin.y = self.lbldesc.frame.maxY + 15
            self.lblstatus.frame.origin.y = self.lblstatustitle.frame.maxY + 8
            DispatchQueue.main.async {
                self.bgvstatus.frame.size.height = self.lblstatus.frame.maxY + 8
                self.bgvphone.frame.origin.y = self.bgvstatus.frame.maxY + 12
                //                self.btnchangename.frame.origin.y = self.bgvphone.frame.maxY + 15
                //                self.btnchangestatus.frame.origin.y = self.bgvphone.frame.maxY + 15
                
                //                self.btnchangename.layer.cornerRadius = 6
                //                self.btnchangestatus.layer.cornerRadius = 6
                // obj.setimageCircle(image: self.imgvprofile, viewcontroller: self)
                obj.setButtonCircle(button: self.btnedit)
            }
        }
        
        obj.putImgInButtonWithOutLabel(button: btnedit, imgname: "editpencil")
        obj.setViewShade(view: bgvname)
        obj.setViewShade(view: bgvphone)
        //        obj.setButtonShade(button: btnchangename)
        //        obj.setButtonShade(button: btnchangestatus)
        self.tablev.register(UINib(nibName: "NameCell", bundle: nil), forCellReuseIdentifier: "NameCell")
        self.tablev.register(UINib(nibName: "AboutCell", bundle: nil), forCellReuseIdentifier: "AboutCell")
        self.tablev.register(UINib(nibName: "PhoneNoCell", bundle: nil), forCellReuseIdentifier: "PhoneNoCell")
        self.tablev.tableFooterView = UIView()
        //MARK:- Unimited rows in cell
        tablev.rowHeight = 128
        tablev.estimatedRowHeight = UITableView.automaticDimension
    }
    
    @objc func funback()
    {
        NotificationCenter.default.removeObserver(self)
        UserDB.child(USERUID).removeAllObservers()
        self.navigationController?.popViewController(animated: true)
    }
    
    func funShowProfilePic(){
        let vc = UIStoryboard.init(name: "Storyboard", bundle: nil).instantiateViewController(withIdentifier: "DisplayVideoImage") as! DisplayVideoImage
        if imgvprofile.image != nil{
            vc.profilepic = imgvprofile.image!
        }
        else{
            vc.profilepic = UIImage(named: "user")!
        }
        vc.videoimagename = "Picture"
        vc.videoimagetag = PROFILEPIC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK:- Upload Imaage
    let picker = UIImagePickerController()
    func funUploadImage(sender: Any)
    {
        picker.delegate = self
        picker.allowsEditing = false
        //        picker.sourceType = .photoLibrary
        //        //MRK: - if use .photolibrary photos and videso both will show when library open
        //        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .savedPhotosAlbum)!
        //        present(picker, animated: true, completion: nil)
        
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.openGallary()
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        /*If you want work actionsheet on ipad
         then you have to use popoverPresentationController to present the actionsheet,
         otherwise app will crash on iPad */
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            alert.popoverPresentationController?.sourceView = sender as? UIView
            alert.popoverPresentationController?.sourceRect = (sender as AnyObject).bounds
            alert.popoverPresentationController?.permittedArrowDirections = .up
        default:
            break
        }
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func openCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera))
        {
            picker.sourceType = UIImagePickerController.SourceType.camera
            picker.allowsEditing = true
            self.present(picker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func openGallary()
    {
        picker.sourceType = UIImagePickerController.SourceType.photoLibrary
        picker.allowsEditing = true
        self.present(picker, animated: true, completion: nil)
    }
    //image picker delegates
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imgvprofile.image = pickedImage
            self.andicator.startAnimating()
            funUserImageUpload() { imagename in
                self.andicator.stopAnimating()
                guard let url = imagename else { return }
                defaults.setValue(url, forKey: "userimage")
                print("image uploaded")
                
                //NEED to fix
                UserDB.child(USERUID).observeSingleEvent(of: .value, with: { (snapshot) in
                        if snapshot.childrenCount > 0
                    {
                        let tempdic = snapshot.value as! NSMutableDictionary
                        //print(tempdic)
                        tempdic.setValue(url, forKey: "UserLink")
                        let tempimageview = UIImageView()
                        tempimageview.kf.setImage(with: URL(string: USER_IMAGE_PATH + url), placeholder: nil, options: nil, progressBlock: nil, completionHandler: { image, error, cacheType, imageURL in
                            if (image != nil){
                                self.imgvprofile.image = image
                            }
                            else {
                                self.imgvprofile.image = UIImage(named: "user")
                            }
                        })
                        
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateProfile"), object: nil)
                            
                        UserDB.child(USERUID).updateChildValues(tempdic as! [AnyHashable : Any], withCompletionBlock: {error, ref in
                            self.andicator.stopAnimating()
                            if error == nil
                            {
                                print("update successfully")
                                obj.showToast(message: "Image update successfully", viewcontroller: self)
                            }
                            else
                            {
                                obj.showToast(message: "Error occured in image upload", viewcontroller: self)
                            }
                        })
                    }
                    else if snapshot.childrenCount == 0
                    {
                        obj.showToast(message: "Error occured in image upload", viewcontroller: self)
                    }
                })
            }
        }
        else
        {
            
        }
        dismiss(animated: true, completion: nil)
    }
    
    //image picker delegates
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    //MARK:- End Upload image
    
    
    //MARK:- Upload image to Firebase Storage
    func uploadMedia(completion: @escaping (_ url: String?) -> Void) {
        // let storageRef = Storage.storage().reference().child("UserPictures")
        let filename = "UserPictures/\(defaults.value(forKey: "imagename") as! String)"
        if let uploadData = self.imgvprofile.image?.jpegData(compressionQuality: 0.4) {
            refStorageFireBase.child(filename).putData(
                uploadData,
                metadata: nil) {
                    (snapshot, error) in
                    if error != nil {
                        print("error")
                        completion("Error Occured in upload picture")
                    } else {
                        print(snapshot as Any)
                        //MARK:- Sample Url
                        // https://firebasestorage.googleapis.com/v0/b/chatapp-de622.appspot.com/o/Message_Images%2F-LY_lpC2UxBf7lQ3VPEA_thumb.jpg?alt=media&token=193523e9-62c8-4db1-9b5f-ee0c626a8d22
                        refStorageFireBase.child(filename).downloadURL { (url, error) in
                            guard let downloadURL = url else {
                                completion("Uh-oh, an error occurred! try again.")
                                return
                            }
                            //MARK:- This code is for just Example and testing the url is showing in App or not
                            //                            let imageg = UIImageView()
                            //                            imageg.kf.setImage(with: downloadURL)
                            //
                            //                            self.view.addSubview(imageg)
                            //                            imageg.bounds = self.view.bounds
                            
                            completion("\(downloadURL)")
                        }
                        
                        //completion((metadata?.downloadURL()?.absoluteString)!)
                        // your uploaded photo url.
                    }
            }
        }
    }
    
    @objc func profileupdate(notification: Notification)
    {
        let datadic = notification.object as! NSDictionary
        
        if let type = datadic.value(forKey: "type") as? String
        {
            var valuetype = ""
            let value = datadic.value(forKey: "value") as? String
            if type == "name"
            {
                valuetype = "User Name"
                lblname.text = value
            }
            else if type == "status"
            {
                valuetype = "User Status"
                lblstatus.text = value
            }
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateProfile"), object: nil)
            obj.showToast(message: "\(valuetype) update successfully", viewcontroller: self)
        }
        tablev.reloadData()
    }
    
    ////////////////////////////Upload User Image on Own Server
    func funUserImageUpload(completion: @escaping (_ imagename: String?) -> Void)
    {
        let timespamimage = "\(Date().currentTimeMillis()!).png"
        let imageData = imgvprofile.image!.jpegData(compressionQuality: 0.3)!
        let parameters : Parameters = ["filename":timespamimage]
        
        obj.webServiceWithPictureAudio(url: UPLOAD_USER_IMAGE + timespamimage, parameters: parameters, imagename: timespamimage, imageData: imageData, audioData: Data(), viewController: self, completionHandler:{
            
            responseObject, error in
            self.andicator.stopAnimating()
            
            if error == nil
            {
                completion(timespamimage)
            }
            else
            {
                completion("error")
            }
        })
    }
    ///MARK:- Table View Delegates
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableView.automaticDimension
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            let cell = tablev.dequeueReusableCell(withIdentifier: "NameCell") as! NameCell
            
            obj.labelunlimitedtext(label: cell.lbldesc)
            cell.lblname.text = (defaults.value(forKey: "username") as! String)
            cell.lbldesc.text = "This name will be visible to your \(APPBUILDNAME ?? "") Contacts."
            cell.lbldesc.sizeToFit()
            obj.setImageHeighWidth4Pad(image: cell.imgv, viewcontroller: self)
            return cell
        }
        else if indexPath.row == 1{
            let cell = tablev.dequeueReusableCell(withIdentifier: "AboutCell") as! AboutCell
           // lblphone.text = USERUniqueID
            obj.labelunlimitedtext(label: cell.lbldesc)
            cell.lbldesc.text = (defaults.value(forKey: "userstatus") as! String)
            cell.lbldesc.sizeToFit()
            obj.setImageHeighWidth4Pad(image: cell.imgv, viewcontroller: self)
            return cell
        }
        else{
            let cell = tablev.dequeueReusableCell(withIdentifier: "PhoneNoCell") as! PhoneNoCell
            cell.lbldesc.text = USERUniqueID
            obj.setImageHeighWidth4Pad(image: cell.imgv, viewcontroller: self)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0{
            objG.showProfilePopup(type: "name", viewController: self)
        }
        else if indexPath.row == 1{
            let vc = UIStoryboard.init(name: "DropDown", bundle: nil).instantiateViewController(withIdentifier: "OtherTableView") as! OtherTableView
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
