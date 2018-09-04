//
//  StreamCommentView.swift
//  facebook-live-ios-sample
//
//  Created by Apple on 8/4/18.
//  Copyright © 2018 Hans Knoechel. All rights reserved.
//

import UIKit
import Kingfisher

class StreamCommentView: UIView, UITableViewDelegate, UITableViewDataSource {
  
    var tableView:UITableView?
    var data:[FacebookComment] = []
    var pinIndex:Int = NSNotFound
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
        cell.bindData(comment: comment, index:indexPath.row, isPinted:indexPath.row == pinIndex)
        cell.didPinComment = {[unowned self]index in
            if index != self.pinIndex {
                if index >= 0, index < self.data.count{
                    let pinComment = self.data[index]
                    self.pinIndex = index
                    WarterMarkServices.shared().configPin(comment: pinComment)
                    self.didPinComment()
                }
            }else{
                self.pinIndex = NSNotFound
                WarterMarkServices.shared().removePinComment()
            }
            self.tableView?.reloadData()
            
        }
        let url = URL(string: "http://graph.facebook.com/\(comment.fromId)/picture?type=square&access_token=\(FacebookServices.shared().curPage?.tokenString ?? "")")
        
        cell.avatarImageView.kf.setImage(with: url,
                                    placeholder: nil,
                                    options: [.transition(ImageTransition.fade(1))],
                                    progressBlock: { receivedSize, totalSize in
                                        print("\(indexPath.row + 1): \(receivedSize)/\(totalSize)")
        },
                                    completionHandler: { image, error, cacheType, imageURL in
                                        if let error  =  error{
                                            print("\(indexPath.row + 1): \(error.description)")
                                        }else{
                                            print("\(indexPath.row + 1): Finished")

                                        }
        })
        cell.backgroundColor = UIColor.clear
        cell.selectionStyle = .none
        
        return cell
    }
    
}
