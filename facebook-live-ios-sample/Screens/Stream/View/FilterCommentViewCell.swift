//
//  FilterCommentViewCell.swift
//  facebook-live-ios-sample
//
//  Created by Apple on 7/29/18.
//  Copyright © 2018 Hans Knoechel. All rights reserved.
//

import UIKit

class FilterCommentViewCell: UITableViewCell {

    @IBOutlet weak var commentButton: UITextField!
    @IBOutlet weak var timeStartTextField: UITextField!
    @IBOutlet weak var timeEndTextField: UITextField!
    
    @IBOutlet weak var filterButton: UIButton!
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var randomButton: UIButton!
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
        commentButton.addBorder(cornerRadius: 4, color: UIColor.lightGray)
        timeStartTextField.addBorder(cornerRadius: 4, color: UIColor.lightGray)
        timeEndTextField.addBorder(cornerRadius: 4, color: UIColor.lightGray)
        
        filterButton.addBorder(cornerRadius: 15, color: UIColor.clear)
        randomButton.addBorder(cornerRadius: 15, color: UIColor.clear)
        cancelButton.addBorder(cornerRadius: 15, color: UIColor.clear)


    }
    
    @IBAction func tappedRandomButton(_ sender: Any) {
    }
    @IBAction func tappedFilterButton(_ sender: Any) {
        WarterMarkServices.shared().configFilterComment(["filterComment":true])

    }
    @IBAction func tappedCancelButton(_ sender: Any) {
        WarterMarkServices.shared().configFilterComment([:])
    }
    
    
}
