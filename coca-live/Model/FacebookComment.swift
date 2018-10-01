//
//  FacebookComment.swift
//  coca-live
//
//  Created by Apple on 8/4/18.
//  Copyright © 2018 Coca Live. All rights reserved.
//

import Foundation
class FacebookComment {
//    "created_time" = "2018-08-04T13:03:11+0000";
//    from =     {
//    id = 320699568063977;
//    name = "E-Works";
//    };
//    id = "1445416775592245_1445417632258826";
//    message = aaaaa;
    var message:String
    var commentId:String
    var createdTime:Int64
    var fromId:String
    var fromName:String
    var thumbnail:String?
    
    init(message:String, commentId:String, createTime:Int64, fromId:String, fromName:String){
        self.message = message
        self.commentId = commentId
        self.createdTime = createTime
        self.fromId = fromId
        self.fromName = fromName
    }
    init(dataJson:[String:Any]){
        message = dataJson["content"] as! String
        createdTime = dataJson["created_at"] as! Int64
        commentId = dataJson["id"] as! String
        fromId = dataJson["id_user"] as! String
        fromName = dataJson["name"] as! String
        thumbnail = dataJson["thumbnail"] as? String
    }
    
    func getTimerText() ->String{
        let date = Date(milliseconds:self.createdTime)
       
        return date.converToString()
    }
//}
}
