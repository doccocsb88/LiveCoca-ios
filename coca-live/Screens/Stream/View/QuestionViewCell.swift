//
//  QuestionViewCell.swift
//  coca-live
//
//  Created by Apple on 7/29/18.
//  Copyright © 2018 Coca Live. All rights reserved.
//

import UIKit

class QuestionViewCell: UITableViewCell {

    @IBOutlet weak var previewImageView: UIImageView!
    @IBOutlet weak var uploadView: UIView!
    
    @IBOutlet weak var uploadButton: UIButton!
    
    @IBOutlet weak var question1View: UIView!
    
    @IBOutlet weak var question2View: UIView!
    @IBOutlet weak var question3View: UIView!
    
    @IBOutlet weak var question4View: UIView!
    
    @IBOutlet weak var addButton: UIButton!
    
    @IBOutlet weak var cancelButton: UIButton!
    
    
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var errorFilterLabel: UILabel!
    
    @IBOutlet weak var questionTextfield: UITextField!
    
    @IBOutlet weak var answer1Textfield: UITextField!
    
    @IBOutlet weak var answer2Textfield: UITextField!
    
    @IBOutlet weak var answer3Textfield: UITextField!
    
    @IBOutlet weak var answer4Textfield: UITextField!
    //
    
    @IBOutlet weak var answerTextfield: UITextField!
    
    @IBOutlet weak var startTimeTextfield: UITextField!
    @IBOutlet weak var endTimeTextfield: UITextField!
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var hideButton: UIButton!
    
    var questionImage:UIImage?
    var didTapSelectImage:()->() = {}
    var didUpdateQuestionConfig:() ->() = {}
    var didUpdateFilterConfig:() ->() = {}
    var config:[String:Any] = [:]
    var hasQuestion:Bool = false
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setup()
        errorLabel.text = nil
        errorFilterLabel.text = nil
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setup(){
        uploadView.addBorder(cornerRadius: 4, color: UIColor.lightGray)
        question1View.addBorder(cornerRadius: 4, color: UIColor.lightGray)
        question2View.addBorder(cornerRadius: 4, color: UIColor.lightGray)
        question3View.addBorder(cornerRadius: 4, color: UIColor.lightGray)
        question4View.addBorder(cornerRadius: 4, color: UIColor.lightGray)
        addButton.addBorder(cornerRadius: 15, color: UIColor.clear)
        cancelButton.addBorder(cornerRadius: 15, color: UIColor.clear)
        uploadButton.imageView?.contentMode = .scaleAspectFit
        //
        filterButton.addBorder(cornerRadius: 15, color: .clear)
        hideButton.addBorder(cornerRadius: 15, color: .clear)

    }
    func updateQuestionImage(_ image:UIImage?){
        self.questionImage = image;
        if let image = questionImage{
            previewImageView.image = image
            config["image"] = image
        }
    }
    @IBAction func tappedUploadButton(_ sender: Any) {
        
        didTapSelectImage()
    }
    @IBAction func tappedCreateQuesstionButton(_ sender: Any) {
        hasQuestion = false
        guard let question = questionTextfield.text, question.count > 0 else{
            errorLabel.text = "Chưa nhập câu hỏi"
            questionTextfield.becomeFirstResponder()
            return
        }
        guard let answer1 = answer1Textfield.text , answer1.count > 0 else{
            errorLabel.text = "Chưa nhập câu trả lời 1"
            answer1Textfield.becomeFirstResponder()

            return
        }
        guard let answer2 = answer2Textfield.text, answer2.count > 0 else{
            errorLabel.text = "Chưa nhập câu trả lời 2"
            answer2Textfield.becomeFirstResponder()
            return
        }
        guard let answer3 = answer3Textfield.text , answer3.count > 0 else{
            errorLabel.text = "Chưa nhập câu trả lời 3"
            answer3Textfield.becomeFirstResponder()

            return
        }
        guard let answer4 = answer4Textfield.text , answer4.count > 0 else{
            errorLabel.text = "Chưa nhập câu trả lời 4"
            answer4Textfield.becomeFirstResponder()

            return
        }
        errorLabel.text = nil
        self.endEditing(true)
        config["question"] = question
        config["answer1"] = answer1
        config["answer2"] = answer2
        config["answer3"] = answer3
        config["answer4"] = answer4
        hasQuestion = true
        WarterMarkServices.shared().configQuestion(config: config)
        didUpdateQuestionConfig()
    }
    
    @IBAction func tappedCancelButton(_ sender: Any) {
        hasQuestion = false
        config = [:]
        WarterMarkServices.shared().configQuestion(config: config)
        didUpdateQuestionConfig()

    }
    @IBAction func tappedHideButton(_ sender: Any) {
        WarterMarkServices.shared().configFilterComment([:])
        didUpdateFilterConfig()
    }
    @IBAction func tappedFilterButton(_ sender: Any) {
        if hasQuestion == false {
            errorFilterLabel.text = "Chưa hoàn thành thông tin phần câu hỏi."

            return
        }
        guard let answer = answerTextfield.text , answer.count > 0 else{
            errorFilterLabel.text = "Chưa nhập câu trả lời."
            answerTextfield.becomeFirstResponder()
            return
        }
        guard let startTime = startTimeTextfield.text , startTime.count > 0 else {
            errorFilterLabel.text = "Chưa nhập thời gian bắt đầu."

            startTimeTextfield.becomeFirstResponder()
            return
        }
        if startTime.isValidTimer() == false{
            errorFilterLabel.text = "Thời gian bắt đầu không hợp lệ."

            return
        }
        guard let endTime = endTimeTextfield.text , endTime.count > 0 else {
            errorFilterLabel.text = "Chưa nhập thời gian kết thúc."

            endTimeTextfield.becomeFirstResponder()
            return
        }
        if endTime.isValidTimer() == false{
            errorFilterLabel.text = "Thời gian kết thúc không hợp lệ."
            return
        }
        errorFilterLabel.text = nil
        var config:[String:Any] = [:]
        config["message"] = answer
        config["start"] = startTime
        config["end"] = endTime
        WarterMarkServices.shared().configFilterComment(config)
        didUpdateFilterConfig()

    }
    
}
