//
//  APIServices.swift
//  facebook-live-ios-sample
//
//  Created by Apple on 8/1/18.
//  Copyright © 2018 Hans Knoechel. All rights reserved.
//

import Foundation
import Alamofire
class APIServices {
    static let sharedInstance : APIServices = {
        let instance = APIServices()
        return instance
    }()
    init(){
        
    }
    class func shared() -> APIServices {
        return sharedInstance
    }
    var request: Alamofire.Request? {
        didSet {
            oldValue?.cancel()
            
            title = request?.description
            headers.removeAll()
            body = nil
            elapsedTime = nil
        }
    }
    var headers: [String: String] = [:]
    var body: String?
    var elapsedTime: TimeInterval?
    var segueIdentifier: String?
    var title: String?
    
    static let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()

    
     func refresh() {
        guard let request = request else {
            return
        }
        
        
        let start = CACurrentMediaTime()
        
        let requestComplete: (HTTPURLResponse?, Result<String>) -> Void = { response, result in
            let end = CACurrentMediaTime()
            self.elapsedTime = end - start
            
            if let response = response {
                for (field, value) in response.allHeaderFields {
                    self.headers["\(field)"] = "\(value)"
                }
            }
            
            if let segueIdentifier = self.segueIdentifier {
                switch segueIdentifier {
                case "GET", "POST", "PUT", "DELETE":
                    self.body = result.value
                case "DOWNLOAD":
                    self.body = self.downloadedBodyString()
                default:
                    break
                }
            }
            
//            self.tableView.reloadData()
//            self.refreshControl?.endRefreshing()
        }
        
        if let request = request as? DataRequest {
            request.responseString { response in
                requestComplete(response.response, response.result)
            }
        } else if let request = request as? DownloadRequest {
            request.responseString { response in
                requestComplete(response.response, response.result)
            }
        }
    }
    
    private func downloadedBodyString() -> String {
        let fileManager = FileManager.default
        let cachesDirectory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        
        do {
            let contents = try fileManager.contentsOfDirectory(
                at: cachesDirectory,
                includingPropertiesForKeys: nil,
                options: .skipsHiddenFiles
            )
            
            if let fileURL = contents.first, let data = try? Data(contentsOf: fileURL) {
                let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions())
                let prettyData = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
                
                if let prettyString = String(data: prettyData, encoding: String.Encoding.utf8) {
                    try fileManager.removeItem(at: fileURL)
                    return prettyString
                }
            }
        } catch {
            // No-op
        }
        
        return ""
    }
}
