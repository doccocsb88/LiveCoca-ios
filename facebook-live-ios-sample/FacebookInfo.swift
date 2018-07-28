//
//  FacebookInfo.swift
//  facebook-live-ios-sample
//
//  Created by Apple on 7/28/18.
//  Copyright © 2018 Hans Knoechel. All rights reserved.
//

import Foundation
class FacebookInfo {
    var tokenString: String?
    var userId: String?
    var displayName: String?
    var email: String?
    var pages:[FacebookInfo] = [];
    static let sharedInstance : FacebookInfo = {
        let instance = FacebookInfo()
        return instance
    }()
    
    //MARK: Local Variable
    
    
    //MARK: Init
    
    init() {
    }
    class func shared() -> FacebookInfo {
        return sharedInstance
    }

}
