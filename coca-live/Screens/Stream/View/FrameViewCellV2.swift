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
    var index:Int = 0
    var streamFrame:StreamFrame?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tappedGesture(_:)))
        self.addGestureRecognizer(gesture)
       
        frameImageView.addBorder(cornerRadius: 2, color: .lightGray)
        frameImageView.backgroundColor = .lightGray

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateContent(frame: StreamFrame?, index:Int){
        self.index = index
        self.streamFrame = frame
        if index == 0{
            nameLabel.text = "Ẩn khung"
            frameImageView.image = nil;
        }else{
            guard let frame = frame else {return}
            nameLabel.text = frame.title
            let url = URL(string: frame.getThumbnailUrl())
            frameImageView.kf.setImage(with: url)
        }
    }
    @objc func tappedGesture(_ gesture:UIGestureRecognizer){
        var config:[String:Any] = [:]
        if let frame = self.streamFrame {
            DispatchQueue.global().async { [weak self] in
                if let url = URL(string: frame.getThumbnailUrl()){
                    if let data = try? Data(contentsOf: url) {
                        if let image = UIImage(data: data) {
                            DispatchQueue.main.async { [weak self] in
                                guard let strongSelf = self else{return}
                                config["image"] = image
                                WarterMarkServices.sharedInstance.configFrame(config: config)
                                strongSelf.didSelectFrame()
                            }
                        }
                    }
                }
            }
        }else{
            WarterMarkServices.sharedInstance.configFrame(config: config)
            self.didSelectFrame()
        }
       
    }
   
    
    
}
