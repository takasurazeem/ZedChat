//
//  PhoneNumber.swift
//  ZedChat
//
//  Created by MacBook Pro on 13/02/2019.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FlagPhoneNumber


class PhoneNumber: UIViewController, UITextFieldDelegate, PopupDelegate {
    
    var phonenumber = String()
    var countryCode = String()
    var countryName = String()
    @IBOutlet weak var btnNext: UIButton!
    @IBAction func btnNext(_ sender: Any) {
        if txtphone.text?.isEmpty == true {
            obj.funValidationfromBottom(sender: txtphone, text: "Please enter phone number", view: bgvphone)
        }
        else {
//            ///for testing
//            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProfileInfo") as! ProfileInfo
//            vc.phonenumber = "\(self.txtphone.text!)"
//            DispatchQueue.main.async {
//                self.navigationController?.pushViewController(vc, animated: true)
//            }
//
//
//            return
            countryName = self.txtphone.countryRepository.locale.regionCode ?? ""
            countryCode = self.txtphone.selectedCountry!.phoneCode
            phonenumber = "\(txtphone.selectedCountry!.phoneCode)\(txtphone.text!)"
            phonenumber = phonenumber.replacingOccurrences(of: " ", with: "")
            phonenumber = phonenumber.replacingOccurrences(of: "+", with: "")
            funSendPhoneAuth()
        }
    }
    @IBOutlet weak var txtphone: FPNTextField!
    
    @IBOutlet weak var imgvflag: UIImageView!
    
    @IBOutlet weak var txtcountrycode: UITextField!
    @IBOutlet weak var bgvphone: UIView!
    @IBOutlet weak var lbltitle: UILabel!
    @IBOutlet weak var lbldesc: UILabel!
    @IBAction func btntxtcountrycode(_ sender: Any) {
        
    }
    @IBOutlet weak var andicator: UIActivityIndicatorView!
    
    override func viewDidAppear(_ animated: Bool) {
        lbldesc.sizeToFit()
        lbldesc.center = self.view.center
        lbldesc.textAlignment = .center
        DispatchQueue.main.async {
            self.lbldesc.frame.origin.y = self.lbltitle.frame.maxY + 20
            self.bgvphone.frame.origin.y = self.lbldesc.frame.maxY + 20
           // obj.txtbottomline(textfield: self.txtphone)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        //defaults.setValue("0", forKey: "autologin")
        if let autologin = defaults.value(forKey: "autologin") as? String
        {
            if autologin == "1"
            {
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DashboardPC") as! DashboardPC
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        obj.hideNavBar(viewcontroller: self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        objG.lblsetting(label: lbldesc)
        objG.lblmultiline(label: lbldesc)
        lbldesc.text = "\(APPBUILDNAME ?? "") will send SMS message to verify your phone number. Enter your country code and phone number"
        txtphone.delegate = self
        obj.txtbottomline(textfield: self.txtphone)
        DispatchQueue.main.async{
            //MARK:- Defaults selected country
            self.txtphone.setFlag(key: FPNOBJCCountryKey.PK)
        }
        objG.btnSetting(button: btnNext)
        objG.statusbarcolor(viewcontroller: self)
        NotificationCenter.default.removeObserver(self)
    }
   
    func btnConfirmPressed(code: String) {
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: GlobalFireBaseverficationID,
            verificationCode: code)
        let encodedData = NSKeyedArchiver.archivedData(withRootObject: credential)
            //for testing
       
//        let credential = GoogleAuthProvider.credential(withIDToken: user.authentication!.idToken, accessToken: user.authentication!.accessToken)

        Auth.auth().signIn(with: credential, completion: { (authResult, error) in
            let currentUser = Auth.auth().currentUser
            let encodedCurrentUser = NSKeyedArchiver.archivedData(withRootObject: currentUser!)
            if error != nil {
               NotificationCenter.default.post(name: NSNotification.Name(rawValue: "stopandicator"), object: nil)
                
                obj.showAlert(title: "Alert!", message: (error?.localizedDescription)!, viewController: self)
                return
            }
            else
            {
                objG.removeVerificationPopup()
                group_defaults.set(encodedData, forKey: "firebasecredential")
                group_defaults.set(encodedCurrentUser, forKey: "currentUser")
                group_defaults.set(self.phonenumber, forKey: "phoneNumber")
                
                //MARK:- Registeration in Notification Services Device Authentication
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProfileInfo") as! ProfileInfo
                vc.phonenumber = self.phonenumber
                vc.countryCode = self.countryCode
                vc.countryName = self.countryName
                DispatchQueue.main.async {
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        })
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func funSendPhoneAuth()
    {
        andicator.startAnimating()
//        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProfileInfo") as! ProfileInfo
//        vc.phonenumber = "\(self.  .text!)"
//        self.navigationController?.pushViewController(vc, animated: true)
//       return
        
        
        PhoneAuthProvider.provider().verifyPhoneNumber(("+"+phonenumber), uiDelegate: nil){ (verificationID, error) in
            self.andicator.stopAnimating()
            if error != nil {
                obj.showAlert(title: "Alert!", message: (error?.localizedDescription)!, viewController: self)
                return
            }else{
                GlobalFireBaseverficationID = verificationID!
                
                objG.showVerificationPopup(string: "textstring", viewController: self)
            }
        }
    }
    
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
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        eview.dismiss()
        return true
    }
}

extension PhoneNumber: FPNTextFieldDelegate {
    func fpnDisplayCountryList() {
        
    }
    
    func fpnDidValidatePhoneNumber(textField: FPNTextField, isValid: Bool) {
        textField.rightViewMode = .always
        //textField.rightView = UIImageView(image: isValid ? #imageLiteral(resourceName: "flag") : #imageLiteral(resourceName: "PK"))
        
        print(
            isValid,
            textField.getFormattedPhoneNumber(format: .E164) ?? "E164: nil",
            textField.getFormattedPhoneNumber(format: .International) ?? "International: nil",
            textField.getFormattedPhoneNumber(format: .National) ?? "National: nil",
            textField.getFormattedPhoneNumber(format: .RFC3966) ?? "RFC3966: nil",
            textField.getRawPhoneNumber() ?? "Raw: nil"
        )
    }
    
    func fpnDidSelectCountry(name: String, dialCode: String, code: String) {
        print(name, dialCode, code)
    }
}
