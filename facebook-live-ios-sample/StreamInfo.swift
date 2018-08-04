//
//  StreamInfo.swift
//  facebook-live-ios-sample
//
//  Created by Apple on 8/4/18.
//  Copyright © 2018 Hans Knoechel. All rights reserved.
//

import Foundation
class StreamInfo {
    let streamId:String
    let urlString:String
    let description:String?
    init(jsonData: [String:Any]) {
        
        streamId = jsonData["id"] as! String
        urlString = jsonData["stream_url"] as! String
        description = ""
    }
    
    
}
