//
//  QuestionMaskView.swift
//  facebook-live-ios-sample
//
//  Created by Apple on 8/4/18.
//  Copyright © 2018 Hans Knoechel. All rights reserved.
//

import UIKit

class QuestionMaskView: UIView {

    @IBOutlet weak var questionImageView: UIImageView!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var answer1Label: UILabel!
    @IBOutlet weak var answer2Label: UILabel!
    
    @IBOutlet weak var answer4Label: UILabel!
    @IBOutlet weak var answer3Label: UILabel!
    //var scale:CGFloat = 1

    override init(frame:CGRect){
        super.init(frame: frame)
        initView()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let xibView = Bundle.main.loadNibNamed("QuestionMaskView", owner: self, options: nil)!.first as! UIView
        xibView.frame = self.bounds
        xibView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(xibView)
    }
    private func initView(){
        let xibView = Bundle.main.loadNibNamed("QuestionMaskView", owner: self, options: nil)!.first as! UIView
        xibView.frame = self.bounds
        xibView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(xibView)
        answer1Label.addBorder(cornerRadius: 25, color: .clear)
        answer2Label.addBorder(cornerRadius: 25, color: .clear)
        answer3Label.addBorder(cornerRadius: 25, color: .clear)
        answer4Label.addBorder(cornerRadius: 25, color: .clear)

    }
    func bindData(config:[String:Any]){
        questionLabel.text = config["question"] as? String
        answer1Label.text =  config["answer1"] as? String
        answer1Label.text =  config["answer2"] as? String
        answer1Label.text =  config["answer3"] as? String
        answer1Label.text =  config["answer4"] as? String
        if let image = config["image"] as? UIImage{
            questionImageView.image = image
        }
        self .updateConstraintsIfNeeded()
    }
}
