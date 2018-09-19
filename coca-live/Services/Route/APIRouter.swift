//
//  APIRouter.swift
//  coca-live
//
//  Created by Macintosh HD on 8/25/18.
//  Copyright © 2018 Coca Live. All rights reserved.
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
    case deleteAccounts(id_account:String)
    case upload(type:String, title:String?, url:String? ,image:UIImage?)
    //
//    case createLive()
//    case endLive()
//    case hasStreaming(id_room:String)
//    case getStatusStream()

    
    // MARK: - HTTPMethod
    private var method: HTTPMethod {
        switch self {
        case .login, .register, .update, .logout, .deleteAccounts, .upload:
            return .post
        case .getUser, .getListAccounts:
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
        case .register:
            let url =  "/users/register?app=ios"
            let checksum = APIUtils.checksum(request_url: url, raw_data: JSON(parameters ?? [:]).stringValue)
            return String(format: "%@&checksum=%@", url,checksum)

        case .update:
            let url =  "/users/update?app=ios"
            let checksum = APIUtils.checksum(request_url: url, raw_data: JSON(parameters ?? [:]).stringValue)
            return String(format: "%@&checksum=%@", url,checksum)
        case .getUser:
            let url =  "/users/get?app=ios"
            let params:[String:String] = [:]
            let checksum = APIUtils.checksum(request_url: url, raw_data: JSON(params).stringValue)
            return String(format: "%@&checksum=%@&token=%@", url,checksum,APIClient.shared().token ?? "")
        case .logout:
            let url =  "/users/logout?app=ios"
            let checksum = APIUtils.checksum(request_url: url, raw_data: JSON(parameters ?? [:]).stringValue)
            return String(format: "%@&checksum=%@&token=%@", url,checksum,APIClient.shared().token ?? "")
        case .getListAccounts:
            let url = "/users/accounts?app=ios"
            let params:[String:String] = [:]
            let checksum = APIUtils.checksum(request_url: url, raw_data: JSON(params).stringValue)
            return String(format: "%@&checksum=%@&token=%@", url,checksum,APIClient.shared().token ?? "")
        case .deleteAccounts:
            let url =  "/users/delete?app=ios"
            let checksum = APIUtils.checksum(request_url: url, raw_data: JSON(parameters ?? [:]).stringValue)
            return String(format: "%@&checksum=%@", url,checksum)
        case .upload:
            
            let url =  "/uploads?app=ios"
            let checksum = APIUtils.checksum(request_url: url, raw_data: JSON(parameters ?? [:]).stringValue)
            return String(format: "%@&checksum=%@", url,checksum)
            
        }
    }
    
    // MARK: - Parameters
    private var parameters: Parameters? {
        switch self {
        case .register(let fullname, let username, let password, let email):
            return [K.APIParameterKey.fullname:fullname, K.APIParameterKey.username: username, K.APIParameterKey.password: password, K.APIParameterKey.email: email]
        case .login(let username, let password):
            return [K.APIParameterKey.username: username, K.APIParameterKey.password: password]
        case .logout:
            return [:]
        case .update(let username, let password, let fullname, let email, let phone, let description):
            var params:[String:String] = [:]
            if let _username = username{
                params[K.APIParameterKey.username] = _username
            }
            if let _password = password{
                params[K.APIParameterKey.password] = _password
            }
            if let _fullname = fullname{
                params[K.APIParameterKey.fullname] = _fullname
            }
            if let _email = email{
                params[K.APIParameterKey.email] = _email
            }
            if let _phone = phone{
                params[K.APIParameterKey.phone] = _phone
            }
            if let _des = description{
                params[K.APIParameterKey.description] = _des
            }
            if let token = APIClient.shared().token{
                params[K.APIParameterKey.token] = token

            }
            return params
        case .deleteAccounts(let id_account):
            var params:[String:Any] = [:]
            if let token = APIClient.shared().token{
                params[K.APIParameterKey.token] = token
                
            }
            params[K.APIParameterKey.id_account] = id_account
            return params
        case .upload(let type, let title, let url, _):
            var params:[String:Any] = [:]
            if let token = APIClient.shared().token{
                params[K.APIParameterKey.token] = token
                
            }
            params["type"] = type
            if let title = title{
                params["title"] = title
            }
            
            if let url = url{
                params["url"] = url
            }
            return params
            
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
