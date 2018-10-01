//
//  Constant.swift
//  coca-live
//
//  Created by Hai Vu on 8/6/18.
//  Copyright © 2018 Coca Live. All rights reserved.
//

import Foundation
struct K {
    struct ProductionServer {
        static let baseAPIURL = "http://live.cocalive.com:4000"
        static let baseURL = "https://live.cocalive.com"
    }
    
    struct APIParameterKey {
        static let password = "password"
        static let email = "email"
        static let username = "username"
        static let phone = "phone"
        static let fullname = "fullname"
        static let description = "description"
        static let token = "token"
        static let access_token = "access_token"
        static let id_social = "id_social"
        static let id_target = "id_target"
        static let id_account = "id_account"

        static let caption = "caption"
        static let id_room = "id_room"
        static let rtmps = "rtmps"
        static let width = "width"
        static let height = "height"
        static let id_category = "id_category"
        static let time_countdown = "time_countdown"
        static let language = "language"
        //
        static let filter_title = "filter_title"
        static let filter_status = "filter_status"
        static let page = "page"
        static let page_size = "page_size"
        static let order_by = "order_by"

        //
        
    }
    struct APIUploadType{
        static let unknow = "unknow"
        static let frame = "frame"
        static let avatar = "avatar"
        static let screen_wait  = "screen_wait"
        static let screen_bye   = "screen_bye"
    }

}

enum HTTPHeaderField: String {
    case authentication = "Authorization"
    case contentType = "Content-Type"
    case acceptType = "Accept"
    case acceptEncoding = "Accept-Encoding"
}

enum ContentType: String {
    case json = "application/json"
}
enum StreamState:Int{
    case Init = 1
    case Created = 2
    case Streaming = 3
    case Ended = 4
}
//enum ConfigKey:String{
//    case countdown = "config_countdown"
//    case random = "config_random"
//    case countComment = "config_count_comment"
//    case filterComment = "config_filter_comment"
//}
struct ConfigKey{
    static let countdown = "config_countdown"
    static let random = "config_random"
    static let countComment = "config_count_comment"
    static let filterComment = "config_filter_comment"
    static let childImage = "config_child_image"
}
