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
    fileprivate let reuseOptionCell = "streamOptionCell"
    fileprivate let reuseUrlCell = "streamUrlCell"

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var addUrlStreamButton: UIButton!
    
    private var boatAnimation: LOTAnimationView?

    let selectStreamInfoVC = SelectStreamAccountViewController()

    var selectedAccount: FacebookInfo?
    var selectedPages:BaseInfo?
    var streamUrls:[StreamInfo] = []
    var openLogin:Bool = false
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
        selectStreamInfoVC.completionHandler = {(account,page) in
            self.selectedAccount = account
            self.selectedPages = page
            self.tableView.reloadData()
        }
        //
        // Create Boat Animation
        boatAnimation = LOTAnimationView(name: "material_loader")
        // Set view to full screen, aspectFill
        boatAnimation!.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        boatAnimation!.contentMode = .scaleAspectFill
        boatAnimation!.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        boatAnimation!.center = self.view.center
        boatAnimation!.isHidden = true
        // Add the Animation
        view.addSubview(boatAnimation!)
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
        if let page = selectedPages , let _ = page.userId{
            boatAnimation?.isHidden = false
            boatAnimation?.play()
            FacebookServices.shared().getFacebookLiveStreamURL(pageInfo: page) {[unowned self] (info) in
                self.streamUrls.append(info)
                self.tableView.reloadData()
                self.boatAnimation?.stop()
                self.boatAnimation?.isHidden = true
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
                cell.updatePageInfo(page: page)
            }
            cell.completionHandler = {[weak self] a in
                print("click \(a)")
                if let strongSelf = self{
                    //select account
                if a == 0{
                    strongSelf.selectStreamInfoVC.accountList = FacebookServices.shared().accountList
                    strongSelf.selectStreamInfoVC.pageList = []
                }else{
                    strongSelf.selectStreamInfoVC.accountList = []
                    strongSelf.selectStreamInfoVC.pageList = FacebookServices.shared().accountList[0].pages
                }
                strongSelf.selectStreamInfoVC.refreshData()

                strongSelf.present(strongSelf.selectStreamInfoVC, animated: true, completion: nil)

                }
                
            }
            cell.didTapAddAccount = { [unowned self] in
                self.openAddCountView()
            }
            return cell;
        }
    }
    
}
