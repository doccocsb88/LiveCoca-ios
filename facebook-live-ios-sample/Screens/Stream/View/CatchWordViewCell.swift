//
//  CatchWordViewCell.swift
//  facebook-live-ios-sample
//
//  Created by Apple on 7/29/18.
//  Copyright © 2018 Hans Knoechel. All rights reserved.
//

import UIKit

class CatchWordViewCell: UITableViewCell {

    @IBOutlet weak var questionView: UIView!
    
    @IBOutlet weak var questionTextField: UITextField!
    @IBOutlet weak var answerTextField: UITextField!
    @IBOutlet weak var startButton: UIButton!
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
        questionView.addBorder(cornerRadius: 4, color: UIColor.lightGray)
        answerTextField.addBorder(cornerRadius: 4, color: UIColor.lightGray)
    }
}
