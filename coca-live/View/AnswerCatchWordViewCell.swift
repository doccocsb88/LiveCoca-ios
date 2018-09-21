//
//  AnswerCatchWordViewCell.swift
//  coca-live
//
//  Created by Macintosh HD on 9/20/18.
//  Copyright © 2018 Coca Live. All rights reserved.
//

import UIKit
import Kingfisher
class AnswerCatchWordViewCell: UITableViewCell {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    @IBOutlet weak var indexLabel: UILabel!
    
    @IBOutlet weak var createdLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.avatarImageView.addBorder(cornerRadius: 25, color: .lightGray)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func updateContent(_ comment:FacebookComment, _ indexPath:IndexPath){
        usernameLabel.text = comment.fromName
        messageLabel.text = comment.message
        indexLabel.text =  "\(indexPath.row + 1)"
        createdLabel.text = comment.getTimerText()
        let facebookProfileUrl = "http://graph.facebook.com/\(comment.fromId)/picture?type=large"
        let url = URL(string: facebookProfileUrl)
        avatarImageView.kf.setImage(with: url)
    }
}
