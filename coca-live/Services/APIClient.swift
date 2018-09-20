//
//  APIClient.swift
//  coca-live
//
//  Created by Macintosh HD on 8/28/18.
//  Copyright © 2018 Coca Live. All rights reserved.
//

import Alamofire
import SwiftyJSON

class APIClient {
    static let DEFAULT_CAPTION = "Coca live"
    var token:String?
    var id:String?
    var user:User?
    var accounts:[BaseInfo] = []
    var comments:[FacebookComment] = []
    static let sharedInstance : APIClient = {
        let instance = APIClient()
        return instance
    }()
    class func shared() -> APIClient {
        return sharedInstance
    }

    func clearData(){
        accounts = []
        user = nil
        id = nil
        token = nil
        comments = []
    }
    func removeAccount(_ id:String){
        for index in 0..<accounts.count {
            let account = accounts[index]
            if let _id = account.id{
                if _id == id{
                    accounts.remove(at: index)
                    break
                }
            }
        }
    }
    func countComment(message:String) -> Int{
        var count = 0
        for comment in comments{
            if message == comment.message{
                count += 1
            }
        }
        return count
    }
    func register(username:String,password:String,fullname:String,email:String,completion:@escaping (_ success:Bool,_ message:String)->Void){
        Alamofire.request(APIRouter.register(fullname: fullname, username: username, password: password, email: email)).responseJSON {response in
            guard response.result.isSuccess,
                let value = response.result.value else {
                    print("Error while fetching tags: \(String(describing: response.result.error))")
                    completion(false,String(describing: response.result.error))
                    return
            }
            // 3
            let jsonResponse = JSON(value)
            print("register \(jsonResponse)")

            if let error = jsonResponse["error"].dictionaryObject{
                print("error \(error)")
                let errorCode = error["code"] as? Int
                let explain = error["explain"] as? String
                let errorMessage = APIError.message(code: errorCode ?? 0, message: explain ?? "")
                completion(false,errorMessage)
            }else{
//                "id" : "tuznzb",
//                "token" : "SPCHU2MW1LA6VPB6F86J19C1W75LW7RT1536241141"
                let id = jsonResponse["id"].stringValue
                if let  token = jsonResponse["token"].string{
                    self.token = token
                    self.id = id
                    completion(true,"")

                }else{
                    completion(false,APIError.Error_Message_Generic)

                }
                
            }

        }
    }
    func login(username: String, password: String, completion:@escaping (_ result:Bool,_ message:String)->Void) {
        Alamofire.request(APIRouter.login(username: username, password: password)).responseJSON {[weak self] response in
            guard let strongSelf = self else{
                return
            }
            guard response.result.isSuccess,
                let value = response.result.value else {
                    print("Error while fetching tags: \(String(describing: response.result.error))")
                    completion(false,String(describing: response.result.error))
                    return
            }
            
            // 3
            let tags = JSON(value)
            print("\(tags)")
            if let error = tags["error"].dictionaryObject{
                print("error \(error)")
                let errorCode = error["code"] as? Int
                let explain = error["explain"] as? String
                let errorMessage = APIError.message(code: errorCode ?? 0, message: explain ?? "")
                completion(false,errorMessage)
            }else{
                let id = tags["id"].stringValue
                let token  = tags["token"].stringValue
                APIClient.shared().id = id
                APIClient.shared().token = token
                completion(true,"")

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
    
    func getListAccount(completion:@escaping (_ success:Bool,_ message:String?)->Void){
//        {"list": [{"fullname": "Sự Kiện Thái Bình", "id": "tuzrxk", "id_social": "100004511980315"}]}
        Alamofire.request(APIRouter.getListAccounts()).responseJSON{response in
            guard response.result.isSuccess,
                let value = response.result.value else {
                    print("Error while fetching tags: \(String(describing: response.result.error))")
                    completion(false,String(describing: response.result.error))
                    return
            }
            
            // 3
            let jsonResponse = JSON(value)
            print("getListAccount \(jsonResponse.dictionaryValue)")
            if let error = jsonResponse["error"].dictionaryObject{
                print("error \(error)")
                let errorCode = error["code"]
                let explain = error["explain"] as? String
                completion(false,explain)
            }else{
                if let list = jsonResponse["list"].array{
                    for i in 0..<list.count{
                        if let data = list[i].dictionaryObject{
                            print("\(data["fullname"])")
                            let account = BaseInfo()
                            account.displayName = data["fullname"] as? String
                            account.userId = data["id_social"] as? String
                            account.id = data["id"] as? String
                            self.accounts.append(account)
                            
                        }
                    }
                    completion(true,nil)
                    
                }else{
                    completion(false,nil)

                }

            }

        }
    }
    
    func updateAccount(username:String?,password:String?,fullname:String?, phone:String?, email:String?,description:String?,completion:@escaping (_ success:Bool,_ message:String?)->Void){
        Alamofire.request(APIRouter.update(username: username, password: password, fullname: fullname, phone: phone, email: email, description: description)).responseJSON{response in
            guard response.result.isSuccess,
                let value = response.result.value else {
                    print("Error while fetching tags: \(String(describing: response.result.error))")
                    completion(false,String(describing: response.result.error))
                    return
            }
            
            // 3
            let jsonResponse = JSON(value)
            print("updateAccount \(jsonResponse.dictionaryObject)")
            if let error = jsonResponse["error"].dictionaryObject{
                print("error \(error)")
                let errorCode = error["code"]
                let explain = error["explain"] as? String
                completion(false,explain)
            }else{
                let status = jsonResponse["status"].boolValue
                let message = jsonResponse["message"].stringValue
                completion(status,message)
                
            }
           
        }
    }
    func logout(completion:@escaping (_ success:Bool,_ message:String?)->Void){
        Alamofire.request(APIRouter.logout()).responseJSON{response in
            guard response.result.isSuccess,
                let value = response.result.value else {
                    print("Error while fetching tags: \(String(describing: response.result.error))")
                    return
            }
            
            // 3
            let jsonResponse = JSON(value)
            print("logout \(jsonResponse.dictionaryValue)")
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
            }else if let fb_error = jsonResponse["fb_error"].dictionaryObject{
                var messsage = fb_error["message"] as? String
                let code = fb_error["code"] as? Int ?? 0
                if code == 190{
                    messsage = "AccessToken không hợp lệ. Lỗi này xảy ra khi người dùng đăng xuất khỏi tài khoản facebook hoặc lỗi hộ thông."
                }
                completion(false,messsage)

            } else{
                completion(true,"")

            }

        }
    }
    func deleteFacebookAccount(id_account:String,completion:@escaping (_ success:Bool,_ message:String?)->Void){
        Alamofire.request(APIRouter.deleteAccounts(id_account: id_account)).responseJSON{response in
            guard response.result.isSuccess,
                let value = response.result.value else {
                    print("Error while fetching tags: \(String(describing: response.result.error))")
                    completion(false,String(describing: response.result.error))
                    return
            }
            let jsonResponse = JSON(value)
            print("deleteFacebookAccount \(jsonResponse.dictionaryValue)")
            if let error = jsonResponse["error"].dictionaryObject{
                print("error \(error)")
                let errorCode = error["code"] as? Int
                let code = errorCode ?? 0
                let explain = error["explain"] as? String
                completion(false,explain)
            }else{
                let status = jsonResponse["status"].boolValue
                let message = jsonResponse["message"].stringValue
                completion(status,message)
            }
        
        }
    }
    func hasStream(completion:@escaping (_ success:Bool,_ message:String?,_ id_room:String?)->Void){
        Alamofire.request(StreamEmdpoint.hasStreaming()).responseJSON{response in
            guard response.result.isSuccess,
                let value = response.result.value else {
                    print("Error while fetching tags: \(String(describing: response.result.error))")
                    completion(false,String(describing: response.result.error),nil)
                    return
            }
            
            // 3
            let jsonResponse = JSON(value)
            print("hasStream \(jsonResponse.dictionaryValue)")
            if let error = jsonResponse["error"].dictionaryObject{
                print("error \(error)")
                let errorCode = error["code"]
                let explain = error["explain"] as? String
//                completion(false,explain,nil)
                completion(false,explain,nil)

            }else{
//                {"id_room": "tuzdin", "status": 0, "message": "You are having streaming"}
                let status = jsonResponse["status"].boolValue
                if status{
                    let message = jsonResponse["message"].stringValue
                    completion(true,message,nil)

                }else{
                    let message = jsonResponse["message"].stringValue
                    let id_room = jsonResponse["id_room"].stringValue
                    completion(false,message,id_room)

                }
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
            }else if let fb_error = jsonResponse["fb_error"].dictionaryObject{
                let message = fb_error["message"] as? String

                if let errorCode = fb_error["code"] as?  Int, errorCode == APIError.Error_Fb_session_expired{
                    completion(false,APIError.message(code: errorCode, message: message ?? ""),nil)
                }else{
                    completion(false,message,nil)
                }
                
            } else{
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
                if let timelines = jsonResponse["timelines"].array{
                    for i in 0..<timelines.count{
                        if let data = timelines[i].dictionaryObject{
                            guard let id = data["id"] as? String else{
                                return
                            }
                            guard let name = data["name"] as? String else{
                                return
                            }
                            let target = SocialTarget(id:id,name:"Tường \(name)")
                            targets.append(target)
                            
                        }
                    }
                }
                if let fanpages = jsonResponse["fanpages"].array{
                    for i in 0..<fanpages.count{
                        if let data = fanpages[i].dictionaryObject{
                            guard let id = data["id"] as? String else{
                                return
                            }
                            guard let name = data["name"] as? String else{
                                return
                            }
                            let target = SocialTarget(id:id,name:"Trang \(name)")
                            targets.append(target)
                        }
                        
                    }
                }
                if let groups = jsonResponse["groups"].array{
                    for i in 0..<groups.count{
                        if let data = groups[i].dictionaryObject{
                            guard let id = data["id"] as? String else{
                                return
                            }
                            guard let name = data["name"] as? String else{
                                return
                            }
                            let target = SocialTarget(id:id,name:"Nhóm \(name)")
                            targets.append(target)
                        }
                        
                    }
                }
             
                completion(true,nil,targets)
                
            }
            
        }

    }
    func createLive(id_social:String,id_target:String,caption:String,completion:@escaping (_ success:Bool,_ code:Int?,_ message:String?,_ streamInfo:StreamInfo?)->Void){
        Alamofire.request(FacebookEndpoint.createLive(id_social:id_social,id_target: id_target, caption: caption)).responseJSON{response in
            guard response.result.isSuccess,
                let value = response.result.value else {
                    print("Error while fetching tags: \(String(describing: response.result.error))")
                    completion(false,nil,String(describing: response.result.error),nil)
                    return
            }
            
            // 3
            let jsonResponse = JSON(value)
            print("createLive \(jsonResponse.dictionaryValue)")
            if let error = jsonResponse["error"].dictionaryObject{
                print("error \(error)")
                let errorCode = error["code"] as? Int
                let code = errorCode ?? 0
                let explain = error["explain"] as? String
                completion(false,code,explain,nil)
            }else{
//?                ["status": 1, "id_video": 1045144052312651, "id_stream": 1045144055645984, "stream_url": rtmp://live-api-s.facebook.com:80/rtmp/1045144055645984?ds=1&s_sw=0&s_vt=api-s&a=AThlQecF2A1OuhKc]

                let streamInfo = StreamInfo(jsonData: jsonResponse.dictionaryObject ?? [:])
                completion(true,200,nil,streamInfo)
                
            }
            
        }
        
    }
    func startLive(stremInfo:StreamInfo, width:Int, height:Int, id_category:String, time_countdown:Int,completion:@escaping (_ success:Bool,_ message:String?,_ id_room:String?)->Void){
        Alamofire.request(StreamEmdpoint.createLive(rtmps: stremInfo, width: width, height: height, id_category: "", time_countdown: 0)).responseJSON{response in
            guard response.result.isSuccess,
                let value = response.result.value else {
                    print("Error while fetching tags: \(String(describing: response.result.error))")
                    completion(false,String(describing: response.result.error),nil)

                    return
            }
            let jsonResponse = JSON(value)
            print("startLive \(jsonResponse.dictionaryValue)")
            if let error = jsonResponse["error"].dictionaryObject{
                print("error \(error)")
                let errorCode = error["code"] as? Int
                let code = errorCode ?? 0
                let explain = error["explain"] as? String
                completion(false,explain ?? APIError.Error_Message_Generic,nil)
            }else{
                let status = jsonResponse["status"].boolValue
                let message = jsonResponse["message"].string
                let id_room = jsonResponse["id"].string
                completion(status,message,id_room)

            }
        }
    }
    
    func endLive(id_room:String,completion:@escaping (_ success:Bool,_ message:String?)->Void){
        Alamofire.request(StreamEmdpoint.endLive(id_room: id_room)).responseJSON{response in
            guard response.result.isSuccess,
                let value = response.result.value else {
                    print("Error while fetching tags: \(String(describing: response.result.error))")
                    completion(false,String(describing: response.result.error))
                    return
            }
            
            // 3
            let jsonResponse = JSON(value)
            print("endLive \(jsonResponse.dictionaryValue)")
            if let error = jsonResponse["error"].dictionaryObject{
                print("error \(error)")
                let errorCode = error["code"] as? Int
                let code = errorCode ?? 0
                let explain = error["explain"] as? String
                completion(false,explain ?? APIError.Error_Message_Generic)

            }else{
                let status = jsonResponse["status"].boolValue
                let message = jsonResponse["message"].string
                completion(status,message ?? APIError.Error_Message_Generic)

            }
        }
    }
    func getComments(id_strem:String,completion:@escaping (_ success:Bool,_ comments:[FacebookComment])->Void){
        Alamofire.request(FacebookEndpoint.comments(id_stream: id_strem)).responseJSON{response in
            guard response.result.isSuccess,
                let value = response.result.value else {
                    print("Error while fetching tags: \(String(describing: response.result.error))")
                    completion(false,[])
                    return
            }
            let jsonResponse = JSON(value)
            print("getComments \(jsonResponse.dictionaryValue)")
            completion(true,[])

        }

    }
    
    func getListFrame(completion:@escaping(_  success:Bool, _ message:String?, _ frames:[StreamFrame]) ->Void){
        
        Alamofire.request(StreamEmdpoint.getListFrame()).responseJSON{response in
            guard response.result.isSuccess,
                let value = response.result.value else {
                    print("Error while fetching frame: \(String(describing: response.result.error))")
                    completion(false,String(describing: response.result.error),[])
                    return
            }
            let jsonResponse = JSON(value)
            print("getListFrame \(jsonResponse.dictionaryValue)")
            if let error = jsonResponse["error"].dictionaryObject{
                print("error \(error)")
                let errorCode = error["code"] as? Int
                let code = errorCode ?? 0
                let explain = error["explain"] as? String
                completion(false,explain,[])
                
            }else{
                var frames:[StreamFrame] = []
                if let list = jsonResponse["list"].array{
                    for i in 0..<list.count{
                        if let data = list[i].dictionaryObject{
                            let title = data["title"] as? String
                            if let thumbnail = data["thumbnail"] as? String{
                                let frame = StreamFrame(title: title ?? "title \(i)", thumbnail: thumbnail)
                                frames.append(frame)
                            }
                        }
                    }

                }
                StreamConfig.shared().listFrame = frames
                completion(true,nil,frames)

            }
        }
    }
    func getStreamConfig(completion:@escaping(_ success:Bool, _ message: String? , _ screen_wait:String?, _ screen_bye: String?) ->Void){
        Alamofire.request(StreamEmdpoint.getConfig()).responseJSON{response in
            guard response.result.isSuccess,
                let value = response.result.value else {
                    print("Error while fetching stream config: \(String(describing: response.result.error))")
                    completion(false,String(describing: response.result.error),nil,nil)
                    return
            }
            let jsonResponse = JSON(value)
            print("getStreamConfig \(jsonResponse.dictionaryValue)")
            if let error = jsonResponse["error"].dictionaryObject{
                print("error \(error)")
                let errorCode = error["code"] as? Int
                let code = errorCode ?? 0
                let explain = error["explain"] as? String
                completion(false,explain,nil,nil)
                
            }else if let config = jsonResponse["config"].dictionary{
                let urlWait  = config["screen_wait"]?.stringValue
                let urlBye   = config["screen_bye"]?.stringValue
                StreamConfig.shared().waitImagePath = urlWait
                StreamConfig.shared().byeImagePath = urlBye

                print("getStreamConfig screen_wait \(urlWait ?? "1")")
                print("getStreamConfig screen_bye \(urlBye ?? "1")")

                completion(true,nil,urlWait,urlBye)
                
            }else{
                completion(false,APIError.Error_Message_Generic,nil,nil)

            }
        }
    }
    func upload(type:String,title:String?, url:String?, image:UIImage?,completion:@escaping(_  success:Bool, _ message:String?,_ frames:[StreamFrame]) ->Void){
        var parameters = [
            "type": type,
            "token": APIClient.shared().token ?? "",
        ]
        if let title = title{
            parameters["title"] = title
        }
        if let url = url{
            parameters["url"] = url
        }
        
        let uploadUrl  = String(format: "%@/uploads?app=ios&checksum=%@", K.ProductionServer.baseAPIURL,APIUtils.checksum(request_url: "/uploads?app=ios", raw_data: JSON(parameters).stringValue))
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            if let image = image{
                if let imageData = UIImagePNGRepresentation(image) {
                    multipartFormData.append(imageData, withName: "file", fileName: "file.jpg", mimeType: "image/jpeg")
                }
            }
          
            for p in parameters {
                let value = p.value
                multipartFormData.append((value.data(using: .utf8))!, withName: p.key)
            }}, to: uploadUrl, method: .post, headers: nil,
                encodingCompletion: { encodingResult in
                    switch encodingResult {
                    case .success(let upload, _, _):
                        upload.responseJSON { [weak self] response in
                            guard let strongSelf = self else {
                                return
                            }
                            guard let value = response.result.value else {
                                return
                            }
                            let jsonResponse = JSON(value)

                            if let error = jsonResponse["error"].dictionaryObject{
                                print("error \(error)")
                                let errorCode = error["code"] as? Int
                                let code = errorCode ?? 0
                                let explain = error["explain"] as? String
                                completion(false,explain,[])
                                
                            }else{
                                var frames:[StreamFrame] = []
                                if let list = jsonResponse["list"].array{
                                    //frame
                                    for i in 0..<list.count{
                                        if let data = list[i].dictionaryObject{
                                            let title = data["title"] as? String
                                            if let thumbnail = data["thumbnail"] as? String{
                                                let frame = StreamFrame(title: title ?? "title \(i)", thumbnail: thumbnail)
                                                frames.append(frame)
                                            }
                                        }
                                    }
                                    StreamConfig.shared().listFrame = frames

                                    completion(true,nil,frames)

                                }else if let _ = jsonResponse["status"].int{
                                    //avatar
                                    let message = jsonResponse["message"].stringValue
                                    completion(true,message,frames)

                                }else if let config = jsonResponse["config"].dictionaryObject{
                                    //screen_wait and screen_bye
//                                    - screen_wait (string): Link ảnh màn hình chờ
//                                    - screen_bye (string): Link ảnh màn hình tạm biệt
                                    let urlWait  = config["screen_wait"] as? String
                                    let urlBye   = config["screen_bye"] as? String
                                    StreamConfig.shared().waitImagePath = urlWait
                                    StreamConfig.shared().byeImagePath = urlBye
                                    completion(true,nil,frames)

                                    
                                }
                                
                            }
                            
                        }
                    case .failure(let encodingError):
                        print("error:\(encodingError)")
                        completion(false,encodingError.localizedDescription,[])

                    }
        })
    }
    func uploadStreamCover(type:String, url:String?, image:UIImage?,completion:@escaping(_  success:Bool, _ message:String?) ->Void){
        var parameters = [
            "type": type,
            "token": APIClient.shared().token ?? "",
            ]

        if let url = url{
            parameters["url"] = url
        }
        
        let uploadUrl  = String(format: "%@/uploads?app=ios&checksum=%@", K.ProductionServer.baseAPIURL,APIUtils.checksum(request_url: "/uploads?app=ios", raw_data: JSON(parameters).stringValue))
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            if let image = image{
                if let imageData = UIImagePNGRepresentation(image) {
                    multipartFormData.append(imageData, withName: "file", fileName: "file.jpg", mimeType: "image/jpeg")
                }
            }
            
            for p in parameters {
                let value = p.value
                multipartFormData.append((value.data(using: .utf8))!, withName: p.key)
            }}, to: uploadUrl, method: .post, headers: nil,
                encodingCompletion: { encodingResult in
                    switch encodingResult {
                    case .success(let upload, _, _):
                        upload.responseJSON { [weak self] response in
                            guard let strongSelf = self else {
                                return
                            }
                            guard let value = response.result.value else {
                                return
                            }
                            let jsonResponse = JSON(value)
                            
                            if let error = jsonResponse["error"].dictionaryObject{
                                print("error \(error)")
                                let errorCode = error["code"] as? Int
                                let code = errorCode ?? 0
                                let explain = error["explain"] as? String
                                completion(false,explain)
                                
                            }else{
                                if let config = jsonResponse["config"].dictionaryObject{
                                    //screen_wait and screen_bye
                                    //                                    - screen_wait (string): Link ảnh màn hình chờ
                                    //                                    - screen_bye (string): Link ảnh màn hình tạm biệt
                                    let urlWait  = config["screen_wait"] as? String
                                    let urlBye   = config["screen_bye"] as? String
                                    StreamConfig.shared().waitImagePath = urlWait
                                    StreamConfig.shared().byeImagePath = urlBye
                                    completion(true,nil)
                                    
                                    
                                }else{
                                    completion(false,APIError.Error_Message_Generic)
                                    
                                }
                                
                            }
                            
                        }
                    case .failure(let encodingError):
                        print("error:\(encodingError)")
                        completion(false,encodingError.localizedDescription)
                        
                    }
        })
    }
    func uploadAvatar(image:UIImage,completion:@escaping(_  success:Bool, _ message:String?) ->Void){
        let parameters = [
            "type": K.APIUploadType.avatar,
            "token": APIClient.shared().token ?? "",
            ]
  
        let uploadUrl  = String(format: "%@/uploads?app=ios&checksum=%@", K.ProductionServer.baseAPIURL,APIUtils.checksum(request_url: "/uploads?app=ios", raw_data: JSON(parameters).stringValue))
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            if let imageData = UIImagePNGRepresentation(image) {
                multipartFormData.append(imageData, withName: "file", fileName: "file.jpg", mimeType: "image/jpeg")
            }
            
            
            for p in parameters {
                let value = p.value
                multipartFormData.append((value.data(using: .utf8))!, withName: p.key)
            }}, to: uploadUrl, method: .post, headers: nil,
                encodingCompletion: { encodingResult in
                    switch encodingResult {
                    case .success(let upload, _, _):
                        upload.responseJSON { [weak self] response in
                            guard let strongSelf = self else {
                                return
                            }
                            guard let value = response.result.value else {
                                return
                            }
                            let jsonResponse = JSON(value)
                            
                            if let error = jsonResponse["error"].dictionaryObject{
                                print("error \(error)")
                                let errorCode = error["code"] as? Int
                                let code = errorCode ?? 0
                                let explain = error["explain"] as? String
                                completion(false,explain)
                                
                            }else{
                                if let _ = jsonResponse["status"].int{
                                    //avatar
                                    let message = jsonResponse["message"].stringValue
                                    completion(true,message)
                                    
                                }else{
                                    completion(false,APIError.Error_Message_Generic)

                                }
                                
                            }
                            
                        }
                    case .failure(let encodingError):
                        print("error:\(encodingError)")
                        completion(false,encodingError.localizedDescription)
                        
                    }
        })
    }
    func getListStream(page:Int?, _ page_size:Int?, _ filter_title:String?, _ filter_status:Int?,completion:@escaping(_  success:Bool, _ message:String?, _ streams:[CocaStream], _ total:Int) ->Void){
        Alamofire.request(StreamEmdpoint.getListStream(page: page, pageSize: page_size, title: filter_title, status: filter_status)).responseJSON{response in
            guard response.result.isSuccess,
                let value = response.result.value else {
                    print("Error while fetching frame: \(String(describing: response.result.error))")
                    completion(false,String(describing: response.result.error),[],0)
                    return
            }
            let jsonResponse = JSON(value)
            print("getListFrame \(jsonResponse.dictionaryValue)")
            if let error = jsonResponse["error"].dictionaryObject{
                print("error \(error)")
                let errorCode = error["code"] as? Int
                let code = errorCode ?? 0
                let explain = error["explain"] as? String
                completion(false,explain,[],0)
                
            }else{
                var streams:[CocaStream] = []
                if let list = jsonResponse["list"].array{
                    for i in 0..<list.count{
                        if let data = list[i].dictionary{
                            if let id = data["id"]?.stringValue{
                                let title = data["title"]?.stringValue ?? ""
                                let created = data["created_at"]?.doubleValue ?? 0.0
                                let desDict = data["destinations"]?.arrayValue ?? []
                                var desData:[Destination] = []
                                
                                for info in desDict{
                                    let id_type = info["id_type"].intValue
                                    let id_video = info["id_video"].stringValue
                                    let des = Destination(id_type: id_type, id_video: id_video)
                                    desData.append(des)
                                }
                                let stream = CocaStream(id:id, title: title, created_at: created, destinations: desData)
                                streams.append(stream)
                            }
                        }
                    }
                    
                }
                let total  = jsonResponse["total_result"].intValue
                completion(true,nil,streams,total)
                
            }
        }
    }
}
