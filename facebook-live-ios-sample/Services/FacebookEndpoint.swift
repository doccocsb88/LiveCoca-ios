//
//  UserEndpoint.swift
//  facebook-live-ios-sample
//
//  Created by Macintosh HD on 8/25/18.
//  Copyright © 2018 Hans Knoechel. All rights reserved.
//

import UIKit
import Alamofire
enum UserEndpoint: URLRequestConvertible {
    case get()
    case target(token:String,id_social:String)
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
        case .profile, .liveStatus:
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
            return "/facebook/create_live?app=ios&checksum=01ecded5183fdc7e7ae5e373f0080a26"
        case .addFacebook:
            return "/facebook/add?app=ios&checksum=01ecded5183fdc7e7ae5e373f0080a26"
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
        case .login(let email, let password):
            return [K.APIParameterKey.email: email, K.APIParameterKey.password: password]
        case .profile:
            return nil
        }
    }
    
    // MARK: - URLRequestConvertible
    func asURLRequest() throws -> URLRequest {
        let url = try K.ProductionServer.baseURL.asURL()
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        
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
