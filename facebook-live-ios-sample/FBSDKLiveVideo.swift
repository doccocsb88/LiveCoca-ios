////
////  FBSDKLiveVideo.swift
////  facebook-live-ios-sample
////
////  Created by Hans Knoechel on 09.03.17.
////  Copyright © 2017 Hans Knoechel. All rights reserved.
////
//
//import UIKit
//// MARK: FBSDKLiveVideoDelegate
//
//public protocol FBSDKLiveVideoDelegate {
//    func liveVideo(_ liveVideo: FBSDKLiveVideo, didStartWith session: FBSDKLiveVideoSession);
//    
//    func liveVideo(_ liveVideo: FBSDKLiveVideo, didStopWith session: FBSDKLiveVideoSession);
//}
//
//public extension FBSDKLiveVideoDelegate {
//    func liveVideo(_ liveVideo: FBSDKLiveVideo, didErrorWith error: Error) {}
//    
//    func liveVideo(_ liveVideo: FBSDKLiveVideo, didChange sessionState: FBSDKLiveVideoSessionState) {}
//    
//    func liveVideo(_ liveVideo: FBSDKLiveVideo, didAdd cameraSource: FBSDKLiveVideoSession) {}
//
//    func liveVideo(_ liveVideo: FBSDKLiveVideo, didUpdate session: FBSDKLiveVideoSession) {}
//
//    func liveVideo(_ liveVideo: FBSDKLiveVideo, didDelete session: FBSDKLiveVideoSession) {}
//}
//
//// MARK: Enumerations
//
//enum FBSDKLiveVideoPrivacy : StringLiteralType {
//    case me = "SELF"
//    
//    case friends = "FRIENDS"
//
//    case friendsOfFriends = "FRIENDS_OF_FRIENDS"
//    
//    case allFriends = "ALL_FRIENDS"
//    
//    case custom = "CUSTOM"
//}
//
//enum FBSDKLiveVideoStatus: StringLiteralType {
//    case unpublished = "UNPUBLISHED"
//
//    case liveNow = "LIVE_NOW"
//
//    case scheduledUnpublished = "SCHEDULED_UNPUBLISHED"
//
//    case scheduledLive = "SCHEDULED_LIVE"
//
//    case scheduledCanceled = "SCHEDULED_CANCELED"
//}
//
//enum FBSDKLiveVideoType: StringLiteralType {
//    case regular = "REGULAR"
//    
//    case ambient = "AMBIENT"
//}
//
//public enum FBSDKLiveVideoSessionState : IntegerLiteralType {
//    case none = 0
//    
//    case previewStarted
//    
//    case starting
//    
//    case started
//    
//    case ended
//    
//    case error
//}
//
//struct FBSDKLiveVideoParameter {
//    var key: String!
//
//    var value: String!
//}
//
////public class FBSDKLiveVideoSession : VCSimpleSession {
////    // Subclass for more generic API-interface
////}
//
//open class FBSDKLiveVideo: NSObject {
//    
//    // MARK: - Live Video Parameters
//    // MARK: Create
//    
//    var overlay: UIView! {
//        didSet {
//            if overlay.isDescendant(of: self.preview) {
//                overlay.removeFromSuperview()
//            } else {
//                self.preview.addSubview(overlay)
//            }
//        }
//    }
//    
//    var videoDescription: String! {
//        didSet {
//            self.createParameters["description"] = videoDescription
//        }
//    }
//    
//    var contentTags: [String]! {
//        didSet {
//            self.createParameters["content_tags"] = contentTags
//        }
//    }
//    
//    var privacy: FBSDKLiveVideoPrivacy = .me {
//        didSet {
//            self.createParameters["privacy"] = "{\"value\":\"\(privacy.rawValue)\"}"
//        }
//    }
//    
//    var plannedStartTime: Date! {
//        didSet {
//            self.createParameters["planned_start_time"] = String(plannedStartTime.timeIntervalSince1970 * 1000)
//        }
//    }
//    
//    var status: FBSDKLiveVideoStatus! {
//        didSet {
//            self.createParameters["status"] = status.rawValue
//        }
//    }
//    
//    var type: FBSDKLiveVideoType = .regular {
//        didSet {
//            self.createParameters["stream_type"] = type.rawValue
//        }
//    }
//    
//    var title: String! {
//        didSet {
//            self.createParameters["title"] = title
//        }
//    }
//    
//    var videoOnDemandEnabled: String! {
//        didSet {
//            self.createParameters["save_vod"] = videoOnDemandEnabled
//        }
//    }
//    
//    // MARK: Update
//    
//    var adBreakStartNow: Bool! {
//        didSet {
//            self.updateParameters["ad_break_start_now"] = adBreakStartNow
//        }
//    }
//    
//    var adBreakTimeOffset: Float! {
//        didSet {
//            self.updateParameters["ad_break_time_offset"] = adBreakTimeOffset
//        }
//    }
//    
//    var disturbing: Bool! {
//        didSet {
//            self.updateParameters["disturbing"] = disturbing
//        }
//    }
//    
//    var embeddable: Bool! {
//        didSet {
//            self.updateParameters["embeddable"] = embeddable
//        }
//    }
//    
//    var sponsorId: String! {
//        didSet {
//            self.createParameters["sponsor_id"] = sponsorId
//        }
//    }
//    
//    // MARK: - Utility API's
//
//    var delegate: FBSDKLiveVideoDelegate!
//
//    var url: URL!
//
//    var id: String!
//    
//    var audience: String = "me"
//    
//    var frameRate: Int = 30
//    
//    var bitRate: Int = 1000000
//    
//    var preview: UIView!
//
//    var isStreaming: Bool = false
//
//    // MARK: - Internal API's
//
//    private var session: FBSDKLiveVideoSession!
//    
//    private var createParameters: [String : Any] = [:]
//
//    private var updateParameters: [String : Any] = [:]
//
//    
//    required public init(delegate: FBSDKLiveVideoDelegate, previewSize: CGRect, videoSize: CGSize) {
//        super.init()
//        
//        self.delegate = delegate
//        
//        self.session = FBSDKLiveVideoSession(videoSize: videoSize, frameRate: Int32(self.frameRate), bitrate: Int32(self.bitRate), useInterfaceOrientation: false)
//        self.session.previewView.frame = previewSize
//        self.session.delegate = self
//        
//        self.preview = self.session.previewView
//    }
//    
//    deinit {
//        if self.session.rtmpSessionState != .ended {
//            self.session.endRtmpSession()
//        }
//
//        self.delegate = nil
//        self.session.delegate = nil
//        self.preview = nil
//    }
//    
//    // MARK: - Public API's
//    
//    func start() {
//        guard FBSDKAccessToken.current().hasGranted("publish_video") else {
//            print("didErrorWith: \(FBSDKLiveVideo.errorFromDescription(description: "The \"publish_video\" permission has not been granted"))")
//
//            return self.delegate.liveVideo(self, didErrorWith: FBSDKLiveVideo.errorFromDescription(description: "The \"publish_video\" permission has not been granted"))
//        }
//        let requestURL = "/\(self.audience)/live_videos"
//        let graphRequest = FBSDKGraphRequest(graphPath: requestURL
//            , parameters: self.createParameters, httpMethod: "POST")
//        
//        DispatchQueue.main.async {
//            _ = graphRequest?.start { (_, result, error) in
//                guard error == nil, let dict = (result as? NSDictionary) else {
//                    return self.delegate.liveVideo(self, didErrorWith: FBSDKLiveVideo.errorFromDescription(description: "Error initializing the live video session: \(String(describing: error?.localizedDescription))"))
//                }
//                
//                self.url = URL(string:(dict.value(forKey: "stream_url") as? String)!)
//                self.id = dict.value(forKey: "id") as? String
//                
//                guard let streamPath = self.url?.lastPathComponent, let query = self.url?.query else {
//                    return self.delegate.liveVideo(self, didErrorWith: FBSDKLiveVideo.errorFromDescription(description: "The stream path is invalid"))
//                }
//                
//                self.session.startRtmpSession(withURL: "rtmp://rtmp-api.facebook.com:80/rtmp/", andStreamKey: "\(streamPath)?\(query)")
//                let frame = UIImage(named: "demo_frame");
//                self.session.addPixelBufferSource(frame, with: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
//                
//                self.delegate.liveVideo(self, didStartWith:self.session)
//            }
//        }
//    }
//    
//    func stop() {
//        guard FBSDKAccessToken.current().hasGranted("publish_video") else {
//            return self.delegate.liveVideo(self, didErrorWith: FBSDKLiveVideo.errorFromDescription(description: "The \"publish_video\" permission has not been granted"))
//        }
//
//        let graphRequest = FBSDKGraphRequest(graphPath: "/\(self.audience)/live_videos", parameters: ["end_live_video":  true], httpMethod: "POST")
//        
//        DispatchQueue.main.async {
//            _ = graphRequest?.start { (_, _, error) in
//                guard error == nil else {
//                    return self.delegate.liveVideo(self, didErrorWith: FBSDKLiveVideo.errorFromDescription(description: "Error stopping the live video session: \(String(describing: error?.localizedDescription))"))
//                }
//                self.session.endRtmpSession()
//                self.delegate.liveVideo(self, didStopWith:self.session)
//            }
//        }
//    }
//    
//    func update() {
//        guard FBSDKAccessToken.current().hasGranted("publish_video") else {
//            return self.delegate.liveVideo(self, didErrorWith: FBSDKLiveVideo.errorFromDescription(description: "The \"publish_video\" permission has not been granted"))
//        }
//        
//        let graphRequest = FBSDKGraphRequest(graphPath: "/\(String(describing: self.id))", parameters: self.createParameters, httpMethod: "POST")
//        
//        DispatchQueue.main.async {
//            _ = graphRequest?.start { (_, result, error) in
//                guard error == nil else {
//                    return self.delegate.liveVideo(self, didErrorWith: FBSDKLiveVideo.errorFromDescription(description: "Error initializing the live video session: \(String(describing: error?.localizedDescription))"))
//                }
//                
//                self.delegate.liveVideo(self, didUpdate: self.session)
//            }
//        }
//    }
//    
//    func delete() {
//        guard FBSDKAccessToken.current().hasGranted("publish_video") else {
//            return self.delegate.liveVideo(self, didErrorWith: FBSDKLiveVideo.errorFromDescription(description: "The \"publish_video\" permission has not been granted"))
//        }
//        
//        let graphRequest = FBSDKGraphRequest(graphPath: "/\(String(describing: self.id))", parameters: ["end_live_video":  true], httpMethod: "DELEGTE")
//        
//        DispatchQueue.main.async {
//            _ = graphRequest?.start { (_, _, error) in
//                guard error == nil else {
//                    return self.delegate.liveVideo(self, didErrorWith: FBSDKLiveVideo.errorFromDescription(description: "Error deleting the live video session: \(String(describing: error?.localizedDescription))"))
//                }
//
//                self.delegate.liveVideo(self, didDelete: self.session)
//            }
//        }
//    }
//    
//    // MARK: Utilities
//    
//    internal class func errorFromDescription(description: String) -> Error {
//        return NSError(domain: FBSDKErrorDomain, code: -1, userInfo: [NSLocalizedDescriptionKey : description])
//    }
//    
//    internal func updateLiveStreamParameters(with parameter: FBSDKLiveVideoParameter) {
//        self.createParameters[parameter.key] = parameter.value
//    }
//    public func getVideoSize() -> CGSize{
//        return self.session.videoSize
//    }
//    public func addFooter(){
//        if(isStreaming){
//            let imageSize = CGSize(width: self.session.videoSize.width, height: 100)
//            let image = UIImage(color: UIColor.red, size: imageSize)
//            let frame = CGRect(x: self.session.videoSize.width/2, y: self.session.videoSize.height - imageSize.height, width: self.session.videoSize.width, height: imageSize.height);
//            //        CGSize = self.session.getvi
//            self.session.addPixelBufferSource(image, with: frame)
//        }
//    }
//    public func addHorizontalText(at x:CGFloat){
//        if(isStreaming){
//            let imageSize = CGSize(width: self.session.videoSize.width, height: 100)
//            var image = UIImage(color: UIColor.blue, size: imageSize)
//            image = image?.textToImage(drawText: "Hai Dep Trai", atPoint: CGPoint(x: x, y: imageSize.height/2))
//           
//            let frame = CGRect(x: self.session.videoSize.width/2, y: imageSize.height, width: self.session.videoSize.width, height: imageSize.height);
//            self.session.addPixelBufferSource(image, with: frame)
//        }
//    }
//}
//
//extension FBSDKLiveVideo : VCSessionDelegate {
//    public func connectionStatusChanged(_ sessionState: VCSessionState) {
//        if sessionState == .started {
//            self.isStreaming = true
//        } else if sessionState == .ended || sessionState == .error {
//            self.isStreaming = false
//        }
//        
//        self.delegate.liveVideo(self, didChange: FBSDKLiveVideoSessionState(rawValue: sessionState.rawValue)!)
//    }
//    
//    public func didAddCameraSource(_ session: VCSimpleSession!) {
//        self.delegate.liveVideo(self, didAdd: session as! FBSDKLiveVideoSession)
//    }
//}

