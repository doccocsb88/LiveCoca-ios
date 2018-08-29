//
//  APIClient.swift
//  facebook-live-ios-sample
//
//  Created by Macintosh HD on 8/28/18.
//  Copyright © 2018 Hans Knoechel. All rights reserved.
//

import Alamofire
import SwiftyJSON

class APIClient {
    var token:String?
    var id:String?
    var user:User?
    static let sharedInstance : APIClient = {
        let instance = APIClient()
        return instance
    }()
    class func shared() -> APIClient {
        return sharedInstance
    }


    func login(username: String, password: String, completion:@escaping (_ result:Bool,_ message:String?)->Void) {
        Alamofire.request(APIRouter.login(username: username, password: password)).responseJSON {[weak self] response in
            guard let strongSelf = self else{
                return
            }
            guard response.result.isSuccess,
                let value = response.result.value else {
                    print("Error while fetching tags: \(String(describing: response.result.error))")
                    completion(false,"")
                    return
            }
            
            // 3
            let tags = JSON(value)
            print("\(tags)")
            if let error = tags["error"].dictionaryObject{
                print("error \(error)")
                let errorCode = error["code"]
                let explain = error["explain"] as? String
                completion(false,explain)
            }else{
                let id = tags["id"].stringValue
                let token  = tags["token"].stringValue
                APIClient.shared().id = id
                APIClient.shared().token = token
                strongSelf.getUser(completion: {
                    
                })
                strongSelf.getListAccount()
                completion(true,nil)

            }

        }
    }
    func getUser(completion:@escaping ()->Void){
        Alamofire.request(APIRouter.getUser()).responseJSON{ response in
            guard response.result.isSuccess,
                let value = response.result.value else {
                    print("Error while fetching tags: \(String(describing: response.result.error))")
                    return
            }
            
            // 3
            let json = JSON(value)
            self.user = User(jsonData: json)
        }
    }
    
    func getListAccount(){
//        {"list": [{"fullname": "Sự Kiện Thái Bình", "id": "tuzrxk", "id_social": "100004511980315"}]}
        Alamofire.request(APIRouter.getListAccounts()).responseJSON{response in
            guard response.result.isSuccess,
                let value = response.result.value else {
                    print("Error while fetching tags: \(String(describing: response.result.error))")
                    return
            }
            
            // 3
            let jsonResponse = JSON(value)
            if let list = jsonResponse["list"].array{
                for i in 0..<list.count{
                    if let acount = list[i].dictionaryObject{
                        print("\(acount["fullname"])")
                    }
                }
                
            }

            
        }
    }
}
