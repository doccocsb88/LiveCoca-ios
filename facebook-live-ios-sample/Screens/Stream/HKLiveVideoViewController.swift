//
//  ViewController.swift
//  facebook-live-ios-sample
//
//  Created by Hans Knoechel on 08.03.17.
//  Copyright © 2017 Hans Knoechel. All rights reserved.
//

import UIKit
//import FBSDKCoreKit
//import FBSDKLoginKit
import LFLiveKit
class HKLiveVideoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    fileprivate let reuseCountDown = "CountDownViewCell"
    fileprivate let reuseSlogan = "SloganViewCell"
    fileprivate let reuseFrame = "FrameViewCellV2"
    fileprivate let reusePin = "PinCommentViewCell"
    fileprivate let reuseQuestion = "QuestionViewCell"
    fileprivate let reuseFilterComment  = "FilterCommentViewCell"
    fileprivate let reuseCatchWord  = "CatchWordViewCell"
    fileprivate let reuseRandomNumber  = "RandomNumberViewCell"
    fileprivate let menuTitles:[String] = ["ĐẾM NGƯỢC","SLOGAN","KHUNG","PIN COMMENT","TẠO CÂU HỎI","LỌC BÌNH LUẬN","ĐUỔI HÌNH BẮT CHỮ","SỐ NGẪU NHIÊN"]
    var blurOverlay: UIVisualEffectView!

    var sessionURL: NSURL!
    
    var loader: UIActivityIndicatorView!
    
    
