//
//  FacebookComment.swift
//  facebook-live-ios-sample
//
//  Created by Apple on 8/4/18.
//  Copyright © 2018 Hans Knoechel. All rights reserved.
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
    var createdTime:String
    var fromId:String
    var fromName:String
    
    init(dataJson:[String:Any]){
        message = dataJson["message"] as! String
        createdTime = dataJson["created_time"] as! String
        commentId = dataJson["id"] as! String
        let from = dataJson["from"] as! [String:Any]
        fromId = from["id"] as! String
        fromName = from["name"] as! String
//        http://graph.facebook.com/fromid/picture?type=square
    }
//}
}