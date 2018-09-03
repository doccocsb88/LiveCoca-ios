//
//  CommentMaskViewCell.swift
//  facebook-live-ios-sample
//
//  Created by Macintosh HD on 8/26/18.
//  Copyright © 2018 Hans Knoechel. All rights reserved.
//

import UIKit

class CommentMaskViewCell: UITableViewCell {

    @IBOutlet weak var indexLabel: UILabel!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    @IBOutlet weak var likeShareLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func updateContent(comment:FacebookComment){
        messageLabel.text = comment.message
        timeLabel.text = comment.getTimerText()
        nameLabel.text = comment.fromName
    }
}
