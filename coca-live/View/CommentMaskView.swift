//
//  CommentMaskView.swift
//  coca-live
//
//  Created by Macintosh HD on 8/22/18.
//  Copyright © 2018 Coca Live. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher
class CommentMaskView: UIView {
    var avatarImageView:UIImageView?
    var displayLabel:UILabel?
    var contentLabel:UILabel?
    var createDateLabel:UILabel?
    var closeButton:UIButton?
    var scale:CGFloat = 1
    var tappedCloseHandle:()->() = {}
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
    }
    
    func initView(){
        let size = self.bounds.size
        
        let config = WarterMarkServices.shared().params["pin"] as? [String:Any];
        var fontSize:CGFloat =  20
        if let _font  = config?["font"] as? CGFloat{
            fontSize = _font
        }
        let font = UIFont.systemFont(ofSize: fontSize)
        guard let comment = config?["comment"] as? FacebookComment else {return}
        //
        let topMargin = 5 * scale
        let avatarSize  = 40 * scale
        avatarImageView = UIImageView(frame: CGRect(x: 5 * scale, y: topMargin, width: avatarSize, height: avatarSize))
        avatarImageView?.addBorder(cornerRadius: avatarSize / 2 , color: UIColor.lightGray)
        avatarImageView?.backgroundColor = UIColor.white

        self.addSubview(avatarImageView!)
        
        displayLabel = UILabel(frame: CGRect(x: 50 * scale, y: topMargin, width: size.width / 2, height: 20 * scale))
        displayLabel?.text = comment.fromName
        displayLabel?.textColor = UIColor.black
        displayLabel?.font = font
        self.addSubview(displayLabel!)
        
        let createDateWidth = 60 * scale
        createDateLabel = UILabel(frame: CGRect(x: self.frame.width - createDateWidth - 10 * scale, y: topMargin, width: createDateWidth, height:    20 * scale))
        let date = Date(milliseconds: comment.createdTime)
        createDateLabel?.text = date.converToString()
        createDateLabel?.textColor = UIColor.black
        createDateLabel?.font = font
        createDateLabel?.textAlignment = .right
        
        self.addSubview(createDateLabel!)
        
        //
        var contentHeight = comment.message.heightWithConstrainedWidth(width: self.frame.width - 60 * scale, font: UIFont.systemFont(ofSize: fontSize * scale))
//        if contentHeight < 25 * scale{
//            contentHeight = 25 * scale
//        }else if contentHeight > 50 * scale{
//            contentHeight = 50 * scale
//        }

//        let messageLabelHeight = size.height - 20 * scale
        contentLabel = UILabel(frame: CGRect(x: 50 * scale, y: 22 * scale, width: self.frame.width - 60 * scale, height: contentHeight))
        contentLabel?.text = comment.message
        contentLabel?.textColor = UIColor.black
        contentLabel?.font = UIFont.systemFont(ofSize: fontSize * scale)
        contentLabel?.numberOfLines = 0
        self.addSubview(contentLabel!)
        
        /**/
        closeButton = UIButton(frame: CGRect(x: size.width - 30 * scale, y: 0, width: 30 * scale, height: 30 * scale))
        closeButton?.setImage(UIImage(named: "ic_close"), for: .normal)
        closeButton?.imageView?.contentMode = .scaleAspectFit
        closeButton?.imageEdgeInsets = UIEdgeInsets(top: 8, left:8, bottom: 8, right: 8)
        closeButton?.addTarget(self, action: #selector(tappedCloseButton(_:)), for: .touchUpInside)
        closeButton?.backgroundColor = UIColor(hexString: "#EB6B79")
        closeButton?.isHidden = true
        closeButton?.addBorder(cornerRadius: 15 * scale, color: .clear)
        
        self.addSubview(closeButton!)
        self.backgroundColor = UIColor.white
        self.addBorder(cornerRadius: 5 * scale, color: UIColor.clear)
    }
    func updateContent(){
        if let config = WarterMarkServices.shared().params["pin"] as? [String:Any]{
//            var fontSize:CGFloat =  20
//            if let _font  = config["font"] as? CGFloat{
//                fontSize = _font
//            }
//            let font = UIFont.systemFont(ofSize: fontSize)
            guard let comment = config["comment"] as? FacebookComment else{return}
            contentLabel?.text = comment.message
            createDateLabel?.text = comment.getTimerText()
            displayLabel?.text = comment.fromName
            let facebookProfileUrl = "http://graph.facebook.com/\(comment.fromId)/picture?type=large"
            let url = URL(string: comment.thumbnail ?? facebookProfileUrl)


            avatarImageView?.kf.setImage(with: url,
                                             placeholder: nil,
                                             options: [.transition(ImageTransition.fade(1))],
                                             progressBlock: { receivedSize, totalSize in
//                                                print("\(indexPath.row + 1): \(receivedSize)/\(totalSize)")
            },
                                             completionHandler: { image, error, cacheType, imageURL in
                                                if let error  =  error{
//                                                    print("\(indexPath.row + 1): \(error.description)")
                                                }else{
//                                                    print("\(indexPath.row + 1): Finished")
    
                                                }
            })

            
        }
    }
    func showCloseButton(){
        closeButton?.isHidden = false
    }
    func hideCloseButton(){
        closeButton?.isHidden = true
    }
    @objc func tappedCloseButton(_ button:UIButton){
        tappedCloseHandle()
    }
}
