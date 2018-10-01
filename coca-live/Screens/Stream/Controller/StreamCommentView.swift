//
//  StreamCommentView.swift
//  coca-live
//
//  Created by Apple on 8/4/18.
//  Copyright © 2018 Coca Live. All rights reserved.
//

import UIKit
import Kingfisher

class StreamCommentView: UIView, UITableViewDelegate, UITableViewDataSource {
  
    var tableView:UITableView?
    var data:[FacebookComment] = []
    var pinCommentId:String? = nil
    var didPinComment:() ->() = {}
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    private func initData(){
    }
    private func initView(){
        tableView = UITableView(frame: self.bounds)
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.rowHeight = UITableViewAutomaticDimension
        tableView?.estimatedRowHeight = 300
        tableView?.register(UINib(nibName: "StreamCommentViewCell", bundle: nil), forCellReuseIdentifier: "StreamCommentViewCell")
        tableView?.backgroundColor = UIColor.clear
        tableView?.separatorStyle  = .none
        self.addSubview(tableView!)
        self.backgroundColor = UIColor.black.withAlphaComponent(0.2)
    }
    
    func reloadData(data:[FacebookComment]){
        self.data = data
        tableView?.reloadData()
    }
    
    func hideTableView(){
        tableView?.isHidden = true
    }
    func showTableView(){
        tableView?.isHidden = false
    }
    func toggleTableView(isHidden:Bool){
        tableView?.isHidden = isHidden
    }
}
extension StreamCommentView{
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return  0.1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let comment = data[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "StreamCommentViewCell", for: indexPath) as! StreamCommentViewCell
        cell.backgroundColor = .clear
        var isPinted = false
        if let pin = pinCommentId{
            isPinted = comment.commentId == pin
        }
        cell.bindData(comment: comment, index:indexPath.row, isPinted:isPinted)
        cell.didPinComment = {[unowned self] commentId in
            if commentId != self.pinCommentId {
               
                self.pinCommentId = commentId
                WarterMarkServices.shared().configPin(comment: comment)
                
            }else{
                self.pinCommentId = nil
                WarterMarkServices.shared().removePinComment()
            }
            self.didPinComment()

            self.tableView?.reloadData()
            
        }
        let url = URL(string: comment.thumbnail ?? "")
        
        cell.avatarImageView.kf.setImage(with: url)
        cell.backgroundColor = UIColor.clear
        cell.selectionStyle = .none
        
        return cell
    }
    
}
