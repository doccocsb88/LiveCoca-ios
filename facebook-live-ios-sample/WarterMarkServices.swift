//
//  WarterMarkServices.swift
//  facebook-live-ios-sample
//
//  Created by Apple on 7/29/18.
//  Copyright © 2018 Hans Knoechel. All rights reserved.
//

import Foundation
import UIKit
class WarterMarkServices{
    static let sharedInstance : WarterMarkServices = {
        let instance = WarterMarkServices()
        return instance
    }()
    var frame:CGRect = CGRect(x: 0, y: 0, width: 0, height: 0 )
    var powerText:String?
    var hasPowerText:Bool = false
    var hasFrame:Bool = false
    
    init(){
        
    }
    class func shared() -> WarterMarkServices {
        return sharedInstance
    }
    func setFrame(frame:CGRect){
        self.frame = frame
    }
    func generateWarterMark() -> UIImage?{
        var background = UIImage(color: UIColor.clear, size: self.frame.size)
    
        background = addFrame(sourceImage: background!)
        return background
    }
    func addFrame(sourceImage:UIImage) -> UIImage?{
        let frame = UIImage(named: "ic_frame_default")
        
        return sourceImage.mergeImage(image: frame!,self.frame, at: self.frame)
        
    }
    
}
