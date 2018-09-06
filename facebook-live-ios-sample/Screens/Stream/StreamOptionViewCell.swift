//
//  StreamOptionViewCell.swift
//  coca-live
//
//  Created by Hai Vu on 7/27/18.
//  Copyright © 2018 Coca Live. All rights reserved.
//

import UIKit

class StreamOptionViewCell: UITableViewCell {

    @IBOutlet weak var accountNameLabel: UILabel!
    @IBOutlet weak var selectStreamPageButton: UIButton!
    
    @IBOutlet weak var pageNameLabel: UILabel!
    @IBOutlet weak var selectStreamAccountButton: UIButton!
   
    @IBOutlet weak var addStreamAccountButton: UIButton!
    
    @IBOutlet weak var streamDescriptionTextView: UITextView!
    
    @IBOutlet weak var countDownButton: UIButton!
    var completionHandler:(Int)->() = {_ in }
    var didTapAddAccount:()->() = {}
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setupUI(){
        selectStreamAccountButton.layer.cornerRadius = 2.0
        selectStreamAccountButton.layer.masksToBounds = true
        selectStreamAccountButton.layer.borderWidth = 1.0
        selectStreamAccountButton.layer.borderColor = UIColor.lightGray.cgColor
        selectStreamAccountButton.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        //
        selectStreamPageButton.layer.cornerRadius = 2.0
        selectStreamPageButton.layer.masksToBounds = true
        selectStreamPageButton.layer.borderWidth = 1.0
        selectStreamPageButton.layer.borderColor = UIColor.lightGray.cgColor
        selectStreamPageButton.imageView?.contentMode = UIViewContentMode.scaleAspectFit

        //
        
        streamDescriptionTextView.layer.cornerRadius = 2.0
        streamDescriptionTextView.layer.masksToBounds = true
        streamDescriptionTextView.layer.borderWidth = 1.0
        streamDescriptionTextView.layer.borderColor = UIColor.lightGray.cgColor
        //
        
        let buttonSize = addStreamAccountButton.frame.size
        addStreamAccountButton.layer.cornerRadius = buttonSize.height / 2
        addStreamAccountButton.layer.masksToBounds = true
    }
  
    @IBAction func addAccountTapped(_ sender: Any) {
        didTapAddAccount()
    }
    @IBAction func selectAccountTapped(_ sender: Any) {
        completionHandler(0)
    }
    
    @IBAction func selectPageTapped(_ sender: Any) {
        completionHandler(1)

    }
    
    @IBAction func countDownTapped(_ sender: Any) {
    }
    func updateAccountInfo(account:BaseInfo){
       
        accountNameLabel.text = account.displayName
    }
    func updatePageInfo(target:SocialTarget){
        pageNameLabel.text = target.name
        
    }

}
