//
//  ProfilePopup.swift
//  sChat
//
//  Created by MacBook Pro on 12/03/2019.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit

class ProfilePopup: UIViewController, UITextFieldDelegate {
    
    var type = ""
    var viewController = UIViewController()
    
    @IBOutlet weak var andicator: UIActivityIndicatorView!
    @IBOutlet weak var vpopup: UIView!
    @IBOutlet weak var btncancel: UIButton!
    @IBAction func btncancel(_ sender: Any) {
        objG.removeVerificationPopup()
    }
    
    @IBOutlet weak var lbltitle: UILabel!
    @IBOutlet weak var txtnamestatus: UITextField!
    
    @IBOutlet weak var btnupdate: UIButton!
    @IBAction func btnupdate(_ sender: Any) {
        if txtnamestatus.text?.isEmpty == true
        {
            obj.funValidationfromBottom(sender: txtnamestatus, text: "Please enter \(type)", view: vpopup)
            
            return
        }
        funprofileupdate(type: type, text: txtnamestatus.text!, andicator: andicator, viewController: self)
        
    }
    @IBOutlet weak var bgvfull: UIView!
    
    override func viewWillAppear(_ animated: Bool) {
        self.view.frame.origin.y = 0
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        btncancel.draw(btncancel.frame)
        lbltitle.textColor = appclr
        andicator.color = appclr
        btncancel.titleLabel?.textColor = appclr
        
        
        if type == "name"
        {
            lbltitle.text = "Update Name"
            txtnamestatus.text = (defaults.value(forKey: "username") as! String)
            txtnamestatus.attributedPlaceholder = NSAttributedString(string: "Type your name",
                                                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        }
        else if type == "status"
        {
            lbltitle.text = "Update Status"
            txtnamestatus.text = (defaults.value(forKey: "userstatus") as! String)
            txtnamestatus.attributedPlaceholder = NSAttributedString(string: "Type your status",
                                                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
            
        }
        
        // Do any additional setup after loading the view.
        txtnamestatus.delegate = self
        obj.txtbottomline(textfield: txtnamestatus)
        obj.setViewShade(view: vpopup)
        txtnamestatus.delegate = self
        btncancel.layer.cornerRadius = 4
        btnupdate.layer.cornerRadius = 4
        
        btnupdate.backgroundColor = appclr
        
        btncancel.setTitleColor(appclr, for: .normal)
        DispatchQueue.main.async{
            self.txtnamestatus.becomeFirstResponder()
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
        if txtnamestatus.text!.count > 300{
            return false
        }
        return true
    }
    
    
}
