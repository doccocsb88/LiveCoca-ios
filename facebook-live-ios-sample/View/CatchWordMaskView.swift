//
//  CatchWordMaskView.swift
//  facebook-live-ios-sample
//
//  Created by Apple on 8/5/18.
//  Copyright © 2018 Hans Knoechel. All rights reserved.
//

import UIKit

class CatchWordMaskView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    var questionImageView:UIImageView?
    var questionLabel:UILabel?
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func initView(){
        let config = WarterMarkServices.shared().params["catchword"] as? [String:Any];
        questionImageView = UIImageView(frame: CGRect(x: 10, y: self.frame.size.height / 5, width: self.frame.size.width - 10, height: (CGFloat)(self.frame.size.height * 4 / 5)))
        questionImageView?.contentMode = .scaleAspectFit
        questionImageView?.image = config?["image"] as? UIImage
        questionImageView?.backgroundColor = UIColor.lightGray
        self.addSubview(questionImageView!)
        
        //
        let height  = self.frame.size.height / 5
        questionLabel = UILabel(frame: CGRect(x: 10, y: 0, width: self.frame.size.width - 20, height: height))
        questionLabel?.text = config?["question"] as? String
        questionLabel?.backgroundColor = UIColor.white
        questionLabel?.addBorder(cornerRadius: height / 2 , color: .clear)
        self.addSubview(questionLabel!)
        
    }
}
