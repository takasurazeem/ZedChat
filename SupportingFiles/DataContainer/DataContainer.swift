//
//  DataContainer.swift
//  Cleaning Master
//
//  Created by User on 25/01/2017.
//  Copyright © 2017 Mustajab. All rights reserved.
//

import UIKit
import Alamofire
import CoreAudioKit
import EasyTipView
import Contacts
import AVFoundation

var keyboardHeight = CGFloat()


//let baseurl = DataContainer.baseUrl()

//MARK: - Easy Tip View Validation
public class DataContainer: UIViewController, URLSessionDelegate, URLSessionDataDelegate, URLSessionDownloadDelegate, URLSessionTaskDelegate {
    
    
    var dicnotification = NSDictionary()
    public var walletbalance = String()
    public var requestid = String()
    static var packageimg = UIImage()
    static var packagename = String()
    static var pakageid = String()
    
    
    
    static var strcode = String()
    static var strphoneno = String()
    static var strname = String()
    static var stremail = String()
    static var strpass = String()
    
    
    
    
    // images for dashboard, hold the image path
    
    static var imagetwopath = String()
    static var imagethreepath = String()
    
    // song backgroundimage url
    static var songimageoneurl = String()
    static var songimagetwourl = String()
    static var songimagethreeurl = String()
    static var songtitle = String()
    static var songurl = String()
    
    /////// news data
    static var arrTitle = [String]()
    static var arrDescription = [String]()
    static var arrImg = [String]()
    
    
    override public func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    override public func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    static func baseUrl() -> String
    {
        // let string = "http://app.property1.com.pk/index.php/"
        var string = ""
        //local server
        string = "http://192.168.10.12/laravel/service_square/public/api/"
        //live server
        string = "https://servicesquare.com.pk/service_square/public/api/"
        return string
    }
    
    
    
    //    //MARK: - Post WebServices for login signup without authorization
    //    func webService2(url:String , parameters:Dictionary<String,Any>, completionHandler: @escaping (NSDictionary?, String?) -> ())
    //    {
    //        let configuration = URLSessionConfiguration.default
    //        configuration.timeoutIntervalForRequest = 20
    //
    //        let sessionManager = Alamofire.SessionManager(configuration: configuration)
    //        let headers: HTTPHeaders = [
    //            //"Content-Type": "application/json",
    //            "Content-Type": "application/x-www-form-urlencoded",
    //            // "Accept": "application/json"
    //        ]
    //
    //        sessionManager.request(url, method: .post, parameters: parameters, encoding:URLEncoding.default , headers: headers).responseData(completionHandler: {
    //
    //            response in
    //            if let json = response.result.value {
    //                print("JSON: \(json)") // serialized json response
    //            }
    //            var jsonstring = String()
    //            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
    //                // print("Data: \(utf8Text)") // original server data as UTF8 string
    //                jsonstring = utf8Text
    //                do{
    //                    let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:Any]
    //
    //                    print(json!)
    //                }
    //                catch let parseError {
    //                    print(parseError)
    //                    print(jsonstring)
    //                    print("Something went wrong")
    //                    print(response.description)
    //                    print(Error.self)
    //                    //print(url)
    //                }
    //            }
    //
    //            let data = response.result
    //            switch(data)
    //            {
    //            case .success(let json):
    //                print(json)
    //
    //                if let data = jsonstring.data(using: String.Encoding.utf8) {
    //                    do {
    //                        let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:Any]
    //
    //                        completionHandler(json! as NSDictionary, nil)
    //                        print(json!)
    //                    } catch let parseError {
    //                        print(parseError)
    //                        print(jsonstring)
    //                        print("Something went wrong")
    //                        print(response.description)
    //                        print(Error.self)
    //
    //                        completionHandler(nil, "Not JSON Data.")
    //                    }
    //                }
    //
    //
    //                sessionManager.session.invalidateAndCancel()
    //                break
    //
    //                //            case .success(let JSON):
    //                //                                    completionHandler(JSON as? NSDictionary, nil)
    //                //
    //                //                                    sessionManager.session.invalidateAndCancel()
    //            //                                break
    //            case .failure(let error):
    //                if error._code == NSURLErrorCannotParseResponse
    //                {
    //                    completionHandler(nil, "Not JSON Data.")
    //                    break
    //                }
    //                else if error._code == NSURLErrorTimedOut
    //                {
    //                    completionHandler(nil, "Server is not responding, request time out please try again.")
    //                    break
    //                }
    //                else if error._code == NSURLErrorCannotFindHost
    //                {
    //                    completionHandler(nil, error.localizedDescription)
    //                    break
    //                }
    //                else if error._code == NSURLErrorNotConnectedToInternet
    //                {
    //                    completionHandler(nil, error.localizedDescription)
    //                    break
    //                }
    //                else
    //                {
    //                    completionHandler(nil, error.localizedDescription)
    //                    break
    //                }
    //            }
    //        })
    //    }
    
