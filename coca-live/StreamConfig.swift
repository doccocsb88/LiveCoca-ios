//
//  StreamConfig.swift
//  coca-live
//
//  Created by Hai Vu on 9/20/18.
//  Copyright © 2018 Coca Live. All rights reserved.
//

import Foundation
import UIKit
class StreamConfig {
    var waitImagePath:String?
    var byeImagePath:String?
    var frameImage:UIImage?
    var listFrame:[StreamFrame] = []
    static let sharedInstance : StreamConfig = {
        let instance = StreamConfig()
        return instance
    }()
    init(){
        
    }
    class func shared() -> StreamConfig {
        return sharedInstance
    }
    
    func setFrameImage(_ path:String){
        let url = URL(string: path)
        let data = try? Data(contentsOf: url!)
        
        frameImage = UIImage(data: data!)
    }
}
