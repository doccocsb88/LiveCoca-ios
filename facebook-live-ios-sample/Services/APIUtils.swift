//
//  APIServices.swift
//  facebook-live-ios-sample
//
//  Created by Apple on 8/1/18.
//  Copyright © 2018 Hans Knoechel. All rights reserved.
//

import Foundation
import Alamofire
class APIUtils {
    static let APP_NAME = "ios"
    static let APP_SECRET =  "SHeJK3fouW"
    static let CLIENT_IP =  "::1"

//    checksum = md5( “[APP_NAME] : [REQUEST_URI] | [RAW_DATA] | [APP_SECRET] | [CLIENT_IP]” )
    static func checksum(request_url:String, raw_data:String) -> String{
        let string  = String(format: "%@:%@|%@|%@|%@",APP_NAME,request_url,raw_data,APP_SECRET,CLIENT_IP)
        return string.MD5(string)
    }
}
