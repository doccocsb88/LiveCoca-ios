//
//  StreamHistoryViewCell.swift
//  coca-live
//
//  Created by Apple on 7/26/18.
//  Copyright © 2018 Coca Live. All rights reserved.
//

import UIKit

class StreamHistoryViewCell: UITableViewCell {

    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var createdLabel: UILabel!
    @IBOutlet weak var roomNameLabel: UILabel!
    
    @IBOutlet weak var link1Button: UIButton!
    
    @IBOutlet weak var link2Button: UIButton!
    @IBOutlet weak var link3Button: UIButton!
    @IBOutlet weak var link4Button: UIButton!
    var didOpenVideoAtIndex:(Int) ->() = {index in }
    var linkButton:[UIButton] = []
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        linkButton = [link1Button,link2Button,link3Button,link4Button]
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func updateContent(_ info:CocaStream){
        roomNameLabel.text = info.title
        createdLabel.text = info.getCreatedString()
        for i in 0..<linkButton.count{
            linkButton[i].isHidden = true
        }
        for i in 0..<info.destinations.count{
            linkButton[i].isHidden = false
        }
    }
    
    @IBAction func tappedLinkButton(_ sender: Any) {
        guard let button = sender as? UIButton else{return}
        let tag = button.tag
        didOpenVideoAtIndex(tag)
    }
}
