//
//  VideoViewCell.swift
//  facebook-live-ios-sample
//
//  Created by Apple on 8/5/18.
//  Copyright © 2018 Hans Knoechel. All rights reserved.
//

import UIKit

class VideoViewCell: UITableViewCell, UITableViewDelegate, UITableViewDataSource{
    fileprivate let cellHeight:CGFloat = 30
    @IBOutlet weak var urlTextfield: UITextField!
    
    @IBOutlet weak var positionButton: UIButton!
    @IBOutlet weak var columeSlider: UISlider!
    @IBOutlet weak var showButton: UIButton!
    @IBOutlet weak var hideButton: UIButton!
    var config:[String:Any] = [:]
    var completeHandle:() ->() = {}
    var tableView:UITableView?
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
        urlTextfield.addBorder(cornerRadius: 4, color: .lightGray)
        showButton.addBorder(cornerRadius: 15, color: .clear)
        hideButton.addBorder(cornerRadius: 15, color: .clear)
        //
        urlTextfield.text = "http://techslides.com/demos/sample-videos/small.mp4"
        
        //
        tableView = UITableView(frame: CGRect(origin: CGPoint.zero, size: CGSize.zero))
        tableView?.delegate = self;
        tableView?.dataSource = self;
        tableView?.backgroundColor = .red
    }
    @IBAction func tappedPositionButton(_ sender: Any) {
        if positionButton.isSelected == false{
            tableView?.frame = CGRect(x: urlTextfield.frame.origin.x, y: urlTextfield.frame.origin.y + urlTextfield.frame.size.height, width: urlTextfield.frame.size.width, height: cellHeight * 3)
            tableView?.addBorder(cornerRadius: 4, color: UIColor.lightGray)
            tableView?.reloadData()
            self.addSubview(tableView!)
        }else{
            tableView?.removeFromSuperview()
        }
    }
    @IBAction func tappedShowButton(_ sender: Any) {
        guard let url = urlTextfield.text else{
            return
        }
        config["url"] = url
        WarterMarkServices.shared().configVideo(config: config)
        completeHandle()
    }
    @IBAction func tappedHideButton(_ sender: Any) {
        config = [:]
        WarterMarkServices.shared().configVideo(config: config)
        completeHandle()
    }
    


    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        cell.frame = CGRect(origin: CGPoint.zero, size: urlTextfield.frame.size)
        let titleLabel = UILabel(frame: cell.bounds)
        titleLabel.textAlignment = .center
        titleLabel.text = "abcdef"
        cell.addSubview(titleLabel)
        
        return cell
    }
}
