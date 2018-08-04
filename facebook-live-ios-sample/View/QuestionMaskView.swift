//
//  QuestionMaskView.swift
//  facebook-live-ios-sample
//
//  Created by Apple on 8/4/18.
//  Copyright © 2018 Hans Knoechel. All rights reserved.
//

import UIKit

class QuestionMaskView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    var questionTextfield:UITextField?
    var answer1Textfield:UITextField?
    var answer2Textfield:UITextField?
    var answer3Textfield:UITextField?
    var answer4Textfield:UITextField?

    override init(frame:CGRect){
        super.init(frame: frame)
        initView()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func initView(){
        let size = self.frame.size
        let textfieldWidth = size.width - 10
        let textfieldHeight:CGFloat = 30
        let margin = (size.width - textfieldWidth ) / 2
        var topmargin = self.frame.size.height - 35
        answer4Textfield = UITextField(frame: CGRect(x: margin, y: topmargin, width: textfieldWidth, height: textfieldHeight))
        answer4Textfield?.addBorder(cornerRadius: 15, color: UIColor.clear)
        answer4Textfield?.backgroundColor = UIColor.red
        
        topmargin = topmargin - 35
        answer3Textfield = UITextField(frame: CGRect(x: margin, y: topmargin, width: textfieldWidth, height: textfieldHeight))
        answer3Textfield?.addBorder(cornerRadius: 15, color: UIColor.clear)
        answer3Textfield?.backgroundColor = UIColor.red
        
        //
        topmargin = topmargin - 35
        answer2Textfield = UITextField(frame: CGRect(x: margin, y: topmargin, width: textfieldWidth, height: textfieldHeight))
        answer2Textfield?.addBorder(cornerRadius: 15, color: UIColor.clear)
        answer2Textfield?.backgroundColor = UIColor.red
        //
        topmargin = topmargin - 35
        answer1Textfield = UITextField(frame: CGRect(x: margin, y: topmargin, width: textfieldWidth, height: textfieldHeight))
        answer1Textfield?.addBorder(cornerRadius: 15, color: UIColor.clear)
        answer1Textfield?.backgroundColor = UIColor.red
        //
        topmargin = topmargin - 55
        
        questionTextfield = UITextField(frame: CGRect(x: margin, y: topmargin, width: textfieldWidth, height: 50))
        questionTextfield?.addBorder(cornerRadius: 25, color: UIColor.clear)
        questionTextfield?.backgroundColor = UIColor.red
        
        
        self.addSubview(questionTextfield!)
        self.addSubview(answer1Textfield!)
        self.addSubview(answer2Textfield!)
        self.addSubview(answer3Textfield!)
        self.addSubview(answer4Textfield!)
        self.backgroundColor = UIColor.clear

    }
    
    func bindData(config:[String:Any]){
        questionTextfield?.text = config["question"] as? String
        answer1Textfield?.text =  config["answer1"] as? String
        answer2Textfield?.text =  config["answer2"] as? String
        answer3Textfield?.text =  config["answer3"] as? String
        answer4Textfield?.text =  config["answer4"] as? String

    }
}
