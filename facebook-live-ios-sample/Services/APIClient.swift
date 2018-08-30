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
    var accounts:[BaseInfo] = []
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
                    if let data = list[i].dictionaryObject{
                        print("\(data["fullname"])")
                        let account = BaseInfo()
                        account.displayName = data["fullname"] as? String
                        account.userId = data["id_social"] as? String
                        self.accounts.append(account)
                        
                    }
                }
                
            }
        }
    }
    
    func updateAccount(username:String?,password:String?,fullname:String?, phone:String?, email:String?,description:String?){
        Alamofire.request(APIRouter.update(username: username, password: password, fullname: fullname, phone: phone, email: email, description: description)).responseJSON{response in
            guard response.result.isSuccess,
                let value = response.result.value else {
                    print("Error while fetching tags: \(String(describing: response.result.error))")
                    return
            }
            
            // 3
            let jsonResponse = JSON(value)
            print("\(jsonResponse.stringValue)")
        }
    }
    
    func addFacebook(access_token:String,completion:@escaping (_ success:Bool,_ message:String?)->Void){
        Alamofire.request(FacebookEndpoint.addFacebook(access_token:access_token)).responseJSON{response in
            guard response.result.isSuccess,
                let value = response.result.value else {
                    print("Error while fetching tags: \(String(describing: response.result.error))")
                    completion(false,String(describing: response.result.error))
                    return
            }
            
            // 3
            let jsonResponse = JSON(value)
            print("addFacebook \(jsonResponse.dictionaryValue)")
            if let error = jsonResponse["error"].dictionaryObject{
                print("error \(error)")
                let errorCode = error["code"]
                let explain = error["explain"] as? String
                completion(false,explain)
            }else{
                completion(true,"")

            }

        }
    }
    func getFacebookTargets(id_social:String,completion:@escaping (_ success:Bool,_ message:String?,_ targets:[SocialTarget]?)->Void){
        Alamofire.request(FacebookEndpoint.target(id_social:id_social)).responseJSON{response in
            guard response.result.isSuccess,
                let value = response.result.value else {
                    print("Error while fetching tags: \(String(describing: response.result.error))")
                    completion(false,String(describing: response.result.error),nil)
                    return
            }
            
            // 3
            let jsonResponse = JSON(value)
            print("getFacebookTargets \(jsonResponse.dictionaryValue)")
            if let error = jsonResponse["error"].dictionaryObject{
                print("error \(error)")
                let errorCode = error["code"]
                let explain = error["explain"] as? String
                completion(false,explain,nil)
            }else{
//                ["fanpages": [
//                    {
//                        "id" : "159903551328819",
//                        "name" : "Nội thất chung cư"
//                    },
//                    {
//                        "id" : "365180880236594",
//                        "name" : "Sự kiện miền bắc"
//                    },
//                    {
//                        "id" : "518189581542420",
//                        "name" : "Tùng cương sự kiện"
//                    }
//                    ], "groups": [
//
//                    ], "timelines": [
//                        {
//                            "id" : "1002824963211227",
//                            "name" : "Sự Kiện Thái Bình"
//                        }
//                    ], "events": [
//
//                    ]]
                var targets:[SocialTarget] = []
                if let fanpages = jsonResponse["fanpages"].array{
                    for i in 0..<fanpages.count{
                        if let data = fanpages[i].dictionaryObject{
                            guard let id = data["id"] as? String else{
                                return
                            }
                            guard let name = data["name"] as? String else{
                                return
                            }
                            let target = SocialTarget(id:id,name:name)
                            targets.append(target)
                        }
                        
                    }
                }
                if let timelines = jsonResponse["timelines"].array{
                    for i in 0..<timelines.count{
                        if let data = timelines[i].dictionaryObject{
                            guard let id = data["id"] as? String else{
                                return
                            }
                            guard let name = data["name"] as? String else{
                                return
                            }
                            let target = SocialTarget(id:id,name:name)
                            targets.append(target)

                        }
                    }
                }
                completion(true,nil,targets)
                
            }
            
        }

    }
    func createLive(id_social:String,id_target:String,caption:String,completion:@escaping (_ success:Bool,_ message:String?,_ streamInfo:StreamInfo?)->Void){
        Alamofire.request(FacebookEndpoint.createLive(id_social:id_social,id_target: id_target, caption: caption)).responseJSON{response in
            guard response.result.isSuccess,
                let value = response.result.value else {
                    print("Error while fetching tags: \(String(describing: response.result.error))")
                    completion(false,String(describing: response.result.error),nil)
                    return
            }
            
            // 3
            let jsonResponse = JSON(value)
            print("createLive \(jsonResponse.dictionaryValue)")
            if let error = jsonResponse["error"].dictionaryObject{
                print("error \(error)")
                let errorCode = error["code"]
                let explain = error["explain"] as? String
                completion(false,explain,nil)
            }else{
//?                ["status": 1, "id_video": 1045144052312651, "id_stream": 1045144055645984, "stream_url": rtmp://live-api-s.facebook.com:80/rtmp/1045144055645984?ds=1&s_sw=0&s_vt=api-s&a=AThlQecF2A1OuhKc]

                let streamInfo = StreamInfo(jsonData: jsonResponse.dictionaryObject ?? [:])
                completion(true,nil,streamInfo)
                
            }
            
        }
        
    }

}
