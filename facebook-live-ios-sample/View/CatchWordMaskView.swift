//
//  CatchWordMaskView.swift
//  coca-live
//
//  Created by Apple on 8/5/18.
//  Copyright © 2018 Coca Live. All rights reserved.
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
        let backgroundColor = UIColor(hexString: "#EB6B79")
        let font = UIFont.systemFont(ofSize: 25)
        let margin = 10 * scale
        let width = self.bounds.width - margin  * 2
        let imageHeight = width * 9 / 16
        var startY = self.bounds.height  - imageHeight
        let config = WarterMarkServices.shared().params["catchword"] as? [String:Any];
        questionImageView = UIImageView(frame: CGRect(x: margin, y: startY, width: width, height: imageHeight))
        questionImageView?.contentMode = .scaleAspectFit
        questionImageView?.image = config?["image"] as? UIImage
//        questionImageView?.backgroundColor = UIColor.lightGray
        self.addSubview(questionImageView!)
        
        //
        let questionText = config?["question"] as? String
        var questionViewHeight = questionText?.heightWithConstrainedWidth(width: width - margin * 2, font: font) ?? 40 * scale
        questionViewHeight = questionViewHeight > 40 * scale ? questionViewHeight : 40 * scale
        startY = startY - 10 * scale - questionViewHeight
        
        let questionView = UIView(frame: CGRect(x: margin, y: startY, width: width, height: questionViewHeight))
        questionView.backgroundColor = backgroundColor
        questionView.addBorder(cornerRadius: questionViewHeight / 2, color: .clear)
        
        questionLabel = UILabel(frame: CGRect(x: margin, y: 0, width: width - margin * 2, height: questionViewHeight))
        questionLabel?.text = config?["question"] as? String
        questionLabel?.textColor = .white
        questionLabel?.font = font
        questionView.addSubview(questionLabel!)
        self.addSubview(questionView)
        
    }
}
