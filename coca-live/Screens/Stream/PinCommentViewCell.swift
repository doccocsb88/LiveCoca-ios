//
//  PinCommentViewCell.swift
//  coca-live
//
//  Created by Apple on 7/29/18.
//  Copyright © 2018 Coca Live. All rights reserved.
//

import UIKit

class PinCommentViewCell: UITableViewCell {
    
    @IBOutlet weak var fontSlider: UISlider!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var updateButton: UIButton!
    var config:[String:Any] = [:]
    var completeHandle:() ->() = {}
    
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
        updateButton.addBorder(cornerRadius: 15, color: UIColor.clear)
        cancelButton.addBorder(cornerRadius: 15, color: UIColor.clear)
    }
    @IBAction func tappedUpdate(_ sender: Any) {
        let fontSize = CGFloat(fontSlider?.value ?? 20)
        WarterMarkServices.shared().configPinComment(font: fontSize)
        completeHandle()
        
        
    }
    
    @IBAction func tappedCancel(_ sender: Any) {
        config = [:]
        WarterMarkServices.shared().removePinComment()
        completeHandle()
        
    }
}

