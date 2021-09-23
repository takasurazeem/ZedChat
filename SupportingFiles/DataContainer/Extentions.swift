//
//  Extentions.swift
//  sChat
//
//  Created by MacBook Pro on 09/07/2019.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit


class Extentions: NSObject {
    
}

extension String {
    var isAlphabatic: Bool {
        return !isEmpty && range(of: "[^a-zA-Z]", options: .regularExpression) == nil
    }
    var isNumeric: Bool{
        return !isEmpty && range(of: "[^0-9]", options: .regularExpression) == nil
    }
    var isAlphaNumaric: Bool{
        return !isEmpty && range(of: "[^a-zA-Z0-9]", options: .regularExpression) == nil
    }
    
}
func PhoneNumberFormate( str : NSMutableString)->String{
    str.insert("(", at: 0)
    str.insert(")", at: 4)
    str.insert("-", at: 8)
    return str as String
}


extension UIApplication {
    var statusBarView: UIView? {
        return nil
        if responds(to: Selector(("statusBar"))){
            return value(forKey: "statusBar") as? UIView
        }
        return nil
    }
    //MARK:- Usage
    // UIApplication.shared.statusBarView?.backgroundColor = .red
    
}

//auto call we can use it for themes
extension UIButton {
    open override func draw(_ rect: CGRect) {
        //provide custom style
        if self.backgroundColor == .clear{
            return
        }
        return
//        self.backgroundColor = appclr
//        self.layer.cornerRadius = 4
//        self.layer.masksToBounds = true
    }
}

extension UIActivityIndicatorView {
    open override func draw(_ rect: CGRect) {
        self.color = appclr
    }
}

extension UIApplication {
    var isKeyboardPresented: Bool {
        if let keyboardWindowClass = NSClassFromString("UIRemoteKeyboardWindow"), self.windows.contains(where: { $0.isKind(of: keyboardWindowClass) }) {
            return true
        } else {
            return false
        }
    }
    //MARK:- Usage
    //    if UIApplication.shared.isKeyboardPresented {
    //        print("Keyboard is presented")
    //    }
}

//MARK:- Blink Image view like whatsapp
extension UIImageView{
    func blink() {
        self.alpha = 0.0
        UIImageView.animate(withDuration: 1, delay: 0.3, options: [.curveLinear, .repeat, .autoreverse], animations: {self.alpha = 1.0}, completion: nil)
    }
}

//MARK:- Blink UILabel view like whatsapp
extension UILabel{
    func blink() {
        self.alpha = 0.0
        UIImageView.animate(withDuration: 2, delay: 0.3, options: [.curveLinear, .repeat, .autoreverse], animations: {self.alpha = 1.0}, completion: nil)
    }
}

//MARK:- Get the number of row in table view
extension UITableView {
    var rowsCount: Int {
        let sections = self.numberOfSections
        var rows = 0
        
        for i in 0...sections - 1 {
            rows += self.numberOfRows(inSection: i)
        }
        return rows
    }
}
//MARK:- Change the image color
extension UIImageView {
    func setImageColor(color: UIColor) {
        let templateImage = self.image?.withRenderingMode(.alwaysTemplate)
        self.image = templateImage
        self.tintColor = color
    }
}

extension UIImage {
    func isEqualToImage(image: UIImage) -> Bool {
        let data1: NSData = self.pngData()! as NSData
        let data2: NSData = image.pngData()! as NSData
        return data1.isEqual(data2)
    }
}
extension Date {
    func currentTimeMillis() -> Int64! {
        return Int64(self.timeIntervalSince1970 * 1000)
    }
}


