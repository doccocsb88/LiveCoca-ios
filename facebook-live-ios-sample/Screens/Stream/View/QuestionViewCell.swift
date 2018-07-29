//
//  QuestionViewCell.swift
//  facebook-live-ios-sample
//
//  Created by Apple on 7/29/18.
//  Copyright © 2018 Hans Knoechel. All rights reserved.
//

import UIKit

class QuestionViewCell: UITableViewCell {

    @IBOutlet weak var uploadView: UIView!
    
    @IBOutlet weak var uploadButton: UIButton!
    
    @IBOutlet weak var question1View: UIView!
    
    @IBOutlet weak var question2View: UIView!
    @IBOutlet weak var question3View: UIView!
    
    @IBOutlet weak var question4View: UIView!
    
    @IBOutlet weak var addButton: UIButton!
    
    @IBOutlet weak var cancelButton: UIButton!
    
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
         uploadView.addBorder(cornerRadius: 4, color: UIColor.lightGray)
        question1View.addBorder(cornerRadius: 4, color: UIColor.lightGray)
         question2View.addBorder(cornerRadius: 4, color: UIColor.lightGray)
         question3View.addBorder(cornerRadius: 4, color: UIColor.lightGray)
         question4View.addBorder(cornerRadius: 4, color: UIColor.lightGray)
         addButton.addBorder(cornerRadius: 15, color: UIColor.clear)
         cancelButton.addBorder(cornerRadius: 15, color: UIColor.clear)
    }
}
