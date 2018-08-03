//
//  FacebookServices.swift
//  facebook-live-ios-sample
//
//  Created by Apple on 7/28/18.
//  Copyright © 2018 Hans Knoechel. All rights reserved.
//

import Foundation

//GraphRequestProtocol
import FacebookCore
//
class FacebookServices {
    static let sharedInstance : FacebookServices = {
        let instance = FacebookServices()
        return instance
    }()
    let accessTokens:[String] = ["EAAHA0tZANRYgBAK6kLdSxgajtdDnoY2fNRoOuAfJK3SFvk2TBk80whqAnp4DjYowVlFZCJZBiXd9R53PZCTfpV9AzZC6hYmZCZAeHrTpEf2KpNHAzqtZAR0kZBCgxl5040gSun59Y33OwyIYxuHNQVGSZCLGuTrF142yZBbf26WzbkEle5xCrv5TikGkmTYL8kK9gzj6fwIVy8ZC6QZDZD"]
    var accountList:[FacebookInfo] = []
    init(){
        
    }
    class func shared() -> FacebookServices {
        return sharedInstance
    }
    func fetchData(onComplete complete: @escaping () -> Void){
        for i in 0 ..< accessTokens.count{
            let accessToken = accessTokens[i];
            getFbId(accessToken: accessToken, onSuccess: { [unowned self] (fbuserId) in
                self.getListPages(tokenId: fbuserId,onSuccess: {
                    complete()
                })
            }) {
                
            }
        }
        
    }
    func getFbId(accessToken: String, onSuccess success: @escaping (_ userid:String) -> Void, onFailure failure: @escaping () -> Void){
        let _  = AccessToken(authenticationToken: accessToken)
     
        print("FacebookServices : \(accessToken)")
            let req = GraphRequest(graphPath: "me", parameters: ["fields": "email,first_name,last_name,gender,picture"], accessToken: AccessToken.current, httpMethod: GraphRequestHTTPMethod(rawValue: "GET")!)
            req.start({ (connection, result) in
                switch result {
                case .failed(let error):
                    print("failed \(error)")
                    failure()
                case .success(let graphResponse):
                    if let responseDictionary = graphResponse.dictionaryValue {
                        print(responseDictionary)
                        let firstNameFB = responseDictionary["first_name"] as? String
                        let lastNameFB = responseDictionary["last_name"] as? String
                        let socialIdFB = responseDictionary["id"] as? String
                        let genderFB = responseDictionary["gender"] as? String
                        let pictureUrlFB = responseDictionary["picture"] as? [String:Any]
                        let photoData = pictureUrlFB!["data"] as? [String:Any]
                        let photoUrl = photoData!["url"] as? String
                        print(firstNameFB ?? "", lastNameFB ?? "", socialIdFB ?? "", genderFB ?? "", photoUrl ?? "")
                        print("success : \(socialIdFB ?? "")")
                        let info = BaseInfo()
                        info.tokenString = accessToken
                        info.userId = socialIdFB
                        info.displayName = "\(firstNameFB ?? "") \(lastNameFB ?? "")"
                        //
                        let account = FacebookInfo()
                        account.tokenString = accessToken
                        account.userId = socialIdFB
                        account.displayName = "\(firstNameFB ?? "") \(lastNameFB ?? "")"
                        self.accountList.append(account)
                        //
                        for account in self.accountList{
                            if account.tokenString ?? "" == accessToken{
                                account.pages.append(info)
                            }
                        }
                        success(socialIdFB ?? "")
                    }
                }
            })
//        }else{
//            print("FacebookServices 2")
//
//        }
    }
    func getListPages(tokenId :String, onSuccess success: @escaping () -> Void){
        let req = GraphRequest(graphPath: "me/accounts", parameters: ["fields": "access_token,name,id"], accessToken: AccessToken.current, httpMethod: GraphRequestHTTPMethod(rawValue: "GET")!)
        req.start({[unowned self] (connection, result) in
            switch result {
            case .failed(let error):
                print("failed \(error)")
                
            case .success(let graphResponse):
                print("failed 1")

                if let responseDictionary = graphResponse.dictionaryValue{
                    guard let datas = responseDictionary["data"] as? [Any] else{
                        return
                    }

                    for data  in datas{
                        //print("failed cc : \(data)")
                        if let data = data as? [String:Any] {
                            print("failed cc : \(data)")
                            
                            let token = data["access_token"] as? String
                            let pageId = data["id"] as? String
                            let pageName = data["name"] as? String
                            let info = BaseInfo()
                            info.tokenString = token
                            info.userId = pageId
                            info.displayName = pageName
                            for account in self.accountList{
                                if account.userId ?? "" == tokenId{
                                    account.pages.append(info)
                                }
                            }
                        }
                    }
                    success()

                    
//                  let datas = responseDictionary["data"] as! NSArray
//                    print(responseDictionary)
//                    for i in 0 ..< datas.count{

//                    }
//                    {
//                        "access_tokenaccess_token" = EAAHA0tZANRYgBAAoEaFGy6zJZBHwKhLNXoUjEEoPUgn5B3rtt30TI9Y8t8tGSe4i1sHUjSOV2d11XCLtrVzrhuq5oGYFlmOBwEnncz0aWqy3gXMEMnk9WwWJLtNSFzNRwLb7qoiK1mo63ZBgqWDyJfWrVpbCZC1JEGNsu3IAGAZDZD;
//                        category = "Landmark & Historical Place";
//                        "category_list" =     (
//                            {
//                                id = 209889829023118;
//                                name = "Landmark & Historical Place";
//                            }
//                        );
//                        id = 316528591739950;
//                        name = Dulichchude;
//                        tasks =     (
//                            ANALYZE,
//                            ADVERTISE,
//                            MODERATE,
//                            "CREATE_CONTENT",
//                            MANAGE
//                        );
//                    }
                    
                }
            }
        })
    }
    func getFacebookLiveStreamURL(pageInfo:BaseInfo, onSuccess success: @escaping (_ streamurl:String) -> Void){
        AccessToken.refreshCurrentToken()

        let accessToken  = AccessToken(authenticationToken: pageInfo.tokenString ?? "")
        let path = "\(pageInfo.userId ?? "")/live_videos"
       
        print("authenToken \(accessToken.userId ?? "")")
        let req = GraphRequest(graphPath: path, parameters: ["fields": "stream_url,id,secure_stream_url,dash_ingest_url"], accessToken: accessToken, httpMethod: GraphRequestHTTPMethod(rawValue: "POST")!)
        req.start({ (connection, result) in
            switch result {
            case .failed(let error):
                print("failed \(error)")
                
            case .success(let graphResponse):
                print("success")
                if let responseDictionary = graphResponse.dictionaryValue {
                    print(responseDictionary)
                    let streamId = responseDictionary["id"] as? String
                    let streamUrl = responseDictionary["stream_url"] as? String
                    let secureStreamUrl = responseDictionary["secure_stream_url"] as? String
                    let dashIngestUrl = responseDictionary["dash_ingest_url"] as? String
                    success(streamUrl ?? "")
                }
            }
        })
    }
}


