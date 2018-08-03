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
    var params:[String:Any] = [:];
    var frame:CGRect = CGRect(x: 0, y: 0, width: 720, height: 1280 )
    var powerText:String?
    var hasPowerText:Bool = false
    var hasFrame:Bool = false
    var countDownImage:UIImage?
    var backgroundImage:UIImage!
    init(){
        backgroundImage = UIImage.imageWithColor(color: UIColor.clear, size: self.frame.size)
        countDownImage = UIImage(named: "bg_countdown")

    }
    class func shared() -> WarterMarkServices {
        return sharedInstance
    }
    func setFrame(frame:CGRect){
        self.frame = frame
    }
    func generateWarterMark() -> UIView{
        let watermarkView = UIView(frame: self.frame)
        backgroundImage = UIImage(color: UIColor.red.withAlphaComponent(0.5), size: self.frame.size)
        backgroundImage = backgroundImage.resizeImage(self.frame.size)
        if let frame = params["frame"] as? Bool , frame == true{
           backgroundImage =  addFrame(sourceImage: backgroundImage)

        }
        if let countdown = params["countdown"] as? Bool, countdown == true{
            addCountDown();
        }
        if let slogan = params["slogan"] as? [String:Any]{
            if let sloganView = handleSlogan(slogan: slogan){
                watermarkView.addSubview(sloganView)
            }
        }
        
        let wartermarkImageView = UIImageView(frame: watermarkView.bounds)
        wartermarkImageView.image = backgroundImage.resizeImage(self.frame.size)
        watermarkView.addSubview(wartermarkImageView)
        return watermarkView
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
    func handleSlogan(slogan:[String:Any]) -> UIView?{
        let sloganView = UIView(frame: CGRect(x: 0, y: self.frame.size.height - 100, width: self.frame.size.width, height: 100))
        sloganView.backgroundColor = UIColor.yellow
        
        let value = slogan["value"] as? Int
        let text = slogan["text"] as? String
        let color = slogan["color"] as? UIColor
        let align = slogan["align"] as? NSTextAlignment
        
      
        let sloganLabel = UILabel(frame: sloganView.bounds)
        sloganLabel.textAlignment = .center
        sloganLabel.textColor = UIColor.white
        sloganLabel.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        sloganLabel.backgroundColor = .purple
        sloganView.addSubview(sloganLabel)
        if value == 0{
            //hide
            return nil
        }else if (value == 1){
            //default
            sloganLabel.text = "Power by CocaLive"
        }else{
            sloganLabel.text = text
        }
        sloganLabel.textColor = color
        sloganLabel.textAlignment = align ?? .center
        return sloganView
    }
    func configSlogan(config:[String:Any]){
        params["slogan"] = config
    }
    /**/
    func hideCountDownView(){
        params["countdown"] = false;
    }
    func showCountdownView(){
        params["countdown"] = true
    }
}
