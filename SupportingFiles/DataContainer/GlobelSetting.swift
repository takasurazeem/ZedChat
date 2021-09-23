//
//  GlobelSetting.swift
//  Property
//
//  Created by IOS Dev on 02/03/2018.
//  Copyright © 2018 IOS Dev. All rights reserved.
//

import UIKit

class GlobelSetting: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    public func funtextfieldsetting(textfield: UITextField) {
        textfield.layer.borderWidth = 1
        textfield.layer.borderColor = appclr.cgColor
        textfield.layer.cornerRadius = textfield.frame.height / 2
    }
    
    public func funbuttonsetting(button: UIButton)
    {
        button.layer.cornerRadius = button.frame.height / 2
    }
    
    //
    public func lblsetting(label: UILabel) {
        label.textColor = appclrlabellLightGray
    }

    public func lblmultiline(label: UILabel)
    {
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
    }
    
    public func btnSetting(button: UIButton)
    {
        button.backgroundColor = appclrbtnbg
    
        //MARK:- Button Shadow and Radius
        button.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 3)
        button.layer.shadowOpacity = 0.2
        button.layer.shadowRadius = 0.0
        button.layer.masksToBounds = false
        button.layer.cornerRadius = 4.0
    }
    
    //MARK:- Change Status bar color and navigation color
    public func statusbarcolor(viewcontroller: UIViewController) {
        //MARK:- Status bar color
//        let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
//        if statusBar.responds(to:#selector(setter: UIView.backgroundColor)) {
//            statusBar.backgroundColor = appclrstatusbar
//        }
        
        
        if #available(iOS 13.0, *) {
            let app = UIApplication.shared
            let statusBarHeight: CGFloat = app.statusBarFrame.size.height
            
            let statusbarView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: statusBarHeight))
            statusbarView.backgroundColor = appclrstatusbar
            view.addSubview(statusbarView)
        } else {
            let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView
            statusBar?.backgroundColor = appclrstatusbar
        }
        UIApplication.shared.statusBarStyle = .default
    }
    
    // Marks: - Add custom popup
    public func showVerificationPopup(string: String, viewController: UIViewController)
    {
        let popvc = UIStoryboard(name: "Popup", bundle: nil).instantiateViewController(withIdentifier: "Popup") as! Popup
        PopUpVC = popvc
        popvc.viewController = self
        popvc.popupDelegate = (viewController as! PopupDelegate)
        viewController.addChild(popvc)
        let frame = CGRect(x: 0, y: 0, width: viewController.view.frame.size.width, height: viewController.view.frame.size.height)
        popvc.view.frame = frame
        viewController.view.addSubview(popvc.view)
        popvc.didMove(toParent: viewController)
        
        viewController.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        viewController.view.alpha = 0.0
        UIView.animate(withDuration: 0.25, animations: {
            viewController.view.alpha = 1.0
            viewController.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        })
    }
    // Marks: - Add custom popup
    public func showProfilePopup(type: String, viewController: UIViewController)
    {
        let popvc = UIStoryboard(name: "Popup", bundle: nil).instantiateViewController(withIdentifier: "ProfilePopup") as! ProfilePopup
        PopUpVC = popvc
        popvc.type = type
        popvc.viewController = self
        viewController.addChild(popvc)
        let frame = CGRect(x: 0, y: 0, width: viewController.view.frame.size.width, height: viewController.view.frame.size.height)
        popvc.view.frame = frame
        viewController.view.addSubview(popvc.view)
        popvc.didMove(toParent: viewController)
        viewController.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        viewController.view.alpha = 0.0
        UIView.animate(withDuration: 0.25, animations: {
            viewController.view.alpha = 1.0
            viewController.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        })
    }
    
    // Marks: - Add custom popup
    public func showDeletePopup(isDeleteForEveryOne: Int, viewController: UIViewController)
    {
        let popvc = UIStoryboard(name: "Popup", bundle: nil).instantiateViewController(withIdentifier: "PopupVC") as! PopupVC
        PopUpVC = popvc
        popvc.isDeleteForEveryOne = isDeleteForEveryOne
        popvc.viewController = self
        viewController.addChild(popvc)
        let frame = CGRect(x: 0, y: 0, width: viewController.view.frame.size.width, height: viewController.view.frame.size.height)
        popvc.view.frame = frame
        viewController.view.addSubview(popvc.view)
        popvc.didMove(toParent: viewController)
        
        viewController.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        viewController.view.alpha = 0.0
        //MARK:- agar is main 0.25 karn dain gay to popup blink kar k atta ha animation .//UIView.animate(withDuration: 0.25, animations: {
        UIView.animate(withDuration: 0.0, animations: {
            viewController.view.alpha = 1.0
            viewController.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        })
    }
    // Marks: - Remove custom popup
    public func removeVerificationPopup()
    {
        UIView.animate(withDuration: 0.25, animations: {
            PopUpVC?.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            PopUpVC?.view.alpha = 0.0
        }, completion: {(finished : Bool) in
            if(finished)
            {
                PopUpVC?.willMove(toParent: nil)
                PopUpVC?.view.removeFromSuperview()
                PopUpVC?.removeFromParent()
            }
        })
    }
    // Marks: - Remove custom popup
    public func removeVerificationPopup(viewController: UIViewController)
    {
        UIView.animate(withDuration: 0.25, animations: {
            viewController.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            viewController.view.alpha = 0.0
        }, completion: {(finished : Bool) in
            if(finished)
            {
                viewController.willMove(toParent: nil)
                viewController.view.removeFromSuperview()
                viewController.removeFromParent()
            }
        })
    }
    
    //MARK:- Check Box Custom Popup
    func showCheckBox(dataSource: [String], dataSourceSelectedCheck: [String], viewController: UIViewController){
        let popvc = UIStoryboard(name: "Popup", bundle: nil).instantiateViewController(withIdentifier: "CheckBox") as! CheckBox
        PopUpVC = popvc
        popvc.CheckBoxDelegate = (viewController as! CheckBoxDelegate)
        popvc.dataSource = dataSource
        popvc.dataSourceSelectedCheck = dataSourceSelectedCheck
        viewController.addChild(popvc)
        let frame = CGRect(x: 0, y: 0, width: viewController.view.frame.size.width, height: viewController.view.frame.size.height)
        popvc.view.frame = frame
        viewController.view.addSubview(popvc.view)
        popvc.didMove(toParent: viewController)
        
        viewController.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        viewController.view.alpha = 0.0
        //MARK:- agar is main 0.25 karn dain gay to popup blink kar k atta hxxa animation .//UIView.animate(withDuration: 0.25, animations: {
        UIView.animate(withDuration: 0.0, animations: {
            viewController.view.alpha = 1.0
            viewController.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        })
    }
    
    //MARK:- Check Box Custom Popup
    func showProgressBar(viewController: UIViewController){
        let popvc = UIStoryboard(name: "Popup", bundle: nil).instantiateViewController(withIdentifier: "ProgressBar") as! ProgressBar
        PopUpVC = popvc
        viewController.addChild(popvc)
        let frame = CGRect(x: 0, y: 0, width: viewController.view.frame.size.width, height: viewController.view.frame.size.height)
        popvc.view.frame = frame
        viewController.view.addSubview(popvc.view)
        popvc.didMove(toParent: viewController)
        
        viewController.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        viewController.view.alpha = 0.0
        //MARK:- agar is main 0.25 karn dain gay to popup blink kar k atta ha animation .//UIView.animate(withDuration: 0.25, animations: {
        UIView.animate(withDuration: 0.0, animations: {
            viewController.view.alpha = 1.0
            viewController.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        })
    }
}

//******************************************************************
// MARK: - Workaround for the Xcode 11.2 bug
//******************************************************************
class UITextViewWorkaround: NSObject {

    // --------------------------------------------------------------------
    // MARK: Singleton
    // --------------------------------------------------------------------
    // make it a singleton
    static let unique = UITextViewWorkaround()

    // --------------------------------------------------------------------
    // MARK: executeWorkaround()
    // --------------------------------------------------------------------
    func executeWorkaround() {

        if #available(iOS 13.2, *) {

            NSLog("UITextViewWorkaround.unique.executeWorkaround(): we are on iOS 13.2+ no need for a workaround")

        } else {

            // name of the missing class stub
            let className = "_UITextLayoutView"

            // try to get the class
            var cls = objc_getClass(className)

            // check if class is available
            if cls == nil {

                // it's not available, so create a replacement and register it
                cls = objc_allocateClassPair(UIView.self, className, 0)
                objc_registerClassPair(cls as! AnyClass)

                #if DEBUG
                NSLog("UITextViewWorkaround.unique.executeWorkaround(): added \(className) dynamically")
               #endif
           }
        }
    }
}
