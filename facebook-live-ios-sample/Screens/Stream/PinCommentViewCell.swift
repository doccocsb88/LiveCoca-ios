//
//  PinCommentViewCell.swift
//  facebook-live-ios-sample
//
//  Created by Apple on 7/29/18.
//  Copyright © 2018 Hans Knoechel. All rights reserved.
//

import UIKit

class PinCommentViewCell: UITableViewCell {

    @IBOutlet weak var fontSlider: UISlider!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var updateButton: UIButton!
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
        updateButton.addBorder(cornerRadius: 15, color: UIColor.clear)
        cancelButton.addBorder(cornerRadius: 15, color: UIColor.clear)
    }
}