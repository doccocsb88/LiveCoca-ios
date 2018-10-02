//
//  WarterMarkServices.swift
//  coca-live
//
//  Created by Apple on 7/29/18.
//  Copyright © 2018 Coca Live. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher
class WarterMarkServices{
    var randomView:RandomMaskView?
    var countCommentView:CountCommentMaskView?
    var countdownView:CountdownMaskView?
//    var pinCommentView:CommentMaskView?
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
    var scale:CGFloat = 1
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
        scale = self.frame.size.width /  UIScreen.main.bounds.width
        var bottomMargin = 0 * scale

        backgroundImage = UIImage(color: UIColor.clear, size: self.frame.size)
        backgroundImage = backgroundImage.resizeImage(self.frame.size)
        if isCountdown(){
            if countdownView == nil{
                countdownView = CountdownMaskView(frame: self.frame, scale: scale)
            }
            countdownView?.updateView()
            watermarkView.addSubview(countdownView!)

            return watermarkView
        }else{
            if let config = params[ConfigKey.stopStream] as? [String:Any],config.keys.count > 0{
                if let image = config["image"] as? UIImage{
                    let imageView = UIImageView(frame: self.frame)
                    imageView.contentMode = .scaleAspectFill
                    imageView.clipsToBounds = true
                    imageView.image = image
                    watermarkView.addSubview(imageView)
                    return watermarkView
                    
                }
                
            }
            if let _  = countdownView{
                countdownView!.removeFromSuperview()
                countdownView = nil
            }
        }
        

        if let _ = params["slogan"] as? [String:Any]{
            
            bottomMargin = 50 * scale

        }
        if let questionConfig = params["question"] as? [String:Any], questionConfig.keys.count > 0{
            let questionView  = QuestionMaskView(frame: self.frame, scale: scale, config:questionConfig)
            
            questionView.bindData(config: questionConfig)
            watermarkView.addSubview(questionView)
        }
        if let catchword = params["catchword"] as? [String: Any], catchword.keys.count > 0{
            let width = self.frame.width
            let height = width * 9 / 16 + 100 * scale
            let catchwordView = CatchWordMaskView(frame: CGRect(x: 0, y: self.frame.size.height - height - bottomMargin, width: width, height: height),scale:scale)
            watermarkView.addSubview(catchwordView)
        }
        
        if let video = params[ConfigKey.childImage] as? [String:Any], let _ = video["image"] as? UIImage{
            let height:CGFloat = self.frame.height - bottomMargin
            let videoView = VideoMaskView(frame: CGRect(x: 0, y: 0 , width: self.frame.width, height: height), scale:scale)
            watermarkView.addSubview(videoView)
            
        }
        if let pinComment = params["pin"] as? [String:Any],pinComment.keys.count > 0,let comment =  pinComment["comment"] as? FacebookComment{
            

            let fontSize = pinComment["font"] as? CGFloat ?? 20
            let font = UIFont.systemFont(ofSize: fontSize * scale)
            let width = self.frame.size.width - 20 * scale

            var labelHeight = comment.message.heightWithConstrainedWidth(width: width - 60 * scale, font: font)

            let height:CGFloat = 30 * scale + labelHeight
            let top = self.frame.size.height - height - 50 * scale
            
            let frame =  CGRect(x: 10 * scale, y: top , width: width, height: height)
            let pinCommentView = CommentMaskView(frame:frame,scale: scale)
            
            pinCommentView.updateContent()
            pinCommentView.frame = frame
            pinCommentView.hideCloseButton()
            watermarkView.addSubview(pinCommentView)
        }else{
//            pinCommentView?.removeFromSuperview()
//            pinCommentView = nil
        }
        if let filterComment = params[ConfigKey.filterComment] as? [String:Any], filterComment.keys.count > 0{
            let height = 30 * 6 * scale + 40 * scale;
            let filterCommentView = FilterCommentMaskView(frame: CGRect(x: 0, y: self.frame.size.height / 10, width: self.frame.size.width, height: height), scale: scale)
            filterCommentView.updateContent()
            watermarkView.addSubview(filterCommentView)
        }
        if let random = params[ConfigKey.random] as? [String:Any], random.keys.count >= 2{
            if  let view = randomView{
                print("randomView : \(view.number1Label?.text ?? "ahahaha")")
                view.removeFromSuperview()
                
            }
//            let width:CGFloat = 720 / 2
//            let height =  (width / 1008 ) * (696 + 30 + 165)
//            let left = (self.view.bounds.width  - width ) / 2
//            let top = (self.view.bounds.height - height ) / 2
            let width = randomView?.frame.width ?? self.frame.size.width / 2
            let height = randomView?.frame.height ??  (width / 1008 ) * (696 + 30 + 165)
            let left = (self.frame.size.width - width) / 2
            let top = (self.frame.size.height - height ) / 2
            let frame = CGRect(x: left, y: top, width: width, height: height)
            randomView?.frame = frame
//            randomView?.backgroundColor = .red
            watermarkView.addSubview(randomView!)

            
        }else{
            randomView?.removeFromSuperview()
            randomView = nil
        }
        
