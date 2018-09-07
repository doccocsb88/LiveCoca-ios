//
//  MenuViewCell.swift
//  coca-live
//
//  Created by Apple on 7/28/18.
//  Copyright © 2018 Coca Live. All rights reserved.
//

import UIKit

class MenuViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var expandButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let origImage = UIImage(named: "ic_angle_down")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        expandButton.setImage(tintedImage, for: .normal)
        expandButton.tintColor = .white
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
  
}