    //MARK: - Post WebServices
    func webService2(url:String , parameters:Dictionary<String,Any>, completionHandler: @escaping ([NSDictionary]?, String?, [String:Any]?) -> ())
    {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 20
        
        let sessionManager = Alamofire.SessionManager(configuration: configuration)
        //        let headers: HTTPHeaders = [
        //            "Content-Type": "application/json",
        //       //     "Content-Type": "application/x-www-form-urlencoded",
        //            "Accept": "application/json"
        //        ]
        sessionManager.request(url, method: .post, parameters: parameters, encoding:URLEncoding.default , headers: nil).responseData(completionHandler: {
            
            response in
            if let json = response.result.value {
                print("JSON: \(json)") // serialized json response
            }
            var jsonstring = String()
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                // print("Data: \(utf8Text)") // original server data as UTF8 string
                jsonstring = utf8Text
                if jsonstring.count > 2
                {
                    do{
                        
                        let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:Any]
                        
                        print(json as Any)
                    }
                    catch let parseError {
                        print(parseError)
                        print(jsonstring)
                        print("Something went wrong")
                        print(response.description)
                        print(Error.self)
                        //print(url)
                    }
                }
            }
            
            let data = response.result
            switch(data)
            {
            case .success(let json):
                print(json)
                
                if let data = jsonstring.data(using: String.Encoding.utf8) {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [NSDictionary]
                        if json != nil
                        {
                            completionHandler(json! as [NSDictionary], nil, nil)
                            print(json!)
                        }
                        else
                        {
                            
                            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                                // print("Data: \(utf8Text)") // original server data as UTF8 string
                                jsonstring = utf8Text
                                if jsonstring.count > 2
                                {
                                    do{
                                        
                                        let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:Any]
                                        if json != nil
                                        {
                                            completionHandler([NSDictionary](), nil, json! as [String: Any])
                                        }
                                        print(json as Any)
                                    }
                                    catch let parseError {
                                        print(parseError)
                                        print(jsonstring)
                                        print("Something went wrong")
                                        print(response.description)
                                        print(Error.self)
                                        //print(url)
                                    }
                                }
                            }
                        }
                        
                    } catch let parseError {
                        print(parseError)
                        print(jsonstring)
                        print("Something went wrong")
                        print(response.description)
                        print(Error.self)
                        
                        completionHandler(nil, "Not JSON Data.", nil)
                    }
                }
                
                
                sessionManager.session.invalidateAndCancel()
                break
                
                //            case .success(let JSON):
                //                                    completionHandler(JSON as? NSDictionary, nil)
                //
                //                                    sessionManager.session.invalidateAndCancel()
            //                                break
            case .failure(let error):
                if error._code == NSURLErrorCannotParseResponse
                {
                    completionHandler(nil, "Not JSON Data.", nil)
                    
                }
                else if error._code == NSURLErrorTimedOut
                {
                    completionHandler(nil, "Server is not responding, request time out please try again.", nil)
                    
                }
                else if error._code == NSURLErrorCannotFindHost
                {
                    completionHandler(nil, error.localizedDescription, nil)
                    
                }
                else if error._code == NSURLErrorNotConnectedToInternet
                {
                    completionHandler(nil, error.localizedDescription, nil)
                    
                }
                else
                {
                    completionHandler(nil, error.localizedDescription, nil)
                    
                }
                sessionManager.session.invalidateAndCancel()
                break
            }
        })
    }
    
    //MARK: - Post WebServices
    func webService(url:String , parameters:Dictionary<String,Any>, completionHandler: @escaping (NSDictionary?, String?) -> ())
    {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 20
        
        let sessionManager = Alamofire.SessionManager(configuration: configuration)
        //        let headers: HTTPHeaders = [
        //            "Content-Type": "application/json",
        //       //     "Content-Type": "application/x-www-form-urlencoded",
        //            "Accept": "application/json"
        //        ]
        sessionManager.request(url, method: .post, parameters: parameters, encoding:URLEncoding.default , headers: nil).responseData(completionHandler: {
            
            response in
            if let json = response.result.value {
                print("JSON: \(json)") // serialized json response
            }
            var jsonstring = String()
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                // print("Data: \(utf8Text)") // original server data as UTF8 string
                jsonstring = utf8Text
                if jsonstring.count > 2
                {
                    do{
                        
                        let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:Any]
                        
                        print(json as Any)
                    }
                    catch let parseError {
                        print(parseError)
                        print(jsonstring)
                        print("Something went wrong")
                        print(response.description)
                        print(Error.self)
                        //print(url)
                    }
                }
            }
            
            let data = response.result
            switch(data)
            {
            case .success(let json):
                print(json)
                if jsonstring == "\"1\""
                {
                    completionHandler(nil, "1")
                    sessionManager.session.invalidateAndCancel()
                    return
                }
                if let data = jsonstring.data(using: String.Encoding.utf8) {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:Any]
                        if json != nil
                        {
                            completionHandler(json! as NSDictionary, nil)
                            print(json!)
                        }
                        else
                        {
                            completionHandler(NSDictionary(), nil)
                        }
                        
                    } catch let parseError {
                        print(parseError)
                        print(jsonstring)
                        print("Something went wrong")
                        print(response.description)
                        print(Error.self)
                        
                        completionHandler(nil, "Not JSON Data.")
                    }
                }
                
                
                sessionManager.session.invalidateAndCancel()
                break
                
                //            case .success(let JSON):
                //                                    completionHandler(JSON as? NSDictionary, nil)
                //
                //                                    sessionManager.session.invalidateAndCancel()
            //                                break
            case .failure(let error):
                if error._code == NSURLErrorCannotParseResponse
                {
                    completionHandler(nil, "Not JSON Data.")
                    
                }
                else if error._code == NSURLErrorTimedOut
                {
                    completionHandler(nil, "Server is not responding, request time out please try again.")
                    
                }
                else if error._code == NSURLErrorCannotFindHost
                {
                    completionHandler(nil, error.localizedDescription)
                    
                }
                else if error._code == NSURLErrorNotConnectedToInternet
                {
                    completionHandler(nil, error.localizedDescription)
                    
                }
                else
                {
                    completionHandler(nil, error.localizedDescription)
                    
                }
                sessionManager.session.invalidateAndCancel()
                break
            }
        })
    }
    //MARK: - Post WebServices
    func webService3(url:String , parameters:Dictionary<String,Any>, completionHandler: @escaping (NSDictionary?, String?) -> ())
    {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 20
        
        let sessionManager = Alamofire.SessionManager(configuration: configuration)
        //        let headers: HTTPHeaders = [
        //            "Content-Type": "application/json",
        //       //     "Content-Type": "application/x-www-form-urlencoded",
        //            "Accept": "application/json"
        //        ]
        
        sessionManager.request(url, method: .post, parameters: parameters, encoding:URLEncoding.default , headers: nil).responseData(completionHandler: {
            
            response in
            if let json = response.result.value {
                print("JSON: \(json)") // serialized json response
            }
            var jsonstring = String()
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                // print("Data: \(utf8Text)") // original server data as UTF8 string
                jsonstring = utf8Text
                if jsonstring.count > 2
                {
                    do{
                        
                        let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:Any]
                        
                        print(json as Any)
                    }
                    catch let parseError {
                        print(parseError)
                        print(jsonstring)
                        print("Something went wrong")
                        print(response.description)
                        print(Error.self)
                        //print(url)
                    }
                }
            }
            
            let data = response.result
            switch(data)
            {
            case .success(let json):
                print(json)
                if jsonstring == "\"1\""
                {
                    completionHandler(nil, "1")
                    sessionManager.session.invalidateAndCancel()
                    return
                }
                if let data = jsonstring.data(using: String.Encoding.utf8) {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:Any]
                        if json != nil
                        {
                            completionHandler(json! as NSDictionary, nil)
                            print(json!)
                        }
                        else
                        {
                            completionHandler(NSDictionary(), nil)
                        }
                        
                    } catch let parseError {
                        print(parseError)
                        print(jsonstring)
                        print("Something went wrong")
                        print(response.description)
                        print(Error.self)
                        
                        completionHandler(nil, "Not JSON Data.")
                    }
                }
                
                
                sessionManager.session.invalidateAndCancel()
                break
                
                //            case .success(let JSON):
                //                                    completionHandler(JSON as? NSDictionary, nil)
                //
                //                                    sessionManager.session.invalidateAndCancel()
            //                                break
            case .failure(let error):
                if error._code == NSURLErrorCannotParseResponse
                {
                    completionHandler(nil, "Not JSON Data.")
                    
                }
                else if error._code == NSURLErrorTimedOut
                {
                    completionHandler(nil, "Server is not responding, request time out please try again.")
                    
                }
                else if error._code == NSURLErrorCannotFindHost
                {
                    completionHandler(nil, error.localizedDescription)
                    
                }
                else if error._code == NSURLErrorNotConnectedToInternet
                {
                    completionHandler(nil, error.localizedDescription)
                    
                }
                else
                {
                    completionHandler(nil, error.localizedDescription)
                    
                }
                sessionManager.session.invalidateAndCancel()
                break
            }
        })
    }
    //MARK: - Post WebServices
    func webServiceWithPictureAudio(url:String , parameters:Dictionary<String,Any>,imagename: String, imageData:Data, audioData:Data, viewController: UIViewController, completionHandler: @escaping ([NSDictionary]?, String?) -> ()) {
        let timespamaudio = "\(Date().currentTimeMillis()!).mp4"
        //        var headers = HTTPHeaders()
        //        headers = [
        //            //"Content-Type" :"text/html; charset=UTF-8",
        //            //"Content-Type": "application/json",
        //            "Content-Type": "application/x-www-form-urlencoded",
        //            //"Accept": "application/json",
        //            "Accept": "multipart/form-data"
        //        ]
        //        headers = [ "Content-type": "multipart/form-data",
        //                    "Accept" : "text/html; charset=UTF-8"]
        
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 20
        //configuration.httpAdditionalHeaders = headers
        //configuration.urlCredentialStorage = nil
        let sessionManager = Alamofire.SessionManager(configuration: configuration)
        var tempFirst = 0
        MEDIAPROGRESS = Float()
        sessionManager.upload(multipartFormData: { (multipartFormData) in
            
            for (key, value) in parameters {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
            if imageData.isEmpty != true {
                multipartFormData.append((imageData), withName: "filename", fileName: imagename, mimeType: "image/png/jpeg/jpg")
            }
            if audioData.isEmpty != true {
                multipartFormData.append((audioData), withName: "voice", fileName: timespamaudio, mimeType: "audio/m4a/wav/mp4")
            }
        }, to: url,
           encodingCompletion: {    response in
            switch(response)
            {
                
            case .success(let upload, _, _):
                //MARK:- Handle progress
                upload.uploadProgress { progress in
                    print("Progress: ", progress.fractionCompleted)
                    
                    // self.bar_progress.progress = Float(progress.fractionCompleted)
                    // self.lbl_uploadProgress.text = "Upload Progress: \( Int(progress.fractionCompleted * 100))%"
                    
                    if progress.fractionCompleted >= 1.0{
                        print("Progress Completed")
                        //MEDIAPROGRESS = Float(progress.fractionCompleted)
                        MEDIAPROGRESS = 1.0
                    }
                    if progress.isPausable{
                        print("Pausable")      // THIS IS WHAT I WANT
                        //objG.removeVerificationPopup(viewController: viewController)
                    }
                    else{
                        print("Not pausable")    // THIS IS MY PROBLEM
                        print("Not pausable \(progress.fractionCompleted)")
                        if tempFirst == 0{
                            tempFirst = 1
                            objG.showProgressBar(viewController: viewController)
                        }
                    }
                    MEDIAPROGRESS = Float(progress.fractionCompleted)
                }
                //MARK:- Handle Response
                upload.responseJSON {
                    response in
                    print(  "response" , response)
                    
                    if let json = response.result.value {
                        print("JSON: \(json)") // serialized json response
                    }
                    var jsonstring = String()
                    if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                        jsonstring = utf8Text
                    }
                    if jsonstring != ""
                    {
                        if let data = jsonstring.data(using: String.Encoding.utf8) {
                            do {
                                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [NSDictionary]
                                if json != nil
                                {
                                    completionHandler(json! as [NSDictionary], nil)
                                    print(json!)
                                }
                                else
                                {
                                    completionHandler([NSDictionary](), nil)
                                }
                                
                            } catch let parseError {
                                print(parseError)
                                print(jsonstring)
                                print("Something went wrong")
                                print(response.description)
                                print(Error.self)
                                
                                completionHandler(nil, "Not JSON Data.")
                            }
                        }
                    }
                    else
                    {
                        if let json = response.result.value {
                            print("JSON: \(json)") // serialized json response
                            completionHandler(([json as! NSDictionary]), nil)
                        }
                    }
                    sessionManager.session.invalidateAndCancel()
                }
                break
            case .failure(let error):
                MEDIAPROGRESS = 1.0
                if error._code == NSURLErrorCannotParseResponse
                {
                    completionHandler(nil, "Not JSON Data.")
                }
                else if error._code == NSURLErrorTimedOut
                {
                    completionHandler(nil, "Server is not responding, request time out please try again.")
                }
                else if error._code == NSURLErrorCannotFindHost
                {
                    completionHandler(nil, error.localizedDescription)
                }
                else if error._code == NSURLErrorNotConnectedToInternet
                {
                    completionHandler(nil, error.localizedDescription)
                }
                else
                {
                    completionHandler(nil, error.localizedDescription)
                }
                sessionManager.session.invalidateAndCancel()
                break
            }
        })
    }
    
    //MARK: - Post WebServices
    func webServicePut(url:String , parameters:Dictionary<String,Any>, completionHandler: @escaping (NSDictionary?, String?) -> ())
    {
        print(url)
        print(parameters)
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 10
        
        let sessionManager = Alamofire.SessionManager(configuration: configuration)
        let headers: HTTPHeaders = [
            //"Content-Type": "application/json",
            "Content-Type": "application/x-www-form-urlencoded",
            "Accept": "application/json"
        ]
        
        sessionManager.request(url, method: .put, parameters: parameters, encoding:URLEncoding.default , headers: headers).responseData(completionHandler: {
            
            response in
            if let json = response.result.value {
                print("JSON: \(json)") // serialized json response
            }
            var jsonstring = String()
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                // print("Data: \(utf8Text)") // original server data as UTF8 string
                jsonstring = utf8Text
                do{
                    let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:Any]
                    
                    print(json!)
                }
                catch let parseError {
                    print(parseError)
                    print(jsonstring)
                    print("Something went wrong")
                    print(response.description)
                    print(Error.self)
                    
                }
            }
            
            let data = response.result
            switch(data)
            {
            case .success(let json):
                print(json)
                if let data = jsonstring.data(using: String.Encoding.utf8) {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:Any]
                        
                        completionHandler(json! as NSDictionary, nil)
                        print(json!)
                    } catch let parseError {
                        print(parseError)
                        print(jsonstring)
                        print("Something went wrong")
                        print(response.description)
                        print(Error.self)
                        
                        completionHandler(nil, "Not JSON Data.")
                    }
                }
                
                
                sessionManager.session.invalidateAndCancel()
                break
                
                //            case .success(let JSON):
                //                                    completionHandler(JSON as? NSDictionary, nil)
                //
                //                                    sessionManager.session.invalidateAndCancel()
            //                                break
            case .failure(let error):
                if error._code == NSURLErrorCannotParseResponse
                {
                    completionHandler(nil, "Not JSON Data.")
                    break
                }
                else if error._code == NSURLErrorTimedOut
                {
                    completionHandler(nil, "Server is not responding, request time out please try again.")
                    break
                }
                else if error._code == NSURLErrorCannotFindHost
                {
                    completionHandler(nil, error.localizedDescription)
                    break
                }
                else if error._code == NSURLErrorNotConnectedToInternet
                {
                    completionHandler(nil, error.localizedDescription)
                    break
                }
                else
                {
                    completionHandler(nil, error.localizedDescription)
                    break
                }
            }
        })
        
    }
    
    
    //MARK: - Post WebServices
    func webServiceDelete(url:String, completionHandler: @escaping (NSDictionary?, String?) -> ())
    {
        print(url)
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 10
        
        let sessionManager = Alamofire.SessionManager(configuration: configuration)
        
        sessionManager.request(url, method: .delete).responseData(completionHandler: {
            
            response in
            if let json = response.result.value {
                print("JSON: \(json)") // serialized json response
            }
            var jsonstring = String()
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                // print("Data: \(utf8Text)") // original server data as UTF8 string
                jsonstring = utf8Text
                do{
                    let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:Any]
                    
                    print(json!)
                }
                catch let parseError {
                    print(parseError)
                    print(jsonstring)
                    print("Something went wrong")
                    print(response.description)
                    print(Error.self)
                    
                }
            }
            
            let data = response.result
            switch(data)
            {
            case .success(let json):
                print(json)
                if let data = jsonstring.data(using: String.Encoding.utf8) {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:Any]
                        
                        completionHandler(json! as NSDictionary, nil)
                        print(json!)
                    } catch let parseError {
                        print(parseError)
                        print(jsonstring)
                        print("Something went wrong")
                        print(response.description)
                        print(Error.self)
                        
                        completionHandler(nil, "Not JSON Data.")
                    }
                }
                
                
                sessionManager.session.invalidateAndCancel()
                break
                
                //            case .success(let JSON):
                //                                    completionHandler(JSON as? NSDictionary, nil)
                //
                //                                    sessionManager.session.invalidateAndCancel()
            //                                break
            case .failure(let error):
                if error._code == NSURLErrorCannotParseResponse
                {
                    completionHandler(nil, "Not JSON Data.")
                    break
                }
                else if error._code == NSURLErrorTimedOut
                {
                    completionHandler(nil, "Server is not responding, request time out please try again.")
                    break
                }
                else if error._code == NSURLErrorCannotFindHost
                {
                    completionHandler(nil, error.localizedDescription)
                    break
                }
                else if error._code == NSURLErrorNotConnectedToInternet
                {
                    completionHandler(nil, error.localizedDescription)
                    break
                }
                else
                {
                    completionHandler(nil, error.localizedDescription)
                    break
                }
            }
        })
    }
    
    
    //MARK: - Get WebServices
    func webServicesGet(url:String, completionHandler: @escaping (NSDictionary?, String?) -> ())
    {
        let apiurl = DataContainer.baseUrl() + url
        
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 10
        
        let sessionManager = Alamofire.SessionManager(configuration: configuration)
        
        Alamofire.request(apiurl).validate().responseData(completionHandler: {
            response in
            
            if let json = response.result.value {
                print("JSON: \(json)") // serialized json response
            }
            var jsonstring = String()
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                // print("Data: \(utf8Text)") // original server data as UTF8 string
                jsonstring = utf8Text
                do{
                    let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:Any]
                    
                    print(json!)
                }
                catch let parseError {
                    print(parseError)
                    print(jsonstring)
                    print("Something went wrong")
                    print(response.description)
                    print(Error.self)
                    
                }
            }
            let data = response.result
            switch(data)
            {
            case .success(let jsonstr):
                print(jsonstr)
                if let data = jsonstring.data(using: String.Encoding.utf8) {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:Any]
                        
                        completionHandler(json! as NSDictionary, nil)
                        print(json!)
                    } catch let parseError {
                        print(parseError)
                        print(jsonstring)
                        print("Something went wrong")
                        print(response.description)
                        print(Error.self)
                        
                        completionHandler(nil, "Not JSON Data.")
                    }
                }
                
                sessionManager.session.invalidateAndCancel()
                break
                
            case .failure(let error):
                if error._code == NSURLErrorCannotParseResponse
                {
                    completionHandler(nil, "Not JSON Data.")
                    break
                }
                else if error._code == NSURLErrorTimedOut
                {
                    completionHandler(nil, "Server is not responding, request time out please try again.")
                    break
                }
                else if error._code == NSURLErrorCannotFindHost
                {
                    completionHandler(nil, error.localizedDescription)
                    break
                }
                else if error._code == NSURLErrorNotConnectedToInternet
                {
                    completionHandler(nil, error.localizedDescription)
                    break
                }
                else
                {
                    completionHandler(nil, error.localizedDescription)
                    break
                }
            }
            
            ///////////////////////
            switch response.result {
            case .success:
                print("Validation Successful")
                if let json = response.result.value {
                    print("JSON: \(json)") // serialized json response
                }
                else
                {
                    completionHandler(nil, "Not JSON Data.")
                }
                //MARK: Data in string
                if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                    print("Data: \(utf8Text)") // original server data as UTF8 string
                }
                
            case .failure(let error):
                print(error)
                completionHandler(nil, error as? String)
            }
            //////////////////////
            
        })
    }
    
    //MARK:- Set Blur UIView
    public func setBlurView(view: UIView){
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.regular)
        var blurEffectView = UIVisualEffectView()
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.tag = 99999
        view.addSubview(blurEffectView)
    }
    //MARK:- Remove Blur UIView
    public func removeBlurView(view: UIView){
        if let viewWithTag = view.viewWithTag(99999) {
            viewWithTag.removeFromSuperview()
        }else{
            print("No view found!")
        }
    }
    
    public func showAlert(title: String, message: String, viewController: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default)
        { (action) in
            
        }
        alert.addAction(ok)
        viewController.present(alert, animated: true)
    }
    //MARK:- New version available on apple store
    func autoUpDateIOSVersion(viewcontroller :UIViewController)
    {
        VersionCheck.shared.isUpdateAvailable() { (hasUpdates) in
          print("is update available: \(hasUpdates)")
            // Create the alert controller
            let alertController = UIAlertController(title: "Latest Version", message: "Old version is: \(APPVERSIONNUMBER!)\n New version is available: \(APPVERSION_ON_APPLE)\nPlease update your latest version from App Store", preferredStyle: .alert)
            // Create the actions
            let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                UIAlertAction in
                NSLog("OK Pressed")
                //MARK:- Forcly Quit the Application
                
                if let url = URL(string: SHARELINKIOS) {
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(url, options: [:], completionHandler: {
                            response in
                            DispatchQueue.main.async {
                                exit(0)
                            }
                        })
                    } else {
                        // Earlier versions
                        if UIApplication.shared.canOpenURL(url as URL) {
                            UIApplication.shared.openURL(url as URL)
                            DispatchQueue.main.async {
                                exit(0)
                            }
                        }
                    }
                }
            }
            // Add the actions
            alertController.addAction(okAction)
            // Present the controller
            viewcontroller.present(alertController, animated: true, completion: nil)
        }
    }
    
    func getYofTextField(textfield: UITextField) -> Float
    {
        var y = Float()
        
        y = Float(textfield.frame.maxY)
        
        return y
    }
    
    //MARK:- Chek valid email
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    
    //MARK: - Easy Tip View Validation
    func funValidationfromBottom(sender: AnyObject, text: String, view: UIView)
    {
        eview.dismiss()
        var preferences = EasyTipView.Preferences()
        preferences.drawing.backgroundColor = .white
        preferences.drawing.foregroundColor = UIColor.darkGray
        preferences.drawing.textAlignment = NSTextAlignment.center
        preferences.drawing.borderColor = .red
        preferences.drawing.borderWidth = 1.5
        
        preferences.animating.dismissTransform = CGAffineTransform(translationX: 50, y: -15)
        preferences.animating.showInitialTransform = CGAffineTransform(translationX: 0, y: -15)
        preferences.animating.showInitialAlpha = 0
        preferences.animating.showDuration = 1.5
        preferences.animating.dismissDuration = 1.5
        preferences.drawing.arrowPosition = .bottom
        
        eview = EasyTipView(text: text, preferences: preferences)
        eview.show(forView: sender as! UIView, withinSuperview: view)
    }
    
    //MARK: - Easy Tip View Validation
    func easyTipViewDidDismiss(_ tipView: EasyTipView) {
        eview.dismiss()
    }
    //MARK: - Easy Tip View Validation
    func funValidationfromTop(sender: AnyObject, text: String, view: UIView) {
        eview.dismiss()
        var preferences = EasyTipView.Preferences()
        preferences.drawing.backgroundColor = .white
        preferences.drawing.foregroundColor = UIColor.darkGray
        preferences.drawing.textAlignment = NSTextAlignment.center
        preferences.drawing.borderColor = .red
        preferences.drawing.borderWidth = 1
        
        preferences.animating.dismissTransform = CGAffineTransform(translationX: 50, y: -15)
        preferences.animating.showInitialTransform = CGAffineTransform(translationX: 0, y: -15)
        preferences.animating.showInitialAlpha = 0
        preferences.animating.showDuration = 1.5
        preferences.animating.dismissDuration = 1.5
        preferences.drawing.arrowPosition = .bottom
        eview = EasyTipView(text: text, preferences: preferences)
        eview.show(forView: sender as! UIView, withinSuperview: view)
    }
    
    var eViewTimer = Timer()
    //MARK: - Easy Tip View Validation
    func funValidationfromTopWithColor(sender: AnyObject, text: String, view: UIView, color: UIColor)
    {
        eview.dismiss()
        var preferences = EasyTipView.Preferences()
        //MARK:- Background Colo.r
        preferences.drawing.backgroundColor = color
        //MARK:- Text Color
        preferences.drawing.foregroundColor = UIColor.white
        preferences.drawing.textAlignment = NSTextAlignment.center
        //MARK:- Border Color
        preferences.drawing.borderColor = color
        preferences.drawing.borderWidth = 1
        
        preferences.animating.dismissTransform = CGAffineTransform(translationX: 50, y: -15)
        preferences.animating.showInitialTransform = CGAffineTransform(translationX: 0, y: -15)
        preferences.animating.showInitialAlpha = 0
        preferences.animating.showDuration = 1.5
        preferences.animating.dismissDuration = 1.5
        preferences.drawing.arrowPosition = .bottom
        eview = EasyTipView(text: text, preferences: preferences)
        eview.show(forView: sender as! UIView, withinSuperview: view)
        eViewTimer.invalidate()
        eViewTimer = Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { timer in
           eview.dismiss()
        }
    }
    //MARK: - Function for Add image in button  LEFT SIDE
    public func putImgInButton(button: UIButton, imgname: String, x:Int, width:Int, height:Int)
    {
        button.setImage(UIImage.init(named: "chaticon"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        // button.contentMode = .scaleAspectFit
        button.setTitle(button.titleLabel?.text!, for: .normal)
        let imageSize:CGSize = CGSize(width: width, height: height)
        button.imageEdgeInsets = UIEdgeInsets(
            top: (button.frame.size.height - imageSize.height) / 2,
            left: -(CGFloat(x)),
            bottom: (button.frame.size.height - imageSize.height) / 2,
            right: 0)
        button.titleEdgeInsets = UIEdgeInsets(
            top: (button.frame.size.height - imageSize.height) / 2,
            left: -(CGFloat(x)),
            bottom: (button.frame.size.height - imageSize.height) / 2,
            right: 0)
    }
    
    //MARK: - Function for Add image in button  LEFT SIDE WITHOUT LABEL
    public func putImgInButtonWithOutLabel(button: UIButton, imgname: String)
    {
        button.setImage(UIImage.init(named: imgname), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        let imageSize:CGSize = CGSize(width: (button.frame.size.width - 8) / 2, height: (button.frame.size.height - 8) / 2)
        
        button.imageEdgeInsets = UIEdgeInsets(
            top: (((button.frame.size.height - imageSize.height) / 2) / 2),
            left: (((button.frame.size.height - imageSize.height) / 2) / 2) ,
            bottom: (((button.frame.size.height - imageSize.height) / 2) / 2),
            right: (((button.frame.size.height - imageSize.height) / 2) / 2))
    }
    public func putImgInButtonWithOutLabel2XSmall(button: UIButton, imgname: String)
    {
        button.setImage(UIImage.init(named: imgname), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        //  button.contentMode = .scaleAspectFit
        let imageSize:CGSize = CGSize(width: ((button.frame.size.width + 12) / 2) / 2, height: ((button.frame.size.height + 12) / 2) / 2)
        button.imageEdgeInsets = UIEdgeInsets(
            top: (((button.frame.size.height - imageSize.height) / 2)) ,
            left: (((button.frame.size.height - imageSize.height) / 2)) ,
            bottom: (((button.frame.size.height - imageSize.height) / 2)),
            right: (((button.frame.size.height - imageSize.height) / 2)))
    }
    public func putImgInButtonWithOutLabelForCell(button: UIButton, imgname: String)
    {
        button.setImage(UIImage.init(named: imgname), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        // button.contentMode = .scaleAspectFit
        let imageSize:CGSize = CGSize(width: (button.frame.size.width - 25) / 2, height: (button.frame.size.height - 8) / 2)
        button.imageEdgeInsets = UIEdgeInsets(
            top: (((button.frame.size.height - imageSize.height) / 2) / 2),
            left: (((button.frame.size.height - imageSize.height) / 2) / 2) ,
            bottom: (((button.frame.size.height - imageSize.height) / 2) / 2),
            right: (((button.frame.size.height - imageSize.height) / 2) / 2))
    }
    //MARK: - Function for Add image in text field LEFT SIDE
    public func putLeftImgInTextField(txtfield: UITextField, imgname: String, x:Int, width:Int, height:Int)
    {
        let y = CGFloat(txtfield.frame.size.height / 2) - CGFloat(height / 2)
        //MARK: - Add image in text field LEFT SIDE
        let leftimgv = UIView()
        leftimgv.frame = CGRect(x:10, y:Int(y), width:40, height:Int(txtfield.frame.size.height))
        txtfield.leftViewMode = UITextField.ViewMode.always
        let imageView = UIImageView(frame: CGRect(x: x, y: Int(y), width: width, height: height))
        let image = UIImage(named: imgname)
        imageView.image = image
        leftimgv.addSubview(imageView)
        txtfield.leftView = leftimgv
    }
    //MARK:- Put right button
    public func putRightImgTextField(txtfield: UITextField, imgname: String, x: Int, width:Int, height:Int)
    {
        let y = CGFloat(txtfield.frame.size.height / 2) - CGFloat(height / 2)
        //MARK: - Add image in text field Right SIDE
        let rightimgv = UIView()
        rightimgv.frame = CGRect(x:0, y:0, width:50, height:txtfield.frame.size.height)
        txtfield.rightViewMode = UITextField.ViewMode.always
        let imageView = UIImageView(frame: CGRect(x: x, y: Int(y), width: width, height: height))
        let image = UIImage(named: imgname)
        imageView.image = image
        rightimgv.addSubview(imageView)
        txtfield.rightView = rightimgv
    }
    
    public func putRightButtoninTextField(btn: UIButton ,txtfield: UITextField, imgname: String, x: Int, width:Int, height:Int)
    {
        btn.backgroundColor = .clear
        let y = CGFloat(txtfield.frame.size.height / 2) - CGFloat(height / 2)
        //MARK: - Add image in text field Right SIDE
        let rightimgv = UIView()
        rightimgv.frame = CGRect(x:0, y:0, width:50, height:txtfield.frame.size.height)
        txtfield.rightViewMode = UITextField.ViewMode.always
        let imageView = UIImageView(frame: CGRect(x: x, y: Int(y), width: width, height: height))
        let image = UIImage(named: imgname)
        imageView.image = image
        rightimgv.addSubview(imageView)
        txtfield.rightView = rightimgv
        
        //MARK: - Add button in text field Right SIDE
        btn.frame = rightimgv.frame
        rightimgv.addSubview(btn)
    }
    
    public func putRightViewinTextField(view: UIView ,txtfield: UITextField, x: Int, width:Int, height:Int)
    {
        let y = CGFloat(txtfield.frame.size.height / 2) - CGFloat(height / 2)
        //MARK: - Add image in text field Right SIDE
        let rightimgv = UIView()
        rightimgv.frame = CGRect(x:5, y:0, width:txtfield.frame.size.height, height:txtfield.frame.size.height)
        txtfield.rightViewMode = UITextField.ViewMode.always
        rightimgv.addSubview(view)
        view.frame.origin.y = y
        view.frame.origin.x = 0
        view.frame.size.width = view.frame.size.height
        txtfield.rightView = rightimgv
        
        //MARK: - Add button in text field Right SIDE
    }
    public func putRightViewAndButtonInTextViewField(button: UIButton, view: UIView ,txtview: UITextView, x: Int, width:Int, height:Int)
    {
        let hw = CGFloat(txtview.frame.size.height / 2) + ((txtview.frame.size.height / 2)/2)
        
        let y = CGFloat(txtview.frame.size.height / 2) - CGFloat(height / 2)
        let x = CGFloat(txtview.frame.maxX - CGFloat(width * 2))
        //MARK: - Add image in text field Right SIDE
        let rightimgv = UIView()
       // rightimgv.backgroundColor = .red
        rightimgv.frame = CGRect(x:x, y:0, width:txtview.frame.size.height * 2, height:txtview.frame.size.height)
      //  txtview.rightViewMode = UITextField.ViewMode.always
        rightimgv.addSubview(view)
        rightimgv.addSubview(button)
        
        view.frame.origin.y = y
        view.frame.origin.x = 0
        view.frame.size.width = view.frame.size.height
       
        let YforButton = CGFloat(txtview.frame.size.height / 2) - CGFloat(hw / 2)
        
        button.frame = CGRect(x: CGFloat(width),
                              y: YforButton,
                              width: hw,
                              height: hw)
        button.contentMode = .scaleAspectFit
        button.imageView?.backgroundColor = .clear
        button.backgroundColor = .clear
        //MARK: - Add button in text field Right SIDE
        
        txtview.addSubview(rightimgv)
    }
    //MARK:- Corner Radius of only two side of UIViews
    public func roundCorners(view :UIView, corners: UIRectCorner, radius: CGFloat){
        let path = UIBezierPath(roundedRect: view.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        view.layer.mask = mask
    }
    
    //MARK:- Unlimited text to label
    public func labelunlimitedtext(label :UILabel)
    {
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 9
    }
    //MARK:- Chage two color in one label
    public func changeLabelColor(label: UILabel, compstr: String, changeclrafterthiscountstr: String, stringfrom: String)
    {
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        //User Two color in one label swift
        let lbltextcount = changeclrafterthiscountstr.count
        let myString:NSString = compstr as NSString
        var myMutableString = NSMutableAttributedString()
        myMutableString = NSMutableAttributedString(string: myString as String, attributes: [NSAttributedString.Key.font:UIFont(name: "Nunito-Regular", size: 13.0)!])
        myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: appclr, range: NSRange(location:stringfrom.count,length:lbltextcount))
        // set label Attribute
        label.attributedText = myMutableString
        label.sizeToFit()
    }
    
    //MARK:- Two line in Navigation Title with Multiple Sizes
    func navigationTwoLineTitle(topline: String, bottomline: String, viewcontroller :UIViewController){
        let topText = NSLocalizedString(topline, comment: "")
        let bottomText = NSLocalizedString(bottomline, comment: "")
        //MARK:- Bold Font
        let titleParameters = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17.0)]
        //MARK:- Regular Font
        let subtitleParameters = [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 10.0)]
        
        let title:NSMutableAttributedString = NSMutableAttributedString(string: topText, attributes: titleParameters)
        let subtitle:NSAttributedString = NSAttributedString(string: bottomText, attributes: subtitleParameters)
        
        title.append(NSAttributedString(string: "\n"))
        title.append(subtitle)
        
        let size = title.size()
        
        let width = size.width
        guard let height = viewcontroller.navigationController?.navigationBar.frame.size.height else {return}
        
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: height))
        titleLabel.attributedText = title
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        titleLabel.textColor = .white
        viewcontroller.navigationItem.titleView = titleLabel
    }
    
    //MARK:- set heigh button 4 ipad
    public func setbuttonHeighWidth4Pad(button: UIButton, viewcontroller :UIViewController)
    {
        let buttonCenterPoint = button.center
        button.frame.size.width = button.frame.size.height
        button.frame.origin.x = (viewcontroller.view.frame.midX - (button.frame.width / 2))
        button.imageView?.contentMode = .scaleAspectFit
        
        button.center = buttonCenterPoint
    }
    //MARK:- set heigh view 4 ipad
    public func setviewHeighWidth4Pad(view: UIView, viewcontroller :UIViewController)
    {
        let viewCenterPoint = view.center
        view.frame.size.width = view.frame.size.height
        view.frame.origin.x = (viewcontroller.view.frame.midX - (view.frame.width / 2))
        view.center = viewCenterPoint
    }
    //MARK:- set heigh view 4 ipad
    public func setLabelHeighWidth4Pad(label: UILabel, viewcontroller :UIViewController)
    {
        let labelCenterPoint = label.center
        label.frame.size.width = label.frame.size.height
        label.frame.origin.x = (label.frame.midX - (label.frame.width / 2))
        label.center = labelCenterPoint
    }
    //MARK:- set heigh image 4 ipad
    public func setImageHeighWidth4Pad(image: UIImageView, viewcontroller :UIViewController)
    {
        let imageCenterPoint = image.center
        image.frame.size.width = image.frame.size.height
        //image.frame.origin.x = (viewcontroller.view.frame.midX - (image.frame.width / 2))
        //image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.center = imageCenterPoint
    }
    //MARK:- set image Circle
    public func setimageCircle(image: UIImageView, viewcontroller: UIViewController)
    {
        setImageHeighWidth4Pad(image: image, viewcontroller: viewcontroller)
        DispatchQueue.main.async {
            image.layer.cornerRadius = image.frame.size.height / 2
            image.clipsToBounds = true
            
            let imagecenterpoint = image.center
            image.frame.size.width = image.frame.size.height
            //image.frame.origin.x = (viewcontroller.view.frame.midX - (image.frame.width / 2))
            //image.contentMode = .scaleAspectFill
            image.center = imagecenterpoint
        }
    }
    //MARK:- set Label Circle
    public func setLabelCircle(label: UILabel, viewcontroller: UIViewController)
    {
        setLabelHeighWidth4Pad(label: label, viewcontroller: viewcontroller)
        DispatchQueue.main.async {
            label.layer.cornerRadius = label.frame.size.height / 2
            label.clipsToBounds = true
            
            let labelCenterPoint = label.center
            label.frame.size.width = label.frame.size.height
            //image.frame.origin.x = (viewcontroller.view.frame.midX - (image.frame.width / 2))
            //image.contentMode = .scaleAspectFill
            label.center = labelCenterPoint
        }
    }
    //MARK:- set View Circle
    public func setViewCircle(view: UIView, viewcontroller: UIViewController)
    {
        setviewHeighWidth4Pad(view: view, viewcontroller: viewcontroller)
        DispatchQueue.main.async {
            view.layer.cornerRadius = view.frame.size.height / 2
            view.clipsToBounds = true
        }
    }
    //MARK:- set View Circle
    public func setButtonCircle(button: UIButton)
    {
        button.clipsToBounds = true
        button.layer.cornerRadius = button.frame.size.height / 2
    }
    public func setViewShade(view: UIView)
    {
        //view.layer.cornerRadius = 8
        view.layer.borderWidth = 1
        view.layer.borderColor = AppTextFieldBorderColor.cgColor
        
        //MARK:- Shade a view
        view.layer.shadowOpacity = 0.5
        view.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        view.layer.shadowRadius = 3.0
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.masksToBounds = false
    }
    public func setButtonShade(button: UIView)
    {
        //view.layer.cornerRadius = 8
        button.layer.borderWidth = 1
        button.layer.borderColor = AppTextFieldBorderColor.cgColor
        
        //MARK:- Shade a view
        button.layer.shadowOpacity = 0.5
        button.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        button.layer.shadowRadius = 3.0
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.masksToBounds = false
    }
    public func setTextFieldShade(textfield: UITextField)
    {
        //view.layer.cornerRadius = 8
        textfield.layer.borderWidth = 1
        textfield.layer.borderColor = AppTextFieldBorderColor.cgColor
        
        //MARK:- Shade a view
        textfield.layer.shadowOpacity = 0.5
        textfield.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        textfield.layer.shadowRadius = 3.0
        textfield.layer.shadowColor = UIColor.black.cgColor
        textfield.layer.masksToBounds = false
    }
    public func setImageViewShade(imageview: UIImageView)
    {
        //view.layer.cornerRadius = 8
        imageview.layer.borderWidth = 1
        imageview.layer.borderColor = AppTextFieldBorderColor.cgColor
        
        //MARK:- Shade a view
        imageview.layer.shadowOpacity = 0.5
        imageview.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        imageview.layer.shadowRadius = 3.0
        imageview.layer.shadowColor = UIColor.black.cgColor
        imageview.layer.masksToBounds = false
    }
    public func txtfieldsetting(textfiled: UITextField, viewcontroller: UIViewController)
    {
        //textfiled.frame = CGRect(x: 15, y: textfiled.frame.origin.y, width: viewcontroller.view.frame.size.width - (15*2), height: textfiled.frame.size.height)
        textfiled.textColor = appclrtextfield
        textfiled.delegate = viewcontroller as? UITextFieldDelegate
        textfiled.layer.borderWidth = 1
        textfiled.layer.borderColor = AppTextFieldBorderColor.cgColor
    }
    public func txtviewsetting(textview: UITextView, viewcontroller: UIViewController)
    {
        // textview.frame = CGRect(x: 15, y: textview.frame.origin.y, width: viewcontroller.view.frame.size.width - (15*2), height: textview.frame.size.height)
        textview.textColor = appclrtextfield
        //MARK:- Padding textview working code
        textview.textContainerInset = UIEdgeInsets(top: 10,left: 5,bottom: 10,right: 5); // top, left, bottom, right
        textview.delegate = viewcontroller as? UITextViewDelegate
        textview.layer.borderWidth = 1
        textview.layer.borderColor = AppTextFieldBorderColor.cgColor
    }
    
    //MARK:- Wifi is Connected or not Check
    func isWifi()->Bool{
        var wifi = Bool()
        do {
            try wifi = Reachability.init()!.isReachableViaWiFi
        }catch{
            wifi = false
        }
        return wifi
    }
    
    //MARK:- Check How many days pass
    func isPassedMoreThan(days: Int, fromDate date : Date, toDate date2 : Date) -> Bool {
        let unitFlags: Set<Calendar.Component> = [.day]
        let deltaD = Calendar.current.dateComponents( unitFlags, from: date, to: date2).day
        return (deltaD ?? 0 > days)
    }
    //MARK:- Fetch All Contacts of Phone with image data
    func fetchContacts(completion: @escaping (_ result: [CNContact], String) -> Void) {
        DispatchQueue.main.async {
            var results = [CNContact]()
            let keys = [CNContactFormatter.descriptorForRequiredKeys(for: CNContactFormatterStyle.fullName), CNContactGivenNameKey,CNContactFamilyNameKey,CNContactMiddleNameKey,CNContactEmailAddressesKey,CNContactPhoneNumbersKey,CNContactImageDataAvailableKey,CNContactThumbnailImageDataKey] as! [CNKeyDescriptor]
            let fetchRequest = CNContactFetchRequest(keysToFetch: keys)
            fetchRequest.sortOrder = .userDefault
            let store = CNContactStore()
            store.requestAccess(for: .contacts, completionHandler: {(grant,error) in
                if grant{
                    do {
                        try store.enumerateContacts(with: fetchRequest, usingBlock: { (contact, stop) -> Void in
                            // NotificationCenter.default.post(name: NSNotification.Name(rawValue: "contactrefresh"), object: nil)
                            results.append(contact)
                        })
                    }
                    catch let error {
                        print(error.localizedDescription)
                    }
                    completion(results, "")
                }else {
                    print("Error \(error?.localizedDescription ?? "")")
                    completion(results, "Contact Permissaion required") 
                }
            })
        }
    }
    //MARK:- PassPhone number and get contact name
    func getContactNameFromNumber(contactNumber: String) -> String {
        var contactName = String()
        let contactStore = CNContactStore()
        let t = CNPhoneNumber.init(stringValue: contactNumber)
        
        var predicate = CNContact.predicateForContacts(withIdentifiers: [contactNumber])
        if #available(iOS 11.0, *) {
            predicate = CNContact.predicateForContacts(matching: t)
        } else {
            // Fallback on earlier versions
        }
        var contacts = [CNContact]()
        var message: String!
        
        do {
            contacts = try contactStore.unifiedContacts(matching: predicate, keysToFetch: CONTACTKEY)
            
            if contacts.count == 0 {
                message = "No contacts were found matching the given name."
            }
        }
        catch {
            message = "Unable to fetch contacts."
        }
        //print(message)
        if contacts.count > 0{
            print(contacts[0])
            let tempcontact = contacts[0]
            
            if let fullname = tempcontact.value(forKey: "fullName") as Any as? String
            {
                contactName = fullname
            }
            else{
                contactName =  (tempcontact.phoneNumbers.first?.value.stringValue)!
            }
        }
        if contactName == ""{
            contactName = contactNumber
        }
        return contactName
    }
    //MARK:- PassPhone number and get contact name
    func getContactNumberFromGlobalNumber(contactNumber: String) -> String {
        var contactName = String()
        let contactStore = CNContactStore()
        let t = CNPhoneNumber.init(stringValue: contactNumber)
        
        var predicate = CNContact.predicateForContacts(withIdentifiers: [contactNumber])
        if #available(iOS 11.0, *) {
            predicate = CNContact.predicateForContacts(matching: t)
        } else {
            // Fallback on earlier versions
        }
        var contacts = [CNContact]()
        var message: String!
        
        do {
            contacts = try contactStore.unifiedContacts(matching: predicate, keysToFetch: CONTACTKEY)
            
            if contacts.count == 0 {
                message = "No contacts were found matching the given name."
            }
        }
        catch {
            message = "Unable to fetch contacts."
        }
        //print(message)
        if contacts.count > 0{
            print(contacts[0])
            let tempcontact = contacts[0]
            
            contactName =  (tempcontact.phoneNumbers.first?.value.stringValue)!
        }
        if contactName == ""{
            contactName = ""
        }
        return contactName
    }
    
    
    //MARK:- Get time into second
    func getTimeintoSecond(time: Int) -> String
    {
        let currentTime = time
        
        let minutes = currentTime/60
        let seconds = currentTime - minutes / 60
        
        let playertime = NSString(format: "%02d:%02d", minutes,seconds) as String
        return playertime
    }
    //MARK:- Timer show in Label for human language 00:01:23 etc like this
    func funHMSInHumanFormatFromSeconds(label: UILabel, seconds: Double) {
        let secondinInt = Int(seconds)
        // let hours = (secondinInt / 3600)
        let minutes = (secondinInt % 3600) / 60
        let seconds = ((secondinInt % 3600) % 60)
        
        label.text = "\(minutes)  \(seconds)"
    }
    
    //MARK:- Timer show in Label for human language 00:01:23 etc like this
    func funHMSFromSeconds(seconds: Double) -> String {
        let secondinInt = Int(seconds)
        // let hours = (secondinInt / 3600)
        let minutes = (secondinInt % 3600) / 60
        let seconds = ((secondinInt % 3600) % 60)
        
        return "\(getStringFrom(seconds: minutes)):\(getStringFrom(seconds: seconds))"
    }
    //MARK:- Timer show in human language 00:01:23 etc like this
    func funhmsFrom(seconds: Int, completion: @escaping (_ hours: Int, _ minutes: Int, _ seconds: Int)->()) {
        
        completion(seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    //MARK:- Timer show in human language 00:01:23 etc like this
    func getStringFrom(seconds: Int) -> String {
        return seconds < 10 ? "0\(seconds)" : "\(seconds)"
    }//End Human language timer
    //MARK:- Change Status bar color and navigation color
    public func statusbarbgdark(viewcontroller: UIViewController) {
        //MARK:- Status bar color
        
        //MARK:- Change left navigation bar color
        viewcontroller.navigationController?.navigationBar.barTintColor = appclrnavbar
        //MARK:- Change left navigation button color
        viewcontroller.navigationItem.leftBarButtonItem?.tintColor = .white
        //MARK:- Hide bottom line of navigation bar
        viewcontroller.navigationController?.navigationBar.shadowImage = UIImage()
        
         if #available(iOS 13.0, *) {
                  let app = UIApplication.shared
                  let statusBarHeight: CGFloat = app.statusBarFrame.size.height

                  let statusbarView = UIView()
                   statusbarView.backgroundColor = appclrstatusbar
                  view.addSubview(statusbarView)

                  statusbarView.translatesAutoresizingMaskIntoConstraints = false
                  statusbarView.heightAnchor
                    .constraint(equalToConstant: statusBarHeight).isActive = true
                  statusbarView.widthAnchor
                    .constraint(equalTo: view.widthAnchor, multiplier: 1.0).isActive = true
                  statusbarView.topAnchor
                    .constraint(equalTo: view.topAnchor).isActive = true
                  statusbarView.centerXAnchor
                    .constraint(equalTo: view.centerXAnchor).isActive = true

               } else {
                     let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
                     if statusBar.responds(to:#selector(setter: UIView.backgroundColor)) {
                         statusBar.backgroundColor = appclrstatusbar
                     }
               }
    }
    public func statusbarbgwhite(viewcontroller: UIViewController) {
        //MARK:- Status bar color
        
        //MARK:- Change left navigation bar color
        viewcontroller.navigationController?.navigationBar.barTintColor = .white
        //MARK:- Change left navigation button color
        viewcontroller.navigationItem.leftBarButtonItem?.tintColor = .gray
        //MARK:- Hide bottom line of navigation bar
        viewcontroller.navigationController?.navigationBar.shadowImage = UIImage()
        
        if #available(iOS 13.0, *) {
           let app = UIApplication.shared
           let statusBarHeight: CGFloat = app.statusBarFrame.size.height

           let statusbarView = UIView()
            statusbarView.backgroundColor = .white
           view.addSubview(statusbarView)

           statusbarView.translatesAutoresizingMaskIntoConstraints = false
           statusbarView.heightAnchor
             .constraint(equalToConstant: statusBarHeight).isActive = true
           statusbarView.widthAnchor
             .constraint(equalTo: view.widthAnchor, multiplier: 1.0).isActive = true
           statusbarView.topAnchor
             .constraint(equalTo: view.topAnchor).isActive = true
           statusbarView.centerXAnchor
             .constraint(equalTo: view.centerXAnchor).isActive = true

        } else {
              let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
              if statusBar.responds(to:#selector(setter: UIView.backgroundColor)) {
                  statusBar.backgroundColor = .white
              }
        }
    }
    
    // Mrks: -  Get thumbnail of video with the Upload image and video
    func thumbnailForVideoAtURL(url: URL) -> UIImage? {
        
        let asset = AVAsset(url: url)
        let assetImageGenerator = AVAssetImageGenerator(asset: asset)
        
        var time = asset.duration
        time.value = min(time.value, 2)
        
        do {
            let imageRef = try assetImageGenerator.copyCGImage(at: time, actualTime: nil)
            return UIImage(cgImage: imageRef)
        } catch {
            print("error")
            return nil
        }
    }
    
    func funOpenAppSetting() {
        if let url = URL(string: "\(UIApplication.openSettingsURLString)&path=LOCATION/\(BUNDLEID)") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    /////////////////////////////////////////////////// Finish Upload image and video from gallery
    
    func device()-> Int{
        if IPAD {
            return 59
        }
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 1136:
                print("iPhone 5 or 5S or 5C")
                //bgv.image = UIImage.init(named: "SE")
                return 33
            case 1334:
                print("iPhone 6/6S/7/8")
                // bgv.image = UIImage.init(named: "6")
                return 39
            case 1920, 2208:
                // bgv.image = UIImage.init(named: "6Plus")
                print("iPhone 6+/6S+/7+/8+")
                return 43
            case 2436:
                print("iPhone X, XS")
                
            case 2688:
                print("iPhone XS Max")
                
            case 1792:
                print("iPhone XR")
                
            default:
                print("Unknown")
            }
        }
        return 43
    }
    //MARK:- Hide Bottom line of navigation bar
    public func hideBottomLineNavBar(viewcontroller: UIViewController) {
        //MARK:- Hide bottom line of navigation bar
        viewcontroller.navigationController?.navigationBar.shadowImage = UIImage()
        
    }
    //MARK:- Hide navigation bar
    func hideNavBar(viewcontroller: UIViewController) {
        //MARK:- Hide navigation bar
        viewcontroller.navigationController?.navigationBar.isHidden = true
       
    }
    
    //MARK:- Show navigation bar
    func showNavBar(viewcontroller: UIViewController) {
        //MARK:- Hide navigation bar
        viewcontroller.navigationController?.navigationBar.isHidden = false
    }
    
    //MARK:- Hide navigation bar
    func hideNavBarBackButton(viewcontroller: UIViewController) {
        //MARK:- Hide navigation bar
        viewcontroller.navigationItem.hidesBackButton = true
    }
    
    //MARK:- Show navigation bar
    func showNavBarBackButton(viewcontroller: UIViewController) {
        //MARK:- Hide navigation bar
        viewcontroller.navigationItem.hidesBackButton = false
    }
    
    //MARK:- Show navigation bar
    func navBarColor(color: UIColor) {
        //MARK:- Hide navigation bar
        navigationController?.navigationBar.barTintColor = color
        
    }
    //NOt working need to fix it
    //MARK:- Resize Navigation Bar Button
    func btnNavBarSetSize(navbutton: UIBarButtonItem, imgname: String)
    {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        let image = UIImage(named: imgname)
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        navbutton.customView?.addSubview(imageView)
    }
    
    func setBottomShadow(object: AnyObject)
    {
        //MARK:- Button Shadow and Radius
        
//        object.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
//        object.layer.shadowOffset = CGSize(width: 0, height: 3)
//        object.layer.shadowOpacity = 0.2
//        object.layer.shadowRadius = 0.0
//        object.layer.masksToBounds = false
//        object.layer.cornerRadius = 4.0
    }
    
    //MARK:- Add bottom line for textfield
    func txtbottomline(textfield: UITextField)
    {
        let frame = CGRect(x: 0.0, y:textfield.frame.height - 1, width: textfield.frame.width, height: 1.0)
        let bottompass = CALayer()
        bottompass.frame = frame
        bottompass.backgroundColor = appclrbottomline.cgColor
        textfield.borderStyle = UITextField.BorderStyle.none
        textfield.layer.addSublayer(bottompass)
    }
    
    func convertTimespamIntoTime(timestring: String) -> String
    {
        let currentDateTimeToMiliSec = NSDate(timeIntervalSince1970: Double(Date().currentTimeMillis()!) / 1000)
        
        let date = NSDate(timeIntervalSince1970: Double(timestring)! / 1000)
        let formatter = DateFormatter()
        formatter.timeZone = (NSTimeZone(name: "\(TimeZone.current.identifier)")! as TimeZone)
        
        formatter.dateFormat = "YYYY-MM-dd"
        //formatter.dateFormat = "ddmmYY"
        let currentdate = formatter.date(from: formatter.string(from: currentDateTimeToMiliSec as Date))
        let msgdate = formatter.date(from: formatter.string(from: date as Date))
        
        if currentdate == msgdate
        {
            formatter.dateFormat = "hh:mm a"
            return "" + formatter.string(from: date as Date)
        }
        else
        {
            formatter.dateFormat = "d/MM/yy hh:mm a"
            return formatter.string(from: date as Date)
        }
    }
    
    func checkMicPermission() -> Bool {

        var permissionCheck: Bool = false

        switch AVAudioSession.sharedInstance().recordPermission {
        case AVAudioSessionRecordPermission.granted:
            permissionCheck = true
        case AVAudioSessionRecordPermission.denied:
            permissionCheck = false
        case AVAudioSessionRecordPermission.undetermined:
            AVAudioSession.sharedInstance().requestRecordPermission({ (granted) in
                if granted {
                    permissionCheck = true
                } else {
                    permissionCheck = false
                }
            })
        default:
            break
        }
        return permissionCheck
    }
    
    func setPermission(title: String, message: String, viewController: UIViewController, mediaType: AVMediaType){
        AVCaptureDevice.requestAccess(for: mediaType) { success in
          if success { // if request is granted (success is true)
            DispatchQueue.main.async {
              //viewController.performSegue(withIdentifier: "identifier", sender: nil)
            }
          } else { // if request is denied (success is false)
            // Create Alert
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

            // Add "OK" Button to alert, pressing it will bring you to the settings app
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            }))
            // Show the alert with animation
            viewController.present(alert, animated: true)
          }
        }
    }
    
    func convertTimeSpamIntoJustDateTime(timestring: String) -> String
    {
        //  let currentDateTimeToMiliSec = NSDate(timeIntervalSince1970: Double(Date().currentTimeMillis()!) / 1000)
        
        let date = NSDate(timeIntervalSince1970: Double(timestring)! / 1000)
        let formatter = DateFormatter()
        formatter.timeZone = (NSTimeZone(name: "\(TimeZone.current.identifier)")! as TimeZone)
        
        formatter.dateFormat = "YYYY-MM-dd"
        //formatter.dateFormat = "ddmmYY"
        //    let currentdate = formatter.date(from: formatter.string(from: currentDateTimeToMiliSec as Date))
        //  let msgdate = formatter.date(from: formatter.string(from: date as Date))
        
        
        formatter.dateFormat = "d/MM/yy hh:mm a"
        return formatter.string(from: date as Date)
    }
    
    func convertTimespamIntoFullDateTime(timestring: String, completion: @escaping (_ isOnline: String, _ time: String)->()) {
        
        let currentDateTimeToMiliSec = NSDate(timeIntervalSince1970: Double(Date().currentTimeMillis()!) / 1000)
        //Mark:- Incoming date in function
        let dateIncoming = NSDate(timeIntervalSince1970: Double(timestring)! / 1000)
        let formatter = DateFormatter()
        formatter.timeZone = (NSTimeZone(name: "\(TimeZone.current.identifier)")! as TimeZone)
        
        formatter.dateFormat = "YYYY-MM-dd"
        //Mark:- Current today date and time
        var currentdate = formatter.date(from: formatter.string(from: currentDateTimeToMiliSec as Date))
        
        var incomingOnlineDate = formatter.date(from: formatter.string(from: dateIncoming as Date))
        
        if currentdate == incomingOnlineDate
        {
            formatter.dateFormat = "YYYY-MM-dd hh:mm a"
            //Mark:- Current today date and time
            currentdate = formatter.date(from: formatter.string(from: currentDateTimeToMiliSec as Date))
            
            incomingOnlineDate = formatter.date(from: formatter.string(from: dateIncoming as Date))
            
            let components = Calendar.current.dateComponents([.hour, .minute], from: incomingOnlineDate!, to: currentdate!)
            
            // To get the hours
            //print(components.hour)
            // To get the minutes
            //print(components.minute)
            
            //MARK:- Check if current time and otheruser online time difference is more then two minutes
            formatter.dateFormat = "hh:mm a"
            if components.hour! < 2
            {
                if components.minute! > 1
                {
                    //Offline
                }
                else
                {
                    //Online
                    completion("1", "" + formatter.string(from: dateIncoming as Date))
                    return
                }
            }
            //Offline
            completion("0", "Today " + formatter.string(from: dateIncoming as Date))
        }
        else
        {
            formatter.dateFormat = "d/MM/yy hh:mm a"
            //Offline
            completion("0", "" + "last seen " + formatter.string(from: dateIncoming as Date))
        }
    }
    func ifPreviousDateMessageSelect(timestring: String) -> String
    {
        let currentDateTimeToMiliSec = NSDate(timeIntervalSince1970: Double(Date().currentTimeMillis()!) / 1000)
        
        let date = NSDate(timeIntervalSince1970: Double(timestring)! / 1000)
        let formatter = DateFormatter()
        formatter.timeZone = (NSTimeZone(name: "\(TimeZone.current.identifier)")! as TimeZone)
        
        formatter.dateFormat = "YYYY-MM-dd"
        //formatter.dateFormat = "ddmmYY"
        
        let currentdate = formatter.date(from: formatter.string(from: currentDateTimeToMiliSec as Date))
        let msgdate = formatter.date(from: formatter.string(from: date as Date))
        
        if currentdate == msgdate
        {
            return "1"
        }
        else
        {
            return "0"
        }
    }
    //MARK:- Download Video and Audio //Type is Video/Audio/Documents/Voice
    func funDownloadPlayShow(urlString: String, type: Int, isAuto: Bool, isProgressBarShow: Bool, viewController: UIViewController,completion: @escaping (_ urlString: String?) -> Void) {
        let url = URL(string: urlString)
        if url == nil {
            return
        }
        // then lets create your document folder url
        let documentsDirectoryURL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        // lets create your destination file url
        let destinationUrl = documentsDirectoryURL.appendingPathComponent(url!.lastPathComponent)
        //print(destinationUrl)
        // to check if it exists before downloading it
        if FileManager.default.fileExists(atPath: destinationUrl.path) {
            print("The file already exists at path")
            completion("\(destinationUrl)")
            return
        }
        else {
            if isAuto{
                var temptype = String()
                let tempArrWifi = WIFI_DATA.components(separatedBy: ",")
                let tempArrMobileData = MOBILE_DATA.components(separatedBy: ",")
                switch type {
                case IMAGE :
                    temptype = "Photo"
                    break
                case AUDIO :
                    temptype = "Audio"
                    break
                case VIDEO :
                    temptype = "Video"
                    break
                case DOCUMENT :
                    temptype = "Document"
                    break
                default:
                    break
                }
                if WIFI{
                    if tempArrWifi.contains(temptype){
                        
                    }else {
                        completion("\("")")
                        return}
                }else{
                    if tempArrMobileData.contains(temptype){
                        
                    }else {
                        completion("\("")")
                        return}
                }
            }
            
            // if the file doesn't exist
            var downloadTask:URLSessionDownloadTask
            //MARK:- WORKIKNG BUT DELEGATES NOT CALL IF WE USE THIS
            downloadTask = URLSession.shared.downloadTask(with: url!, completionHandler: {
                (URL, response, error) -> Void in
                
                do {
                    guard let URL = URL, error == nil else {
                        return }
                    try FileManager.default.moveItem(at: URL, to: destinationUrl)
                    print("File moved to documents folder")
                    completion("\(destinationUrl)")
                }
                catch let error as NSError {
                    //self.player = nil
                    print(error.localizedDescription)
                    // obj.showToast(message: error.localizedDescription, viewcontroller: self!)
                    completion("\(destinationUrl)")
                } catch {
                    print("AVAudioPlayer init failed")
                    //obj.showToast(message: "Video Failed ...!", viewcontroller: self!)
                    print("Failed ...!")
                }
            })
            downloadTask.resume()
        }
    }
    
    //MARK:- Download Video and Audio //Type is Video/Audio/Documents/Voice
    func funForceDownloadPlayShow(urlString: String, isProgressBarShow: Bool, viewController: UIViewController,completion: @escaping (_ urlString: String?) -> Void) {
        let url = URL(string: urlString)
        // then lets create your document folder url
        let documentsDirectoryURL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        // lets create your destination file url
        let destinationUrl = documentsDirectoryURL.appendingPathComponent(url!.lastPathComponent)
        //print(destinationUrl)
        // to check if it exists before downloading it
        if FileManager.default.fileExists(atPath: destinationUrl.path) {
            print("The file already exists at path")
            completion("\(destinationUrl)")
            return
        }
        else {
            MEDIAPROGRESS = Float()
            
            objG.showProgressBar(viewController: viewController)
            let destination = DownloadRequest.suggestedDownloadDestination(for: .documentDirectory)
            
            Alamofire.download(
                url!,
                method: .get,
                parameters: nil,
                encoding: JSONEncoding.default,
                headers: nil,
                to: destination).downloadProgress(closure: { (progress) in
                    //progress closure
                    MEDIAPROGRESS = Float(progress.fractionCompleted)
                    print(MEDIAPROGRESS)
                }).response(completionHandler: { (response) in
                    //here you able to access the DefaultDownloadResponse
                    //result closure
                    if MEDIAPROGRESS == 1.0 {
                        print("Go!")
                        do {
                            //  guard let URL = response.temporaryURL else {
                            //    return }
                            
                            completion("\(destinationUrl)")
                        }
                        catch {
                            //localFileDestinationUrl = URL(string: "")
                            print("Error in Compete Download URLSessionDownloadTas catch Failed ...!")
                        }
                    } else {
                        print(MEDIAPROGRESS)
                    }//End of if MEDIAPROGRESS == 1.0
                })//End of Alamofire.download(
        }
    }
    
    var isCompeted = Bool()
    var localFileDestinationUrl: URL!
    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print("File complete download")
        MEDIAPROGRESS = 1.0
        do {
            //            guard let URL = location else {
            //                return }
            try FileManager.default.moveItem(at: location, to: localFileDestinationUrl!)
            print("File moved to documents folder")
            // completion("\(destinationUrl)")
        }
        catch let error as NSError {
            //localFileDestinationUrl = URL(string: "")
            print("Error in Compete Download URLSessionDownloadTask catch let error" + error.localizedDescription)
        } catch {
            //localFileDestinationUrl = URL(string: "")
            print("Error in Compete Download URLSessionDownloadTas catch Failed ...!")
        }
    }
    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        // println("download task did write data")
        
        let progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
        print(progress)
        MEDIAPROGRESS = Float(totalBytesWritten)
        if Float(MEDIAPROGRESS) >= 0.99{
            print("Downloading Complete")      // THIS IS WHAT I WANT
        }
        else{
            print("Not pausable")    // THIS IS MY PROBLEM
        }
    }
    
    //MARK:- This try cach is use for move local image/audio/video/documents file to Local Directry
    func funMoveLocalFileToLocalDirectory(fileName: String, downloadURL: URL, fileData: Data){
        //MARK:- This try cach is use for move local image/audio/video/documents file to Local Directry
        do {
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let fileURL = documentsURL.appendingPathComponent(fileName)
            try fileData.write(to: fileURL, options: .atomic)
            //////////////////////
            try FileManager.default.moveItem(at: downloadURL, to: fileURL)
            print("File moved to documents folder")
            
            /////////////////////////
            
        } catch { }
    }
    func showProgress()
    {
        //        let progressview = CGRect(x: toastLabel.frame.origin.x, y: toastLabel.frame.origin.y, width: toastLabel.frame.size.width + 40, height: toastLabel.frame.size.height + 40)
    }
    
    //MARK:- Show Toast Like Android
    func showToast(message : String, viewcontroller: UIViewController) {
        let toastLabel = UILabel()
        labelunlimitedtext(label: toastLabel)
        toastLabel.text = message
        toastLabel.sizeToFit()
        toastLabel.frame = CGRect(x: toastLabel.frame.origin.x, y: toastLabel.frame.origin.y, width: toastLabel.frame.size.width + 40, height: toastLabel.frame.size.height + 40)
        toastLabel.center = viewcontroller.view.center
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont(name: "Montserrat-Light", size: 12.0)
        
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = toastLabel.frame.size.height / 2;
        toastLabel.clipsToBounds  =  true
        //viewcontroller.view.addSubview(toastLabel)
        UIView.animate(withDuration: 3.0, delay: 0.0, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
        UIApplication.shared.keyWindow!.addSubview(toastLabel)
    }
    
    //MARK:- Bubble Message Custom
    func setLabelHightWidth(label: UILabel, bgview: UIImageView, senderReceiver: String, labeltime: UILabel, imgviewstatus: UIImageView, view: UIView)
    {
        label.sizeToFit()
        let framelabel = UILabel()
        framelabel.frame = label.frame
        
        self.labelunlimitedtext(label: framelabel)
        framelabel.text = label.text!
        framelabel.frame = CGRect(x: label.frame.origin.x, y: label.frame.origin.y, width: label.frame.size.width + 40, height: label.frame.size.height + 40)
        framelabel.sizeToFit()
        //framelabel.frame.size.width = framelabel.intrinsicContentSize.width
        framelabel.frame.origin.x = label.frame.maxX - (framelabel.frame.size.width - 26)
        bgview.frame.size.width = framelabel.frame.size.width + 30
        //        print(label)
        //        print(framelabel)
        //        print(bgview)
        //
        DispatchQueue.main.async {
            if senderReceiver == "sender"
            {
                let line = framelabel.calculateMaxLines()
                // bgview.frame.size.width = framelabel.frame.size.width + 40
                if line > 1
                {
                    label.textAlignment = .right
                    bgview.frame.size.width = framelabel.frame.size.width + 30
                }
                else
                {
                    label.textAlignment = .right
                }
                bgview.frame.origin.x = label.frame.maxX - (framelabel.frame.size.width + 20)
                labeltime.frame.origin.x = bgview.frame.origin.x - (labeltime.frame.width + 8)
                imgviewstatus.frame.origin.x = bgview.frame.origin.x - (imgviewstatus.frame.width + 8)
            }
            else
            {
                bgview.frame.size.width = framelabel.frame.size.width + 30
                
                bgview.frame.origin.x = label.frame.minX - 15
                
                labeltime.frame.origin.x = bgview.frame.maxX + 8
                //MARK:- Not using in incomming cell
                //imgviewstatus.frame.origin.x = bgview.frame.maxX + 8
            }
            
            self.setImageViewShade(imageview: bgview)
        }
    }
    
    func SendPushNotification(toToken: String, title: String, body: String, data: [String: Any])
    {
        let sender = PushNotificationSender()
        sender.sendPushNotification(to: toToken, title: title, body: body, data: data)
    }
    
    //    // Marks: - Keyboard Handling in UIViews
    func keybShow(notification: NSNotification) {
        
        self.view.frame.origin.y = 64
        
        //let height = Float(self.view.frame.size.height)
        
        let userInfo:NSDictionary = notification.userInfo! as NSDictionary
        let keyboardFrame:NSValue = userInfo.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.cgRectValue
        keyboardHeight = keyboardRectangle.height
        
        //        var lblremheight = Float()
        //        if (height - (txtfiledMaxY + 64)) < 20
        //        {
        //            lblremheight = (height - (txtfiledMaxY - 60));
        //        }
        //        else
        //        {
        //            lblremheight = (height - (txtfiledMaxY + 40));
        //        }
        //
        //
        //       // print(lblremheight)
        //        let kbremheight = Float(height - keyboardHeight)
        //       // print(kbremheight)
        //        let checkheight = Float(lblremheight - (kbremheight))
        //        //print(checkheight)
        //
        //        if checkheight < 0
        //        {
        //            let h = abs(checkheight)
        //            print(h)
        //            activeview.frame.origin.y = (CGFloat)((checkheight))
        //        }
        //        else
        //        {
        //
        //        }
    }
    
    
    
    //MARK:- Find link in string
    func findLinkInText(label: UILabel) {
        
        let input = label.text!
        let link = findLink(string: input)
        if link == ""{
            return
        }
        let attributedString = NSMutableAttributedString(string: input)
        let linkRange = (attributedString.string as NSString).range(of: link)
        attributedString.addAttribute(NSAttributedString.Key.link, value: "https://\(link)", range: linkRange)
        let linkAttributes: [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.foregroundColor: UIColor.green,
            NSAttributedString.Key.underlineColor: UIColor.lightGray,
            NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        
        // textView is a UITextView
        //  label.linkTextAttributes = linkAttributes as [String : Any]
        label.attributedText = attributedString
    }
    func findLink(string: String) -> String {
        
        let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        
        let matches = detector.matches(in: string, options: [], range: NSRange(location: 0, length: string.utf16.count))
        var link = ""
        for match in matches {
            //guard let range = Range(match.range, in: input) else { continue }
            guard let range = Range(match.range, in: string) else { return ""}
            let url = string[range]
            print(url)
            link = String(url)
            return link
        }
        return ""
    }//END find link in label and string
    //
    //    func keybHide(notification: NSNotification) {
    //        print("kb hide")
    //        activeview.frame.origin.y = 64
    //    }
    
    //    //MARK:- Get path from google and draw polyline on the map
    //    func getRoughtfromGoogleAndDrawOnMAP(origin:String, destination: String, viewformap: GMSMapView, startimg: String, endimg: String ,completionHandler: @escaping (GMSPolyline?, String?) -> ())
    //    {
    ////        let origin = "\(startlat),\(startlong)"
    ////        let destination = "\(endlat),\(endlong)"
    //        let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&mode=driving&key=AIzaSyCCV0o8uVWymFDp_B7nzDM6xt1VlmrMZjc"
    //        
    //        obj.webServicesGet(url: url, completionHandler: {
    //            responseObject, error in
    //            
    //            if error == nil && responseObject != nil
    //            {
    //                let data = responseObject?.value(forKey: "routes") as! NSArray
    //                let legs = data.value(forKey: "legs") as! NSArray
    //                let steps = legs.value(forKey: "steps") as! NSArray
    //                //let startloc = steps.value(forKey: "start_address") as! NSArray
    //                //let endloc = steps.value(forKey: "start_address") as! NSArray
    //                let routeOverviewPolyline = data.value(forKey: "overview_polyline") as! NSArray
    //                var polyline = GMSPolyline()
    //                if steps.count > 0
    //                {
    //                    viewformap.clear()
    //                    
    //                    let  routeDict = routeOverviewPolyline[0] as! NSDictionary
    //                    let points = routeDict["points"]
    //                    let path = GMSPath.init(fromEncodedPath: points as! String)
    //                    polyline = GMSPolyline.init(path: path)
    //                    polyline.strokeColor = clrstatusbar
    //                    polyline.strokeWidth = 5
    //                    //MARK:- of you want to you the Polyline funcation in same class.
    //                    polyline.map = viewformap
    //                    
    //                    let originarr = origin.split{$0 == ","}.map(String.init)
    //                    let destinationarr = destination.split{$0 == ","}.map(String.init)
    //                    // or simply:
    //                    // let fullNameArr = fullName.characters.split{" "}.map(String.init)
    //                    
    //                    //latarr[0] // First
    //                    //longarr[0] // Last
    //                    
    //                    //MARK:- Draw mark position for draw image
    //                    let positionstart = CLLocationCoordinate2DMake(Double(originarr[0])!, Double(originarr[1])!)
    //                    let positionend = CLLocationCoordinate2DMake(Double(destinationarr[0])!, Double(destinationarr[1])!)
    //                    //MARK:- Draw marker for flag
    //                    let markerstart = GMSMarker()
    //                    let markerImageStart = UIImage(named: startimg)!.withRenderingMode(.alwaysTemplate)
    //                    markerstart.position = positionstart
    //                    markerstart.title = "Driver"
    //                    markerstart.icon = markerImageStart
    //                    markerstart.map = viewformap
    //                    
    //                    let markerend = GMSMarker()
    //                    let markerImageEnd = UIImage(named: endimg)!.withRenderingMode(.alwaysTemplate)
    //                    markerend.position = positionend
    //                    markerend.title = "Driver"
    //                    markerend.icon = markerImageEnd
    //                    markerend.map = viewformap
    //                }
    //                else
    //                {
    //                    completionHandler(nil, nil)
    //                }
    //                completionHandler(polyline as GMSPolyline, nil)
    //                
    //            }
    //            else
    //            {
    //                var errorstr = String()
    //                if error != nil{
    //                    errorstr = (error?.description)!
    //                }
    //                completionHandler(nil, errorstr)
    //            }
    //            
    //        })
    //    }
    
    
    
}


//
//  AKMicrophone.swift
//  AudioKit
//
//  Created by Aurelius Prochazka, revision history on Github.
//  Copyright © 2017 Aurelius Prochazka. All rights reserved.
//
/// Audio from the standard input
//open class AKMicrophone: AKNode, AKToggleable {
//
//    internal let mixer = AVAudioMixerNode()
//
//    /// Output Volume (Default 1)
//    open dynamic var volume: Double = 1.0 {
//        didSet {
//            volume = max(volume, 0)
//            mixer.outputVolume = Float(volume)
//        }
//    }
//
//    /// Set the actual microphone device
//    public func setDevice(_ device: AKDevice) throws {
//        do {
//            try AudioKit.setInputDevice(device)
//        } catch {
//            AKLog("Could not set input device")
//        }
//    }
//
//    fileprivate var lastKnownVolume: Double = 1.0
//
//    /// Determine if the microphone is currently on.
//    open dynamic var isStarted: Bool {
//        return volume != 0.0
//    }
//
//    /// Initialize the microphone
//    override public init() {
//        #if !os(tvOS)
//            super.init()
//            self.avAudioNode = mixer
//            AKSettings.audioInputEnabled = true
//            AudioKit.engine.attach(mixer)
//            if let inputNode = AudioKit.engine.inputNode {
//                AudioKit.engine.connect(inputNode, to: self.avAudioNode, format: nil)
//            }
//        #endif
//    }
//
//    deinit {
//        AKSettings.audioInputEnabled = false
//    }
//
//    /// Function to start, play, or activate the node, all do the same thing
//    open func start() {
//        if isStopped {
//            volume = lastKnownVolume
//        }
//    }
//
//    /// Function to stop or bypass the node, both are equivalent
//    open func stop() {
//        if isPlaying {
//            lastKnownVolume = volume
//            volume = 0
//        }
//    }
//}
//MARK:- App Gradient Colors on UIView
extension UIView {
    func applyGradient(colours: [UIColor]) -> Void {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.startPoint = CGPoint(x : 0.0, y : 0.5)
        gradient.endPoint = CGPoint(x :1.0, y: 0.5)
        self.layer.insertSublayer(gradient, at: 0)
    }
}

class Colors {
    var gl:CAGradientLayer!
    
    init() {
        let colorTop = UIColor(red: 192.0 / 255.0, green: 38.0 / 255.0, blue: 42.0 / 255.0, alpha: 1.0).cgColor
        let colorMiddle = UIColor(red: 192.0 / 255.0, green: 38.0 / 255.0, blue: 42.0 / 255.0, alpha: 1.0).cgColor
        let colorBottom = UIColor(red: 35.0 / 255.0, green: 2.0 / 255.0, blue: 2.0 / 255.0, alpha: 1.0).cgColor
        
        self.gl = CAGradientLayer()
        self.gl.colors = [colorTop, colorMiddle, colorBottom]
        self.gl.locations = [0.0, 1.0]
    }
}
//MARK:- For Gif Image load
extension UIImageView {
    
    public func loadGif(name: String) {
        DispatchQueue.global().async {
            let image = UIImage.gif(name: name)
            DispatchQueue.main.async {
                self.image = image
            }
        }
    }
}

extension UIImage {
    
    public class func gif(data: Data) -> UIImage? {
        // Create source from data
        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else {
            print("SwiftGif: Source for the image does not exist")
            return nil
        }
        
        return UIImage.animatedImageWithSource(source)
    }
    
    public class func gif(url: String) -> UIImage? {
        // Validate URL
        guard let bundleURL = URL(string: url) else {
            print("SwiftGif: This image named \"\(url)\" does not exist")
            return nil
        }
        
        // Validate data
        guard let imageData = try? Data(contentsOf: bundleURL) else {
            print("SwiftGif: Cannot turn image named \"\(url)\" into NSData")
            return nil
        }
        
        return gif(data: imageData)
    }
    
    public class func gif(name: String) -> UIImage? {
        // Check for existance of gif
        guard let bundleURL = Bundle.main
            .url(forResource: name, withExtension: "gif") else {
                print("SwiftGif: This image named \"\(name)\" does not exist")
                return nil
        }
        
        // Validate data
        guard let imageData = try? Data(contentsOf: bundleURL) else {
            print("SwiftGif: Cannot turn image named \"\(name)\" into NSData")
            return nil
        }
        
        return gif(data: imageData)
    }
    
    internal class func delayForImageAtIndex(_ index: Int, source: CGImageSource!) -> Double {
        var delay = 0.1
        
        // Get dictionaries
        let cfProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil)
        let gifPropertiesPointer = UnsafeMutablePointer<UnsafeRawPointer?>.allocate(capacity: 0)
        if CFDictionaryGetValueIfPresent(cfProperties, Unmanaged.passUnretained(kCGImagePropertyGIFDictionary).toOpaque(), gifPropertiesPointer) == false {
            return delay
        }
        
        let gifProperties:CFDictionary = unsafeBitCast(gifPropertiesPointer.pointee, to: CFDictionary.self)
        
        // Get delay time
        var delayObject: AnyObject = unsafeBitCast(
            CFDictionaryGetValue(gifProperties,
                                 Unmanaged.passUnretained(kCGImagePropertyGIFUnclampedDelayTime).toOpaque()),
            to: AnyObject.self)
        if delayObject.doubleValue == 0 {
            delayObject = unsafeBitCast(CFDictionaryGetValue(gifProperties,
                                                             Unmanaged.passUnretained(kCGImagePropertyGIFDelayTime).toOpaque()), to: AnyObject.self)
        }
        
        delay = delayObject as? Double ?? 0
        
        if delay < 0.1 {
            delay = 0.1 // Make sure they're not too fast
        }
        
        return delay
    }
    
    internal class func gcdForPair(_ a: Int?, _ b: Int?) -> Int {
        var a = a
        var b = b
        // Check if one of them is nil
        if b == nil || a == nil {
            if b != nil {
                return b!
            } else if a != nil {
                return a!
            } else {
                return 0
            }
        }
        
        // Swap for modulo
        if a! < b! {
            let c = a
            a = b
            b = c
        }
        
        // Get greatest common divisor
        var rest: Int
        while true {
            rest = a! % b!
            
            if rest == 0 {
                return b! // Found it
            } else {
                a = b
                b = rest
            }
        }
    }
    
    internal class func gcdForArray(_ array: Array<Int>) -> Int {
        if array.isEmpty {
            return 1
        }
        
        var gcd = array[0]
        
        for val in array {
            gcd = UIImage.gcdForPair(val, gcd)
        }
        
        return gcd
    }
    
    internal class func animatedImageWithSource(_ source: CGImageSource) -> UIImage? {
        let count = CGImageSourceGetCount(source)
        var images = [CGImage]()
        var delays = [Int]()
        
        // Fill arrays
        for i in 0..<count {
            // Add image
            if let image = CGImageSourceCreateImageAtIndex(source, i, nil) {
                images.append(image)
            }
            
            // At it's delay in cs
            let delaySeconds = UIImage.delayForImageAtIndex(Int(i),
                                                            source: source)
            delays.append(Int(delaySeconds * 1000.0)) // Seconds to ms
        }
        
        // Calculate full duration
        let duration: Int = {
            var sum = 0
            
            for val: Int in delays {
                sum += val
            }
            
            return sum
        }()
        
        // Get frames
        let gcd = gcdForArray(delays)
        var frames = [UIImage]()
        
        var frame: UIImage
        var frameCount: Int
        for i in 0..<count {
            frame = UIImage(cgImage: images[Int(i)])
            frameCount = Int(delays[Int(i)] / gcd)
            
            for _ in 0..<frameCount {
                frames.append(frame)
            }
        }
        
        // Heyhey
        let animation = UIImage.animatedImage(with: frames,
                                              duration: Double(duration) / 1000.0)
        
        return animation
    }
    
}
extension UITableView {
    func reloadData(completion: @escaping () -> ()) {
        UIView.animate(withDuration: 0, animations: { self.reloadData()})
        {_ in completion() }
    }
}
extension UILabel {
    func calculateMaxLines() -> Int {
        let maxSize = CGSize(width: frame.size.width, height: CGFloat(Float.infinity))
        let charSize = font.lineHeight
        let text = (self.text ?? "") as NSString
        let textSize = text.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font!], context: nil)
        let linesRoundedUp = Int(ceil(textSize.height/charSize))
        return linesRoundedUp
    }
}

