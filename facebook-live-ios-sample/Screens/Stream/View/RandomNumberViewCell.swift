//
//  RandomNumberViewCell.swift
//  facebook-live-ios-sample
//
//  Created by Apple on 7/29/18.
//  Copyright © 2018 Hans Knoechel. All rights reserved.
//

import UIKit

class RandomNumberViewCell: UITableViewCell {
    @IBOutlet weak var fromTextField: UITextField!
    
    @IBOutlet weak var toTextField: UITextField!
    
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var randomButton: UIButton!
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
    }
}
