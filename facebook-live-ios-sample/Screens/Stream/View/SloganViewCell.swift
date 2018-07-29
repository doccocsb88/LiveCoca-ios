//
//  SloganViewCell.swift
//  facebook-live-ios-sample
//
//  Created by Apple on 7/29/18.
//  Copyright © 2018 Hans Knoechel. All rights reserved.
//

import UIKit

class SloganViewCell: UITableViewCell {

    @IBOutlet weak var hideButton: UIButton!
    
    @IBOutlet weak var powerButton: UIButton!
    
    @IBOutlet weak var otherButton: UIButton!
    @IBOutlet weak var colorButton: UIButton!
    @IBOutlet weak var alignButton: UIButton!
    
    @IBOutlet weak var updateButton: UIButton!
    
    @IBOutlet weak var sloganTextField: UITextField!
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
        colorButton.addBorder(cornerRadius: 4, color: UIColor.lightGray)
        //
        alignButton.addBorder(cornerRadius: 4, color: UIColor.lightGray)
        //
        
        updateButton.layer.cornerRadius = 15.0
        updateButton.layer.masksToBounds = true
        
        //
        hideButton.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        powerButton.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        otherButton.imageView?.contentMode = UIViewContentMode.scaleAspectFit

    }
}
