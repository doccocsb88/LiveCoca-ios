//
//  CommentMaskView.swift
//  facebook-live-ios-sample
//
//  Created by Macintosh HD on 8/22/18.
//  Copyright © 2018 Hans Knoechel. All rights reserved.
//

import Foundation
import UIKit

class CommentMaskView: UIView {
    var avatarImageView:UIImageView?
    var displayLabel:UILabel?
    var contentLabel:UILabel?
    var createDateLabel:UILabel?
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
    }
    
    func initView(){
        let size = self.bounds.size
        
        let config = WarterMarkServices.shared().params["pin"] as? [String:Any];
        let font = config?["font"] as? Int
        let comment = config?["comment"] as? FacebookComment
        
        //
        avatarImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40 * scale, height: 40 * scale))
        avatarImageView?.addBorder(cornerRadius: 20, color: UIColor.lightGray)
        avatarImageView?.backgroundColor = UIColor.white
        self.addSubview(avatarImageView!)
        
        displayLabel = UILabel(frame: CGRect(x: 50 * scale, y: 0, width: 200, height: 20 * scale))
        displayLabel?.text = comment?.fromName
        displayLabel?.textColor = UIColor.black
        self.addSubview(displayLabel!)
        
        createDateLabel = UILabel(frame: CGRect(x: size.width - 100, y: 0, width: 90 * scale, height:    20 * scale))
        createDateLabel?.text = comment?.createdTime
        createDateLabel?.textColor = UIColor.black
        self.addSubview(createDateLabel!)
        
        //
        contentLabel = UILabel(frame: CGRect(x: 50 * scale, y: 25 * scale, width: size.width - 60, height: 50 * scale))
        contentLabel?.text = comment?.message
        contentLabel?.textColor = UIColor.black
        self.addSubview(contentLabel!)
        self.backgroundColor = UIColor.white
        self.addBorder(cornerRadius: 5, color: UIColor.clear)
    }
}
