//
//  APIConfiguration.swift
//  facebook-live-ios-sample
//
//  Created by Macintosh HD on 8/25/18.
//  Copyright © 2018 Hans Knoechel. All rights reserved.
//

import UIKit
import Alamofire
protocol APIConfiguration: URLRequestConvertible {
    var method: HTTPMethod { get }
    var path: String { get }
    var parameters: Parameters? { get }
}
