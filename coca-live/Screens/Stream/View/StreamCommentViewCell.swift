//
//  StreamCommentViewCell.swift
//  coca-live
//
//  Created by Apple on 8/4/18.
//  Copyright © 2018 Coca Live. All rights reserved.
//

import UIKit
class StreamCommentViewCell: UITableViewCell {
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var avatarImageView: UIImageView!
    
    @IBOutlet weak var displayNameLabel: UILabel!
    
    @IBOutlet weak var createDateLabel: UILabel!
    
    @IBOutlet weak var messageLabel: UILabel!

    @IBOutlet weak var pinButton: UIButton!
    var didPinComment:(Int)->() = {index in}
    var comment:FacebookComment?
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
    
    func bindData(comment:FacebookComment, index:Int, isPinted:Bool){
        self.comment = comment;
        displayNameLabel.text = comment.fromName
        let times = comment.createdTime.components(separatedBy: "T")
        var timeText = times[1];
        timeText = timeText.components(separatedBy: "+")[0]
        createDateLabel.text = timeText
        messageLabel.text = comment.message
        self.tag = index + 1
        pinButton.isSelected = isPinted
    }
    
    @IBAction func tappedPinButton(_ sender: Any) {
        let index = self.tag - 1
//        if let comment = self.comment{
//            WarterMarkServices.shared().configPin(comment: comment)
//        }
        
        didPinComment(index)
    }
}
