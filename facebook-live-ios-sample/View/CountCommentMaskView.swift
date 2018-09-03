//
//  CountCommentMaskView.swift
//  facebook-live-ios-sample
//
//  Created by Macintosh HD on 8/28/18.
//  Copyright © 2018 Hans Knoechel. All rights reserved.
//

import UIKit

class CountCommentMaskView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    var scale:CGFloat = 1
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    init(frame: CGRect, scale:CGFloat) {
        super.init(frame: frame)
        self.scale = scale
        initView()
    }

    private func initView(){
        guard let config = WarterMarkServices.shared().params[ConfigKey.countComment.rawValue] as? [String:Any] else{
            return
        }
        
        let count = config.keys.count
        let width = self.frame.size.width - 20 * scale
        let height = 40 * scale
        let thumbHeight = 35 * scale
        let margin = 10 * scale
        var top = self.frame.size.height
        for i in 0..<count{
            let index = i + 1
            let key = Array(config.keys)[i]
            top = top - height - margin
            let view = UIView(frame: CGRect(x: margin, y: top, width: width, height: height))
            let countLabel = UILabel(frame: CGRect(x:(height - thumbHeight) / 2, y: (height - thumbHeight) / 2, width: thumbHeight, height: thumbHeight))
            countLabel.addBorder(cornerRadius: thumbHeight / 2, color: .clear)
            countLabel.backgroundColor = .white
            countLabel.contentMode = .scaleAspectFit
            countLabel.text = "9"
            countLabel.font = UIFont.systemFont(ofSize: 20 * scale)
            countLabel.textAlignment = .center
            view.addSubview(countLabel)
            
            //
            let titleLabel = UILabel(frame: CGRect(x: height + 5, y: 5 * scale, width: width - height - 10, height: 30 * scale))
            titleLabel.text = config[key] as? String
            titleLabel.textColor = .white
            titleLabel.font = UIFont.systemFont(ofSize: 15 * scale)
            view.addSubview(titleLabel)
    
            ///
            view.backgroundColor = UIColor.init(hexString: "#FC6076")
            view.addBorder(cornerRadius: height / 2, color: .clear)
            self.addSubview(view)
        }
        
    }

}
