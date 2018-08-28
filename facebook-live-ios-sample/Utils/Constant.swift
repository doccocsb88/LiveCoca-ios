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
        static let baseURL = "http://live.cocalive.com:4000"
    }
    
    struct APIParameterKey {
        static let password = "password"
        static let email = "email"
        static let username = "username"
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
    case random = "config_random"
    case countComment = "config_count_comment"
}
