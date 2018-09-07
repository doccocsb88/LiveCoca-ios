//
//  QuestionMaskView.swift
//  coca-live
//
//  Created by Apple on 8/4/18.
//  Copyright © 2018 Coca Live. All rights reserved.
//

import UIKit

class QuestionMaskView: UIView {

    var questionImageView: UIImageView?
    var questionLabel: UILabel?
    var answer1Label: UILabel?
    var answer2Label: UILabel?
    
    var answer4Label: UILabel?
    var answer3Label: UILabel?
    var scale:CGFloat = 1
    var config:[String:Any] = [:]
    init(frame:CGRect, scale:CGFloat, config:[String:Any]){
        super.init(frame: frame)
        self.scale = scale;
        self.config = config
        initView()
    }

    override init(frame:CGRect){
        super.init(frame: frame)
        initView()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    private func initView(){
        let marginBottom = 50 * scale
        let size = self.bounds.size
        let margin = 10 * scale
        let answerViewWidth = size.width / 2 - margin * 2
        let answerViewHeight = 30 * scale
        let backgroundColor = UIColor(hexString: "#EB6B79")
        var startY = size.height - (answerViewHeight * 2 + margin ) - marginBottom
        let view1 =  UIView(frame: CGRect(x: margin, y: startY, width: answerViewWidth, height: answerViewHeight))
        view1.backgroundColor = UIColor(hexString: "#EB6B79")
        view1.addBorder(cornerRadius: answerViewHeight / 2, color: .clear)
        self.addSubview(view1)
        //
        let view2 =  UIView(frame: CGRect(x:size.width / 2 +  margin, y: startY, width: answerViewWidth, height: answerViewHeight))
        view2.backgroundColor = UIColor(hexString: "#EB6B79")
        view2.addBorder(cornerRadius: answerViewHeight / 2, color: .clear)
        self.addSubview(view2)
        startY  = startY + margin + answerViewHeight
//
        let view3 =  UIView(frame: CGRect(x: margin, y: startY, width: answerViewWidth, height: answerViewHeight))
        view3.backgroundColor = UIColor(hexString: "#EB6B79")
        view3.addBorder(cornerRadius: answerViewHeight / 2, color: .clear)
        self.addSubview(view3)
        //
        let view4 =  UIView(frame: CGRect(x:size.width / 2 + margin, y: startY, width: answerViewWidth, height: answerViewHeight))
        view4.backgroundColor = UIColor(hexString: "#EB6B79")
        view4.addBorder(cornerRadius: answerViewHeight / 2, color: .clear)
        self.addSubview(view4)

        createView(number: 1, label: &answer1Label, view: view1)
        createView(number: 2, label: &answer2Label, view: view2)
        createView(number: 3, label: &answer3Label, view: view3)
        createView(number: 4, label: &answer4Label, view: view4)
        
        //
        let questionViewWidth = size.width - margin * 2
        let questionText = config["question"] as? String
        var height = questionText?.heightWithConstrainedWidth(width: questionViewWidth - margin * 2, font: UIFont.systemFont(ofSize: 20)) ?? 40 * scale
        height = height > 40 * scale ? height : 40 * scale
        startY = size.height - (answerViewHeight * 2 + margin) - (height + 10 * scale) - marginBottom
        
        questionLabel = UILabel(frame: CGRect(x: margin, y: 0, width: questionViewWidth - margin * 2, height: height))
        questionLabel?.text = questionText
        questionLabel?.numberOfLines = 0
        questionLabel?.textAlignment = .center
        questionLabel?.textColor = UIColor.white
        questionLabel?.font = UIFont.systemFont(ofSize: 20)
        let questionView  = UIView(frame: CGRect(x: margin, y: startY, width: questionViewWidth, height: height))
        
        questionView.backgroundColor = backgroundColor
        questionView.addBorder(cornerRadius: height / 2, color: .clear)
        questionView.addSubview(questionLabel!)
        self.addSubview(questionView)
        //
        
        let imageHeight = answerViewWidth * 9 / 16
        startY = startY - imageHeight - 10 * scale
        questionImageView = UIImageView(frame: CGRect(x: margin, y: startY, width: questionViewWidth, height: imageHeight))
        questionImageView?.contentMode = .scaleAspectFit
        self.addSubview(questionImageView!)

    }
    func createView( number:Int,label:inout UILabel?, view:UIView){
        let size = view.bounds.height
        label = UILabel(frame: CGRect(x: size, y: 0, width: view.bounds.width - size, height: size))
        label?.textAlignment = .left
        label?.textColor = .white
        label?.font = UIFont.systemFont(ofSize: 20)
        view.addSubview(label!)
        //
        let numberLabel = UILabel(frame: CGRect(x: 2, y: 2, width: size - 4, height: size - 4))
        numberLabel.backgroundColor = .white
        numberLabel.textColor = UIColor.black
        numberLabel.addBorder(cornerRadius: (size - 4) / 2, color: .clear)
        numberLabel.text = "\(number)"
        numberLabel.textAlignment = .center
        numberLabel.font = UIFont.systemFont(ofSize: 25)
        view.addSubview(numberLabel)
    }
    func bindData(config:[String:Any]){
        questionLabel?.text = config["question"] as? String
        answer1Label?.text =  config["answer1"] as? String
        answer2Label?.text =  config["answer2"] as? String
        answer3Label?.text =  config["answer3"] as? String
        answer4Label?.text =  config["answer4"] as? String
        if let image = config["image"] as? UIImage{
            questionImageView?.image = image
        }
        self .updateConstraintsIfNeeded()
    }
}
