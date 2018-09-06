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
        var font:CGFloat =  20
        if let _font  = config?["font"] as? CGFloat{
            font = _font
        }
        
        let comment = config?["comment"] as? FacebookComment
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: size.width - 30 * scale, height: size.height))
        containerView.backgroundColor = .white
        containerView.addBorder(cornerRadius: 5, color: .clear)
        self.addSubview(containerView)
        //
        let topMargin = 5 * scale
        let avatarSize  = 40 * scale
        avatarImageView = UIImageView(frame: CGRect(x: 0, y: topMargin, width: avatarSize, height: avatarSize))
        avatarImageView?.addBorder(cornerRadius: avatarSize / 2 , color: UIColor.lightGray)
        avatarImageView?.backgroundColor = UIColor.white

        containerView.addSubview(avatarImageView!)
        
        displayLabel = UILabel(frame: CGRect(x: 50 * scale, y: topMargin, width: size.width / 2, height: 20 * scale))
        displayLabel?.text = comment?.fromName
        displayLabel?.textColor = UIColor.black
        displayLabel?.font = UIFont.systemFont(ofSize: 13 * scale)
        containerView.addSubview(displayLabel!)
        
        let createDateWidth = 100 * scale
        createDateLabel = UILabel(frame: CGRect(x: containerView.frame.width - createDateWidth, y: topMargin, width: createDateWidth, height:    20 * scale))
        createDateLabel?.text = comment?.createdTime
        createDateLabel?.textColor = UIColor.black
        createDateLabel?.font = UIFont.systemFont(ofSize: 13 * scale)
        createDateLabel?.textAlignment = .right
        containerView.addSubview(createDateLabel!)
        
        //
        let messageLabelHeight = size.height - 30
        contentLabel = UILabel(frame: CGRect(x: 50 * scale, y: 30 * scale, width: containerView.frame.width - 60 * scale, height: messageLabelHeight * scale))
        contentLabel?.text = comment?.message
        contentLabel?.textColor = UIColor.black
        contentLabel?.font = UIFont.systemFont(ofSize: font)
        containerView.addSubview(contentLabel!)
        
        /**/
        closeButton = UIButton(frame: CGRect(x: size.width - 30 * scale, y: 0, width: 30 * scale, height: 30 * scale))
        closeButton?.setImage(UIImage(named: "ic_close"), for: .normal)
        closeButton?.imageView?.contentMode = .scaleAspectFit
        closeButton?.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        closeButton?.addTarget(self, action: #selector(tappedCloseButton(_:)), for: .touchUpInside)
        closeButton?.addBorder(cornerRadius: 15 * scale, color: .clear)
        closeButton?.backgroundColor = UIColor(hexString: "#EB6B79")
        closeButton?.isHidden = true
        self.addSubview(closeButton!)
        self.backgroundColor = UIColor.clear
//        self.addBorder(cornerRadius: 5, color: UIColor.clear)
    }
    func updateContent(){
        if let config = WarterMarkServices.shared().params["pin"] as? [String:Any]{
            var font:CGFloat = 20
            if let _font = config["font"] as? CGFloat{
                font = _font
            }
            let comment = config["comment"] as? FacebookComment
            contentLabel?.font = UIFont.systemFont(ofSize: font)
            contentLabel?.text = comment?.message
            createDateLabel?.text = comment?.getTimerText()
            displayLabel?.text = comment?.fromName
            let url = URL(string: "http://graph.facebook.com/\(comment?.fromId)/picture?type=square&access_token=\(FacebookServices.shared().curPage?.tokenString ?? "")")
    
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
