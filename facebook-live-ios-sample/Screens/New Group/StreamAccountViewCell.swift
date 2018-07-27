//
//  StreamAccountViewCell.swift
//  facebook-live-ios-sample
//
//  Created by Hai Vu on 7/27/18.
//  Copyright © 2018 Hans Knoechel. All rights reserved.
//

import UIKit

class StreamAccountViewCell: UITableViewCell {

    @IBOutlet weak var accountTypeImageView: UIImageView!
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var pageNameLabel: UILabel!
    
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var statusImageView: UIImageView!
    @IBOutlet weak var removeButton: UIButton!
    
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
        let size = removeButton.frame.size;
        removeButton.layer.cornerRadius = size.height / 2;
        removeButton.layer.masksToBounds = true
        removeButton.clipsToBounds = true
        removeButton.layer.borderColor = UIColor.lightGray.cgColor
        removeButton.layer.borderWidth = 1.0
        //
        let avatarSize = avatarImageView.frame.size
        
        avatarImageView.layer.cornerRadius = avatarSize.height / 2
        avatarImageView.layer.masksToBounds = true
        avatarImageView.clipsToBounds = true
        //
        accountTypeImageView.layer.cornerRadius = avatarSize.height / 2
        accountTypeImageView.layer.masksToBounds = true
        accountTypeImageView.clipsToBounds = true
        
    }
}
