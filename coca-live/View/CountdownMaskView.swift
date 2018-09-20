//
//  CountdownMaskView.swift
//  coca-live
//
//  Created by Macintosh HD on 8/31/18.
//  Copyright © 2018 Coca Live. All rights reserved.
//

import UIKit

class CountdownMaskView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    var backgroundImageView:UIImageView?
    var scale:CGFloat = 1
    
    var hourView:UIView?
    var minsView:UIView?
    var secsView:UIView?
    var hourLabel:UILabel?
    var minsLabel:UILabel?
    var secsLabel:UILabel?

    var separate1View:UILabel?
    var separate2View:UILabel?
    var configHour:Int = 0
    var configMins:Int = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    init(frame: CGRect,scale:CGFloat) {
        super.init(frame: frame)
        self.scale = scale
        initView()
    }
    
    func initView(){
        var image = UIImage(named: "bg_countdown")
        if let config = WarterMarkServices.shared().params[ConfigKey.countdown] as? [String:Any]{
            if let countdown = config["countdown"] as? String{
                let info = countdown.components(separatedBy: ":")
                configHour = Int(info[0]) ?? 0
                configMins = Int(info[1]) ?? 0
            }
            if let _image = config["image"] as? UIImage{
                image = _image
            }
        }
        
        let date = Date()
        let components = Calendar.current.dateComponents([.hour,.minute,.second], from: date)
        let hour = components.hour ?? 0
        let mins = components.minute ?? 0
        let seconds = components.second ?? 0
        let delHour = configHour - hour
        let delMins = configMins - mins
        let delSecs = 0 - seconds
        let totalSecs = delHour * 60 * 60 + delMins * 60 + delSecs
        
        backgroundImageView = UIImageView(frame: self.bounds)
        backgroundImageView?.image = image
        backgroundImageView?.contentMode = .scaleToFill
        self.addSubview(backgroundImageView!)
        //
        
        
        let width = 50 * scale
        let height = 30 * scale
        let margin = 10 * scale
        var left = 10 * scale
        
        let top = self.bounds.height - 10 * scale - height
        
        hourView = UIView(frame: CGRect(x: left, y: top, width: width, height: height))
        hourView?.backgroundColor = .white
        hourView?.addBorder(cornerRadius: 4, color: .clear)
        self.addSubview(hourView!)
        hourLabel = UILabel(frame: hourView!.bounds)
        hourLabel?.textAlignment = .center
        hourLabel?.textColor = .black
        hourLabel?.text = String(format: "%d", totalSecs / (60 * 60))
        hourView?.addSubview(hourLabel!)
        //
        left = left + width
        separate1View = UILabel(frame: CGRect(x: left, y: top, width: margin, height: height))
        separate1View?.text = ":"
        separate1View?.textAlignment = .center
        separate1View?.textColor = .black
        self.addSubview(separate1View!)
        
        //
        left = left + margin
        minsView = UIView(frame: CGRect(x: left, y: top, width: width, height: height))
        minsView?.backgroundColor = .white
        minsView?.addBorder(cornerRadius: 4, color: .clear)
        self.addSubview(minsView!)
        minsLabel = UILabel(frame: minsView!.bounds)
        minsLabel?.textAlignment = .center
        minsLabel?.textColor = .black
        minsLabel?.text = String(format: "%d", (totalSecs / 60) % 60)
        
        minsView?.addSubview(minsLabel!)

        //
        left = left + width
        separate2View = UILabel(frame: CGRect(x: left, y: top, width: margin, height: height))
        separate2View?.text = ":"
        separate2View?.textAlignment = .center
        separate2View?.textColor = .black
        self.addSubview(separate2View!)

        //
        left = left + margin
        secsView = UIView(frame: CGRect(x: left, y: top, width: width, height: height))
        secsView?.backgroundColor = .white
        secsView?.addBorder(cornerRadius: 4, color: .clear)
        self.addSubview(secsView!)
        secsLabel = UILabel(frame: secsView!.bounds)
        secsLabel?.textAlignment = .center
        secsLabel?.textColor = .black
        secsLabel?.text = String(format: "%d", totalSecs % 60)
        secsView?.addSubview(secsLabel!)
        
    }
    func updateView(){
        if let config = WarterMarkServices.shared().params[ConfigKey.countdown] as? [String:Any]{
            if let countdown = config["countdown"] as? String{
                let info = countdown.components(separatedBy: ":")
                configHour = Int(info[0]) ?? 0
                configMins = Int(info[1]) ?? 0
            }
        }
        
        let date = Date()
        let components = Calendar.current.dateComponents([.hour,.minute,.second], from: date)
        let hour = components.hour ?? 0
        let mins = components.minute ?? 0
        let seconds = components.second ?? 0
        let delHour = configHour - hour
        let delMins = configMins - mins
        let delSecs = 0 - seconds
        let totalSecs = delHour * 60 * 60 + delMins * 60 + delSecs
        hourLabel?.text = String(format: "%@", Int.converToNumberString(totalSecs / (60 * 60)))
        minsLabel?.text = String(format: "%@", Int.converToNumberString((totalSecs / 60) % 60))
        secsLabel?.text = String(format: "%@", Int.converToNumberString(totalSecs % 60))

    }

}