//    var liveVideo: FBSDKLiveVideo!
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
    }
    
    @IBAction func horizontalButtonTapped(_ sender: Any) {
        self.scheduledTimerWithTimeInterval()
    }
    
    @IBAction func footerButtonTapped(_ sender: Any) {
//        self.liveVideo.addFooter()
    }
    
    var session: LFLiveSession = {
        let audioConfiguration = LFLiveAudioConfiguration.defaultConfiguration(for: LFLiveAudioQuality.high)
        let videoConfiguration = LFLiveVideoConfiguration.defaultConfiguration(for: LFLiveVideoQuality.low3)
        let session = LFLiveSession(audioConfiguration: audioConfiguration, videoConfiguration: videoConfiguration)
        return session!
    }()
    
   
    

    
    // 关闭按钮
    var closeButton: UIButton = {
        let closeButton = UIButton(frame: CGRect(x: UIScreen.main.bounds.width - 10 - 44, y: 20, width: 44, height: 44))
        closeButton.setImage(UIImage(named: "close_preview"), for: UIControlState())
        closeButton.backgroundColor = UIColor.green
        return closeButton
    }()
    
    // 摄像头
    var cameraButton: UIButton = {
        let cameraButton = UIButton(frame: CGRect(x: UIScreen.main.bounds.width - 54 * 2, y: 20, width: 44, height: 44))
        cameraButton.setImage(UIImage(named: "camra_preview"), for: UIControlState())
        cameraButton.backgroundColor = UIColor.blue
        return cameraButton
    }()
    
 
    
    // 开始直播按钮
    var curMenuIndex:Int = -1;
    override func viewDidLoad() {
        super.viewDidLoad()
//          1920x1080
//          1280x720
//        self.liveVideo = FBSDKLiveVideo(
//            delegate: self,
//            previewSize: self.view.bounds,
//            videoSize: CGSize(width: 720, height: 1280)
//        )
        
        let myOverlay = UIView(frame: CGRect(x: 5, y: 5, width: self.view.bounds.size.width - 10, height: 30))
        myOverlay.backgroundColor =  UIColor(red: 0.0 , green:1.0, blue: 0.0, alpha: 0.5)
        
//        self.liveVideo.privacy = .me
//        self.liveVideo.audience = "me" // or your user-id, page-id, event-id, group-id, ...
        
        // Comment in to show a green overlay bar (configure with your own one)
        // self.liveVideo.overlay = myOverlay
        
        initializeUserInterface()
        
        
        session.delegate = self
        session.preView = self.view
        
        self.requestAccessForVideo()
        self.requestAccessForAudio()
        self.view.backgroundColor = UIColor.clear
        self.view.addSubview(closeButton)
        self.view.addSubview(cameraButton)

        cameraButton.addTarget(self, action: #selector(didTappedCameraButton(_:)), for:.touchUpInside)
        closeButton.addTarget(self, action: #selector(didTappedWarterMarkButton(_:)), for:.touchUpInside)
        toggleMenuView()
        WarterMarkServices.shared().setFrame(frame: self.view.bounds)
        
        
        ///
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 300
        tableView.register(UINib(nibName: reuseCountDown, bundle: nil), forCellReuseIdentifier: reuseCountDown)
        tableView.register(UINib(nibName: reuseSlogan, bundle: nil), forCellReuseIdentifier: reuseSlogan)
        tableView.register(UINib(nibName: reuseFrame, bundle: nil), forCellReuseIdentifier: reuseFrame)
        tableView.register(UINib(nibName: reusePin, bundle: nil), forCellReuseIdentifier: reusePin)
        tableView.register(UINib(nibName: reuseQuestion, bundle: nil), forCellReuseIdentifier: reuseQuestion)
        tableView.register(UINib(nibName: reuseFilterComment, bundle: nil), forCellReuseIdentifier: reuseFilterComment)
        tableView.register(UINib(nibName: reuseCatchWord, bundle: nil), forCellReuseIdentifier: reuseCatchWord)
        tableView.register(UINib(nibName: reuseRandomNumber, bundle: nil), forCellReuseIdentifier: reuseRandomNumber)

    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startLive()
    }
    
    func initializeUserInterface() {
        self.loader = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        self.loader.frame = CGRect(x: 15, y: 15, width: 40, height: 40)
        
        self.blurOverlay = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        self.blurOverlay.frame = self.view.bounds
        
//        self.view.insertSubview(self.liveVideo.preview, at: 0)


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
//        self.liveVideo.start()

        self.loader.startAnimating()
        self.recordButton.addSubview(self.loader)
        self.recordButton.isEnabled = false
    }
    
    func stopStreaming() {
//        self.liveVideo.stop()
    }
    func scheduledTimerWithTimeInterval(){
        // Scheduling timer to Call the function "updateCounting" with the interval of 1 seconds
//        startX = self.liveVideo.getVideoSize().width
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(HKLiveVideoViewController.updateCounting), userInfo: nil, repeats: true)
    }
    
    @objc func updateCounting(){
        startX = startX - 1
//        self.liveVideo.addHorizontalText(at:startX)
        print("startX \(startX)")
    }
    
    @IBAction func menuTapped(_ sender: Any) {
        menuButton.isSelected = !menuButton.isSelected
        toggleMenuView()
    }
    
    @IBAction func switchCameraTapped(_ sender: Any) {
    }
    
    @IBAction func commentTapped(_ sender: Any) {
    }
    @IBAction func chatTapped(_ sender: Any) {
    }
    
    @IBAction func stopStreamTapped(_ sender: Any) {
//        dismiss(animated: true, completion: nil)
            stopLive()
    }
    func toggleFunctionalButtonView(){
        //              footerButton.isHidden = !self.liveVideo.isStreaming
        //            hozirontalTextButton.isHidden = !self.liveVideo.isStreaming
        
    }
    func toggleMenuView(){
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
}



extension HKLiveVideoViewController{
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            //countdown
            return 190
            
        case 1:
            //slogan
            return 315
        case 2:
            //list frame
            return 80
        case 3:
            //prin comment
            return 110
        case 4:
            //add question
            return 410
        case 5:
            //filter comment
            return 280
        case 6:
            //catch word
            return 320
        case 7:
            //random number
            return 150
        default:
            return 0
            
        }
        return 0
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let width  = self.view.frame.size.width - 100
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width - 100, height: 50))
        let titleLabel = UILabel(frame: CGRect(x: 10, y: 0, width: width - 50, height: 50))
        titleLabel.text = menuTitles[section]
        titleLabel.textAlignment = .left
        titleLabel.textColor = .white
        view.addSubview(titleLabel)
        
        let expandButton = UIButton(frame: CGRect(x: width - 40, y: 10, width: 30, height: 30))
        let origImage = section == curMenuIndex ? UIImage(named: "ic_angle_down") : UIImage(named: "ic_angle_up")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        expandButton.tag = section
        expandButton.setImage(tintedImage, for: .normal)
        expandButton.tintColor = .white
        expandButton.imageView?.contentMode = .scaleAspectFit
        expandButton.addTarget(self, action: #selector(didExpandTableCell(_:)), for: .touchUpInside)
        view.addSubview(expandButton)
        view.backgroundColor = UIColor.darkGray
        return view
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return menuTitles.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == curMenuIndex{
            if section == 2{
                return 10
            }
            return 1
        }
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            //countdown
            let cell = tableView.dequeueReusableCell(withIdentifier:reuseCountDown, for: indexPath)
            return cell
        case 1:
            //slogan
            let cell = tableView.dequeueReusableCell(withIdentifier:reuseSlogan, for: indexPath)
            return cell
        case 2:
            //list frame
            let cell = tableView.dequeueReusableCell(withIdentifier:reuseFrame, for: indexPath)
            return cell
        case 3:
            //pin comment
            let cell = tableView.dequeueReusableCell(withIdentifier:reusePin, for: indexPath)
            return cell
        case 4:
            //add question
            let cell = tableView.dequeueReusableCell(withIdentifier:reuseQuestion, for: indexPath)
            return cell
        case 5:
            //filter comment
            let cell = tableView.dequeueReusableCell(withIdentifier:reuseFilterComment, for: indexPath)
            return cell
        case 6:
            //filter comment
            let cell = tableView.dequeueReusableCell(withIdentifier:reuseCatchWord, for: indexPath)
            return cell
        case 7:
            //filter comment
            let cell = tableView.dequeueReusableCell(withIdentifier:reuseRandomNumber, for: indexPath)
            return cell
        default:
            let cell = UITableViewCell()
            
            return cell
        }
    }
    @objc func didExpandTableCell(_ button: UIButton){
        curMenuIndex = button.tag
        tableView.scrollsToTop = true
        tableView.reloadData()
    }
}
extension HKLiveVideoViewController : LFLiveSessionDelegate {
    func requestAccessForVideo() -> Void {
        let status = AVCaptureDevice.authorizationStatus(for: AVMediaType.video);
        switch status  {
        // 许可对话没有出现，发起授权许可
        case AVAuthorizationStatus.notDetermined:
            AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { (granted) in
                if(granted){
                    DispatchQueue.main.async {
                        self.session.running = true
                    }
                }
            })
            break;
        // 已经开启授权，可继续
        case AVAuthorizationStatus.authorized:
            session.running = true;
            break;
        // 用户明确地拒绝授权，或者相机设备无法访问
        case AVAuthorizationStatus.denied: break
        case AVAuthorizationStatus.restricted:break;
        default:
            break;
        }
    }
    
    func requestAccessForAudio() -> Void {
        let status = AVCaptureDevice.authorizationStatus(for:AVMediaType.audio)
        switch status  {
        // 许可对话没有出现，发起授权许可
        case AVAuthorizationStatus.notDetermined:
            AVCaptureDevice.requestAccess(for: AVMediaType.audio, completionHandler: { (granted) in
                
            })
            break;
        // 已经开启授权，可继续
        case AVAuthorizationStatus.authorized:
            break;
        // 用户明确地拒绝授权，或者相机设备无法访问
        case AVAuthorizationStatus.denied: break
        case AVAuthorizationStatus.restricted:break;
        default:
            break;
        }
    }
    func startLive(){
      let stream = LFLiveStreamInfo()
            stream.url = "rtmp://live-api-s.facebook.com:80/rtmp/1877886212257888?ds=1&s_vt=api-s&a=ATgcF4aipBBcRBTO"
            session.startLive(stream)
      
    }
    func stopLive(){
        session.stopLive()

    }
    //MARK: - Callbacks
    
    // 回调
    func liveSession(_ session: LFLiveSession?, debugInfo: LFLiveDebug?) {
        print("debugInfo: \(String(describing: debugInfo?.currentBandwidth))")
    }
    
    func liveSession(_ session: LFLiveSession?, errorCode: LFLiveSocketErrorCode) {
        print("errorCode: \(errorCode.rawValue)")
    }
    
    func liveSession(_ session: LFLiveSession?, liveStateDidChange state: LFLiveState) {
        print("liveStateDidChange: \(state.rawValue)")
        switch state {
        case LFLiveState.ready:
            break;
        case LFLiveState.pending:
            break;
        case LFLiveState.start:
            break;
        case LFLiveState.error:
            break;
        case LFLiveState.stop:
            break;
        default:
            break;
        }
    }
    
    //MARK: - Events
    
    // 开始直播
   
    @objc func didTappedWarterMarkButton(_ button: UIButton) -> Void {
        let wartermarkView = UIImageView()
        wartermarkView.backgroundColor = UIColor.clear
        wartermarkView.image = WarterMarkServices.shared().generateWarterMark()
        wartermarkView.frame = self.view.bounds
        session.warterMarkView = wartermarkView
    }
    // 美颜
    @objc func didTappedBeautyButton(_ button: UIButton) -> Void {
        session.beautyFace = !session.beautyFace;
    }
    
    // 摄像头
    @objc func didTappedCameraButton(_ button: UIButton) -> Void {
        let devicePositon = session.captureDevicePosition;
        session.captureDevicePosition = (devicePositon == AVCaptureDevice.Position.back) ? AVCaptureDevice.Position.front : AVCaptureDevice.Position.back;
    }
    
    // 关闭
    func didTappedCloseButton(_ button: UIButton) -> Void  {
        
    }
    
    //MARK: - Getters and Setters
    
    //  默认分辨率368 ＊ 640  音频：44.1 iphone6以上48  双声道  方向竖屏

}
