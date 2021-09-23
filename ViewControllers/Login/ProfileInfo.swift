//
//  ProfileInfo.swift
//  ZedChat
//
//  Created by MacBook Pro on 13/02/2019.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import Alamofire
import CoreLocation
import GoogleMaps

class ProfileInfo: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, CLLocationManagerDelegate {

    var phonenumber = String()
    var countryCode = String()
    var countryName = String()
    var user_id = Int()
    
    @IBOutlet weak var lbltitle: UILabel!
    @IBOutlet weak var lbldesc: UILabel!
    @IBOutlet weak var imgvprofile: UIImageView!
    @IBOutlet weak var txtdisplayname: UITextField!
    @IBOutlet weak var txtstatus: UITextField!
    
    @IBOutlet weak var btnNext: UIButton!
    @IBAction func btnNext(_ sender: Any) {
        self.view.endEditing(true)
        if txtdisplayname.text == ""{
            obj.showAlert(title: "Alert!", message: "Please enter display name", viewController: self)
        }
        else{
            let imgname = "1.png"
            self.funUserRegisterOwnServer(imageName: imgname)
        }
        
//        if imgvprofile.image!.isEqualToImage(image: UIImage(named: "user")!)
//        {
//            //MARK:- Without Image Registration
//            defaults.setValue(imgname, forKey: "userimage")
//             DispatchQueue.main.async {
//                self.funUserRegisterOwnServer(imageName: imgname)
//             }
//        }
//        else
//        {
//            //MARK:- User Image upload
//            funUserImageUpload(completion: { imagename in
//                self.andicator.stopAnimating()
//                if imagename == "error"
//                {
//                    obj.showToast(message: "Please try again error occur", viewcontroller: self)
//                }else{
//                    imgname = imagename!
//                    defaults.setValue(imgname, forKey: "userimage")
//                    DispatchQueue.main.async {
//                        self.funUserRegisterOwnServer(imageName: imgname)
//                    }
//                }
//            })
//        }
    }
    @IBOutlet weak var bgvbtnnext: UIView!
    @IBOutlet weak var andicator: UIActivityIndicatorView!
    
    
    @IBOutlet weak var btnupload: UIButton!
    @IBAction func btnupload(_ sender: Any) {
        funUploadImage(sender: sender)
    }
    @IBOutlet weak var btnback: UIButton!
    @IBOutlet weak var btnresend: UIButton!
    @IBAction func btnback(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    override func viewDidAppear(_ animated: Bool) {
        
    }
    override func viewWillAppear(_ animated: Bool) {
       
    }
    override func viewDidLoad() {
        
        obj.txtbottomline(textfield: txtstatus)
        obj.txtbottomline(textfield: txtdisplayname)
        objG.statusbarcolor(viewcontroller: self)
        txtstatus.delegate = self
        txtdisplayname.delegate = self
        self.phonenumber = phonenumber.replacingOccurrences(of: " ", with: "")
        self.phonenumber = phonenumber.replacingOccurrences(of: "+", with: "")
                
        phonenumber = phonenumber.components(separatedBy: CharacterSet.decimalDigits.inverted).joined(separator: "")
        objG.lblsetting(label: lbldesc)
        objG.lblmultiline(label: lbldesc)
        lbldesc.text = "Please provide you name, profile picture and message."
        lbldesc.sizeToFit()
        lbldesc.center = self.view.center
        lbldesc.textAlignment = .center
        self.view.autoresizesSubviews = false
        objG.btnSetting(button: btnNext)
        locationManager.delegate = self
        let authorizationStatus = CLLocationManager.authorizationStatus()
        if (authorizationStatus == CLAuthorizationStatus.notDetermined) {
            self.locationManager.requestWhenInUseAuthorization()
        } else {
            self.locationManager.startUpdatingLocation()
        }
        registerForKeyboardNotifications()
        
        obj.setImageHeighWidth4Pad(image: imgvprofile, viewcontroller: self)
        //obj.setimageCircle(image: imgvprofile, viewcontroller: self)
        
        DispatchQueue.main.async {
            self.lbldesc.frame.origin.y = self.lbltitle.frame.maxY + 20
            self.bgvbtnnext.frame.origin.y = self.lbldesc.frame.maxY + 20
            self.btnback.frame .origin.y = self.bgvbtnnext.frame.maxY + 20
            self.btnresend.frame.origin.y = self.bgvbtnnext.frame.maxY + 20
        }
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    func registerForKeyboardNotifications(){
        //Adding notifies on keyboard appearing
        
        //Removing notifies on keyboard appearing
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShowNotification(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillBeHidden(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    //MARK:- Keyboard handle
    var activeField: UITextField?
    var keyboardtag = 0
    var tablevheight = CGFloat()
    @objc func keyboardWillShowNotification(notification: NSNotification){
        //Need to calculate keyboard exact size due to Apple suggestions
        // self.scrollView.isScrollEnabled = true
        
        var info = notification.userInfo!
        let keyboardSize = (info[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        //let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize!.height, 0.0)
        var aRect :CGRect = self.view.frame
        if let activeField = self.activeField {
            if activeField == txtstatus
            {
                // if (!(aRect.contains(activeField.frame.origin))){
                //self.view.frame = aRect
                
                // }
            }
            if keyboardtag == 0
            {
                // self.tablev.frame.size.height -= (keyboardSize!.height - 120)
                aRect.size.height -= keyboardSize!.height
                keyboardtag = 1
                if IPAD
                {
                    return
                }
                self.view.frame.origin.y = -100
            }
        }
    }
    
    @objc func keyboardWillBeHidden(notification: NSNotification){
        //Once keyboard disappears, restore original positions
        var info = notification.userInfo!
        let keyboardSize = (info[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        //let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, -keyboardSize!.height, 0.0)
        
        //self.view.frame = aRect
        if keyboardtag == 1
        {// self.view.frame.size.height = self.view.frame.size.height + (288)
            var aRect :CGRect = self.view.frame
            // self.view.endEditing(true)
            aRect.size.height += keyboardSize!.height
           
            keyboardtag = 0
            if IPAD
            {
                return
            }
            self.view.frame.origin.y = 0
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    //MARK:- Textfield Delegates
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        eview.dismiss()
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        eview.dismiss()
        self.view.endEditing(true)
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        eview.dismiss()
        activeField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField){
        activeField = nil
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        eview.dismiss()
        if txtstatus.text!.count > 300{
            return false
        }
        return true
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
            btnupload.tag = 1
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
    
    ////////////////////////////Register in Our Own Server
    func funIfRegistration(imageName: String)
    {
        DispatchQueue.main.async {
            self.funregistration(imageName: imageName)
        }
    }
    
    func funUserRegisterOwnServer(imageName: String) {
        var fcmtoken = ""
        if let token = defaults.value(forKey: "fcmtoken") as? String {
            fcmtoken = token
        }
        else
        {obj.showToast(message: "Please wait try again!", viewcontroller: self)}
        guard let userID = Auth.auth().currentUser?.uid else {
            
            obj.showToast(message: "Please wait try again!", viewcontroller: self)
            return }
        let parameters : Parameters =
            ["token":fcmtoken,
             "mac": DEVICEID,
             "cellNum": phonenumber,
             "countryCode": countryCode,
             "country":countryName,
             "email": "",
             "version": (APPVERSIONNUMBER! as NSString).floatValue,
             "name": txtdisplayname.text!,
             "firebaseUserId": userID,
             "source": "ios",
             "osVersion": IPHONESOSVERSION,
             "profilePic":imageName]
        
        andicator.startAnimating()
        obj.webService2(url: REGISTERATION, parameters: parameters, completionHandler:{ responseObject, error,responseObject2nd  in
                self.andicator.stopAnimating()
                
                if error == nil {
                    let dataarr = (responseObject2nd! as NSDictionary).value(forKey: "data") as! NSArray
                    let datadic = dataarr[0] as! NSDictionary
                    if datadic.count > 0 {
                        if let tempUserid = datadic.value(forKey: "id") as? Int {
                            self.user_id = tempUserid
                        }
                        else if let tempUserid = datadic.value(forKey: "id") as? String {
                            self.user_id = Int(tempUserid)!
                        }
                        
                        if CLLocationManager.locationServicesEnabled() {
                            switch CLLocationManager.authorizationStatus() {
                            case .notDetermined, .restricted, .denied:
                                print("No access")
                               // obj.showToast(message: "Please enable your Gps", viewcontroller: self)
                            case .authorizedAlways, .authorizedWhenInUse:
                                print("Access")
                                self.locationManager.startUpdatingLocation()
                                self.LocationName(lat: self.currentlat, lng: self.currentlong, userid: self.user_id)
                            @unknown default:
                              //  obj.showToast(message: "Please enable your Gps", viewcontroller: self)
                                break
                            }
                        } else {
                            print("Location services are not enabled")
                        
                        }
                        
                        //self.funSendCurrentLocation(userid: self.user_id)
                        group_defaults.set(self.user_id, forKey: "userid")
                        defaults.setValue("\(self.user_id)", forKey: "userid")
                        DispatchQueue.main.async {
                            self.funIfRegistration(imageName: imageName)
                        }
                    }
                    else {
                        obj.showAlert(title: "Error!", message: "Error occured try again", viewController: self)
                    }
                }
                else {
                    obj.showAlert(title: "Error!", message: (error?.description)!, viewController: self)
                }
        })
    }
    
    //MARK:- Register User
    func funregistration(imageName: String) {
        andicator.startAnimating()
        guard let userID = Auth.auth().currentUser?.uid else {
            DispatchQueue.main.async {
                self.funUserRegister(imageName: imageName)
            }
            
            return }
        USERUID = userID
        group_defaults.set(userID, forKey: "uid")
        defaults.setValue(userID, forKey: "uid")
        defaults.setValue(userID, forKey: "uidIfLogout")
        defaults.setValue("\(self.phonenumber)", forKey: "phoneno")
        group_defaults.setValue("\(self.phonenumber)", forKey: "phoneno")
        self.funUserUpdate(uid: userID, imageName: imageName)
        
//        refFireBase.child("Users")
//            .queryOrdered(byChild: "UserPhoneNumber")
//            .queryEqual(toValue: self.phonenumber)
//            .observeSingleEvent(of: .value, with: { snapshot in
//
//                if snapshot.childrenCount > 0
//                 {
//                    if let snapShot = snapshot.children.allObjects as? [DataSnapshot] {
//                        for snap in snapShot{
//                            defaults.setValue("\(self.phonenumber)", forKey: "phoneno")
//
//                            DispatchQueue.main.async {
//                                self.funUserUpdate(uid: snap.key, imagename: imagename)
//                            }
//                            break
//                        }
//                    }
//                }
//                else if snapshot.childrenCount == 0
//                {
//                    DispatchQueue.main.async {
//                        self.funUserRegister(imagename: imagename)
//                    }
//                }
//            })
    }
    
    func funUserRegister(imageName: String) {
        let timespam = Date().currentTimeMillis()!
        var fcmtoken = ""
        if let token = defaults.value(forKey: "fcmtoken") as? String
        {
            fcmtoken = token
        }
        else
        {return}
        
        andicator.startAnimating()
        guard let userID = Auth.auth().currentUser?.uid else {
            obj.showToast(message: "Please wait try again!", viewcontroller: self)
            return }
        ///// Save user Info
        UserDB.child(userID).setValue([
            "\(objUserDBM.userName)"      : self.txtdisplayname.text! as String,
            "\(objUserDBM.profilePhoto)" : imageName,
            "\(objUserDBM.status)" : "\(self.txtstatus.text!)" as String,
            "\(objUserDBM.phoneNumber)"  : self.phonenumber,
            "\(objUserDBM.userId)"  : "\(self.user_id)",
            "\(objUserDBM.deviceId)" :DEVICEID,
            "\(objUserDBM.fcmId)"    : fcmtoken,
            "\(objUserDBM.source)" : SOURCECODE,
           "\(objUserDBM.onLine)" : timespam,
            "\(objUserDBM.onLineUpdatedAt)" : timespam]
       
            as [String :Any],withCompletionBlock: {
                error, ref in
                self.andicator.stopAnimating()
                if error == nil
                {
                    /////// Save user Location
                    defaults.setValue(self.txtdisplayname.text!, forKey: "username")
                    group_defaults.setValue(self.txtdisplayname.text!, forKey: "username")
                    defaults.setValue("\(self.txtstatus.text!)", forKey: "userstatus")
                    group_defaults.setValue("\(self.txtstatus.text!)", forKey: "userstatus")
                    defaults.setValue("1", forKey: "autologin")
                    defaults.setValue("\(self.phonenumber)", forKey: "phoneno")
                    group_defaults.setValue("\(self.phonenumber)", forKey: "phoneno")
                    //obj.showToast(message: "Account Created Successfully.", viewcontroller: self)
                    
                    self.sinchLogin(userid: self.phonenumber + "_" + "\(self.user_id)")
                    
                    let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DashboardPC") as! DashboardPC
                    self.navigationController?.pushViewController(vc, animated: true)
                    //Removing notifies on keyboard appearing
                    NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
                    NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
                    //This Query is for update data gainst uid
                }
                else
                {
                    obj.showAlert(title: "Error", message: error.debugDescription, viewController: self)
                }
        })
    }
    func funUserUpdate(uid: String, imageName: String) {
        let timespam = Date().currentTimeMillis()!
        var fcmtoken = ""
        if let token = defaults.value(forKey: "fcmtoken") as? String
        {
            fcmtoken = token
        }
        else
        {return}
        ///// Update user Info
        
        UserDB.child(uid).setValue([
            "\(objUserDBM.userName)" : self.txtdisplayname.text! as String,
            "\(objUserDBM.profilePhoto)" : imageName,
            "\(objUserDBM.status)" : "\(self.txtstatus.text!)" as String,
            "\(objUserDBM.phoneNumber)" : self.phonenumber,
            "\(objUserDBM.userId)" : "\(self.user_id)",
            "\(objUserDBM.deviceId)" :DEVICEID,
            "\(objUserDBM.fcmId)" : fcmtoken,
            "\(objUserDBM.source)" : SOURCECODE,
            "\(objUserDBM.onLine)" : timespam,
            "\(objUserDBM.onLineUpdatedAt)" : timespam]
            
            as [String :Any],withCompletionBlock: {
                error, ref in
                self.andicator.stopAnimating()
                if error == nil {
                    ///// Save user Location
                    defaults.setValue(self.txtdisplayname.text!, forKey: "username")
                    group_defaults.setValue(self.txtdisplayname.text!, forKey: "username")
                    defaults.setValue("\(self.txtstatus.text!)", forKey: "userstatus")
                    group_defaults.setValue("\(self.txtstatus.text!)", forKey: "userstatus")
                    defaults.setValue(imageName, forKey: "userimg")
                    group_defaults.setValue(imageName, forKey: "userimg")
                    defaults.setValue(self.phonenumber, forKey: "userphone")
                    group_defaults.setValue(self.phonenumber, forKey: "userphone")
                    defaults.setValue("1", forKey: "autologin")
                    DispatchQueue.main.async {
                        self.sinchLogin(userid: self.phonenumber + "_" + "\(self.user_id)")
                    }
                    
                    //obj.showToast(message: "Account Created Successfully.", viewcontroller: self)
                    //Removing notifies on keyboard appearing
                    NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
                    NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)

                    let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DashboardPC") as! DashboardPC
                    DispatchQueue.main.async {
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                    
                    //This Query is for update data gainst uid
                    //ref.child("user").child(uid).updateChildValues(["latitude": self.lat, "longitude": self.lon], withCompletionBlock: {error, ref in
                    
                    //                if error == nil
                    //                {
                    //                    print("update successfully")
                    //                }
                    //                else
                    //                {
                    //
                    //                }
                    //})
                }
                else
                {
                    obj.showAlert(title: "Error", message: error.debugDescription, viewController: self)
                }
        })
    }
    
    func sinchLogin(userid: String) {
        //MARK: - Post notification when user login for sinch calling
        NotificationCenter.default.post(name: Notification.Name("UserDidLoginNotification"), object: nil, userInfo: ["userId":userid])
        //END SENDING push notification to observer Sinch Call
    }
    ////////////////////////////Upload User Image on Own Server
    func funUserImageUpload(completion: @escaping (_ imagename: String?) -> Void) {
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
   
    //MARK:- Location
    let locationManager = CLLocationManager()
    var currentlat = Double()
    var currentlong = Double()
    var newLocation = CLLocation()
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager.stopUpdatingLocation()
        
        newLocation = (locations.last)!
        
        currentlat = locations.first!.coordinate.latitude
        currentlong = locations.first!.coordinate.longitude
        
        
        if let location = locations.first {
            
            currentlat = location.coordinate.latitude
            currentlong = location.coordinate.longitude
        }
    }
    
    var address = String()
    var city = String()
    var state = String()
    var country = String()
    var postalCode = String()
    var knownName = String()
    
    func funSendCurrentLocation(userid: Int)
    {
        let parameters : Parameters =
            ["lat":currentlat,
             "lng": currentlong,
             "userId": userid,
             "address": address,
             "city": city,
             "state": state,
             "country": country,
             "knownName": knownName,
             "postalCode": postalCode,
             "dated": ""]
        
        //andicator.startAnimating()
        obj.webService(url: SENDCURRENTLOCATION, parameters: parameters, completionHandler:{ responseObject, error in
            //self.andicator.stopAnimating()
            
            if error == nil && responseObject != nil || error == "1"
            {
                
            }
            else
            {
               // obj.showAlert(title: "Error!", message: (error?.description)!, viewController: self)
            }
        })
    }
    
    // Get Location Name from Latitude and Longitude
    func LocationName(lat: Double , lng: Double, userid: Int)
    {
        geocode(latitude: lat, longitude: lng) { placemark, error in
            guard let placemark = placemark, error == nil else { return }
            var addressString = ""
            // you should always update your UI in the main thread
            DispatchQueue.main.async {
                //  update UI here
                print("address1:", placemark.thoroughfare ?? "")
                print("address2:", placemark.subThoroughfare ?? "")
                print("city:",     placemark.locality ?? "")
                print("state:",    placemark.administrativeArea ?? "")
                print("zip code:", placemark.postalCode ?? "")
                print("country:",  placemark.country ?? "")
                print("knownName:", placemark.name ?? "")
                if let address1 = placemark.thoroughfare
                {
                    addressString = (address1 as String)
                }
                if let tempcity2 = placemark.locality
                {
                    self.city = (tempcity2 as String)
                    if addressString == ""
                    {
                        addressString = (tempcity2 as String)
                    }
                    else
                    {
                        addressString = addressString + ", " + (tempcity2 as String)
                    }
                }
                if let tempstate = placemark.administrativeArea
                {
                    self.state = (tempstate as String)
                    if addressString == ""
                    {
                        addressString = (tempstate as String)
                    }
                    else
                    {
                        addressString = addressString + ", " + (tempstate as String)
                    }
                }
                if let tempzip = placemark.postalCode
                {
                    self.postalCode = tempzip
                    if addressString == ""
                    {
                        addressString = (tempzip as String)
                    }
                    else
                    {
                        addressString = addressString + ", " + (tempzip as String)
                    }
                }
                if let tempknownName = placemark.name
                {
                    self.knownName = tempknownName
                    if addressString == ""
                    {
                        //addressString = (tempknownName as String)
                    }
                    else
                    {
                        //addressString = addressString + ", " + (tempzip as String)
                    }
                }
                if let tempcountry = placemark.country
                {
                    self.country = tempcountry
                    if addressString == ""
                    {
                        addressString = (tempcountry as String)
                    }
                    else
                    {
                        addressString = addressString + ", " + (tempcountry as String)
                    }
                }
                self.address = addressString
                DispatchQueue.main.async {
                    self.funSendCurrentLocation(userid: userid)
                }
            }
        }
    }
    func geocode(latitude: Double, longitude: Double, completion: @escaping (CLPlacemark?, Error?) -> ())  {
        CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: latitude, longitude: longitude)) { placemarks, error in
            guard let placemark = placemarks?.first, error == nil else {
                completion(nil, error)
                return
            }
            completion(placemark, nil)
        }
    }
    
}
