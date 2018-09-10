//
//  FrameViewCellV2.swift
//  coca-live
//
//  Created by Apple on 7/29/18.
//  Copyright © 2018 Coca Live. All rights reserved.
//

import UIKit

class FrameViewCellV2: UITableViewCell {

    @IBOutlet weak var frameImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    var didSelectFrame:()->() = {}
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tappedGesture(_:)))
        self.addGestureRecognizer(gesture)
        if self.tag == 0{
            nameLabel.text = "Ẩn khung"
            frameImageView.image = nil;
            frameImageView.backgroundColor = .lightGray
        }else{
            frameImageView.backgroundColor = .white

        }

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @objc func tappedGesture(_ gesture:UIGestureRecognizer){
        let tag  = self.tag
        var config:[String:Any] = [:]
        if tag > 0{
            if tag % 2 == 0{
                config["image"] = "frame_01"
            }else{
                config["image"] = "frame_02"
                
            }
        }
        WarterMarkServices.sharedInstance.configFrame(config: config)
        didSelectFrame()
    }
    
    
}
