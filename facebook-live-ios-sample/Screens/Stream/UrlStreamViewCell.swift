//
//  UrlStreamViewCell.swift
//  facebook-live-ios-sample
//
//  Created by Hai Vu on 7/27/18.
//  Copyright © 2018 Hans Knoechel. All rights reserved.
//

import UIKit

class UrlStreamViewCell: UITableViewCell {

    @IBOutlet weak var removeButton: UIButton!
    @IBOutlet weak var urlLabel: UILabel!
    var completionHandler:(Int)->() = {_ in }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        urlLabel.layer.borderColor = UIColor.lightGray.cgColor
        urlLabel.layer.borderWidth = 1.0
        urlLabel.layer.cornerRadius = 2.0
        urlLabel.layer.masksToBounds = true
        
        //
        removeButton.layer.cornerRadius = removeButton.frame.size.height / 2
        removeButton.layer.masksToBounds = true
        removeButton.layer.borderWidth = 1
        removeButton.layer.borderColor = UIColor.lightGray.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func updateUrlStreamLabel(urlStream:String){
        urlLabel.text = urlStream
    }
    
    @IBAction func tappedRemoveButton(_ sender: Any) {
        let index = removeButton.tag
        completionHandler(index)
    }
}
