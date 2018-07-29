//
//  FacebookInfo.swift
//  facebook-live-ios-sample
//
//  Created by Apple on 7/28/18.
//  Copyright © 2018 Hans Knoechel. All rights reserved.
//

import Foundation
class FacebookInfo: BaseInfo{
 
    var email: String?
    var pages:[BaseInfo] = [];
    static let sharedInstance : FacebookInfo = {
        let instance = FacebookInfo()
        return instance
    }()
    
    //MARK: Local Variable
    
    
    //MARK: Init
    
    override init() {
    }
    class func shared() -> FacebookInfo {
        return sharedInstance
    }

}
