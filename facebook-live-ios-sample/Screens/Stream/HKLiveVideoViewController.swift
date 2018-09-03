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
//import GPUImage
class HKLiveVideoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    fileprivate let reuseCountDown = "CountDownViewCell"
    fileprivate let reuseSlogan = "SloganViewCell"
    fileprivate let reuseFrame = "FrameViewCellV2"
    fileprivate let reusePin = "PinCommentViewCell"
    fileprivate let reuseQuestion = "QuestionViewCell"
    fileprivate let reuseFilterComment  = "FilterCommentViewCell"
    fileprivate let reuseVideo  = "VideoViewCell"

    fileprivate let reuseCatchWord  = "CatchWordViewCell"
    fileprivate let reuseRandomNumber  = "RandomNumberViewCell"
    fileprivate let reuseCountComment  = "CountCommentViewCell"

    fileprivate let menuTitles:[String] = ["ĐẾM NGƯỢC","SLOGAN","KHUNG","PIN COMMENT","TẠO CÂU HỎI","LỌC BÌNH LUẬN","HIỂN THỊ VIDEO","ĐUỔI HÌNH BẮT CHỮ","SỐ NGẪU NHIÊN","THỐNG KÊ COMMENT"]
    var blurOverlay: UIVisualEffectView!

    var sessionURL: NSURL!
    
    var loader: UIActivityIndicatorView!
    
    
//    var liveVideo: FBSDKLiveVideo!
    var timer = Timer()
    var startX : CGFloat = 0.0
    
    @IBOutlet weak var commentContainerView: UIView!
    var commentView:StreamCommentView?
    let commentViewHeight:CGFloat = 300
    
    @IBOutlet weak var stopStreamButton: UIButton!
    
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var switchCameraButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var chatButton: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sideMenuView: UIView!
    
    
    @IBOutlet weak var menuLeadingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var menuWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var chatContainerView: UIView!
    @IBOutlet weak var chatTextView: UITextView!
    @IBOutlet weak var commentBoxMarginBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var commentViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var menuBottomConstraint: NSLayoutConstraint!
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
        let videoConfiguration = LFLiveVideoConfiguration.defaultConfiguration(for: LFLiveVideoQuality.high3)
        videoConfiguration?.videoSize = CGSize(width: 720, height: 1280)
        let session = LFLiveSession(audioConfiguration: audioConfiguration, videoConfiguration: videoConfiguration)
        return session!
    }()
    
    
    // 开始直播按钮
    var curMenuIndex:Int = -1;
    var streamUrls:[StreamInfo] = []
    
    //
    let imagePicker = UIImagePickerController()
    var selectedImage:[String:UIImage] = [:]
    var selectPhotoKey:String = ""
//    var backgroundMovie:GPUImageMovie?
    
    var randomView:RandomMaskView?
    var updateTimer:Timer?
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
        session.preView = self.view;
        
        self.requestAccessForVideo()
        self.requestAccessForAudio()
        self.view.backgroundColor = UIColor.clear
//        self.view.addSubview(closeButton)
//        self.view.addSubview(cameraButton)
        //
        commentView = StreamCommentView(frame: CGRect(x: 0, y:0, width: self.view.frame.size.width, height: commentViewHeight))
        commentView?.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        commentContainerView.addSubview(commentView!)
        commentContainerView.bringSubview(toFront: self.chatContainerView)
        commentView?.didPinComment = {[unowned self] in
            self.updateWatermarkView(nil)
        }
        //
