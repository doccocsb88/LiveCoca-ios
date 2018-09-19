//
//  FrameViewCell.swift
//  coca-live
//
//  Created by Hai Vu on 7/27/18.
//  Copyright © 2018 Coca Live. All rights reserved.
//

import UIKit
import Kingfisher
class FrameViewCell:
UICollectionViewCell {
    @IBOutlet weak var thumbnailView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    func updateContent(_ frame:StreamFrame){
        titleLabel.text = frame.title
        
        let url = URL(string: frame.getThumbnailUrl())

        thumbnailView.kf.setImage(with: url)
    }
}
