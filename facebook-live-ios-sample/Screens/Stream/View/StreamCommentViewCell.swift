//
//  StreamCommentViewCell.swift
//  facebook-live-ios-sample
//
//  Created by Apple on 8/4/18.
//  Copyright © 2018 Hans Knoechel. All rights reserved.
//

import UIKit
class StreamCommentViewCell: UITableViewCell {
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var avatarImageView: UIImageView!
    
    @IBOutlet weak var displayNameLabel: UILabel!
    
    @IBOutlet weak var createDateLabel: UILabel!
    
    @IBOutlet weak var messageLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        containerView.addBorder(cornerRadius: 5, color: UIColor.clear)
        avatarImageView.addBorder(cornerRadius: 20, color: UIColor.lightGray)
        self.backgroundColor = UIColor.clear
        self.contentView.backgroundColor = UIColor.clear
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func bindData(comment:FacebookComment){
       
        displayNameLabel.text = comment.fromName
        let times = comment.createdTime.components(separatedBy: "T")
        var timeText = times[1];
        timeText = timeText.components(separatedBy: "+")[0]
        createDateLabel.text = timeText
        messageLabel.text = comment.message
    }
    
    @IBAction func tappedPinButton(_ sender: Any) {
    }
}
