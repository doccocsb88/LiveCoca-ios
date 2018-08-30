//
//  APIRouter.swift
//  facebook-live-ios-sample
//
//  Created by Macintosh HD on 8/25/18.
//  Copyright © 2018 Hans Knoechel. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
enum APIRouter: URLRequestConvertible {
    
    case login(username:String, password:String)
    case register(fullname:String,username:String, password:String,email:String)
    case update(username:String?,password:String?,fullname:String?, phone:String?, email:String?,description:String?)
    case logout()
    case getUser()
    case getListAccounts()
    case deleteAccounts()
    //
    case createLive()
    case endLive()
    case hasStreaming(id_room:String)
    case getStatusStream()

    
    // MARK: - HTTPMethod
    private var method: HTTPMethod {
        switch self {
        case .login, .register, .update, .logout, .deleteAccounts:
            return .post
        case .getUser, .getListAccounts:
            return .get
        default:
            return .get
        }
    }
    
    // MARK: - Path
    private var path: String {
        switch self {
        case .login:
            let url =  "/users/login?app=ios"
            let checksum = APIUtils.checksum(request_url: url, raw_data: "")
            return String(format: "%@&checksum=%@", url,checksum)
        case .register(let fullname, let username, let password, let email):
            let url =  "/users/register?app=ios"
            let params:[String:String] = ["fullname":fullname,
                                          "username":username,
                                          "password":password,
                                          "email":email]
            let checksum = APIUtils.checksum(request_url: url, raw_data: JSON(params).stringValue)
            return String(format: "%@&checksum=%@", url,checksum)

        case .update(let username, let password, let fullname, let email, let phone, let description):
            let url =  "/users/update?app=ios"
            var params:[String:String] = [:]
            if let username = username{
                params["username"] = username
            }
            if let password = password{
                params["password"] = password
            }
            if let fullname = fullname{
                params["fullname"] = fullname
            }
            if let email = email{
                params["email"] = email
            }
            if let phone = phone{
                params["phone"] = phone
            }
            if let description = description{
                params["description"] = description
            }
            
            let checksum = APIUtils.checksum(request_url: url, raw_data: JSON(params).stringValue)
            return String(format: "%@&checksum=%@", url,checksum)
        case .getUser:
            let url =  "/users/get?app=ios"
            let params:[String:String] = [:]
            let checksum = APIUtils.checksum(request_url: url, raw_data: JSON(params).stringValue)
            return String(format: "%@&checksum=%@", url,checksum)
        case .logout:
            let url =  "/users/logout?app=ios"
            let params:[String:String] = [:]
            let checksum = APIUtils.checksum(request_url: url, raw_data: JSON(params).stringValue)
            return String(format: "%@&checksum=%@", url,checksum)
        case .getListAccounts:
            let url = "/users/accounts?app=ios"
            let params:[String:String] = [:]
            let checksum = APIUtils.checksum(request_url: url, raw_data: JSON(params).stringValue)
            return String(format: "%@&checksum=%@", url,checksum)
        case .deleteAccounts:
            return "/users/delete?app=ios"

        default:
            return ""
            
        }
    }
    
    // MARK: - Parameters
    private var parameters: Parameters? {
        switch self {
        case .register(let fullname, let username, let password, let email):
            return [K.APIParameterKey.fullname:fullname, K.APIParameterKey.username: username, K.APIParameterKey.password: password, K.APIParameterKey.email: email]
        case .login(let username, let password):
            return [K.APIParameterKey.username: username, K.APIParameterKey.password: password]
        case .update(let username, let password, let fullname, let email, let phone, let description):
            return [K.APIParameterKey.username: username, K.APIParameterKey.password: password, K.APIParameterKey.fullname:fullname, K.APIParameterKey.email: email, K.APIParameterKey.phone:phone, K.APIParameterKey.description:description]
            
        default:
            return nil
            
        }
    }
    
    // MARK: - URLRequestConvertible
    func asURLRequest() throws -> URLRequest {
        var fullURL = String(format: "%@%@", K.ProductionServer.baseAPIURL,path)
        if let token = APIClient.shared().token{
            fullURL = String(format: "%@&token=%@", fullURL,token)
        }
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
