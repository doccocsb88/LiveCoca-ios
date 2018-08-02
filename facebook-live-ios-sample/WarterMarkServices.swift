//
//  WarterMarkServices.swift
//  facebook-live-ios-sample
//
//  Created by Apple on 7/29/18.
//  Copyright © 2018 Hans Knoechel. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher
class WarterMarkServices{
    static let sharedInstance : WarterMarkServices = {
        let instance = WarterMarkServices()
        return instance
    }()
    var params:[String:Bool] = [:];
    var frame:CGRect = CGRect(x: 0, y: 0, width: 720, height: 1280 )
    var powerText:String?
    var hasPowerText:Bool = false
    var hasFrame:Bool = false
    var countDownImage:UIImage?
    var backgroundImage:UIImage!
    init(){
        backgroundImage = UIImage(color: UIColor.clear, size: self.frame.size)
        countDownImage = UIImage(named: "bg_countdown")

    }
    class func shared() -> WarterMarkServices {
        return sharedInstance
    }
    func setFrame(frame:CGRect){
        self.frame = frame
    }
    func generateWarterMark() -> UIImage?{
    
        backgroundImage = UIImage(color: UIColor.red.withAlphaComponent(0.5), size: self.frame.size)
        backgroundImage = backgroundImage.resizeImage(self.frame.size)
        if let frame = params["frame"] , frame == true{
           backgroundImage =  addFrame(sourceImage: backgroundImage)

        }
        if let countdown = params["countdown"], countdown == true{
            addCountDown();
        }
        return backgroundImage.resizeImage(self.frame.size)
    }
    func addCountDown(){
        if var countdownImage = countDownImage{
            countdownImage = countdownImage.resizeImage(self.frame.size)
            backgroundImage = backgroundImage.mergeImage(image: countdownImage, self.frame, at: self.frame)
        }
    }
    func addFrame(sourceImage:UIImage) -> UIImage?{
        let frameImage = UIImage(named: "ic_frame_default")
        
        return sourceImage.mergeImage(image: frameImage!,self.frame, at: self.frame)
        
    }
    /**/
    func hideCountDownView(){
        params["countdown"] = false;
    }
    func showCountdownView(){
        params["countdown"] = true
    }
}
