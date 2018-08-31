//
//  ErrorCode.swift
//  facebook-live-ios-sample
//
//  Created by Macintosh HD on 8/19/18.
//  Copyright © 2018 Hans Knoechel. All rights reserved.
//

import Foundation
enum ErrorCode: Int {
    case error_fb_session_invalid = 467
    case error_fb_session_expired = 190
}


//struct APIError {
//    static let Error_Generic = (0, "Unknown")
//    static let Error_DB = (909, "Database")
//}

struct APIError {
     static let Error_Generic:Int                = 0//, "Unknown")
     static let Error_DB:Int                     = 909//, "Database")
     static let Error_UserNotFound:Int           = 202//, )
    static func message(code:Int, message:String) ->String{
        switch code {
        case Error_Generic:
            return "Unknown"
        case Error_UserNotFound:
            return "Tài khoản đăng nhập hoặc mật khẩu không đúng, vui lòng đăng nhập lại!"
        default:
            return message
        }
    }

    
}
