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
            print(response.request)
            print(response.response)
            print(response.data)
            print(response.result)
            print(response)

        }
    }
}
