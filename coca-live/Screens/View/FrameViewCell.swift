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
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var selectButton: UIButton!
    var didSelectFrame:()->() = {}
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.priceLabel.isHidden = true
        selectButton.imageView?.contentMode = .scaleAspectFit
    }

    
    func updateContent(_ frame:StreamFrame, _ isSelected:Bool){
        titleLabel.text = frame.title
        
        let url = URL(string: frame.getThumbnailUrl())

        thumbnailView.kf.setImage(with: url)
        selectButton.isSelected = isSelected
    }
    func getFrameImage()-> UIImage?{
        return thumbnailView.image
    }
    @IBAction func tappedSelectButton(_ sender: Any) {
        didSelectFrame()
        
    }
}
