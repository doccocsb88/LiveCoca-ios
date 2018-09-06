//
//  StreamInfo.swift
//  coca-live
//
//  Created by Apple on 8/4/18.
//  Copyright © 2018 Coca Live. All rights reserved.
//

import Foundation
import SwiftyJSON
class StreamInfo {
    let streamId:String
    let urlString:String
    let description:String?
    let status:Int
    let videoID:String
    var id_target:String?
    var id_social:String?
//    {"status": 1, "stream_url": "rtmp://live-api-s.facebook.com:80/rtmp/1044499249043798?ds=1&s_sw=0&s_vt=api-s&a=ATitHxfUOPcyFHc5", "id_stream": "1044499249043798", "id_video": "1044499245710465"}
    init(jsonData: [String:Any]) {
        status = jsonData["status"] as? Int ?? 0
        streamId = jsonData["id_stream"] as? String ?? ""
        urlString = jsonData["stream_url"] as? String ?? ""
        description = ""
        videoID = jsonData["id_video"] as? String ?? ""
        id_target = ""
        id_social = ""
    }
    init(jsonData:JSON) {
        status = jsonData["status"].intValue
        streamId = jsonData["id_stream"].stringValue
        urlString = jsonData["stream_url"].stringValue
        description = ""
        videoID = jsonData["id_video"].stringValue
        id_target = ""
        id_social = ""

    }
    func toJSON() -> [String:Any]{
        let json =  [
            "stream_url": self.urlString,
            "id_video": self.videoID,
            "id_stream": self.streamId,
            "caption": self.description ?? "CocaLive",
            "id_target": self.id_target ?? "",
            "id_social": self.id_social ?? ""
        ]
        return json
    }

    func toJSONStrinng() ->String{
        if let theJSONData = try? JSONSerialization.data(
            withJSONObject: toJSON(),
            options: []) {
            let theJSONText = String(data: theJSONData,
                                     encoding: .ascii)
            print("JSON string = \(theJSONText!)")
            return theJSONText ?? ""
        }
        
        return ""
    }
    func getLiveStreamUrl() ->String{
        var url  = self.urlString.replacingOccurrences(of: "443", with: "80")
        url = url.replacingOccurrences(of: "rtmps", with: "rtmp")
        return url
    }
    
}
