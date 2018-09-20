//
//  CocaStream.swift
//  coca-live
//
//  Created by Hai Vu on 9/20/18.
//  Copyright © 2018 Coca Live. All rights reserved.
//

import Foundation
struct CocaStream {
    var id:String
    var title:String
    var created_at:Double
    var destinations:[Destination]
    func getCreatedString() ->String{
        let date = Date(timeIntervalSince1970: created_at)
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        let strDate = dateFormatter.string(from: date)
        return strDate
    }
    func getVideoUrl(_ index:Int) ->String?{
        if index < destinations.count{
            let des = destinations[index]
            return des.getVideoUrl()
        }
        return nil
    }
    func getFacebookUrls(_ index:Int) -> [String]{
        var urls:[String] = []
        if index < destinations.count{
            let des = destinations[index]
            urls.append("fb://profile/\(des.id_video)") // App)
            urls.append("http://www.facebook.com/\(des.id_video)") // Website if app fails
        }
        return urls
    }
}
struct Destination{
    var id_type:Int
    var id_video:String
    
    func getVideoUrl() -> String?{
//        id_type (int): Loại nơi phát. 1 - Facebook, 2 - Youtube
//        - id_video (string): Mã video của nơi phát
//        Với id_type = 1: https://facebook.com/[id_video]
//        Với id_type = 2: https://youtube.com/watch?v=[id_video]
        if id_type == 1{
            return String(format: "https://facebook.com/%@", id_video)
        }else if id_type == 2{
            return String(format: "https://youtube.com/watch?v=%@", id_video)
        }
        return nil
    }

}
