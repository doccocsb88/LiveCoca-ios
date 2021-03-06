//
//  FacebookInfo.swift
//  coca-live
//
//  Created by Apple on 7/28/18.
//  Copyright © 2018 Coca Live. All rights reserved.
//

import Foundation
import SwiftyJSON
class FacebookInfo: BaseInfo{
    var photoUrl:String?
    var email: String?
    var pages:[BaseInfo] = [];
    static let sharedInstance : FacebookInfo = {
        let instance = FacebookInfo()
        return instance
    }()
    
    //MARK: Local Variable
    
    
    //MARK: Init
    init(jsonData:[String:Any]) {
        let firstNameFB = jsonData["first_name"] as? String
        let lastNameFB = jsonData["last_name"] as? String
        let socialIdFB = jsonData["id"] as? String
        let genderFB = jsonData["gender"] as? String
        let pictureUrlFB = jsonData["picture"] as? [String:Any]
        if let pic = pictureUrlFB{
            let photoData = pic["data"] as? [String:Any]
            if let _ = photoData{
                photoUrl = photoData!["url"] as? String
            }
        }
    }
    init(jsonData:JSON){
        
    }
    override init() {
    }
    class func shared() -> FacebookInfo {
        return sharedInstance
    }

}
