//
//  ViewController.swift
//  facebook-live-ios-sample
//
//  Created by Hans Knoechel on 08.03.17.
//  Copyright © 2017 Hans Knoechel. All rights reserved.
//

import UIKit

class HKLiveVideoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
            
    var blurOverlay: UIVisualEffectView!

    var sessionURL: NSURL!
    
    var loader: UIActivityIndicatorView!
    
    var loginButton: FBSDKLoginButton!
    
    var liveVideo: FBSDKLiveVideo!
    var timer = Timer()
    var startX : CGFloat = 0.0
    @IBOutlet weak var footerButton: UIButton!
    @IBOutlet weak var hozirontalTextButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    
    @IBOutlet weak var stopStreamButton: UIButton!
    
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var switchCameraButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var chatButton: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    
    
    @IBOutlet weak var menuLeadingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var menuWidthConstraint: NSLayoutConstraint!
    
    @IBAction func recordButtonTapped() {
        if !self.liveVideo.isStreaming {
            startStreaming()
        } else {
            stopStreaming()
        }
    }
    
    @IBAction func horizontalButtonTapped(_ sender: Any) {
        self.scheduledTimerWithTimeInterval()
    }
    
    @IBAction func footerButtonTapped(_ sender: Any) {
        self.liveVideo.addFooter()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
//          1920x1080
//          1280x720
        self.liveVideo = FBSDKLiveVideo(
            delegate: self,
            previewSize: self.view.bounds,
            videoSize: CGSize(width: 720, height: 1280)
        )
        
        let myOverlay = UIView(frame: CGRect(x: 5, y: 5, width: self.view.bounds.size.width - 10, height: 30))
        myOverlay.backgroundColor =  UIColor(red: 0.0 , green:1.0, blue: 0.0, alpha: 0.5)
        
        self.liveVideo.privacy = .me
        self.liveVideo.audience = "me" // or your user-id, page-id, event-id, group-id, ...
        
        // Comment in to show a green overlay bar (configure with your own one)
        // self.liveVideo.overlay = myOverlay
        
        initializeUserInterface()
    }
    
    func initializeUserInterface() {
        self.loader = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        self.loader.frame = CGRect(x: 15, y: 15, width: 40, height: 40)
        
        self.blurOverlay = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        self.blurOverlay.frame = self.view.bounds
        
        self.view.insertSubview(self.liveVideo.preview, at: 0)

        self.loginButton = FBSDKLoginButton()
        self.loginButton.publishPermissions = ["publish_video"]
        self.loginButton.loginBehavior = .native
        self.loginButton.center = CGPoint(x: self.view.bounds.size.width / 2, y: 60)
        self.loginButton.delegate = self
        self.view.addSubview(self.loginButton)

        if FBSDKAccessToken.current() == nil {
            self.view.insertSubview(self.blurOverlay, at: 1)
        } else {
            self.recordButton.isHidden = false
        }
        //hide functional button
//        footerButton.isHidden = true
//        hozirontalTextButton.isHidden = true
        switchCameraButton.imageView?.contentMode = UIViewContentMode.scaleAspectFit
         commentButton.imageView?.contentMode = UIViewContentMode.scaleAspectFit
         chatButton.imageView?.contentMode = UIViewContentMode.scaleAspectFit
         stopStreamButton.layer.cornerRadius = 2
         stopStreamButton.layer.masksToBounds = true
         stopStreamButton.layer.borderColor = UIColor.white
        .cgColor
         stopStreamButton.layer.borderWidth = 1
    }
    
    func startStreaming() {
        self.liveVideo.start()

        self.loader.startAnimating()
        self.recordButton.addSubview(self.loader)
        self.recordButton.isEnabled = false
    }
    
    func stopStreaming() {
        self.liveVideo.stop()
    }
    func scheduledTimerWithTimeInterval(){
        // Scheduling timer to Call the function "updateCounting" with the interval of 1 seconds
        startX = self.liveVideo.getVideoSize().width
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(HKLiveVideoViewController.updateCounting), userInfo: nil, repeats: true)
    }
    
    func updateCounting(){
        startX = startX - 1
        self.liveVideo.addHorizontalText(at:startX)
        print("startX \(startX)")
    }
    
    @IBAction func menuTapped(_ sender: Any) {
        menuButton.isSelected = !menuButton.isSelected
        if self.menuButton.isSelected{
            self.menuLeadingConstraint.constant = 0
        }else{
            self.menuLeadingConstraint.constant = 0 - self.menuWidthConstraint.constant
        }
        UIView.animate(withDuration: 0.5, animations: {
          
            self.view.updateFocusIfNeeded()

        }) { (finished) in
        }
    }
    
    @IBAction func switchCameraTapped(_ sender: Any) {
    }
    
    @IBAction func commentTapped(_ sender: Any) {
    }
    @IBAction func chatTapped(_ sender: Any) {
    }
    
    @IBAction func stopStreamTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension HKLiveVideoViewController : FBSDKLiveVideoDelegate {
    
    func liveVideo(_ liveVideo: FBSDKLiveVideo, didStartWith session: FBSDKLiveVideoSession) {
        self.loader.stopAnimating()
        self.loader.removeFromSuperview()
        self.recordButton.isEnabled = true
       
        self.recordButton.imageView?.image = UIImage(named: "stop-button")
        toggleFunctionalButtonView()
    }
    
    func liveVideo(_ liveVideo: FBSDKLiveVideo, didChange sessionState: FBSDKLiveVideoSessionState) {
        print("Session state changed to: \(sessionState)")
    }
    
    func liveVideo(_ liveVideo: FBSDKLiveVideo, didStopWith session: FBSDKLiveVideoSession) {
        self.recordButton.imageView?.image = UIImage(named: "record-button")
        toggleFunctionalButtonView()

    }
    
    func liveVideo(_ liveVideo: FBSDKLiveVideo, didErrorWith error: Error) {
        self.recordButton.imageView?.image = UIImage(named: "record-button")
        print("didErrorWith: \(error.localizedDescription)")
        self.loader.removeFromSuperview()
        self.recordButton.isEnabled = true;
    }
    
    func toggleFunctionalButtonView(){
//              footerButton.isHidden = !self.liveVideo.isStreaming
//            hozirontalTextButton.isHidden = !self.liveVideo.isStreaming
       
    }
}

extension HKLiveVideoViewController : FBSDKLoginButtonDelegate {
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        self.recordButton.isHidden = true
        self.view.insertSubview(self.blurOverlay, at: 1)
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil {
            print("Error logging in: \(error.localizedDescription)")
            return
        }
        
        self.recordButton.isHidden = false
        self.blurOverlay.removeFromSuperview()
    }
}
extension HKLiveVideoViewController{
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let width  = self.view.frame.size.width - 100
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width - 100, height: 50))
        let titleLabel = UILabel(frame: CGRect(x: 10, y: 0, width: width - 50, height: 50))
        titleLabel.text = "abc"
        titleLabel.textAlignment = .left
        titleLabel.textColor = .white
        view.addSubview(titleLabel)
        
        let expandButton = UIButton(frame: CGRect(x: width - 40, y: 10, width: 30, height: 30))
        let origImage = UIImage(named: "ic_angle_down")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        expandButton.setImage(tintedImage, for: .normal)
        expandButton.tintColor = .white
        expandButton.imageView?.contentMode = .scaleAspectFit
        
        view.addSubview(expandButton)
        
        return view
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 10
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell", for: indexPath)
        
        return cell
    }
}
