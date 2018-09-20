//
//  VideoViewCell.swift
//  coca-live
//
//  Created by Apple on 8/5/18.
//  Copyright © 2018 Coca Live. All rights reserved.
//

import UIKit

class VideoViewCell: UITableViewCell, UITableViewDelegate, UITableViewDataSource{
    fileprivate let cellHeight:CGFloat = 30
    fileprivate let positions:[String] = ["Góc trên trái", "Góc trên phải", "Góc dưới phải", "Góc dưới trái"]
    
    @IBOutlet weak var previewImageView: UIImageView!
    @IBOutlet weak var selectImageButton: UIButton!
    @IBOutlet weak var positionButton: UIButton!
    @IBOutlet weak var showButton: UIButton!
    @IBOutlet weak var hideButton: UIButton!
    var config:[String:Any] = [:]
    var completeHandle:() ->() = {}
    var tableView:UITableView?
    var tappedSelectImage:()->() = {}
    var previewImage:UIImage?
    var position:Int = 0
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
        let radius = showButton.frame.height / 2
        showButton.addBorder(cornerRadius: radius, color: .clear)
        hideButton.addBorder(cornerRadius: radius, color: .clear)
        positionButton.addBorder(cornerRadius: radius, color: .clear)
        selectImageButton.addBorder(cornerRadius: radius, color: .clear)
        previewImageView.addBorder(cornerRadius: 2, color: .lightGray)
        //
        
        //
        tableView = UITableView(frame: CGRect(origin: CGPoint.zero, size: CGSize.zero))
        tableView?.delegate = self;
        tableView?.dataSource = self;
        tableView?.backgroundColor = .white
        tableView?.register(UINib(nibName: "ImagePositionTableViewCell", bundle: nil), forCellReuseIdentifier: "positionCell")
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapped(_:)))
        tableView?.addGestureRecognizer(tapGesture)
        tapGesture.delegate = self
    }
    func updateContent(_ image:UIImage){
        self.previewImage = image
        self.previewImageView.image = image
    }
    @IBAction func tappedPositionButton(_ sender: Any) {
        if positionButton.isSelected == false{
            tableView?.frame = CGRect(x: 0 , y: 0, width: self.bounds.width , height: cellHeight * CGFloat(positions.count))
            tableView?.addBorder(cornerRadius: 4, color: UIColor.lightGray)
            tableView?.reloadData()
            self.addSubview(tableView!)
        }else{
            tableView?.removeFromSuperview()
        }
        positionButton.isSelected = !positionButton.isSelected
    }
    @IBAction func tappedSelectImageButton(_ sender: Any) {
        tappedSelectImage()
        
    }
    
    @IBAction func tappedShowButton(_ sender: Any) {
        guard let image = previewImage else {return}
        config["image"] = image
        config["position"] = self.position

        WarterMarkServices.shared().configVideo(config: config)
        completeHandle()
    }
    @IBAction func tappedHideButton(_ sender: Any) {
        config = [:]
        WarterMarkServices.shared().configVideo(config: config)
        completeHandle()
    }
    
    @objc func tapped(_ recognizer:UIGestureRecognizer){
        if recognizer.state == .ended {
            guard let tableview = self.tableView else {return}
            let tapLocation = recognizer.location(in: tableview)
            if let tapIndexPath = tableview.indexPathForRow(at: tapLocation) {
               self.position = tapIndexPath.row
                NSLog("childImage tapped %ld", tapIndexPath.row)
                self.tableView?.removeFromSuperview()
                self.positionButton.isSelected = false
            }
        }
    }

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return positions.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "positionCell", for: indexPath) as! ImagePositionTableViewCell
        let positionTitle = positions[indexPath.row]
        cell.updateContent(positionTitle)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        NSLog("childImage clicked %ld", indexPath.row)
    }
}
