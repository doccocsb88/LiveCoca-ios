//
//  APIClient.swift
//  facebook-live-ios-sample
//
//  Created by Macintosh HD on 8/28/18.
//  Copyright © 2018 Hans Knoechel. All rights reserved.
//

import Alamofire
class APIClient {
    

    static func login(username: String, password: String, completion:@escaping (Result<User>)->Void) {
        Alamofire.request(APIRouter.login(username: username, password: password)).responseJSON { response in
            print(response)
            //to get status code
            if let status = response.response?.statusCode {
                switch(status){
                case 201:
                    print("example success")
                default:
                    print("error with response status: \(status)")
                }
            }
            //to get JSON return value
            if let result = response.result.value {
                let JSON = result as! NSDictionary
                print(JSON)
            }

        }
    }
}
