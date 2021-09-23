//
//  ProgressBar.swift
//  ZedChat
//
//  Created by MacBook Pro on 16/07/2019.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit


class ProgressBar: UIViewController {

    @IBOutlet weak var bgv: UIView!
    @IBOutlet weak var progressBar: UIProgressView!
    
    @IBOutlet weak var btncancel: UIButton!
    @IBAction func btncancel(_ sender: Any) {
        objG.removeVerificationPopup()
    }
    @IBOutlet weak var bgvtitle: UIView!
    var timerr = 0.0
    override func viewDidLoad() {
        bgvtitle.backgroundColor = appclr
        super.viewDidLoad()
        timerr = 0.0
        obj.setViewShade(view: bgv)
        // Do any additional setup after loading the view.
        MEDIAPROGRESS = 0
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { timer in
            self.timerr = self.timerr + 0.5
            if MEDIAPROGRESS >= 0.99 {
                print("Go!")
                let progress = (Float(MEDIAPROGRESS))
                self.progressBar.setProgress(Float(progress), animated:true)
                DispatchQueue.main.async {
                    timer.invalidate()
                    Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { timer in
                        objG.removeVerificationPopup()
                    }
                }
            } else {
                print(MEDIAPROGRESS)
                let progress = (Float(MEDIAPROGRESS))
                self.progressBar.setProgress(Float(progress), animated:true)
                if self.timerr > 10.0{
                    MEDIAPROGRESS = 1
                }
            }
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

}
