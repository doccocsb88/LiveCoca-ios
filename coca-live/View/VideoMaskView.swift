//
//  VideoMaskView.swift
//  coca-live
//
//  Created by Apple on 8/5/18.
//  Copyright © 2018 Coca Live. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import MediaPlayer

class VideoMaskView: UIView {
    var childImageView:UIImageView?
    var scale:CGFloat = 1
    init(frame: CGRect, scale:CGFloat) {
        super.init(frame: frame)
        self.scale = scale
        initView()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()

    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initView()

    }

    
    func initView(){
        var childWidth = self.frame.width / 3
        var childHeight = childWidth * 4 / 3
        guard let  config = WarterMarkServices.shared().params[ConfigKey.childImage] as?  [String:Any] , let image  = config["image"] as? UIImage else{return}
        if image.size.width > image.size.height{
            childWidth = self.frame.width / 2
        }else{
            childWidth = self.frame.width / 3

        }
        childHeight = childWidth / image.size.width * image.size.height

        let position = config["position"] as? Int ?? 0
        var row = 0
        var col = 0
        switch position {
        case 0:
            row = 0
            col = 0
            break
        case 1:
            row = 1
            col = 0
            break
        case 2:
            row = 1
            col = 1
            break
        case 3:
            row = 0
            col = 1
            break
        default:
            break
        }
        let left = row == 0 ? 0 : self.frame.width - childWidth
        let top = col == 0 ? 0 : self.frame.height - childHeight - 5 * scale
        childImageView = UIImageView(frame: CGRect(x: left, y: top, width: childWidth, height: childHeight))
        childImageView?.contentMode = .scaleAspectFit
        childImageView?.image = image
        childImageView?.backgroundColor = .red
        self.addSubview(childImageView!)
        
    }

}
