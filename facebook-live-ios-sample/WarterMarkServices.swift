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
    var randomView:RandomMaskView?
    var countCommentView:CountCommentMaskView?
    var countdownView:CountdownMaskView?
    var pinCommentView:CommentMaskView?
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
        let bottomMargin = 50 * scale

        backgroundImage = UIImage(color: UIColor.clear, size: self.frame.size)
        backgroundImage = backgroundImage.resizeImage(self.frame.size)
        if let countdown = params[ConfigKey.countdown.rawValue] as? [String:Any], let _ = countdown["countdown"] as? String{
            if countdownView == nil{
                countdownView = CountdownMaskView(frame: self.frame, scale: scale)
            }else{
                countdownView?.removeFromSuperview()
            }
            countdownView?.updateView()
            watermarkView.addSubview(countdownView!)

            return watermarkView
        }else{
            if let _  = countdownView{
                countdownView!.removeFromSuperview()
                countdownView = nil
            }
        }
        if let frame = params["frame"] as? Bool , frame == true{
            backgroundImage =  addFrame(sourceImage: backgroundImage)
            
        }

        if let slogan = params["slogan"] as? [String:Any]{
            if let sloganView = handleSlogan(slogan: slogan){
                watermarkView.addSubview(sloganView)
            }
        }
        if let questionConfig = params["question"] as? [String:Any], questionConfig.keys.count > 0{
            let questionView: QuestionMaskView = QuestionMaskView()
            
            questionView.frame = self.frame
            questionView.bindData(config: questionConfig)
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
        if let pinComment = params["pin"] as? [String:Any],pinComment.keys.count > 0,let comment =  pinComment["comment"] as? FacebookComment{
            
            let font = pinComment["font"] as? CGFloat
            let labelHeight = comment.message .heightWithConstrainedWidth(width: self.frame.size.width - 60, font: UIFont.systemFont(ofSize: font ?? 20))
                
            let height:CGFloat = (30 + labelHeight ) * scale
            let width = self.frame.size.width
            let top = self.frame.size.height - height - 50 * scale
            
            let frame =  CGRect(x: 0, y: top , width: width, height: height)
            if pinCommentView == nil{
                pinCommentView = CommentMaskView(frame:frame,scale: scale)
            }
            pinCommentView?.updateContent()
            pinCommentView?.frame = frame
            watermarkView.addSubview(pinCommentView!)
        }
        if let filterComment = params[ConfigKey.filterComment.rawValue] as? [String:Any], filterComment.keys.count > 0{
            let height = 30 * 6 * scale;
            let filterCommentView = FilterCommentMaskView(frame: CGRect(x: 0, y: self.frame.size.height / 10, width: self.frame.size.width, height: height), scale: scale)
            filterCommentView.updateContent()
            watermarkView.addSubview(filterCommentView)
        }
        if let random = params[ConfigKey.random.rawValue] as? [String:Any], random.keys.count >= 2{
            if  let view = randomView{
                print("randomView : \(view.number1Label?.text ?? "ahahaha")")
                view.removeFromSuperview()
                
            }
            let width = self.frame.size.width / 2
            let height =  (width / 1008 ) * (696 + 30 + 165)
            let left = (self.frame.size.width - width) / 2
            let top = (self.frame.size.height - height ) / 2
            let frame = CGRect(x: left, y: top, width: width, height: height)
            randomView?.frame = frame
            watermarkView.addSubview(randomView!)

            
        }
        
        if let countComment = params[ConfigKey.countComment.rawValue] as? [String:Any], countComment.keys.count > 0{
            let frame = CGRect(x: 0, y: self.frame.height / 2 - 50 * scale, width: self.frame.width, height: self.frame.height / 2)
            countCommentView =  CountCommentMaskView(frame: frame, scale: self.scale)
            countCommentView?.backgroundColor = .clear
            //                countCommentView?.transform = CGAffineTransform(scaleX: scale, y: scale)
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
        params[ConfigKey.filterComment.rawValue] = config
    }
    func configRandom(_ config:[String:Any]){
        params[ConfigKey.random.rawValue] = config
        
    }
    func configCountComment(_ config:[String:Any]){
        params[ConfigKey.countComment.rawValue] = config

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
        params[ConfigKey.countdown.rawValue] = config
    }
    
    func hasFilterCommentView() -> Bool{
        if let filterComment = params[ConfigKey.filterComment.rawValue] as? [String:Any], filterComment.keys.count > 0{
            return true
        }
        return false
    }
}