//        cameraButton.addTarget(self, action: #selector(didTappedCameraButton(_:)), for:.touchUpInside)
//        closeButton.addTarget(self, action: #selector(didTappedWarterMarkButton(_:)), for:.touchUpInside)
        toggleMenuView()
        WarterMarkServices.shared().setFrame(frame: CGRect(x: 0, y: 0, width: 720, height: 1280))
        
        
        ///
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 300
        tableView.register(UINib(nibName: reuseCountDown, bundle: nil), forCellReuseIdentifier: reuseCountDown)
        tableView.register(UINib(nibName: reuseSlogan, bundle: nil), forCellReuseIdentifier: reuseSlogan)
        tableView.register(UINib(nibName: reuseFrame, bundle: nil), forCellReuseIdentifier: reuseFrame)
        tableView.register(UINib(nibName: reusePin, bundle: nil), forCellReuseIdentifier: reusePin)
        tableView.register(UINib(nibName: reuseQuestion, bundle: nil), forCellReuseIdentifier: reuseQuestion)
        tableView.register(UINib(nibName: reuseFilterComment, bundle: nil), forCellReuseIdentifier: reuseFilterComment)
        tableView.register(UINib(nibName: reuseVideo, bundle: nil), forCellReuseIdentifier: reuseVideo)

        tableView.register(UINib(nibName: reuseCatchWord, bundle: nil), forCellReuseIdentifier: reuseCatchWord)
        tableView.register(UINib(nibName: reuseRandomNumber, bundle: nil), forCellReuseIdentifier: reuseRandomNumber)
        tableView.register(UINib(nibName: reuseCountComment, bundle: nil), forCellReuseIdentifier: reuseCountComment)

    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        APIClient.shared().startLive(stremInfo: self.streamUrls[0], width: 720, height: 1280, id_category: "", time_countdown: 0) { (success, message, targets) in
//            
//        }

        startLive()
        
//        let height:CGFloat = 300
//        let width:CGFloat = height / (720 / 1280)
//        let x = UIScreen.main.bounds.width - width
//        let frame =  CGRect(x: self.view.frame.width - width, y: self.view.frame.height - height - 50 , width: width, height: height)
//        let videoView = VideoMaskView(frame:frame)
//        videoView.playVideo(from: "http://techslides.com/demos/sample-videos/small.mp4")
//        self.view.addSubview(videoView)
    }
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear(_:)), name: Notification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear(_:)), name: Notification.Name.UIKeyboardWillShow, object: nil)
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
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
        switchCamera()
    }
    
    @IBAction func commentTapped(_ sender: Any) {
        UIView.animate(withDuration: 0.25) { [unowned self] in
            if let tag = self.commentContainerView?.tag, tag == 1{
//                 self.commentContainerView?.isHidden = true
                self.commentViewHeightConstraint.constant = 50

                 self.commentContainerView?.tag = 0
                self.commentView?.toggleTableView(isHidden:true)
            }else{
                self.commentViewHeightConstraint.constant = 350
                 self.commentContainerView?.tag = 1
                self.commentView?.toggleTableView(isHidden:false)
            }
        }
        
    }
    @IBAction func chatTapped(_ sender: Any) {
        chatTextView.text = ""
        FacebookServices.shared().postComment(message: "", streamId: "", tokenString: "");
        self.view.endEditing(true)
    }
    
    @IBAction func stopStreamTapped(_ sender: Any) {
//        dismiss(animated: true, completion: nil)
            stopLive()
    }
    func toggleFunctionalButtonView(){
        //              footerButton.isHidden = !self.liveVideo.isStreaming
        //            hozirontalTextButton.isHidden = !self.liveVideo.isStreaming
        
    }
    func hideMenuView(){
        menuButton.isSelected = false;
        toggleMenuView()
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
            self.view.bringSubview(toFront: self.sideMenuView)
            self.view.endEditing(true)
        }
    }
    @objc func keyboardWillAppear(_ notification: Notification) {
        //Do something here
        adjustKeyboardShow(true, notification: notification)

    }
    
    @objc func keyboardWillDisappear(_ notification: Notification) {
        //Do something here
        adjustKeyboardShow(false, notification: notification)
    }
    func adjustKeyboardShow(_ open: Bool, notification: Notification) {
        let userInfo = notification.userInfo ?? [:]
        let keyboardFrame = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        let height = (keyboardFrame.height) * (open ? 1 : 0)
        self.commentBoxMarginBottomConstraint.constant = height;
        if  curMenuIndex >= 5 {
            self.menuBottomConstraint.constant = height
        }
    }
    func hideCommentView(){
        
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
            let cell = tableView.dequeueReusableCell(withIdentifier:reuseCountDown, for: indexPath) as! CountDownViewCell
            cell.completeHandle = {[unowned self] isShow in

                self.updateWatermarkView(nil)
                if let countdown = WarterMarkServices.shared().params[ConfigKey.countdown.rawValue] as? [String:Any], let _ = countdown["countdown"] as? String{
                    self.view.endEditing(true)
                    self.hideMenuView()
                }
                if let countdown = WarterMarkServices.shared().params[ConfigKey.countdown.rawValue] as? [String:Any]{
                    if let mute = countdown["mute"] as? Bool{
                        self.session.muted = mute
                    }
                }
            }
            cell.tappedUploadImage = {[unowned self] in
                self.selectPhotoKey = "countdown"

                self.openPhotoLibrary()
            }
            cell.selectionStyle = .none
            return cell
        case 1:
            //slogan
            let cell = tableView.dequeueReusableCell(withIdentifier:reuseSlogan, for: indexPath) as! SloganViewCell
            cell.completeHandle = {[unowned self]update in
                self.updateWatermarkView(nil)
            }
            cell.selectionStyle = .none
            return cell
        case 2:
            //list frame
            let cell = tableView.dequeueReusableCell(withIdentifier:reuseFrame, for: indexPath)
            cell.selectionStyle = .none
            return cell
        case 3:
            //pin comment
            let cell = tableView.dequeueReusableCell(withIdentifier:reusePin, for: indexPath) as! PinCommentViewCell
            cell.selectionStyle = .none
            cell.completeHandle = {[unowned self] in
                self.updateWatermarkView(nil)
            }
            return cell
        case 4:
            //add question
            let cell = tableView.dequeueReusableCell(withIdentifier:reuseQuestion, for: indexPath) as! QuestionViewCell
            cell.didTapSelectImage = {[unowned self] in
                self.selectPhotoKey = "questionImage"
                self.openPhotoLibrary()
            }
            cell.didUpdateQuestionConfig = {[unowned self] in
                self.updateWatermarkView(nil)
            }
            cell.updateQuestionImage(selectedImage["questionImage"])
            cell.selectionStyle = .none
            return cell
        case 5:
            //filter comment
            let cell = tableView.dequeueReusableCell(withIdentifier:reuseFilterComment, for: indexPath) as! FilterCommentViewCell
            cell.didUpdateFilterConfig = {[unowned self] in
                self.updateWatermarkView(nil)
            }
            cell.selectionStyle = .none
            return cell
        case 6:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseVideo, for: indexPath) as! VideoViewCell
            cell.completeHandle = {[unowned self] in
                self.updateWatermarkView(nil)
            }
            cell.selectionStyle = .none
            return cell
        
        case 7:
            //catch word
            let cell = tableView.dequeueReusableCell(withIdentifier:reuseCatchWord, for: indexPath) as! CatchWordViewCell
       
            cell.completeHandle = {[unowned self]type in
                //0 start
                //1 add frame
                //2 add image
                if type == 1{
                    self.selectPhotoKey = "frameImage"
                    self.openPhotoLibrary()
                }else if (type == 2){
                    self.selectPhotoKey = "questionImage"

                    self.openPhotoLibrary()
                }else{
                    self.updateWatermarkView(nil)
                }
            }
        cell.updateImages(frame:selectedImage["frameImage"],questionImage:selectedImage["questionImage"])
            cell.selectionStyle = .none
            
            return cell
        case 8:
            //random comment
            let cell = tableView.dequeueReusableCell(withIdentifier:reuseRandomNumber, for: indexPath) as! RandomNumberViewCell
            cell.completeHandle = {[unowned self ] in
                self.updateWatermarkView(nil)
            }
            cell.selectionStyle = .none
            return cell
        case 9:
            let cell = tableView.dequeueReusableCell(withIdentifier:reuseCountComment, for: indexPath) as! CountCommentViewCell
            cell.completeHandle = {[unowned self ] in
                self.updateWatermarkView(nil)
            }
            cell.didTapSelectImage = {[unowned self] key in
                self.selectPhotoKey = key
                self.openPhotoLibrary()

            }
            if let image = self.selectedImage[ConfigKey.countComment.rawValue]{
                cell.updateCountCommentImage(image)
            }
            cell.selectionStyle = .none
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
        case AVAuthorizationStatus.notDetermined:
            AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { (granted) in
                if(granted){
                    DispatchQueue.main.async {
                        self.session.running = true
                    }
                }
            })
            break;
        case AVAuthorizationStatus.authorized:
            session.running = true;
            break;
        case AVAuthorizationStatus.denied: break
        case AVAuthorizationStatus.restricted:break;
        default:
            break;
        }
    }
    
    func requestAccessForAudio() -> Void {
        let status = AVCaptureDevice.authorizationStatus(for:AVMediaType.audio)
        switch status  {
        case AVAuthorizationStatus.notDetermined:
            AVCaptureDevice.requestAccess(for: AVMediaType.audio, completionHandler: { (granted) in
                
            })
            break;
        case AVAuthorizationStatus.authorized:
            break;
        case AVAuthorizationStatus.denied: break
        case AVAuthorizationStatus.restricted:break;
        default:
            break;
        }
    }
    func startLive(){
        if streamUrls.count > 0 {
            let stream = LFLiveStreamInfo()
            stream.url = streamUrls[0].getLiveStreamUrl()
            stream.streamId = streamUrls[0].streamId
            print("stream : start \(stream.url!) + +\(stream.streamId!)")
            session.startLive(stream)
        }
       
        
    }
    func stopLive(){
        session.stopLive()

    }
    //MARK: - Callbacks
    
    func liveSession(_ session: LFLiveSession?, debugInfo: LFLiveDebug?) {
        print("stream : debugInfo: \(String(describing: debugInfo?.currentBandwidth))")
    }
    
    func liveSession(_ session: LFLiveSession?, errorCode: LFLiveSocketErrorCode) {
        print("stream : errorCode: \(errorCode.rawValue)")
    }
    
    func liveSession(_ session: LFLiveSession?, liveStateDidChange state: LFLiveState) {
        print("stream : liveStateDidChange: \(state.rawValue)")
        switch state {
        case LFLiveState.ready:
            

            break;

        case LFLiveState.pending:
            break;
        case LFLiveState.start:
            Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(fetchStreamComments), userInfo: nil, repeats: true)
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
    
   
    @objc func updateWatermarkView(_ button: UIButton?) -> Void {
        if let countdown = WarterMarkServices.shared().params[ConfigKey.countdown.rawValue] as? [String:Any], let _ = countdown["countdown"] as? String{
            self.updateTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateWatermarkView(_:)), userInfo: nil, repeats: false)
            

        }else{
            if self.updateTimer != nil{
                self.updateTimer?.invalidate()
                self.updateTimer = nil
            }
            if let random = WarterMarkServices.shared().params[ConfigKey.random.rawValue]as? [String:Any], random.keys.count >= 2{
            
            if let _ = randomView {
            
            }else{
                let width:CGFloat = 720 / 2
                let height =  (width / 1008 ) * (696 + 30 + 165)
                let left = (self.view.bounds.width  - width ) / 2
                let top = (self.view.bounds.height - height ) / 2
                randomView = RandomMaskView(frame:CGRect(x: left, y: top, width: width, height: height), scale: 1)
                randomView?.backgroundColor = .clear
                randomView?.completeHandle = {[weak self]start in
                    guard let strongSelf = self else{
                        return
                    }
                    if start{
                        WarterMarkServices.shared().startRandomNumber()
                        if let _  = strongSelf.updateTimer{
                            strongSelf.updateTimer?.invalidate()
                            strongSelf.updateTimer = nil
                        }
                        strongSelf.updateTimer = Timer.scheduledTimer(timeInterval: 0.02, target: strongSelf, selector: #selector(strongSelf.updateWatermarkView(_:)), userInfo: nil, repeats: true)

                    }else{
                        WarterMarkServices.shared().stopRandomNumber()
                        if let _  = strongSelf.updateTimer{
                            strongSelf.updateTimer?.invalidate()
                            strongSelf.updateTimer = nil
                        }

                    }
                    
                }
                self.view.addSubview(randomView!)
                self.updateTimer = Timer.scheduledTimer(timeInterval: 0.02, target: self, selector: #selector(self.updateWatermarkView(_:)), userInfo: nil, repeats: true)

            }
        }else{
            if let view = randomView{
                view.removeFromSuperview()
                randomView = nil
            }
        }
        }
        let wartermarkFrame  = CGRect(x: 0, y: 0, width: 720, height: 1280 )
        WarterMarkServices.shared().setFrame(frame: wartermarkFrame)
        let view  = randomView?.copyView()  as? RandomMaskView
        let scale = 720 / UIScreen.main.bounds.width
        view?.transform = CGAffineTransform(scaleX: scale, y: scale)
        WarterMarkServices.shared().randomView = view
        view?.stopRandom()
        let waterMarkView = WarterMarkServices.shared().generateWarterMark()
        session.warterMarkView = waterMarkView

    }
    @objc func didTappedBeautyButton(_ button: UIButton) -> Void {
        session.beautyFace = !session.beautyFace;
    }
    
    @objc func didTappedCameraButton(_ button: UIButton) -> Void {
       switchCamera()
    }
    
    // 关闭
    func didTappedCloseButton(_ button: UIButton) -> Void  {
        
    }
    func switchCamera(){
        let devicePositon = session.captureDevicePosition;
        session.captureDevicePosition = (devicePositon == AVCaptureDevice.Position.back) ? AVCaptureDevice.Position.front : AVCaptureDevice.Position.back;
    }
     @objc func fetchStreamComments(){
        print("fetchStreamComments")
        FacebookServices.shared().getStreamComment(streamId: self.streamUrls[0].streamId) {[unowned self] (comments) in
            if let view = self.commentView{
                if comments.count == 0{
                    var dummyComments:[FacebookComment] = []
                    for i in 0..<10{
                        let comment = FacebookComment(message: "a", commentId: "\(i)", createTime: "2018-09-02T11:44:39+0000", fromId: "\(i)\(i)", fromName: "name\(i)")
                        dummyComments.append(comment)
                    }
                    view.reloadData(data: dummyComments)
                    APIClient.shared().comments = dummyComments

                }else{
                    view.reloadData(data: comments)
                    APIClient.shared().comments = comments

                }
                if WarterMarkServices.shared().hasFilterCommentView(){
                    self.updateWatermarkView(nil)
                }
            }
        }
    }
    //MARK: - Getters and Setters
  
    func openPhotoLibrary() {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            print("can't open photo library")
            return
        }
        
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        present(imagePicker, animated: true)
    }
}
extension HKLiveVideoViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        defer {
            picker.dismiss(animated: true)
        }
        
        print(info)
        // get the image
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            return
        }
        
        // do something with it
//        imageView.image = image//÷
        print("selectPhotoKey \(self.selectPhotoKey)")
        self.selectedImage[self.selectPhotoKey] = image
        self.tableView.reloadData()
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        defer {
            picker.dismiss(animated: true)
        }
        
        print("did cancel")
    }
}
