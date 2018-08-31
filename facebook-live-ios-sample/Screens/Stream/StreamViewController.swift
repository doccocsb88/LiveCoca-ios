//
//  StreamViewController.swift
//  facebook-live-ios-sample
//
//  Created by Apple on 7/26/18.
//  Copyright © 2018 Hans Knoechel. All rights reserved.
//

import UIKit
import Lottie
//import CommonCrypto
class StreamViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
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
    private var loadingAnimation: LOTAnimationView?

    let selectStreamInfoVC = SelectStreamAccountViewController()

    var selectedAccount: BaseInfo?
    var selectedPages:SocialTarget?
    var curTargets:[SocialTarget] = []
    var streamUrls:[StreamInfo] = []
    var openLogin:Bool = false
    var pickerType:PickType = .account
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let pw = "123456IrbrMHoO8zjaqy3h"
        print("aaaa : \("".MD5(pw))")
        setup()
        setupUI()
        FacebookServices.shared().fetchData {
            let pages = FacebookServices.shared().accountList;
            print("pages : \(pages.count)")
        }

    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIApplication.shared.statusBarStyle = .lightContent
        if !openLogin {
            openLogin = true
            openLoginScreen()
        }

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
        loadingAnimation = LOTAnimationView(name: "material_loader")
        // Set view to full screen, aspectFill
        loadingAnimation!.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        loadingAnimation!.contentMode = .scaleAspectFill
        loadingAnimation!.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        loadingAnimation!.center = self.view.center
        loadingAnimation!.isHidden = true
        // Add the Animation
        view.addSubview(loadingAnimation!)
    }
    func setupUI(){
        let buttonSize = nextButton.frame.size;
        nextButton.layer.cornerRadius = buttonSize.height / 2;
        nextButton.layer.masksToBounds = true
        
        addUrlStreamButton.layer.cornerRadius = buttonSize.height /  2
        addUrlStreamButton.layer.masksToBounds = true
    }
    
    func openLoginScreen(){
        let loginViewController = LoginViewController(nibName: "LoginViewController", bundle: nil)
        self.present(loginViewController, animated: true, completion: nil)
    }
    func openAddCountView(){
        let vc = AddStreamAccountViewController(nibName: "AddStreamAccountViewController", bundle: nil)
        vc.modalPresentationStyle = .overFullScreen
        
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
        loadingAnimation?.isHidden = false
        loadingAnimation?.play()

        APIClient.shared().createLive(id_social: account.userId, id_target: target.id, caption: "") {[unowned self]  (success, message, info) in
            self.loadingAnimation?.isHidden = true
            self.loadingAnimation?.stop()
            if success{
                if let _info = info{
                    self.streamUrls.append(_info)
                    self.tableView.reloadData()
                }

            }else{
                
            }

        }

    }
    
    @IBAction func nextTapped(_ sender: Any) {
        if self.streamUrls.count > 0{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let controller = storyboard.instantiateViewController(withIdentifier: "LiveVideoViewController") as? HKLiveVideoViewController{
                controller.streamUrls = self.streamUrls
                self.present(controller, animated: true, completion: nil)
            }
        }
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
//                    strongSelf.selectStreamInfoVC.accountList = APIClient.shared().accounts
//                    strongSelf.selectStreamInfoVC.targetList = []
                    strongSelf.showPickerView(type: .account)
                }else{
//                    strongSelf.selectStreamInfoVC.accountList = []
                    strongSelf.showPickerView(type: .target)
                }
//                strongSelf.selectStreamInfoVC.refreshData()
//                strongSelf.present(strongSelf.selectStreamInfoVC, animated: true, completion: nil)

                }
                
            }
            cell.didTapAddAccount = { [unowned self] in
                self.openAddCountView()
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
