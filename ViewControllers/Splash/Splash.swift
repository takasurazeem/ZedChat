//
//  Splash.swift
//  sChat
//
//  Created by MacBook Pro on 02/04/2019.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit
import GoogleMaps
import Alamofire
import CoreLocation
import CoreData


class Splash: UIViewController, CLLocationManagerDelegate{
    
    var isSplash = 0
    var arrGfullname_temp = [String]()
    var arrGfname_temp = [String]()
    var arrGlname_temp = [String]()
    var arrGnumber_temp = [String]()
    var arrGpic_temp = NSMutableArray()
    var arrGnumberWithoutSpaces_temp = NSMutableArray()
    
    var arrGRectifyPhone_temp = NSMutableArray()
    var arrGuserphone_temp = NSMutableArray()
    var arrGuserid_temp = NSMutableArray()
    
    @IBOutlet weak var bhview: UIView!
    override func viewDidLoad() {
        regNotificationForSplashScreen()
        super.viewDidLoad()
        //MARK:- Get Data from Database
        
        // deleteData(entityName: "Setting")
        // deleteData(entityName: "CallRecords")
        fetchData(newStorageData: NSManagedObject()){ success in
            if success == false{
                self.openDatabse()
            }else{
                
            }
        }
        // Do any additional setup after loading the view.
        self.bhview.backgroundColor = UIColor.init(patternImage: UIImage.init(named: "chat_bg.png")!)
        
        
    }
    
