//
//  StreamViewController.swift
//  coca-live
//
//  Created by Apple on 7/26/18.
//  Copyright © 2018 Coca Live. All rights reserved.
//

import UIKit
import Lottie
import AVFoundation
//import CommonCrypto
class StreamViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    enum PickType:Int{
        case account
        case target
    }
    fileprivate let reuseOptionCell = "streamOptionCell"
    fileprivate let reuseUrlCell = "streamUrlCell"
    fileprivate let pickerHeight:CGFloat = 340

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var addUrlStreamButton: UIButton!
    var picker:UIPickerView?
    var pickerView:UIView?
    
    let selectStreamInfoVC = SelectStreamAccountViewController()
    var streamViewController:HKLiveVideoViewController?
    var selectedAccount: BaseInfo?
    var selectedPages:SocialTarget?
    var curTargets:[SocialTarget] = []
    var streamUrls:[StreamInfo] = []
    var openLogin:Bool = false
    var pickerType:PickType = .account
    var caption:String?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let pw = "123456IrbrMHoO8zjaqy3h"
        print("aaaa : \("".MD5(pw))")
        setup()
        setupUI()
        initLoadingView(nil)
//        FacebookServices.shared().fetchData {
//            let pages = FacebookServices.shared().accountList;
//            print("pages : \(pages.count)")
//        }
        APIClient.shared().getUser(completion: {
            
        })
        
        //get list frame
        
        let date = Date(milliseconds: 1538397789)
        let txt = date.caculateTimeToNow()
        
        NSLog("fromnow %@ --- %@", txt, date.converToString())
        fetchSocialAccounts()

    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIApplication.shared.statusBarStyle = .lightContent
        
       
    }
    override var prefersStatusBarHidden: Bool{
        return false
    }
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setup(){
       
        self.navigationController?.navigationBar.topItem?.title = "ĐĂNG LIVESTREAM"

        //
        
        tableView.register(UINib(nibName: "StreamOptionViewCell", bundle: nil), forCellReuseIdentifier:reuseOptionCell)
        tableView.register(UINib(nibName: "UrlStreamViewCell", bundle: nil), forCellReuseIdentifier:reuseUrlCell)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        self.view.addGestureRecognizer(tapGesture)
        
        //
        selectStreamInfoVC.modalPresentationStyle = .overFullScreen
        selectStreamInfoVC.didSelectAccount = {[unowned self](account) in
                self.selectedAccount = account
                self.loadingAnimation!.isHidden = false
                self.loadingAnimation?.play()
                APIClient.shared().getFacebookTargets(id_social: account.userId, completion: {[unowned self] (success, message,targets) in
                    self.loadingAnimation?.isHidden = true
                    self.loadingAnimation?.stop()
                    if success{
                        self.selectStreamInfoVC.accountList = []
                        self.selectStreamInfoVC.refreshData(targets: targets ?? [])
                    }
                })
                self.tableView.reloadData()

            
        }
        selectStreamInfoVC.didSelectTarget = { target in
            self.selectedPages = target
            self.tableView.reloadData()
        }
        /*
         init pickerView
         */
        let pickerPosY =  self.view.frame.size.height
        let pickerWidth  = self.view.frame.size.width
        let frame = CGRect(x: 0, y: pickerPosY, width: pickerWidth, height: pickerHeight)
        //
        pickerView = UIView(frame: frame)
        pickerView?.addShadow(offset:CGSize(width: 0, height: -1),radius:2)
        pickerView?.backgroundColor = .white
        //
        let updateButton = UIButton(frame: CGRect(x: pickerWidth - 65, y: 5, width: 60, height: 30))
        updateButton.setTitle("Cập nhật", for: .normal)
        updateButton.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        updateButton.setTitleColor(.black, for: .normal)
        updateButton.addTarget(self, action: #selector(tappedUpdateAcountTarget(_:)), for: .touchUpInside)
        updateButton.addBorder(cornerRadius: 4, color: UIColor(hexString: "#FC6076"))
        pickerView?.addSubview(updateButton)
        //
        let marginTop:CGFloat = 40
        picker = UIPickerView(frame: CGRect(x: 0, y: marginTop, width: pickerWidth, height: pickerHeight - marginTop))
        picker?.backgroundColor = .white
        picker?.dataSource = self
        picker?.delegate = self
        picker?.addShadow(offset:CGSize(width: 0, height: -0.2),radius:0.2)

        pickerView?.addSubview(picker!)
        self.view.addSubview(pickerView!)
        //
        // Create Boat Animation
    }
    func setupUI(){
        let buttonSize = nextButton.frame.size;
        nextButton.layer.cornerRadius = buttonSize.height / 2;
        nextButton.layer.masksToBounds = true
        
        addUrlStreamButton.layer.cornerRadius = buttonSize.height /  2
        addUrlStreamButton.layer.masksToBounds = true
    }
    

    func fetchSocialAccounts(){
        showLoadingView()
        APIClient.shared().getListAccount {[unowned self] (success, message) in
            self.hideLoadingView()
            if success{
                if APIClient.shared().accounts.count > 0{
                    self.selectedAccount = APIClient.shared().accounts[0];
                    self.tableView.reloadData()
                    self.getTarget()
                }
            }else{
                self.showMessageDialog(nil, message ?? "")
            }
        }
    }
    func openAddFbAccessTokenScreen(){
        let vc = AddStreamAccountViewController(nibName: "AddStreamAccountViewController", bundle: nil)
        vc.modalPresentationStyle = .overFullScreen
        vc.didAddFacebookToken = {
            self.fetchSocialAccounts()
        }
        self.present(vc, animated: true, completion: nil)
    }
    func openHasStreamView(id_social:String,id_target:String){
        let vc = HasStreamPopupView(nibName: "HasStreamPopupView", bundle: nil)
        vc.id_social = id_social
        vc.id_target = id_target
        vc.modalPresentationStyle = .overFullScreen
        vc.didCreateLive = {info in
            if let _info = info{
                _info.id_social = self.selectedAccount?.userId
                _info.id_target = self.selectedPages?.id
                self.streamUrls.append(_info)
                self.tableView.reloadData()
            }
        }
        self.present(vc, animated: true, completion: nil)
    }

     @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    @IBAction func addUrlStreamTapped(_ sender: Any) {
        guard let target = selectedPages else{
//            boatAnimation?.isHidden = false
//            boatAnimation?.play()
//            FacebookServices.shared().getFacebookLiveStreamURL(pageInfo: FacebookInfo()) {[unowned self] (info) in
//                self.streamUrls.append(info)
//                self.tableView.reloadData()
//                self.boatAnimation?.stop()
//                self.boatAnimation?.isHidden = true
//            }
            return
        }
        guard let account = selectedAccount else{
            return
        }
        if self.streamUrls.count >= 2{
            self.showAlertMessage(nil, "Bạn chỉ có thể live stream tối đa trên hai trang cùng một thời điểm")
            return
        }
        for streamInfo in self.streamUrls {
            if streamInfo.id_social == account.userId && streamInfo.id_target == target.id{
                self.showAlertMessage(nil, "Bạn chỉ có thể đăng 1 live stream trên một trang. Vui lòng chọn nơi đăng khác.")

                return;
            }
        }
        self .showLoadingView()
        
        APIClient.shared().createLive(id_social: account.userId, id_target: target.id, caption: self.caption ?? APIClient.DEFAULT_CAPTION) {[unowned self]  (success,code , message, info) in
            self.hideLoadingView()
            if success{
                if let _info = info{
                    _info.id_social = account.userId
                    _info.id_target = target.id
                    self.streamUrls.append(_info)
                    self.tableView.reloadData()
                }

            }else{
                if let _code = code, _code == APIError.Error_ExistStream{
                    self.openHasStreamView(id_social: account.userId, id_target: target.id)
                }
            }

        }

    }
    
    @IBAction func nextTapped(_ sender: Any) {
        if self.streamUrls.count > 0{
            let canStream = checkPermissions()
            if canStream{
                showLiveStreamScreen()
            }else{
                showRequestPermissionsSceen()
            }
        }else{
            showMessageDialog(nil, "Bạn chưa thêm nơi đăng")
        }
    }
    func showLiveStreamScreen(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        streamViewController = storyboard.instantiateViewController(withIdentifier: "LiveVideoViewController") as? HKLiveVideoViewController
        
        streamViewController?.streamUrls = self.streamUrls
        streamViewController?.didStreamEndedHandler = {
            self.reset()
        }
        self.present(streamViewController!, animated: true, completion: nil)
    }
    func showStreamEndedScreen(){
        let endedViewController = StreamEndedViewController(nibName: "StreamEndedViewController", bundle: nil)

        self.present(endedViewController, animated: true, completion: nil)
    }
    func showRequestPermissionsSceen(){
        let vc = StreamPermissionViewController(nibName: "StreamPermissionViewController", bundle: nil)
        vc.modalPresentationStyle = .overFullScreen
        vc.didRequestPermission = {[unowned self] status in
            if status {
                self.showLiveStreamScreen()
            }
        }
        present(vc, animated: true, completion: nil)
    }
    func checkPermissions() ->Bool{
        let cameraStatus = AVCaptureDevice.authorizationStatus(for: .video)
        let status = AVCaptureDevice.authorizationStatus(for:AVMediaType.audio)
        
        if cameraStatus ==  .authorized  && status  ==  .authorized {
            //already authorized
           return true
        }
        
        return false
        
        
    }
}
extension StreamViewController{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
            return 40
        }
        return 410
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return streamUrls.count + 1
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseUrlCell, for: indexPath) as! UrlStreamViewCell
            if indexPath.row < streamUrls.count{
                let info = streamUrls[indexPath.row]
                cell.updateUrlStreamLabel(urlStream: info.urlString)
            }else{
                cell.updateUrlStreamLabel(urlStream:"")

            }
            cell.removeButton.tag = indexPath.row
            cell.completionHandler = {[unowned self](index) in
                if index  < self.streamUrls.count{
                    self.streamUrls.remove(at: index)
                    self.tableView.reloadData()
                }
            }
            return cell
        }else{
           let cell = tableView.dequeueReusableCell(withIdentifier: reuseOptionCell, for: indexPath) as! StreamOptionViewCell
            cell.selectionStyle = .none
            cell.updateCaption(caption)
            if let account = selectedAccount{
                cell.updateAccountInfo(account: account)
                
            }
            if let page = selectedPages{
                cell.updatePageInfo(target: page)
            }
            cell.completionHandler = {[weak self] a in
                print("click \(a)")
                if let strongSelf = self{
                    //select account
                if a == 0{
                    strongSelf.showPickerView(type: .account)
                }else{
                    strongSelf.showPickerView(type: .target)
                }
                }
                
            }
            cell.didTapAddAccount = { [unowned self] in
                self.openAddFbAccessTokenScreen()
            }
            cell.didCaptionChanged = {[unowned self] caption in
                self.caption = caption
            }
            return cell;
        }
    }
    @objc func tappedUpdateAcountTarget(_ button:UIButton){
        self.tableView.reloadData()
        self.hidePickerView()
    }
    func showPickerView(type:PickType){
        self.pickerType = type
        self.picker?.reloadAllComponents()
        UIView.animate(withDuration: 0.25, animations: {
            self.pickerView?.frame = CGRect(x: 0, y: self.view.frame.size.height - self.pickerHeight, width: self.view.frame.size.width, height: self.pickerHeight)
        }) { (finish) in
            
        }
    }
    func hidePickerView(){
        UIView.animate(withDuration: 0.25, animations: {
            self.pickerView?.frame = CGRect(x: 0, y: self.view.frame.size.height, width: self.view.frame.size.width, height: self.pickerHeight)
        }) { (finish) in
            if self.pickerType == .account{
                if let _ = self.selectedAccount{
                    self.getTarget()
                }
            }
        }
    }
    func reset(){
        self.streamUrls = []
        self.caption = nil
        self.tableView.reloadData()
    }
    func getTarget(){
        self.loadingAnimation!.isHidden = false
        self.loadingAnimation?.play()
        APIClient.shared().getFacebookTargets(id_social:   self.selectedAccount!.userId, completion: {[unowned self] (success, message,targets) in
            self.loadingAnimation?.isHidden = true
            self.loadingAnimation?.stop()
            if success{
//                self.selectStreamInfoVC.accountList = []
//                self.selectStreamInfoVC.refreshData(targets: targets ?? [])
                if let _targets = targets{
                    self.curTargets = _targets
                    if _targets.count > 0{
                         self.selectedPages = _targets[0]
                    }
                    self.tableView.reloadData()
                }
            }
        })
        self.tableView.reloadData()
        
    }
}
extension StreamViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if self.pickerType == .account {
            return APIClient.shared().accounts.count

        }else if self.pickerType == .target {
            return self.curTargets.count

        }else{
            return 0
        }

    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if self.pickerType == .account {
            let account = APIClient.shared().accounts[row]
            return account.displayName ?? ""
        }else if self.pickerType == .target {
            let target = self.curTargets[row]
            return target.name
        }else{
            return nil
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if self.pickerType == .account {
            self.selectedAccount = APIClient.shared().accounts[row]
        }else if self.pickerType == .target {
            self.selectedPages = self.curTargets[row]

        }
    }
}
