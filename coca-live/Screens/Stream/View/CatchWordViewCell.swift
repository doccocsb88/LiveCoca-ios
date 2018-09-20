//
//  CatchWordViewCell.swift
//  coca-live
//
//  Created by Apple on 7/29/18.
//  Copyright © 2018 Coca Live. All rights reserved.
//

import UIKit

class CatchWordViewCell: UITableViewCell {


    @IBOutlet weak var frameImageView: UIImageView!
    
    @IBOutlet weak var addFrameButton: UIButton!
    
    @IBOutlet weak var questionImageView: UIImageView!
    
    @IBOutlet weak var addQuestionImageView: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var questionTextField: UITextField!
    @IBOutlet weak var answerTextField: UITextField!
    @IBOutlet weak var startButton: UIButton!
    var config:[String:Any] = [:]
    var frameImage:UIImage?
    var questionImage:UIImage?
    var completeHandle:(Int) ->() = {type  in }
    var gameState:Int = 0
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
        errorLabel.text = nil
       
    }
    func updateImages(frame:UIImage?, questionImage:UIImage?){
        self.frameImage = frame
        self.questionImage = questionImage
        if let frame = frameImage{
            config["frame"] = frame
        }
        if let questionImage = self.questionImage{
            config["questionImage"] = questionImage

        }
        frameImageView.image = frameImage
        questionImageView.image = questionImage
    }
    @IBAction func tappedStartButton(_ sender: Any) {
        if let frame = frameImage{
            config["frame"] = frame
        }
        guard let image = questionImage else{
            errorLabel.text = "Chưa chọn hình"

            return
        }
        guard let question = questionTextField.text, question.count > 0 else{
            questionTextField.becomeFirstResponder()
            errorLabel.text = "Chưa nhập câu hỏi"
            return
        }
        guard let answer = answerTextField.text else{
            return
        }
        config["state"] = gameState
        gameState += 1
        errorLabel.textColor = nil
        questionTextField.resignFirstResponder()
        answerTextField.resignFirstResponder()
        config["image"] = image
        config["question"] = question
        config["answer"] = answer
        if gameState == 1{
            startButton.setTitle("Kết thúc", for: .normal)
        }else if gameState == 2 {
            startButton.setTitle("Ẩn", for: .normal)
        }else{
            config = [:]
            startButton.setTitle("Bắt đầu", for: .normal)
            gameState = 0 
        }
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
