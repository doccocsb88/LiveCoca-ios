//
//  CatchWordViewCell.swift
//  facebook-live-ios-sample
//
//  Created by Apple on 7/29/18.
//  Copyright © 2018 Hans Knoechel. All rights reserved.
//

import UIKit

class CatchWordViewCell: UITableViewCell {


    @IBOutlet weak var frameImageView: UIImageView!
    
    @IBOutlet weak var addFrameButton: UIButton!
    
    @IBOutlet weak var questionImageView: UIImageView!
    
    @IBOutlet weak var addQuestionImageView: UIButton!
    @IBOutlet weak var questionTextField: UITextField!
    @IBOutlet weak var answerTextField: UITextField!
    @IBOutlet weak var startButton: UIButton!
    var config:[String:Any] = [:]
    var frameImage:UIImage?
    var questionImage:UIImage?
    var completeHandle:(Int) ->() = {type  in }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setup()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setup(){
        startButton.addBorder(cornerRadius: 15, color: UIColor.clear)
        questionTextField.addBorder(cornerRadius: 4, color: UIColor.lightGray)
        answerTextField.addBorder(cornerRadius: 4, color: UIColor.lightGray)
        //
        frameImageView.image = frameImage
        questionImageView.image = questionImage
    }
    @IBAction func tappedStartButton(_ sender: Any) {
        if let frame = frameImage{
            config["frame"] = frame
        }
        guard let image = questionImage else{
            return
        }
        guard let question = questionTextField.text else{
            return
        }
        guard let answer = questionTextField.text else{
            return
        }
        config["image"] = image
        config["question"] = question
        config["answer"] = answer
        WarterMarkServices.shared().configCatchWord(config: config)
        completeHandle(0)
    }
    @IBAction func tappedAddFrameButton(_ sender: Any) {
        completeHandle(1)
    }
    
    @IBAction func tappedQuestionImageButton(_ sender: Any) {
        completeHandle(2)

    }
}
