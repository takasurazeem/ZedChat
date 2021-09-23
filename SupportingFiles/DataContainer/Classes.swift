//
//  Classes.swift
//  ZedChat
//
//  Created by Apple on 18/11/2019.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit
import Alamofire

class Classes: NSObject {

}

class VersionCheck {
  public static let shared = VersionCheck()
  func isUpdateAvailable(callback: @escaping (Bool)->Void) {
    Alamofire.request("https://itunes.apple.com/lookup?bundleId=\(BUNDLEID)").responseJSON { response in
      if let json = response.result.value as? NSDictionary, let results = json["results"] as? NSArray, let entry = results.firstObject as? NSDictionary, let appStoreVersion = entry["version"] as? String{
        APPVERSION_ON_APPLE = appStoreVersion
        if let installed = Int(APPVERSIONNUMBER!.replacingOccurrences(of: ".", with: "")), let appStore = Int(appStoreVersion.replacingOccurrences(of: ".", with: "")), appStore > installed {
          callback(true)
        }
        
      }
    }
  }
}
