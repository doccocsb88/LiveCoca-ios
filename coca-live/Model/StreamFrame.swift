//
//  StreamFrame.swift
//  coca-live
//
//  Created by Macintosh HD on 9/19/18.
//  Copyright © 2018 Coca Live. All rights reserved.
//

import Foundation
struct StreamFrame{
    let title:String
    let thumbnail:String
    func getThumbnailUrl() ->String{
        return String(format: "%@%@", K.ProductionServer.baseURL,thumbnail)
    }
}
