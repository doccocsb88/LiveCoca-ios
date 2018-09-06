//
//  CountCommentMaskView.swift
//  coca-live
//
//  Created by Macintosh HD on 8/28/18.
//  Copyright © 2018 Coca Live. All rights reserved.
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
    var count1Label:UILabel?
    var count2Label:UILabel?
    var count3Label:UILabel?
    var count4Label:UILabel?

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
            if let message = config[key] as? String{
                countLabel.text = "\(APIClient.shared().countComment(message:message))"
            }else{
                countLabel.text = "0"
            }
            countLabel.font = UIFont.systemFont(ofSize: 20 * scale)
            countLabel.textAlignment = .center
            view.addSubview(countLabel)
            
            //
            let titleLabel = UILabel(frame: CGRect(x: height + 5, y: 5 * scale, width: width - height - 10, height: 30 * scale))
            titleLabel.text = config[key] as? String
            titleLabel.textColor = .white
            titleLabel.font = UIFont.systemFont(ofSize: 15 * scale)
            view.addSubview(titleLabel)
            switch key{
            case "comment1":
                count1Label = countLabel
                break
            case "comment2":
                count2Label = countLabel
                break
            case "comment3":
                count3Label = countLabel
                break
            case "comment4":
                count4Label = countLabel
                break

            default:
                break
            }
            ///
            view.backgroundColor = UIColor.init(hexString: "#FC6076")
            view.addBorder(cornerRadius: height / 2, color: .clear)
            self.addSubview(view)
        }
        
    }
    func updateData(){
        guard let config = WarterMarkServices.shared().params[ConfigKey.countComment.rawValue] as? [String:Any] else{
            return
        }
        count1Label?.text = config["comment1"] as? String
        count2Label?.text = config["comment2"] as? String
        count3Label?.text = config["comment3"] as? String
        count4Label?.text = config["comment4"] as? String


    }

}
