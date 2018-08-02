//
//  CountDownViewCell.swift
//  facebook-live-ios-sample
//
//  Created by Apple on 7/29/18.
//  Copyright © 2018 Hans Knoechel. All rights reserved.
//

import UIKit

class CountDownViewCell: UITableViewCell {

    @IBOutlet weak var muteButton: UIButton!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var showButton: UIButton!
    
    @IBOutlet weak var selectImageButton: UIButton!
    
    @IBOutlet weak var uploadButton: UIButton!
    var completeHandle:(Bool) ->() =  {(isOn) in }
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
        let size = cameraButton.frame.size
        showButton.layer.cornerRadius = size.height / 2
        showButton.layer.masksToBounds = true
        //
        muteButton.layer.cornerRadius = size.height / 2
        muteButton.layer.masksToBounds = true
        
        //
        cameraButton.layer.cornerRadius = size.height / 2
        cameraButton.layer.masksToBounds = true
        //
        selectImageButton.layer.cornerRadius = 2
        selectImageButton.layer.masksToBounds = true
        selectImageButton.layer.borderColor = UIColor.lightGray.cgColor
        selectImageButton.layer.borderWidth = 1.0
        
        let origImage = UIImage(named: "ic_upload")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        uploadButton.setImage(tintedImage, for: .normal)
        uploadButton.tintColor = UIColor.lightGray
        uploadButton.imageView?.contentMode = UIViewContentMode.scaleAspectFit

    }
    @IBAction func tappedShowButton(_ sender: Any) {
        WarterMarkServices.shared().showCountdownView()
        completeHandle(true)
    }
    @IBAction func tappedMuteButton(_ sender: Any) {
    }
    
    @IBAction func tappedCameraButton(_ sender: Any) {
    }
}