//MARK:- Convert Second to milisecond , milisecond to second
//https://stackoverflow.com/questions/30771820/swift-convert-milliseconds-into-minutes-seconds-and-milliseconds
extension TimeInterval {
    var minuteSecondMS: String {
        return String(format:"%d:%02d.%03d", minute, second, millisecond)
    }
    var minute: Int {
        return Int((self/60).truncatingRemainder(dividingBy: 60))
    }
    var second: Int {
        return Int(truncatingRemainder(dividingBy: 60))
    }
    var millisecond: Int {
        return Int((self*1000).truncatingRemainder(dividingBy: 1000))
    }
    var durationToMilliSecond: Int{
        return Int(self*1000)
    }
}

extension Int {
    var msToSeconds: Double {
        return Double(self) / 1000
    }
}

//MARK:- Device to device Push Notification
class PushNotificationSender {
    func sendPushNotification(to token: String, title: String, body: String, data: [String: Any]) {
        let url = NSURL(string: FBASE_SEND_NOTIFICATION_URL)!
        var tempdataAndroid = data
        var paramString = [String : Any]()
        var tempisAndroid = Bool()
        let tempdic = data as NSDictionary
        if (tempdic.allKeys as NSArray).contains("isAndroidUser") {
            tempisAndroid = (tempdic.value(forKey: "isAndroidUser") as? Bool)!
            if tempisAndroid == true{
                //For Android
                tempdataAndroid.removeValue(forKey: "title")
                tempdataAndroid.removeValue(forKey: "body")
                tempdataAndroid.removeValue(forKey: "isAndroidUser")
                paramString = [
                    "to" : token,
                    "priority": "high",
                    "data" : tempdataAndroid,
                    "sound": "default"
                   // "notification": tempdataAndroid
                ]
            }else{
                tempdataAndroid.removeValue(forKey: "isAndroidUser")
                //For IOS
                paramString = [
                    "to" : token,
                    // "title":title,
                    // "body":body,
                    "priority": "high",
                    "data" : data,
                    "notification": data,
                    //"aps": dd,
                    //"payload": dd,
                    "sound": "default"
                    // "mutable_content": true,
                    //  "content_available": true
                ]
            }
        }
        else{
            if isAndroidUser == true{
                //For Android
                tempdataAndroid.removeValue(forKey: "title")
                tempdataAndroid.removeValue(forKey: "body")
                paramString = [
                    "to" : token,
                    "priority": "high",
                    "data" : tempdataAndroid,
                    "sound": "default"
                   // "notification": tempdataAndroid
                ]
            }else{
                
                //For IOS
                paramString = [
                    "to" : token,
                    // "title":title,
                    // "body":body,
                    "priority": "high",
                    "data" : data,
                    "notification": data,
                    //"aps": dd,
                    //"payload": dd,
                    "sound": "default"
                    // "mutable_content": true,
                    //  "content_available": true
                ]
            }
        }
        
        
        //        let dd = [
        //            "title":title,
        //            "body":body,
        //            "alert": "Hello!",
        //            "sound": "default",
        //            "mutable_content": true,
        //            //"content_available": true,
        //            "badge": 0,
        //            "data": [
        //                    "attachment-url": "https://ibb.co/BccHsMR"
        //            ]] as [String : Any]
        
        //        let paramString: [String : Any] = ["to" : token,
        //                                           "title":title,
        //                                           "body":body,
        //                                           "priority": "high",
        //                                           "data" : data,
        //                                           // "notification": data,
        //            "aps": dd,
        //            "payload": dd,
        //            "sound": "incomming.mp3",
        //            // "content_available": true//,
        //            "mutable_content": true
        //        ]
        
        
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject:paramString, options: [.prettyPrinted])
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("key=\(FIREBASE_SERVERKEY)", forHTTPHeaderField: "Authorization")
        let task =  URLSession.shared.dataTask(with: request as URLRequest)  { (data, response, error) in
            do {
                if let jsonData = data {
                    if let jsonDataDict  = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: AnyObject] {
                        NSLog("Received data:\n\(jsonDataDict))")
                    }
                }
            } catch let err as NSError {
                print(err.debugDescription)
            }
        }
        task.resume()
    }
}

