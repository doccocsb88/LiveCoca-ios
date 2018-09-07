//
//  APIServices.swift
//  coca-live
//
//  Created by Apple on 8/1/18.
//  Copyright © 2018 Coca Live. All rights reserved.
//

import Foundation
enum HourCompare:Int{
    case before
    case equal
    case after
}
class APIUtils {
    static let APP_NAME = "ios"
//    static let APP_SECRET =  "5GJ7ITJ(*"//"SHeJK3fouW"
    static let APP_SECRET = "SHeJK3fouW"

    static let CLIENT_IP =  "::1"

//    checksum = md5( “[APP_NAME] : [REQUEST_URI] | [RAW_DATA] | [APP_SECRET] | [CLIENT_IP]” )
    static func checksum(request_url:String, raw_data:String) -> String{
        let string  = String(format: "%@:%@|%@|%@|%@",APP_NAME,request_url,raw_data,APP_SECRET,CLIENT_IP)
        return string.MD5(string)
    }
    
    static func compareHour(_ from:String,_ to:String) -> HourCompare{
        let fromElement = from.components(separatedBy: ":")
        let fromHour = Int(fromElement[0]) ?? 0
        let fromMins = Int(fromElement[1]) ?? 0
        var fromSecs = 0;
        if fromElement.count > 2 {
            fromSecs = Int(fromElement[2]) ?? 0
        }
        let fromTotalSecs = fromHour * 60 * 60 + fromMins * 60 + fromSecs
        let toElement = to.components(separatedBy: ":")
        let toHour = Int(toElement[0]) ?? 0
        let toMins = Int(toElement[1]) ?? 0
        var toSecs = 0;
        if toElement.count > 2 {
            toSecs = Int(toElement[2]) ?? 0
            
        }
        let toTotalSecs = toHour * 60 * 60 + toMins * 60 + toSecs
        if fromTotalSecs <= toTotalSecs{
            return .before
        }else if fromTotalSecs >= toTotalSecs{
            return .after
        }
        return .equal
    }
}
