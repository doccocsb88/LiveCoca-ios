//
//  SelectStreamAccountViewCell.swift
//  coca-live
//
//  Created by Hai Vu on 7/27/18.
//  Copyright © 2018 Coca Live. All rights reserved.
//

import UIKit

class SelectStreamAccountViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configView(account:BaseInfo){
        titleLabel.text = account.displayName ?? "ccc"
    }
    func configView(account:FacebookInfo){
        titleLabel.text = account.displayName ?? "ccc"
    }
    func configView(target:SocialTarget){
        titleLabel.text = target.name ?? "ccc"
    }

}
