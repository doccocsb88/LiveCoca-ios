//
//  CountCommentViewCell.swift
//  coca-live
//
//  Created by Macintosh HD on 8/28/18.
//  Copyright © 2018 Coca Live. All rights reserved.
//

import UIKit

class CountCommentViewCell: UITableViewCell {

    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var comment2Textfield: UITextField!
    @IBOutlet weak var comment1Textfield: UITextField!
    
    @IBOutlet weak var comment3Textfield: UITextField!
    @IBOutlet weak var comment4Textfield: UITextField!
    
    @IBOutlet weak var updateButton: UIButton!
    
    @IBOutlet weak var hideButton: UIButton!
    var config:[String:Any] = [:]
    var completeHandle:() ->() = {}
    var didTapSelectImage:(String) ->() = {imageKey in }
    var thumbImage:UIImage?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupView(){
        comment1Textfield.addBorder(cornerRadius: 4, color: UIColor.lightGray)
        comment2Textfield.addBorder(cornerRadius: 4, color: UIColor.lightGray)
        comment3Textfield.addBorder(cornerRadius: 4, color: UIColor.lightGray)
        comment4Textfield.addBorder(cornerRadius: 4, color: UIColor.lightGray)
        updateButton.addBorder(cornerRadius: 15, color: UIColor.clear)
        hideButton.addBorder(cornerRadius: 15, color: UIColor.clear)


    }
    func updateCountCommentImage(_ image: UIImage){
        thumbImage = image
        thumbImageView.image  = image
        config["image"] = image
    }
    @IBAction func tappedUpdateButton(_ sender: Any) {
        var count:Int = 0
        if let text = comment1Textfield.text , text.count > 0{
            count  = count + 1
            config["comment1"] =   text
            
        }
        if let text = comment2Textfield.text , text.count > 0{
            count  = count + 1
            config["comment2"] =   text
            
        }
        if let text = comment3Textfield.text , text.count > 0{
            count  = count + 1
            config["comment3"] =   text
            
        }
        if let text = comment4Textfield.text , text.count > 0{
            count  = count + 1
            config["comment4"] =   text
            
        }
        if count > 0{
            WarterMarkServices.shared().configCountComment(config)
            completeHandle()
        }
    }
    
    @IBAction func tappedHideButton(_ sender: Any) {
        config = [:]
        WarterMarkServices.shared().configCountComment(config)
        completeHandle()
    }
    
    @IBAction func tappedSelectImage(_ sender: Any) {
        didTapSelectImage(ConfigKey.countComment.rawValue)
    }
}
