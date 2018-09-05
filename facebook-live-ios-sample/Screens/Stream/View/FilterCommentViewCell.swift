//
//  FilterCommentViewCell.swift
//  facebook-live-ios-sample
//
//  Created by Apple on 7/29/18.
//  Copyright © 2018 Hans Knoechel. All rights reserved.
//

import UIKit

class FilterCommentViewCell: UITableViewCell {

    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var commentButton: UITextField!
    @IBOutlet weak var timeStartTextField: UITextField!
    @IBOutlet weak var timeEndTextField: UITextField!
    
    @IBOutlet weak var filterButton: UIButton!
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var randomButton: UIButton!
    var config:[String:Any] = [:]
    var didUpdateFilterConfig:() ->() = {}
    var errorIndex:Int = NSNotFound
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
        commentButton.addBorder(cornerRadius: 4, color: UIColor.lightGray)
        timeStartTextField.addBorder(cornerRadius: 4, color: UIColor.lightGray)
        timeEndTextField.addBorder(cornerRadius: 4, color: UIColor.lightGray)
        
        filterButton.addBorder(cornerRadius: 15, color: UIColor.clear)
        randomButton.addBorder(cornerRadius: 15, color: UIColor.clear)
        cancelButton.addBorder(cornerRadius: 15, color: UIColor.clear)


    }
    
    @IBAction func tappedRandomButton(_ sender: Any) {
    }
    @IBAction func tappedFilterButton(_ sender: Any) {
        guard let message = commentButton.text , message.count > 0 else {
            commentButton.becomeFirstResponder()
            errorLabel.text = "Chưa nhập nội dung bình luận"
            errorIndex = 0
            return
        }
        guard let start = timeStartTextField.text, start.isValidTimer() else{
            timeStartTextField.becomeFirstResponder()
            errorLabel.text = "Thời gian bắt đầu không hợp lệ"
            errorIndex = 1

            return
        }
        guard let end = timeEndTextField.text , end.isValidTimer() else{
            timeEndTextField.becomeFirstResponder()
            errorLabel.text = "Thời gian kết thúc không hợp lệ"
            errorIndex = 2

            return
        }
        errorIndex = NSNotFound
        errorLabel.text = nil
        config["message"] = message
        config["start"] = start
        config["end"] = end
        
        WarterMarkServices.shared().configFilterComment(config)
        didUpdateFilterConfig()

    }
    @IBAction func tappedCancelButton(_ sender: Any) {
        config = [:]
        WarterMarkServices.shared().configFilterComment(config)
        didUpdateFilterConfig()
    }
}
