//
//  StreamEndpoint.swift
//  facebook-live-ios-sample
//
//  Created by Macintosh HD on 9/1/18.
//  Copyright © 2018 Hans Knoechel. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire
enum StreamEmdpoint: URLRequestConvertible {
    case createLive(rtmps:StreamInfo,width:Int,height:Int, id_category:String,time_countdown:Int)
    case endLive(id_room:String)
    case hasStreaming()
    case statusStream(id_room:String)
    var method: HTTPMethod {
        switch self {
        case .createLive, .endLive:
            return .post
        
        case .hasStreaming, .statusStream:
            return .get
        }
    }
    var path: String {
        switch self {
        case .createLive:
            let url =  "/livestream/create_live?app=ios"
            let checksum = APIUtils.checksum(request_url: url, raw_data: JSON(parameters ?? [:]).stringValue)
            return String(format: "%@&checksum=%@", url,checksum)

        case .endLive:
            let url =  "/livestream/end_live?app=ios"
            let checksum = APIUtils.checksum(request_url: url, raw_data: JSON(parameters ?? [:]).stringValue)
            return String(format: "%@&checksum=%@", url,checksum)

        case .hasStreaming:
            let url =  "/livestream/has_streaming?app=ios"
            let checksum = APIUtils.checksum(request_url: url, raw_data: JSON(parameters ?? [:]).stringValue)
            return String(format: "%@&checksum=%@&token=%@", url,checksum,APIClient.shared().token ?? "")

        case .statusStream(let id_room):
            let url =  "/livestream/status?app=ios"
            let checksum = APIUtils.checksum(request_url: url, raw_data: JSON(parameters ?? [:]).stringValue)
            return String(format: "%@&checksum=%@&id_room=%@", url,checksum,id_room)

        }
    }
    var parameters: Parameters? {
        var params:[String:Any] = [:]
        switch self {
        case .createLive(let rtmps, let width, let height, let id_category, let time_countdown):
            params[K.APIParameterKey.token] = APIClient.shared().token ?? ""
//            var info:[JSON] = []
//            info.append(JSON(rtmp.toJSON()))
            params[K.APIParameterKey.rtmps] = [rtmps.toJSON()]
            params[K.APIParameterKey.width] = width
            params[K.APIParameterKey.height] = height
            params[K.APIParameterKey.id_category] = id_category
            params[K.APIParameterKey.time_countdown] = time_countdown
            params[K.APIParameterKey.language] = "vi"
            print("createLive\(params)")
            return params
        case .endLive(let id_room):
            params[K.APIParameterKey.token] = APIClient.shared().token ?? ""
            params[K.APIParameterKey.id_room] = id_room
            return params
        case .hasStreaming:
            return nil
        case .statusStream:
            return params
        }
    }
    func asURLRequest() throws -> URLRequest {
        let fullURL = String(format: "%@%@", K.ProductionServer.baseAPIURL,path)
        
        let url = try fullURL.asURL()
        
        var urlRequest = URLRequest(url: url)
        
        // HTTP Method
        urlRequest.httpMethod = method.rawValue
        
        // Common Headers
        urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.acceptType.rawValue)
        urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
        
        // Parameters
        if let parameters = parameters {
            do {
                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
            } catch {
                throw AFError.parameterEncodingFailed(reason: .jsonEncodingFailed(error: error))
            }
        }
        
        return urlRequest

    }

}
