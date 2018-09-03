//
//  Constant.swift
//  facebook-live-ios-sample
//
//  Created by Hai Vu on 8/6/18.
//  Copyright © 2018 Hans Knoechel. All rights reserved.
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
        static let caption = "caption"
        static let id_room = "id_room"
        static let rtmps = "rtmps"
        static let width = "width"
        static let height = "height"
        static let id_category = "id_category"
        static let time_countdown = "time_countdown"
        static let language = "language"

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
enum ConfigKey:String{
    case countdown = "config_countdown"
    case random = "config_random"
    case countComment = "config_count_comment"
}
