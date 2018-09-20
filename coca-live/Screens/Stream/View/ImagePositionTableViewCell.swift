//
//  ImagePositionTableViewCell.swift
//  coca-live
//
//  Created by Hai Vu on 9/20/18.
//  Copyright © 2018 Coca Live. All rights reserved.
//

import UIKit

class ImagePositionTableViewCell: UITableViewCell {

    @IBOutlet weak var positionLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateContent(_ positionTitle:String){
        positionLabel.text = positionTitle
    }
    
}
