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
        let scale = self.frame.size.height /  UIScreen.main.bounds.height
        let bottomMargin = 50 * scale

        backgroundImage = UIImage(color: UIColor.clear, size: self.frame.size)
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
        if let question = params["question"] as? [String:Any], question.keys.count > 0{
            let height = 230 * scale
            let questionView = QuestionMaskView(frame: CGRect(x: 0, y: self.frame.size.height - height - 10, width: self.frame.size.width, height: height), scale:scale)
            questionView.bindData(config: question)
            watermarkView.addSubview(questionView)
        }
        if let catchword = params["catchword"] as? [String: Any], catchword.keys.count > 0{
            let height = 250 * scale
            let catchwordView = CatchWordMaskView(frame: CGRect(x: 0, y: self.frame.size.height - height - bottomMargin, width: self.frame.size.width, height: height))
            watermarkView.addSubview(catchwordView)
        }
        
        if let video = params["video"] as? [String:Any], video.keys.count > 0, let url = video["url"] as? String{
            let height:CGFloat = 300 * scale
            let width:CGFloat = height / (720 / 1280)
            let videoView = VideoMaskView(frame: CGRect(x: self.frame.size.width - width, y: self.frame.size.height - height - bottomMargin , width: width, height: height))
            videoView.playVideo(from: url)
            watermarkView.addSubview(videoView)
            
        }
        if let pinComment = params["pin"] as? [String:Any],pinComment.keys.count >= 2,let font =  pinComment["font"] as? Int{
            if font > 0{
                let height:CGFloat = 200 * scale
                let width = self.frame.size.width
                let pinView = CommentMaskView(frame: CGRect(x: 0, y: self.frame.size.height / 2 , width: width, height: height),scale: scale)
                watermarkView.addSubview(pinView)

            }
            
        }
//        let wartermarkImageView = UIImageView(frame: watermarkView.bounds)
//        wartermarkImageView.image = backgroundImage.resizeImage(self.frame.size)
//        watermarkView.addSubview(wartermarkImageView)
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
    func configQuestion(config:[String:Any]){
        params["question"] = config
    }
    func configPin(comment:FacebookComment){
        if var config = params["pin"] as? [String:Any]{
            config["comment"] = comment
            params["pin"] = config
        }else{
            let config = ["comment":comment]
            params["pin"] = config

        }
        

    }
    func configCatchWord(config:[String:Any]){
        params["catchword"] = config
    }
    func configVideo(config:[String:Any]){
        params["video"] = config
    }
    func configPinComment(font:Int){
        if var config = params["pin"] as? [String:Any]{
            config["font"] = font
            params["pin"] = config
        }else{
            let config = ["font":font]
            params["pin"] = config
            
        }
    }
    /**/
    func hideCountDownView(){
        params["countdown"] = false;
    }
    func showCountdownView(){
        params["countdown"] = true
    }
}
