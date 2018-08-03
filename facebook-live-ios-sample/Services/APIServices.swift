//
//  APIServices.swift
//  facebook-live-ios-sample
//
//  Created by Apple on 8/1/18.
//  Copyright © 2018 Hans Knoechel. All rights reserved.
//

import Foundation
import Alamofire
class APIServices {
    enum Constants {
        static let loginURLPath = "http://api.cocalive.com/users"
        static let authenticationToken = "Basic xxx"
    }
    static let sharedInstance : APIServices = {
        let instance = APIServices()
        return instance
    }()
    init(){
        
    }
    class func shared() -> APIServices {
        return sharedInstance
    }
    func login(username:String, password:String,completion: @escaping ([User]?) -> Void) {
        guard let url = URL(string: Constants.loginURLPath) else {
            completion(nil)
            return
        }
        Alamofire.request(url,
                          method: .get,
                          parameters: ["username": username,"password":password])
            .validate()
            .responseJSON { response in
                guard response.result.isSuccess else {
                    print("Error while fetching remote rooms: \(String(describing: response.result.error))")
                        completion(nil)
                    return
                }
                
                guard let value = response.result.value as? [String: Any],
                    let rows = value["rows"] as? [[String: Any]] else {
                        print("Malformed data received from fetchAllRooms service")
                        completion(nil)
                        return
                }
                
                let rooms = rows.compactMap { roomDict in return User(jsonData: roomDict) }
                completion(rooms)
        }
    }
}
