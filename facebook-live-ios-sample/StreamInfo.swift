//
//  StreamInfo.swift
//  facebook-live-ios-sample
//
//  Created by Apple on 8/4/18.
//  Copyright © 2018 Hans Knoechel. All rights reserved.
//

import Foundation
import SwiftyJSON
class StreamInfo {
    let streamId:String
    let urlString:String
    let description:String?
    let status:Int
    let videoID:String
//    {"status": 1, "stream_url": "rtmp://live-api-s.facebook.com:80/rtmp/1044499249043798?ds=1&s_sw=0&s_vt=api-s&a=ATitHxfUOPcyFHc5", "id_stream": "1044499249043798", "id_video": "1044499245710465"}
    init(jsonData: [String:Any]) {
        status = jsonData["status"] as? Int ?? 0
        streamId = jsonData["id_stream"] as? String ?? ""
        urlString = jsonData["stream_url"] as? String ?? ""
        description = ""
        videoID = jsonData["id_video"] as? String ?? ""
    }
    init(jsonData:JSON) {
        status = jsonData["status"].intValue
        streamId = jsonData["id_stream"].stringValue
        urlString = jsonData["stream_url"].stringValue
        description = ""
        videoID = jsonData["id_video"].stringValue

    }
    
    
}