        if let countComment = params[ConfigKey.countComment] as? [String:Any], countComment.keys.count > 0{
            let frame = CGRect(x: 0, y: self.frame.height / 2 - 50 * scale, width: self.frame.width, height: self.frame.height / 2)
            if countCommentView == nil{
                countCommentView =  CountCommentMaskView(frame: frame, scale: self.scale)
            }
            countCommentView?.backgroundColor = .clear
            countCommentView?.updateData()
            watermarkView.addSubview(countCommentView!)

        }else{
            if let _ = countCommentView{
                countCommentView?.removeFromSuperview()
            }
            countCommentView = nil
        }
//        let wartermarkImageView = UIImageView(frame: watermarkView.bounds)
//        wartermarkImageView.image = backgroundImage.resizeImage(self.frame.size)
//        watermarkView.addSubview(wartermarkImageView)
        if let frameConfig = params["frame"] as? [String:Any],let image =  frameConfig["image"] as? Image{
            
            let frameView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
            frameView.image = image
            
            watermarkView.addSubview(frameView)
            
        }
        if let slogan = params["slogan"] as? [String:Any]{
            if let sloganView = handleSlogan(slogan: slogan){
                watermarkView.addSubview(sloganView)
            }            
        }
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
    func configFrame(config:[String:Any]){
        params["frame"] = config
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
        sloganLabel.backgroundColor = UIColor.init(hexString: "#FC6076")
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
        params[ConfigKey.childImage] = config
    }
    func configPinComment(font:CGFloat){
        if var config = params["pin"] as? [String:Any]{
            config["font"] = font
            params["pin"] = config
        }else{
            let config = ["font":font]
            params["pin"] = config
            
        }
    }
    func removePinComment(){
        params["pin"] = [:]
    }
    
    func configFilterComment(_ config:[String:Any]){
        params[ConfigKey.filterComment] = config
    }
    func configRandom(_ config:[String:Any]){
        params[ConfigKey.random] = config
        
    }
    func configCountComment(_ config:[String:Any]){
        params[ConfigKey.countComment] = config

    }
    func startRandomNumber(){
        if let view = randomView{
            print("randomView start")

            view.startRandom()
        }
    }
    func stopRandomNumber(){
        if let view = randomView{
            print("randomView stop")
            view.stopRandom()
        }
    }
    /**/
    func hideCountDownView(){
        params["countdown"] = false;
    }
    func showCountdownView(){
        params["countdown"] = true
    }
    
    func configCountDown(config:[String:Any]){
        params[ConfigKey.countdown] = config
    }
    
    func hasFilterCommentView() -> Bool{
        if let filterComment = params[ConfigKey.filterComment] as? [String:Any], filterComment.keys.count > 0{
            return true
        }
        return false
    }
    func hasPinCommentView() ->Bool{
        if let pinComment = params["pin"] as? [String:Any],pinComment.keys.count > 0,let _ =  pinComment["comment"] as? FacebookComment{
            return true
        }
        return false
    }
    func hasCountCommentView() ->Bool{
        if let countComment = params[ConfigKey.countComment] as? [String:Any], countComment.keys.count > 0{
            return true
        }
        return false
    }
    func hasRandomView() ->Bool{
        if let random = params[ConfigKey.random] as? [String:Any], random.keys.count >= 2{
            return true
        }
        return false
    }
    func isCountdown() ->Bool{
        if let config = params[ConfigKey.countdown] as? [String:Any], let countdown = config["countdown"] as? String{
            let info = countdown.components(separatedBy: ":")
            let configHour = Int(info[0]) ?? 0
            let configMins = Int(info[1]) ?? 0
            
            let date = Date()
            let components = Calendar.current.dateComponents([.hour,.minute,.second], from: date)
            let hour = components.hour ?? 0
            let mins = components.minute ?? 0
            let seconds = components.second ?? 0
            let delHour = configHour - hour
            let delMins = configMins - mins
            let delSecs = 0 - seconds
            let totalSecs = delHour * 60 * 60 + delMins * 60 + delSecs
            if totalSecs > 0{
                return true
            }
        }
        return false
    }
    func isStopStream() -> Bool{
        if let config = params[ConfigKey.stopStream] as? [String:Any],config.keys.count > 0{
            return true
        }
        return false
    }
    func configStopStream(_ config:[String:Any]){
        params[ConfigKey.stopStream] = config
    }
    func resetConfig(){
        params = [:]
        randomView?.removeFromSuperview()
        randomView = nil
        
        countCommentView = nil
        countCommentView?.removeFromSuperview()
        countdownView = nil
        countdownView?.removeFromSuperview()
//        pinCommentView = nil
//        pinCommentView?.removeFromSuperview()

    }
}
