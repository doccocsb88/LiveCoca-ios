//
//  FilterCommentMaskView.swift
//  facebook-live-ios-sample
//
//  Created by Macintosh HD on 8/26/18.
//  Copyright © 2018 Hans Knoechel. All rights reserved.
//

import UIKit

class FilterCommentMaskView: UIView, UITableViewDelegate, UITableViewDataSource {
    fileprivate let cellHeight:CGFloat = 30
    var scale:CGFloat = 1
    var headerVew:UIView?
    var indexLabel:UILabel?
    var displayNameLabel:UILabel?
    var messageLabel:UILabel?
    var likeShareLabel:UILabel?
    var timeLabel:UILabel?
    var tableView:UITableView?
    var data:[FacebookComment] = []
    init(frame: CGRect, scale:CGFloat) {
        super.init(frame: frame)
        self.scale = scale
        initView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func initView(){
        let size = self.bounds.size
        headerVew = UIView(frame: CGRect(x: 0, y: 0, width: size.width, height: 30 * scale));
        headerVew?.backgroundColor = UIColor.lightGray
        self.addSubview(headerVew!)
        //
        let indexWidth = size.width / 10;
        let headerHeight = 30 * scale
        indexLabel = UILabel(frame: CGRect(x: 0, y: 0, width:indexWidth , height: headerHeight))
        indexLabel?.textAlignment  = .center
        indexLabel?.textColor = .white
        indexLabel?.text = "STT"
        headerVew?.addSubview(indexLabel!)
        //
        displayNameLabel = UILabel(frame: CGRect(x: indexWidth, y: 0, width: indexWidth * 2, height: headerHeight))
        displayNameLabel?.textAlignment  = .center
        displayNameLabel?.textColor = .white
        displayNameLabel?.text = "Tên"

        headerVew?.addSubview(displayNameLabel!)
        //
        
        messageLabel = UILabel(frame: CGRect(x: indexWidth * 3, y: 0, width: indexWidth * 4, height: headerHeight))
        messageLabel?.textAlignment  = .center
        messageLabel?.textColor = .white
        messageLabel?.text = "Nội dung"

        headerVew?.addSubview(messageLabel!)
        //
        likeShareLabel = UILabel(frame: CGRect(x: indexWidth * 7, y: 0, width:indexWidth , height: headerHeight))
        likeShareLabel?.textAlignment  = .center
        likeShareLabel?.textColor = .white
        likeShareLabel?.text = "Thích/Chia sẻ"
        headerVew?.addSubview(likeShareLabel!)
        
        //
        timeLabel = UILabel(frame: CGRect(x: indexWidth * 8, y: 0, width:indexWidth * 2  , height: headerHeight))
        timeLabel?.textAlignment  = .center
        timeLabel?.textColor = .white
        timeLabel?.text = "Thời gian"
        headerVew?.addSubview(timeLabel!)
        
        //
        tableView = UITableView(frame: CGRect(x: 0, y: headerHeight, width: size.width, height: headerHeight * 10));
        tableView?.delegate = self;
        tableView?.dataSource = self;
        tableView?.backgroundColor = .clear;
        tableView?.register(UINib(nibName: "CommentMaskViewCell", bundle: nil), forCellReuseIdentifier: "CommentMaskViewCell")
        self.addSubview(tableView!)
        self.addBorder(cornerRadius: 5, color: .lightGray)
        self.backgroundColor = .white
        
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count;
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight * scale;
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentMaskViewCell", for: indexPath) as! CommentMaskViewCell
        let comment = data[indexPath.row]
        cell.updateContent(comment: comment)
        return cell;
    }
    
    func updateContent(){
        if let config = WarterMarkServices.shared().params[ConfigKey.filterComment.rawValue] as? [String:Any]{
            let message = config["message"] as! String
            let start = config["start"] as? String ?? "0:0"
            let end = config["end"] as? String ?? "0:0"
            data.removeAll()
            for comment in APIClient.shared().comments{
                let commentTime = comment.getTimerText()
                
                if comment.message == message, APIUtils.compareHour(commentTime, start) == .after, APIUtils.compareHour(commentTime, end) == .before{
                    data.append(comment)
                }
                
            }
            tableView?.reloadData()
            
        }
    }
    
}
