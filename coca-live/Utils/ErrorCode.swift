//
//  ErrorCode.swift
//  coca-live
//
//  Created by Macintosh HD on 8/19/18.
//  Copyright © 2018 Coca Live. All rights reserved.
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
    static let Error_Message_Generic:String     = "Lỗi hệ thống"
    static let Error_Generic:Int                = 0//, "Unknown")
    static let Error_DB:Int                     = 909//, "Database")
    static let Error_UserNotFound:Int           = 202//, )
    static let Error_ExistStream                = 403
    static let Error_Fb_session_expired         = 190
    static func message(code:Int, message:String) ->String{
        switch code {
        case Error_Generic:
            return "Lỗi hệ thống"
        case Error_UserNotFound:
            return "Tài khoản đăng nhập hoặc mật khẩu không đúng, vui lòng đăng nhập lại!"
        case Error_ExistStream:
            return "You are having streaming"
        case Error_Fb_session_expired:
            return "Access token đã hết hạn hoặc tài khoản này đang bị khóa livestream. Bạn hãy thêm lại tài khoản này hoặc thêm tài khoản khác."
        default:
            return message
        }
    }

    
}
