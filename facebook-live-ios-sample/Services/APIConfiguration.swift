//
//  APIConfiguration.swift
//  coca-live
//
//  Created by Macintosh HD on 8/25/18.
//  Copyright © 2018 Coca Live. All rights reserved.
//

import UIKit
import Alamofire
protocol APIConfiguration: URLRequestConvertible {
    var method: HTTPMethod { get }
    var path: String { get }
    var parameters: Parameters? { get }
}