//MARK:- Hyper link label
class LinkedLabel: UILabel {
    
    fileprivate let layoutManager = NSLayoutManager()
    fileprivate let textContainer = NSTextContainer(size: CGSize.zero)
    fileprivate var textStorage: NSTextStorage?
    
    
    override init(frame aRect:CGRect){
        super.init(frame: aRect)
        self.initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialize()
    }
    
    func initialize(){
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(LinkedLabel.handleTapOnLabel))
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(tap)
    }
    
    override var attributedText: NSAttributedString?{
        didSet{
            if let _attributedText = attributedText{
                self.textStorage = NSTextStorage(attributedString: _attributedText)
                
                self.layoutManager.addTextContainer(self.textContainer)
                self.textStorage?.addLayoutManager(self.layoutManager)
                
                self.textContainer.lineFragmentPadding = 0.0;
                self.textContainer.lineBreakMode = self.lineBreakMode;
                self.textContainer.maximumNumberOfLines = self.numberOfLines;
            }
        }
    }
    
    @objc func handleTapOnLabel(tapGesture:UITapGestureRecognizer) {
        
        let link = obj.findLink(string: self.text!)
        if link == ""{
            return
        }
        let locationOfTouchInLabel = tapGesture.location(in: tapGesture.view)
        let labelSize = tapGesture.view?.bounds.size
        let textBoundingBox = self.layoutManager.usedRect(for: self.textContainer)
        let textContainerOffset = CGPoint(x: ((labelSize?.width)! - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x, y: ((labelSize?.height)! - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y)
        
        let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - textContainerOffset.x, y: locationOfTouchInLabel.y - textContainerOffset.y)
        let indexOfCharacter = self.layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: self.textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        
        self.attributedText?.enumerateAttribute(NSAttributedString.Key.link, in: NSMakeRange(0, (self.attributedText?.length)!), options: NSAttributedString.EnumerationOptions(rawValue: UInt(0)), using:{
            (attrs: Any?, range: NSRange, stop: UnsafeMutablePointer<ObjCBool>) in
            
            if NSLocationInRange(indexOfCharacter, range){
                if let _attrs = attrs{
                    
                    guard let url = URL(string: "\(_attrs as! String)"), !url.absoluteString.isEmpty else {
                        return
                    }
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
        })
    }}
