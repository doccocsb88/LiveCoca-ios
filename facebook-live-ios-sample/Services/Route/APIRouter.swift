//
//  APIRouter.swift
//  facebook-live-ios-sample
//
//  Created by Macintosh HD on 8/25/18.
//  Copyright © 2018 Hans Knoechel. All rights reserved.
//

import UIKit
import Alamofire
enum APIRouter: URLRequestConvertible {
    
    case login(username:String, password:String)
    case register(fullname:String,username:String, password:String,email:String)
    case update(token:String,email:String)
    case logout()
    case getUser()
    case getListAccounts()
    case deleteAccounts()
    //
    case createLive()
    case endLive()
    case hasStreaming(id_room:String)
    case getStatusStream()
    case posts
    case post(id: Int)
    
    // MARK: - HTTPMethod
    private var method: HTTPMethod {
        switch self {
        case .login, .register, .update, .logout, .deleteAccounts:
            return .post
        case .posts, .post, .getUser, .getListAccounts:
            return .get
        default:
            return .get
        }
    }
    
    // MARK: - Path
    private var path: String {
        switch self {
        case .login:
            return "/users/login"
        case .register:
            return "/users/register"
        case .update:
            return "/users/update"
        case .getUser:
            return "/users/get"
        case .logout:
            return "/users/logout"
        case .getListAccounts:
            return "/users/accounts"
        case .deleteAccounts:
            return "/users/delete"
        case .posts:
            return "/posts"
        case .post(let id):
            return "/posts/\(id)"
        default:
            return ""
            
        }
    }
    
    // MARK: - Parameters
    private var parameters: Parameters? {
        switch self {
        case .login(let username, let password):
            return [K.APIParameterKey.username: username, K.APIParameterKey.password: password]
        case .posts, .post:
            return nil
        default:
            return nil
            
        }
    }
    
    // MARK: - URLRequestConvertible
    func asURLRequest() throws -> URLRequest {
        let url = try K.ProductionServer.baseURL.asURL()
        let fullPath = String(format: "%@?app=ios&checksum=6c3de2526c041b3d0a129172564fca08", path)
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(fullPath))
        
        // HTTP Method
        urlRequest.httpMethod = method.rawValue
        
        // Common Headers
//        urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.acceptType.rawValue)
//        urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
        
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