    func regNotificationForSplashScreen() {
        //MARK:- Notification when tap on some user
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.addObserver(self, selector: #selector(funFetchAllContacts(notification:)), name: NSNotification.Name(rawValue: "contactrefresh"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(setPassword), name: NSNotification.Name(rawValue: "setPassword"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(funUserLogOut), name: NSNotification.Name(rawValue: "funUserLogOut"), object: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
        
    }
    @objc func setPassword(){
        funLockScreen(viewController: self, isCancelButton: true, type: "new")
    }
    override func viewWillAppear(_ animated: Bool) {
        obj.hideNavBar(viewcontroller: self)
        locationManager.delegate = self
        let authorizationStatus = CLLocationManager.authorizationStatus()
        if (authorizationStatus == CLAuthorizationStatus.notDetermined) {
            self.locationManager.requestWhenInUseAuthorization()
        } else {
            self.locationManager.startUpdatingLocation()
        }
        
        if let autologin = defaults.value(forKey: "autologin") as? String
        {
            if autologin == "1"
            {
                funLockScreenCheck(viewController: self)
            }
        }
//                funFetchAllContacts(notification: Notification(name: Notification.Name(rawValue: "contactrefresh")))
//        
//                return
//
        if let temp = defaults.value(forKey: "arrGuserid") as? NSMutableArray
        {
            if temp.count != 0
            {
                arrGfullname = defaults.value(forKey: "arrGfullname") as! [String]
                arrGfname = defaults.value(forKey: "arrGfname") as! [String]
                arrGlname = defaults.value(forKey: "arrGlname") as! [String]
                arrGnumber = defaults.value(forKey: "arrGnumber") as! [String]
                
                let decoded  = defaults.object(forKey: "arrGpic") as! Data
                arrGpic = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! NSMutableArray
                //arrGpic = defaults.value(forKey: "arrGpic") as! NSMutableArray
                arrGnumberWithoutSpaces = defaults.value(forKey: "arrGnumberWithoutSpaces") as! NSMutableArray
                //////////
                arrGRectifyPhone = defaults.value(forKey: "arrGRectifyPhone") as! NSMutableArray
                arrGuserphone = defaults.value(forKey: "arrGuserphone") as! NSMutableArray
                arrGuserid = defaults.value(forKey: "arrGuserid") as! NSMutableArray
                
                ///
                
                arrGuserid = defaults.value(forKey: "arrGuserUid") as! NSMutableArray
                arrGRectifyPhone = defaults.value(forKey: "arrGRectifyPhone") as! NSMutableArray
                let decoded2  = defaults.object(forKey: "arrGuserpic") as! Data
                arrGuserpic = NSKeyedUnarchiver.unarchiveObject(with: decoded2) as! NSMutableArray
                
                //arrGuserpic = defaults.value(forKey: "arrGuserpic") as! NSMutableArray
                arrGusername = defaults.value(forKey: "arrGusername") as! NSMutableArray
                arrGuserphone = defaults.value(forKey: "arrGuserphone") as! NSMutableArray
                arrGuserFBToken = defaults.value(forKey: "arrGuserFBToken") as! NSMutableArray
                arrGuserUid =  defaults.value(forKey: "arrGuserUid") as! NSMutableArray
                
                
                arrGfullname_AppUser = defaults.value(forKey: "arrGfullname_AppUser") as! [String]
                arrGfname_AppUser = defaults.value(forKey: "arrGfname_AppUser") as! [String]
                arrGlname_AppUser = defaults.value(forKey: "arrGlname_AppUser") as! [String]
                arrGnumber_AppUser = defaults.value(forKey: "arrGnumber_AppUser") as! [String]
                
                let decoded_AppUser  = defaults.object(forKey: "arrGpic_AppUser") as! Data
                arrGpic_AppUser = NSKeyedUnarchiver.unarchiveObject(with: decoded_AppUser) as! NSMutableArray
                //arrGpic = defaults.value(forKey: "arrGpic") as! NSMutableArray
                arrGnumberWithoutSpaces_AppUser = defaults.value(forKey: "arrGnumberWithoutSpaces_AppUser") as! NSMutableArray
            }
        }
        
        if arrGnumber.count == 0 {
            funFetchAllContacts(notification: Notification(name: Notification.Name(rawValue: "contactrefresh")))
        }
        else if arrGuserphone.count == 0 {
            funRectifyUser()
        }
        else {
            // self.funSortData()
            DispatchQueue.main.async {
                self.funViewAppear()
            }
        }
    }
    
    func funViewAppear() {
        if isSplash == 0 {
            isSplash = 1
            openviewConroller()
        }
    }
    //MARK:- Open View Controller
    func openviewConroller() {
        if let autologin = defaults.value(forKey: "autologin") as? String {
            if autologin == "1" {
                if CLLocationManager.locationServicesEnabled() {
                    switch CLLocationManager.authorizationStatus() {
                    case .notDetermined, .restricted, .denied:
                        print("No access")
                        
                    // obj.showToast(message: "Please enable your Gps", viewcontroller: self)
                    case .authorizedAlways, .authorizedWhenInUse:
                        print("Access")
                        if let _ = USERID {
                            locationManager.startUpdatingLocation()
                            LocationName(lat: currentlat, lng: currentlong, userid: USERID!)
                        }
                        else {
                            
                        }
                    @unknown default:
                        //   obj.showToast(message: "Please enable your Gps", viewcontroller: self)
                        
                        break
                    }
                } else {
                    print("Location services are not enabled")
                    //obj.showToast(message: "Please enable your Gps", viewcontroller: self)
                }
                
                let phonenumber = USERUniqueID
                let tempuserid = USERID
                self.sinchLogin(userid: "\(phonenumber )" + "_" + "\(tempuserid ?? "")")
                
                DispatchQueue.main.async {
                    let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DashboardPC")
                    self.navigationController?.pushViewController(vc, animated: true)
                    //let vc = DashboardPC()
                   //` self.navigationController?.pushViewController(vc, animated: true)
                        
                   // self.present(vc, animated: true, completion: nil)
                
//                    let appdelegate = UIApplication.shared.delegate as! AppDelegate
//                    let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//                    let tableViewController = mainStoryboard.instantiateViewController(withIdentifier: "DashboardPC") as! DashboardPC
//
//                   // let navigationVC = UINavigationController(rootViewController: tableViewController)
//                    appdelegate.window!.rootViewController = navigationVC
                }
                
            }
            else
            {
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PhoneNumber") as! PhoneNumber
                DispatchQueue.main.async {
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
        else
        {
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PhoneNumber") as! PhoneNumber
            DispatchQueue.main.async {
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    func sinchLogin(userid: String)
    {
        //MARK: - Post notification when user login for sinch calling
        NotificationCenter.default.post(name: Notification.Name("UserDidLoginNotification"), object: nil, userInfo: ["userId":userid])
        //END SENDING push notification to observer Sinch Call
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
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
            if let tempid = USERID
            {
                //LocationName(lat: currentlat, lng: currentlong, userid: tempid)
            }
        }
    }
    
    var address = String()
    var city = String()
    var state = String()
    var country = String()
    var postalCode = String()
    var knownName = String()
    
    func funSendCurrentLocation(userid: String)
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
        
        obj.webService(url: SENDCURRENTLOCATION, parameters: parameters, completionHandler:{ responseObject, error in
            
            if error == nil && responseObject != nil || error == "1"
            {
                
            }
            else
            {
                //obj.showAlert(title: "Error!", message: (error?.description)!, viewController: self)
            }
        })
    }
    
    // Get Location Name from Latitude and Longitude
    func LocationName(lat: Double , lng: Double, userid: String)
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
    //1
    //////////////////////MARK:- User Contacts Get///////////////////////
    var pull = ""
    @objc func funFetchAllContacts(notification: Notification) {
        if let datadic = notification.object as? NSDictionary {
            if let temp = datadic.value(forKey: "isPull") as? String {
                if temp == "1" {
                    pull = temp
                }
            }
        }
        else {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "startAndicator"), object: nil)
        }
        
        let temp2ndarrGfullname = arrGfullname_temp
        let temp2ndarrGfname = arrGfname_temp
        let temp2ndarrGlname = arrGlname_temp
        let temp2ndarrGnumber = arrGnumber_temp
        let temp2ndarrGpic = arrGpic_temp
        let temp2ndarrGnumberWithoutSpaces = arrGnumberWithoutSpaces_temp
        
        arrGfullname_temp = [String]()
        arrGfname_temp = [String]()
        arrGlname_temp = [String]()
        arrGnumber_temp = [String]()
        arrGpic_temp = NSMutableArray()
        arrGnumberWithoutSpaces_temp = NSMutableArray()
        
        var temparrfullname = [String]()
        var temparrfname = [String]()
        var temparrlname = [String]()
        var temparrnumber = [String]()
        let temparrpic = NSMutableArray()
        //MARK:- Fetch Phone numbers from Phone
        obj.fetchContacts(completion: {contacts,error  in
            if error != ""{
                if self.isSplash == 1 {
                    DispatchQueue.main.async {
                        // create the alert
                        let alert = UIAlertController(title: "Contact!", message: "You may not see the Contact Permission is required to show your friends names", preferredStyle: UIAlertController.Style.alert)

                        // add the actions (buttons)
                        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
                        alert.addAction(UIAlertAction(title: "Setting", style: UIAlertAction.Style.destructive, handler: { action in
                            // do something like...
                            obj.funOpenAppSetting()
                        }))
                        // show the alert
                        self.present(alert, animated: true, completion: nil)
                    }
                }else{
                    self.funViewAppear()
                }
                return
            }
            contacts.forEach({print("FullNAme: \($0.value(forKey: "fullName") as Any) Name: \($0.givenName), Number: \($0.phoneNumbers.first?.value.stringValue ?? "nil")")
                //MARK:- Phone Number
                var tempphone = ""
                if let temp = $0.phoneNumbers.first?.value.stringValue
                {
                    temparrnumber.append(temp)
                    tempphone = temp
                }
                else
                {
                    if $0.phoneNumbers.first?.value.stringValue == nil{
                        return
                    }
                    temparrnumber.append(
                        "\($0.phoneNumbers.first?.value.stringValue ?? "nil")")
                }
                
                if let fullname = $0.value(forKey: "fullName") as Any as? String
                {
                    temparrfullname.append(fullname)
                }
                else if (($0.phoneNumbers.first?.value.stringValue) != nil){
                    temparrfullname.append(
                        ($0.phoneNumbers.first?.value.stringValue)!)
                }
                else{
                    temparrfullname.append("")
                }
                temparrfname.append("\($0.givenName)")
                temparrlname.append("\($0.familyName)")
                
                var img = UIImage()
                if $0.thumbnailImageData != nil
                {
                    img = UIImage.init(data: $0.thumbnailImageData!)!
                    temparrpic.add(img)
                }
                else
                {
                    if let fullname = $0.value(forKey: "fullName") as Any as? String
                    {
                        temparrpic.add(fullname)
                    }
                    else
                    {
                        temparrpic.add("\($0.givenName) \($0.familyName)")
                    }
                }
                
                tempphone = tempphone.components(separatedBy: CharacterSet.decimalDigits.inverted).joined(separator: "")
                if tempphone.first == "0" || tempphone.first == "+"
                {
                    tempphone.removeFirst()
                }
                if tempphone.first == "0"
                {
                    tempphone.removeFirst()
                }
                self.arrGnumberWithoutSpaces_temp.add(tempphone)
                // let searchToSearch = tempphone
            })
            
            if temparrnumber.count > self.arrGnumber_temp.count {
                self.arrGfullname_temp = temparrfullname
                self.arrGfname_temp = temparrfname
                self.arrGlname_temp = temparrlname
                self.arrGnumber_temp = temparrnumber
                self.arrGpic_temp = temparrpic
            }
            else {
                self.arrGfullname_temp = temp2ndarrGfullname
                self.arrGfname_temp = temp2ndarrGfname
                self.arrGlname_temp = temp2ndarrGlname
                self.arrGnumber_temp = temp2ndarrGnumber
                self.arrGpic_temp = temp2ndarrGpic
                self.arrGnumberWithoutSpaces_temp = temp2ndarrGnumberWithoutSpaces
            }
            
            defaults.setValue(self.arrGfullname_temp, forKey: "arrGfullname")
            defaults.setValue(self.arrGfname_temp, forKey: "arrGfname")
            defaults.setValue(self.arrGlname_temp, forKey: "arrGlname")
            defaults.setValue(self.arrGnumber_temp, forKey: "arrGnumber")
            let encodedData = NSKeyedArchiver.archivedData(withRootObject: self.arrGpic_temp)
            defaults.set(encodedData, forKey: "arrGpic")
            //defaults.setValue(arrGpic, forKey: "arrGpic")
            defaults.setValue(self.arrGnumberWithoutSpaces_temp, forKey: "arrGnumberWithoutSpaces")
            if contacts.count > 0 {
                DispatchQueue.main.async {
                    self.funRectifyUser()
                }
            }
            else {
                
            }
        })
        
        DispatchQueue.main.async{
            self.funViewAppear()
        }
    }
    //2
    ////////////////////////////Register in Our Own Server
    func funRectifyUser() {
        arrGRectifyPhone_temp = NSMutableArray()
        arrGuserphone_temp = NSMutableArray()
        arrGuserid_temp = NSMutableArray()
        
        var tempnumberarray = [String]()
        for tempno in arrGnumber_temp {
            var tempno2 = tempno as String
            if tempno2.first == "0" {
                tempno2.removeFirst()
            }
            if tempno2.first == "0" {
                tempno2.removeFirst()
            }
            tempnumberarray.append(tempno2)
        }
        
        var allcontactArray = tempnumberarray.joined(separator:",")
        
        allcontactArray = allcontactArray.replacingOccurrences(of: "\\s", with: "", options: .regularExpression)
        allcontactArray = allcontactArray.trimmingCharacters(in: .whitespaces)
        allcontactArray = allcontactArray.replacingOccurrences(of: " ", with: "")
        allcontactArray = allcontactArray.replacingOccurrences(of: "+", with: "")
        allcontactArray = allcontactArray.replacingOccurrences(of: "-", with: "")
        allcontactArray = allcontactArray.replacingOccurrences(of: "(", with: "")
        allcontactArray = allcontactArray.replacingOccurrences(of: ")", with: "")
        print (allcontactArray)
        let parameters : Parameters =
            ["AllContacts": allcontactArray]
        print (parameters)
        
        obj.webService2(url: RECTIFYUSER, parameters: parameters, completionHandler:{ responseObject, error, responseObject2nd  in
            
            if error == nil {
                if (responseObject?.count)! > 0 {
                    let dataarr = responseObject! as NSArray
                    if dataarr.count > 0 {
                        arrGuserpic = (dataarr.value(forKey: "ProfilePic") as! NSArray).mutableCopy() as! NSMutableArray
                        arrGuserFBToken = (dataarr.value(forKey: "fcmId") as! NSArray).mutableCopy() as! NSMutableArray
                        arrGuserUid = (dataarr.value(forKey: "firebaseUserId") as! NSArray).mutableCopy() as! NSMutableArray
                        arrGuserid = (dataarr.value(forKey: "id") as! NSArray).mutableCopy() as! NSMutableArray
                        arrGusername = (dataarr.value(forKey: "name") as! NSArray).mutableCopy() as! NSMutableArray
                        arrGRectifyPhone = (dataarr.value(forKey: "username") as! NSArray).mutableCopy() as! NSMutableArray
                        arrGuserphone = (dataarr.value(forKey: "username") as! NSArray).mutableCopy() as! NSMutableArray
                        self.funSortData()
                    }
                    else {
                        //obj.showAlert(title: "Error!", message: "Error occured try again", viewController: self)
                        
                    }
                }
                else {
                    self.funViewAppear()
                }
            }
            else {
                //obj.showAlert(title: "Error!", message: (error?.description)!, viewController: self)
                self.funRectifyUser()
            }
        })
    }
    
    func funSortData() {
        var temparrGfullname =  arrGfullname_temp
        var temparrGfname = arrGfname_temp
        var temparrGlname = arrGlname_temp
        var temparrGnumber = arrGnumber_temp
        var temparrGpic = arrGpic_temp as! [Any]
        var temparrGnumberWithoutSpaces = arrGnumberWithoutSpaces_temp as! [Any]
        
        let sortedOrder = (arrGfullname_temp).enumerated().sorted(by: {$0.1>$1.1}).map({$0.0})
        
        temparrGfullname = ((sortedOrder.map({temparrGfullname[$0]}) as NSArray).mutableCopy() as! NSMutableArray).reversed() as! [String]
        temparrGfname = ((sortedOrder.map({temparrGfname[$0]}) as NSArray).mutableCopy() as! NSMutableArray).reversed() as! [String]
        
        temparrGlname = ((sortedOrder.map({temparrGlname[$0]}) as NSArray).mutableCopy() as! NSMutableArray).reversed() as! [String]
        temparrGnumber = ((sortedOrder.map({temparrGnumber[$0]}) as NSArray).mutableCopy() as! NSMutableArray).reversed() as! [String]
        temparrGpic = ((sortedOrder.map({temparrGpic[$0]}) as NSArray).mutableCopy() as! NSMutableArray).reversed()
        temparrGnumberWithoutSpaces = ((sortedOrder.map({temparrGnumberWithoutSpaces[$0]}) as NSArray).mutableCopy() as! NSMutableArray).reversed()
        
        arrGfullname_temp = temparrGfullname
        arrGfname_temp = temparrGfname
        arrGlname_temp = temparrGlname
        arrGnumber_temp = temparrGnumber
        arrGpic_temp = (temparrGpic as NSArray).mutableCopy() as! NSMutableArray
        
        self.funSortIssChatContact()
    }
    @objc func funSortIssChatContact() {
        
        var temparrfullname = arrGfullname_temp
        var temparrfname = arrGfname_temp
        var temparrlname = arrGlname_temp
        var temparrnumber = arrGnumber_temp
        let temparrpic = arrGpic_temp
        let temparrnumberWithoutSpaces = arrGnumberWithoutSpaces_temp
        
        var temparrfullnameFind = [String]()
        var temparrfnameFind = [String]()
        var temparrlnameFind = [String]()
        var temparrnumberFind = [String]()
        var temparrpicFind = NSMutableArray()
        var temparrnumberWithoutSpacesFind = NSMutableArray()
        
        for temp in arrGRectifyPhone{
            let contactUserNo = obj.getContactNumberFromGlobalNumber(contactNumber:"\(temp)")
            print(contactUserNo)
            if contactUserNo != "" {
                var itemsArray = temparrnumber
                var searchToSearch = contactUserNo
                if searchToSearch.first == "0" {
                    searchToSearch.removeFirst()
                }
                self.find(value: searchToSearch, in: itemsArray) { userindex in
                    guard let userindex = userindex else { return }
                    //Mark:- Index Find
                    
                    let  tempfullname = temparrfullname[userindex]
                    let  tempfname = temparrfname[userindex]
                    let  templname = temparrlname[userindex]
                    let  tempnumber = temparrnumber[userindex]
                    let  temppic = temparrpic[userindex]
                    let  temptempphone = temparrnumberWithoutSpaces[userindex]
                    
                    temparrfullnameFind.append(tempfullname)
                    temparrfnameFind.append(tempfname)
                    temparrlnameFind.append(templname)
                    temparrnumberFind.append(tempnumber)
                    temparrpicFind.add(temppic)
                    temparrnumberWithoutSpacesFind.add(temptempphone)
                    
                    temparrfullname.remove(at: userindex)
                    temparrfname.remove(at: userindex)
                    temparrlname.remove(at: userindex)
                    temparrnumber.remove(at: userindex)
                    temparrpic.removeObject(at: userindex)
                    temparrnumberWithoutSpaces.remove(userindex)
                    
                    itemsArray = temparrnumber
                }
            }
            else {
                
            }
        }//MARK:- End of for loop
        
        //MARK:- Sort Find Contacts
        if temparrnumberFind.count > 0 {
            var temparrGfullname =  temparrfullnameFind
            var temparrGfname = temparrfnameFind
            var temparrGlname = temparrlnameFind
            var temparrGnumber = temparrnumberFind
            var temparrGpic = temparrpicFind as! [Any]
            var temparrGnumberWithoutSpaces = temparrnumberWithoutSpacesFind as! [Any]
            
            let sortedOrder = (temparrfullnameFind).enumerated().sorted(by: {$0.1>$1.1}).map({$0.0})
            
            temparrGfullname = ((sortedOrder.map({temparrGfullname[$0]}) as NSArray).mutableCopy() as! NSMutableArray).reversed() as! [String]
            temparrGfname = ((sortedOrder.map({temparrGfname[$0]}) as NSArray).mutableCopy() as! NSMutableArray).reversed() as! [String]
            
            temparrGlname = ((sortedOrder.map({temparrGlname[$0]}) as NSArray).mutableCopy() as! NSMutableArray).reversed() as! [String]
            temparrGnumber = ((sortedOrder.map({temparrGnumber[$0]}) as NSArray).mutableCopy() as! NSMutableArray).reversed() as! [String]
            temparrGpic = ((sortedOrder.map({temparrGpic[$0]}) as NSArray).mutableCopy() as! NSMutableArray).reversed()
            temparrGnumberWithoutSpaces = ((sortedOrder.map({temparrGnumberWithoutSpaces[$0]}) as NSArray).mutableCopy() as! NSMutableArray).reversed()
            
            temparrfullnameFind = temparrGfullname
            temparrfnameFind = temparrGfname
            temparrlnameFind = temparrGlname
            temparrnumberFind = temparrGnumber
            temparrpicFind = (temparrGpic as NSArray).mutableCopy() as! NSMutableArray
            temparrnumberWithoutSpacesFind = (temparrGnumberWithoutSpaces as NSArray).mutableCopy() as! NSMutableArray
            
        }
        //Remove own number from contact numbers
        if USERUniqueID != "" {
            let contactUserNo = obj.getContactNumberFromGlobalNumber(contactNumber:"\(USERUniqueID)")
            print(contactUserNo)
            if contactUserNo != "" {
                let itemsArray = temparrnumberFind
                var searchToSearch = contactUserNo
                if searchToSearch.first == "0" {
                    searchToSearch.removeFirst()
                }
                
                self.find(value: searchToSearch, in: itemsArray) { userindex in
                    guard let userindex = userindex else { return }
                    //Mark:- Index Find
                    temparrfullnameFind.remove(at: userindex)
                    temparrfnameFind.remove(at: userindex)
                    temparrlnameFind.remove(at: userindex)
                    temparrnumberFind.remove(at: userindex)
                    temparrpicFind.removeObject(at: userindex)
                    temparrnumberWithoutSpacesFind.remove(userindex)
                }
            }
        }
        
        //MARK:- Sort Rectify Numbers from Server
        var temp_arrGuserpic = [Any]()
        var temp_arrGuserFBToken = [Any]()
        var temp_arrGuserUid = [Any]()
        var temp_arrGuserid = [Any]()
        var temp_arrGusername = [Any]()
        var temp_arrGRectifyPhone = [Any]()
        var temp_arrGuserphone = [Any]()
        
        for (_,temp) in temparrnumberFind.enumerated() {
            let contactUserNo = obj.getContactNumberFromGlobalNumber(contactNumber:"\(temp)")
            print(contactUserNo)
            if contactUserNo != "" {
                let itemsArray = arrGuserphone
                var searchToSearch = contactUserNo
                searchToSearch = searchToSearch.components(separatedBy: CharacterSet.decimalDigits.inverted).joined(separator: "")
                if searchToSearch.first == "0" || searchToSearch.first == "+" {
                    searchToSearch.removeFirst()
                }
                if searchToSearch.first == "0" {
                    searchToSearch.removeFirst()
                }
                
                self.find(value: searchToSearch, in: itemsArray as! [String]) { userindex in
                    guard let userindex = userindex else { return }
                    //Mark:- Index Find
                    let  temp_userpic = arrGuserpic[userindex]
                    let  temp_userFBToken = arrGuserFBToken[userindex]
                    let  temp_userUid = arrGuserUid[userindex]
                    let  temp_userid = arrGuserid[userindex]
                    let  temp_username = arrGusername[userindex]
                    let  temp_phone = arrGRectifyPhone[userindex]
                    let  temp_userphone = arrGuserphone[userindex]
                    
                    temp_arrGuserpic.append(temp_userpic)
                    temp_arrGuserFBToken.append(temp_userFBToken)
                    temp_arrGuserUid.append(temp_userUid)
                    temp_arrGuserid.append(temp_userid)
                    temp_arrGusername.append(temp_username)
                    temp_arrGRectifyPhone.append(temp_phone)
                    temp_arrGuserphone.append(temp_userphone)
                }
            }
            else {
                
            }
        }//MARK:- End of for loop
        //MARK:- Sort Rectify Numbers from Server
        arrGuserpic = (temp_arrGuserpic as NSArray).mutableCopy() as! NSMutableArray
        arrGuserFBToken = (temp_arrGuserFBToken as NSArray).mutableCopy() as! NSMutableArray
        arrGuserUid = (temp_arrGuserUid as NSArray).mutableCopy() as! NSMutableArray
        arrGuserid = (temp_arrGuserid as NSArray).mutableCopy() as! NSMutableArray
        arrGusername = (temp_arrGusername as NSArray).mutableCopy() as! NSMutableArray
        arrGRectifyPhone = (temp_arrGRectifyPhone as NSArray).mutableCopy() as! NSMutableArray
        arrGuserphone = (temp_arrGuserphone as NSArray).mutableCopy() as! NSMutableArray
        defaults.setValue(arrGuserUid, forKey: "arrGuserUid")
        defaults.setValue(arrGuserid, forKey: "arrGuserid")
        defaults.setValue(arrGRectifyPhone, forKey: "arrGRectifyPhone")
        let encodedData2nd = NSKeyedArchiver.archivedData(withRootObject: arrGuserpic)
        
        defaults.setValue(encodedData2nd, forKey: "arrGuserpic")
        defaults.setValue(arrGusername, forKey: "arrGusername")
        defaults.setValue(arrGuserFBToken, forKey: "arrGuserFBToken")
        
        defaults.setValue(arrGRectifyPhone, forKey: "arrGRectifyPhone")
        defaults.setValue(arrGuserphone, forKey: "arrGuserphone")
        
        arrGfullname_temp = temparrfullnameFind + temparrfullname
        arrGfname_temp  = temparrfnameFind + temparrfname
        arrGlname_temp  = temparrlnameFind + temparrlname
        arrGnumber_temp = temparrnumberFind + temparrnumber
        let arrPicOne = temparrpicFind as! [Any]
        let arrPicTwo = temparrpic as! [Any]
        let picResult = arrPicOne + arrPicTwo
        arrGpic_temp = NSMutableArray(array:picResult)
        let arrNoOne = temparrnumberWithoutSpacesFind as! [Any]
        let arrNoTwo = temparrnumberWithoutSpaces as! [Any]
        let noResult = arrNoOne + arrNoTwo
        arrGnumberWithoutSpaces_temp = NSMutableArray(array:noResult)
        
        //AppUsers in this case invite button will not show in Contacts List
        arrGfullname_AppUser = temparrfullnameFind
        arrGfname_AppUser = temparrfnameFind
        arrGlname_AppUser = temparrlnameFind
        arrGnumber_AppUser = temparrnumberFind
        arrGnumberWithoutSpaces_AppUser = temparrnumberWithoutSpacesFind
        arrGpic_AppUser = temparrpicFind
        
        defaults.setValue(arrGfullname_AppUser, forKey: "arrGfullname_AppUser")
        defaults.setValue(arrGfname_AppUser, forKey: "arrGfname_AppUser")
        defaults.setValue(arrGlname_AppUser, forKey: "arrGlname_AppUser")
        defaults.setValue(arrGnumber_AppUser, forKey: "arrGnumber_AppUser")
        
        let encodedData_AppUser = NSKeyedArchiver.archivedData(withRootObject: arrGpic_AppUser)
        defaults.set(encodedData_AppUser, forKey: "arrGpic_AppUser")
        //defaults.setValue(arrGpic, forKey: "arrGpic")
        defaults.setValue(arrGnumberWithoutSpaces_AppUser, forKey: "arrGnumberWithoutSpaces_AppUser")
        
        arrGfullname = arrGfullname_temp
        arrGfname = arrGfname_temp
        arrGlname = arrGlname_temp
        arrGnumber = arrGnumber_temp
        arrGpic = arrGpic_temp
        arrGnumberWithoutSpaces = arrGnumberWithoutSpaces_temp
        
        defaults.setValue(arrGfullname, forKey: "arrGfullname")
        defaults.setValue(arrGfname, forKey: "arrGfname")
        defaults.setValue(arrGlname, forKey: "arrGlname")
        defaults.setValue(arrGnumber, forKey: "arrGnumber")
        
        let encodedData = NSKeyedArchiver.archivedData(withRootObject: arrGpic)
        defaults.set(encodedData, forKey: "arrGpic")
        //defaults.setValue(arrGpic, forKey: "arrGpic")
        defaults.setValue(arrGnumberWithoutSpaces, forKey: "arrGnumberWithoutSpaces")
        
        if pull == "1" {
            pull = ""
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "endRefresh"), object: nil)
        }
        else {
            pull = ""
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "stopAndicator"), object: nil)
        }
        self.funViewAppear()
    }
    
    func find(value searchValue: String, in array: [String], completion: @escaping (_ userindex: Int?) -> Void) {
        
        let itemsArray = array
        var searchToSearch = searchValue
//        searchToSearch = searchToSearch.components(separatedBy: CharacterSet.decimalDigits.inverted).joined(separator: "")
//        searchToSearch = searchToSearch.replacingOccurrences(of: "\\s", with: "", options: .regularExpression)
//        searchToSearch = searchToSearch.trimmingCharacters(in: .whitespaces)
        //searchToSearch = searchToSearch.replacingOccurrences(of: " ", with: "")
        
        
        let filteredStrings = itemsArray.filter({(item: String) -> Bool in
            
            let stringMatch = item.lowercased().range(of: searchToSearch.lowercased())
            return stringMatch != nil ? true : false
        })
        
        if filteredStrings.count > 0 {
            let temparray = array
            for (_, temp) in filteredStrings.enumerated() {
                if temparray.contains(temp){
                    let tempindex = temparray.firstIndex(of: temp)!
                    completion(tempindex)
                }
            }
//            //andicator.startAnimating()
//            if filteredStrings.count == 1
//            {
//                let tempnumber = filteredStrings[0]
//                if array.contains(tempnumber){
//                    completion(array.firstIndex(of: tempnumber)!)
//                }
//            }else{
//                var temparray = array
//                for temp in filteredStrings{
//                    //let tempnumber = filteredStrings[count]
//                    if temparray.contains(temp){
//                        let tempindex = temparray.firstIndex(of: temp)!
//                        completion(tempindex)
//                        temparray.remove(at: tempindex)
//                    }
//                }
//            }
        }
        else {
            completion(nil)
        }
    }
    
    @objc func funUserLogOut() {
        let alert = UIAlertController(title: "", message: LOGOUTMESSAGE, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Verify", style: .default, handler: { action in
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PhoneNumber") as! PhoneNumber
            DispatchQueue.main.async {
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }))
        alert.addAction(UIAlertAction(title: "Close", style: .cancel, handler: { action in
            exit(0)
        }))
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SinchLogout"), object: nil)
        defaults.setValue(nil, forKey: "autologin")
        defaults.setValue(nil, forKey: "uid")
        defaults.setValue(nil, forKey: "phoneno")
        defaults.setValue(nil, forKey: "userid")
        group_defaults.setValue(nil, forKey: "autologin")
        group_defaults.setValue(nil, forKey: "uid")
        group_defaults.setValue(nil, forKey: "phoneno")
        group_defaults.setValue(nil, forKey: "userid")
        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
    }
    
    //MARK:- This function is not used its major work is fetch contacts detals from server
    //    @objc func fetchUserData()
    //    {
    //        let tempuserid = arrGuserid
    //
    //        let temparrGuserpic = NSMutableArray()
    //        let temparrGusername = NSMutableArray()
    //        let temparrGuserphone = NSMutableArray()
    //        let temparrGuserFBToken = NSMutableArray()
    //        let temparrGuserid = NSMutableArray()
    //        let temparrGuserUid = NSMutableArray()
    //
    //        var tempcount = 0
    //       // let tempGuserid = arrGuserid
    //        let tempGRectifyPhone = arrGRectifyPhone
    //        for tempiddd in tempuserid
    //        {
    //            if tempiddd == nil
    //            {
    //                return
    //            }
    //            UserDB.queryOrdered(byChild: "user_id")
    //                .queryEqual(toValue: "\(tempiddd)")
    //                .observeSingleEvent(of: .value, with: { (snapshot) in
    //                    print(snapshot)
    //                    UserDB.child(snapshot.key).removeAllObservers()
    //                    if snapshot.childrenCount > 0
    //                    {
    //                        let datadic = (((snapshot.value as! NSDictionary).allValues as NSArray)[0]) as! NSDictionary
    //                        temparrGuserUid.add((snapshot.value as! NSDictionary).allKeys[0])
    //                        temparrGuserpic.add(datadic.value(forKey: "UserLink") as Any)
    //                        temparrGusername.add(datadic.value(forKey: "UserName") as Any)
    //                        temparrGuserphone.add(datadic.value(forKey: "UserPhoneNumber") as Any)
    //                        temparrGuserid.add(datadic.value(forKey: "user_id") as Any)
    //                        temparrGuserFBToken.add(datadic.value(forKey: "fcmId") as Any)
    //                    }
    //                    else
    //                    {
    //                        //let tempindex = arrGuserid.index(of: tempiddd)
    //                       // tempGuserid.removeObject(at: tempindex)
    //                      //  tempGRectifyPhone.removeObject(at: tempindex)
    //                    }
    //                    tempcount = tempcount + 1
    //                    if tempcount >= tempuserid.count
    //                    {
    //                        if tempuserid.count  > 0
    //                        {
    //                           // arrGuserid = tempGuserid
    //                            arrGRectifyPhone = tempGRectifyPhone
    //                            arrGuserpic = temparrGuserpic
    //                            arrGusername = temparrGusername
    //                            arrGuserphone = temparrGuserphone
    //                            arrGuserFBToken = temparrGuserFBToken
    //                            arrGuserid = temparrGuserid
    //                            arrGuserUid = temparrGuserUid
    //
    //                            defaults.setValue(arrGuserUid, forKey: "arrGuserUid")
    //                            defaults.setValue(arrGuserid, forKey: "arrGuserid")
    //                            defaults.setValue(arrGRectifyPhone, forKey: "arrGRectifyPhone")
    //                            defaults.setValue(arrGuserpic, forKey: "arrGuserpic")
    //                            defaults.setValue(arrGusername, forKey: "arrGusername")
    //                            defaults.setValue(arrGuserphone, forKey: "arrGuserphone")
    //                            defaults.setValue(arrGuserFBToken, forKey: "arrGuserFBToken")
    //                        }
    //                    }
    //                })
    //        }
    //    }
    
    
    //MARK:- Local Core Data Database
    // MARK: Methods to Open, Store and Fetch data
    func openDatabse() {
        let entityStorageData = NSEntityDescription.entity(forEntityName: "Setting", in: context)
        
        let newStorageData = NSManagedObject(entity: entityStorageData!, insertInto: context)
        
        saveData(newStorageData:newStorageData)
        // deleteData(entityName: "Setting")
        //return
        
    }
    func fetchData(newStorageData:NSManagedObject, completion: @escaping (_ success: Bool?) -> Void) {
        print("Fetching Data..")
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Setting")
        //request.fetchLimit = 1
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            if result.count == 0 {
                completion(false)
                return
            }
            //let dataArray = result as NSArray
            // let dataArray2nd = dataArray
            for data in result as! [NSManagedObject] {
                if let temp = data.value(forKey: "wifi_data") as? String{
                    WIFI_DATA = temp
                    MOBILE_DATA = data.value(forKey: "mobile_data") as! String
                    ROAMING_DATA = (data.value(forKey: "roaming_data") as? String)!
                    LOW_DATAUSAGE = data.value(forKey: "low_datausage") as! Bool
                    READ_RECEIPT = data.value(forKey: "read_receipts") as! Bool
                    completion(true)
                }
                else {
                    context.delete(data)
                    try context.save()
                    //                    appDelegate.saveContext()
                    // deleteData(entityName: "Setting")
                    
                    //saveData(newStorageData: data)
                    completion(false)
                }
                //MARK:- Get all key and Values of Cordata fetch Resul
                //let keys = Array(data.entity.attributesByName.keys)
                //let dict = data.dictionaryWithValues(forKeys: keys)
            }
        } catch {
            print("Fetching data Failed")
        }
    }
    
    func saveData(newStorageData:NSManagedObject)
    {
        WIFI_DATA = "Photo,Audio,Video,Document"
        MOBILE_DATA = "Photo"
        ROAMING_DATA = ""
        LOW_DATAUSAGE = false
        READ_RECEIPT = true
        
        //        let entity =  NSEntityDescription.entity(forEntityName: "Setting", in:context!)
        //        let item = NSManagedObject(entity: entity!, insertInto:context!)
        //
        newStorageData.setValue(WIFI_DATA, forKey: "wifi_data")
        newStorageData.setValue(MOBILE_DATA, forKey: "mobile_data")
        newStorageData.setValue(ROAMING_DATA, forKey: "roaming_data")
        newStorageData.setValue(LOW_DATAUSAGE, forKey: "low_datausage")
        newStorageData.setValue(READ_RECEIPT, forKey: "read_receipts")
        
        print("Saving Data..")
        do {
            try context!.save()
            appDelegate.saveContext()
        } catch _ {
            print("Something went wrong.")
        }
    }
    
    func deleteData(entityName:String){
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            var count = 0
            //            let dataArray = result as NSArray
            //            let dataArray2nd = dataArray
            for data in result as! [NSManagedObject] {
                //                if let temp = data.value(forKey: "wifi_data") as? String{
                //                    print(temp)
                //                }else{
                //
                //                }
                print("data: \(data)")
                context.delete(data)
                try context.save()
                print("\(count)")
                // let groupid = data.value(forKey: "groupid") as! String
                //let age = data.value(forKey: "age") as! String
                // print("User Name is : "+groupid+" and Age is : "+age)
                
                count += 1
            }
        } catch {
            print("Fetching data Failed")
        }
    }
    
}
