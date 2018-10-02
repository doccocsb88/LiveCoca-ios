//
//  FilterCommentMaskView.swift
//  coca-live
//
//  Created by Macintosh HD on 8/26/18.
//  Copyright © 2018 Coca Live. All rights reserved.
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
    var titleLabel:UILabel?;
    var logoImageView:UIImageView?
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
        //
        var marginTop:CGFloat = 5 * scale
        titleLabel = UILabel(frame: CGRect(x: size.width / 4, y: marginTop, width: size.width / 2, height: 30 * scale))
        titleLabel?.textAlignment = .center
        titleLabel?.font = UIFont.systemFont(ofSize: 20)
        titleLabel?.text = "Danh sách người tham gia"
        titleLabel?.textColor = .black
        self.addSubview(titleLabel!)
        
        //
        let logoHeight = 20 * scale
        let logoWidth = logoHeight * 3.75
        let logoTopMargin = 10 * scale
        logoImageView = UIImageView(frame: CGRect(x: size.width - logoWidth - 10 * scale, y: logoTopMargin, width: logoWidth, height: logoHeight))
        logoImageView?.contentMode = .scaleAspectFit
        logoImageView?.image = UIImage(named: "ic_logo_color")
        
        self.addSubview(logoImageView!)
        //
        marginTop = 40 * scale
        headerVew = UIView(frame: CGRect(x: 0, y: marginTop, width: size.width, height: 30 * scale));
        headerVew?.backgroundColor = UIColor(hexString: "#fc6076")
        self.addSubview(headerVew!)
        //
        let indexWidth = size.width / 20;
        let headerHeight = 30 * scale
        indexLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 2 * indexWidth , height: headerHeight))
        indexLabel?.textAlignment  = .center
        indexLabel?.textColor = .white
        indexLabel?.text = "STT"
        headerVew?.addSubview(indexLabel!)
        //
        displayNameLabel = UILabel(frame: CGRect(x: 2 * indexWidth, y: 0, width: indexWidth * 4, height: headerHeight))
        displayNameLabel?.textAlignment  = .center
        displayNameLabel?.textColor = .white
        displayNameLabel?.text = "Tên"
//        displayNameLabel?.backgroundColor = .red
        headerVew?.addSubview(displayNameLabel!)
        //
        
        messageLabel = UILabel(frame: CGRect(x: indexWidth * 6, y: 0, width: indexWidth * 8, height: headerHeight))
        messageLabel?.textAlignment  = .center
        messageLabel?.textColor = .white
        messageLabel?.text = "Nội dung"

        headerVew?.addSubview(messageLabel!)
        //
        likeShareLabel = UILabel(frame: CGRect(x: indexWidth * 14, y: 0, width: indexWidth * 3 , height: headerHeight))
        likeShareLabel?.textAlignment  = .center
        likeShareLabel?.textColor = .white
        likeShareLabel?.text = "Like/Share"
//        likeShareLabel?.backgroundColor = .red
        headerVew?.addSubview(likeShareLabel!)
        
        //
        timeLabel = UILabel(frame: CGRect(x: indexWidth * 17, y: 0, width:indexWidth * 3  , height: headerHeight))
        timeLabel?.textAlignment  = .center
        timeLabel?.textColor = .white
        timeLabel?.text = "Thời gian"
        headerVew?.addSubview(timeLabel!)
        
        //
        marginTop = marginTop + headerHeight
        tableView = UITableView(frame: CGRect(x: 0, y: marginTop, width: size.width, height: headerHeight * 10));
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
        let index = indexPath.row + 1
        cell.updateContent(index:index,comment: comment)
        return cell;
    }
    
    func updateContent(){
        if let config = WarterMarkServices.shared().params[ConfigKey.filterComment] as? [String:Any]{
            let message = config["message"] as! String
            let start = config["start"] as? String ?? "0:0"
            let end = config["end"] as? String ?? "0:0"
            data.removeAll()
            NSLog("filtercomment %ld", APIClient.shared().comments.count)
            for comment in APIClient.shared().comments{
                let commentTime = comment.getTimerText()
                NSLog("filtercomment %@", commentTime)

                if comment.message == message, APIUtils.compareHour(commentTime, start) == .after, APIUtils.compareHour(commentTime, end) == .before{
                    data.append(comment)
                }
                
            }
            tableView?.reloadData()
            
        }
    }
    
}
