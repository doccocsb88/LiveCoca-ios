//
//  UserEndpoint.swift
//  facebook-live-ios-sample
//
//  Created by Macintosh HD on 8/25/18.
//  Copyright © 2018 Hans Knoechel. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
enum FacebookEndpoint: URLRequestConvertible {
    case get()
    case target(id_social:String)
    case addFacebook(access_token:String)
    case createLive(id_social:String,id_target:String,caption:String)
    case liveStatus(id_stream:String)
    case login(email:String, password:String)
    case profile(id: Int)
    
    // MARK: - HTTPMethod
    var method: HTTPMethod {
        switch self {
        case .login , .addFacebook, .createLive:
            return .post
        case .profile, .liveStatus , .target:
            return .get
        default:
            return .get
        }
    }
    
    // MARK: - Path
    var path: String {
        switch self {
        case .liveStatus(let id_stream):
            return "/facebook/live_status?app=ios&checksum=6c3de2526c041b3d0a129172564fca08&id_stream=\(id_stream)"
        case .createLive:
            let url =  "/facebook/create_live?app=ios"
            let checksum = APIUtils.checksum(request_url: url, raw_data: JSON(parameters ?? [:]).stringValue)
            return String(format: "%@&checksum=%@", url,checksum)

        case .addFacebook:
            let url =  "/facebook/add?app=ios"
            let checksum = APIUtils.checksum(request_url: url, raw_data: JSON(parameters ?? [:]).stringValue)
            return String(format: "%@&checksum=%@", url,checksum)
        case .target(let id_social):
            let url = "/facebook/targets?app=ios"
            let checksum = APIUtils.checksum(request_url: url, raw_data: JSON(parameters ?? [:]).stringValue)
            return String(format: "%@&checksum=%@&token=%@&id_social=%@", url,checksum,APIClient.shared().token ?? "",id_social)

        case .login:
            return "/login"
        case .profile(let id):
            return "/profile/\(id)"
        default:
            return ""
        }
    }
    
    // MARK: - Parameters
    var parameters: Parameters? {
        switch self {
        case .addFacebook(let access_token):
            var params:[String:String] = [:]
            params[K.APIParameterKey.token] = APIClient.shared().token ?? ""
            params[K.APIParameterKey.access_token] = access_token
            return params
        case .createLive(let id_social, let id_target, let caption):
            var params:[String:String] = [:]
            params[K.APIParameterKey.id_social] = id_social
            params[K.APIParameterKey.id_target] = id_target
            params[K.APIParameterKey.caption] = caption
            params[K.APIParameterKey.token] = APIClient.shared().token ?? ""
            return params
        case .login(let email, let password):
            return [K.APIParameterKey.email: email, K.APIParameterKey.password: password]
        case .profile:
            return nil
        default:
            return nil
        }
    }
    
    // MARK: - URLRequestConvertible
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
