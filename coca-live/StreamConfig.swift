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
    var waitImage:UIImage?
    var byeImage:UIImage?

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
    func setWaitImage(_ path:String){
        waitImagePath = path
        DispatchQueue.global().async { [weak self] in
            guard let strongSelf = self else {return}
            if let url = URL(string: String(format: "%@%@",K.ProductionServer.baseURL, path)){
                if let data = try? Data(contentsOf: url) {
                    if let image = UIImage(data: data) {
                        strongSelf.waitImage = image
                    }
                }
            }
        }
    }
    func setByeImage(_ path:String){
        byeImagePath = path
        DispatchQueue.global().async { [weak self] in
            guard let strongSelf = self else {return}
            if let url = URL(string: String(format: "%@%@",K.ProductionServer.baseURL, path)){
                if let data = try? Data(contentsOf: url) {
                    if let image = UIImage(data: data) {
                        strongSelf.byeImage = image
                    }
                }
            }
        }
    }
    func setFrameImage(_ path:String){
        DispatchQueue.global().async { [weak self] in
            guard let strongSelf = self else {return}
            if let url = URL(string: path){
                if let data = try? Data(contentsOf: url) {
                    if let image = UIImage(data: data) {
                        strongSelf.frameImage = image
                        WarterMarkServices.shared().configFrame(config: ["image":image])
                    }
                }
            }
        }
    }
    func setFrameImage(_ image:UIImage){
        frameImage = image

    }
}
