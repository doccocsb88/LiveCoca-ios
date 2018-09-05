//
//  RandomNumberViewCell.swift
//  facebook-live-ios-sample
//
//  Created by Apple on 7/29/18.
//  Copyright © 2018 Hans Knoechel. All rights reserved.
//

import UIKit

class RandomNumberViewCell: UITableViewCell {
    
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var fromTextField: UITextField!
    @IBOutlet weak var toTextField: UITextField!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var randomButton: UIButton!
    var config:[String:Any] = [:]
    var completeHandle:() ->() = { }

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
        fromTextField.addBorder(cornerRadius: 4, color: UIColor.lightGray)
        toTextField.addBorder(cornerRadius: 4, color: UIColor.lightGray)
        randomButton.addBorder(cornerRadius: 15, color: UIColor.clear)
        cancelButton.addBorder(cornerRadius: 15, color: UIColor.clear)
        
        fromTextField.delegate = self
        toTextField.delegate = self
    }
    @IBAction func tappedRandomButton(_ sender: Any) {
        guard let from = fromTextField.text, from.count > 0 else{
            errorLabel.text = "Chưa nhập số bắt đầu"
            fromTextField.becomeFirstResponder()
            return
        }
        guard let to = toTextField.text , to.count > 0 else {
            errorLabel.text = "Chưa nhập số kết thúc"
            toTextField.becomeFirstResponder()

            return
        }
        errorLabel.text = nil
        fromTextField.resignFirstResponder()
        toTextField.resignFirstResponder()

        config["from"] = Int(from)
        config["to"] = Int(to)
        
        WarterMarkServices.shared().configRandom(config)
        completeHandle()
    }
    
    @IBAction func tappedCancelButton(_ sender: Any) {
        config = [:]
        WarterMarkServices.shared().configRandom(config)
        completeHandle()
    }
    
}

extension RandomNumberViewCell:UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //For mobile numer validation
//        if textField == mobileNoTF {
            let allowedCharacters = CharacterSet(charactersIn:"0123456789 ")//Here change this characters based on your requirement
            let characterSet = CharacterSet(charactersIn: string)
            return allowedCharacters.isSuperset(of: characterSet)
//        }
        return true
    }

}
