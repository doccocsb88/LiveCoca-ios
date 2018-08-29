//
//  User.swift
//  facebook-live-ios-sample
//
//  Created by Apple on 8/3/18.
//  Copyright © 2018 Hans Knoechel. All rights reserved.
//

import Foundation
import SwiftyJSON
class User {
//    {"username": "cocatest", "phone": "", "avatar": "/skin/frontend/default/img/no-thumbnail.jpg", "description": "", "fullname": "Coca Test", "coin": 0, "id": "tuzran", "email": ""}
    var username:String?
    var phone:String?
    var avatar:String?
    var description:String?
    var fullname:String?
    var coin:String?
    var id:String?
    var email:String?
    init (jsonData: JSON){
        username = jsonData["username"].stringValue
        phone = jsonData["phone"].stringValue
        avatar = jsonData["avatar"].stringValue
        description = jsonData["description"].stringValue
        coin = jsonData["coin"].stringValue
        id = jsonData["id"].stringValue
        email = jsonData["email"].stringValue
        fullname = jsonData["fullname"].stringValue
        print("user :\(jsonData)")
    }
}
