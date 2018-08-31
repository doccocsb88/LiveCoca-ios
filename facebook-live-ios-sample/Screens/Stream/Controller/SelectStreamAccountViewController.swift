//
//  SelectStreamAccountViewController.swift
//  facebook-live-ios-sample
//
//  Created by Hai Vu on 7/27/18.
//  Copyright © 2018 Hans Knoechel. All rights reserved.
//

import UIKit

class SelectStreamAccountViewController: UIViewController , UITableViewDelegate, UITableViewDataSource {
  
    var tableView: UITableView?
    
    var targetList:[SocialTarget] = []
    var accountList:[BaseInfo] = []
    var viewType:Int = 0;
    var didSelectAccount:(BaseInfo)->() = { (account) in }
    var didSelectTarget:(SocialTarget) ->() = {target in}
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setup()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.async{ [unowned self] in
            self.tableView?.reloadData()
        }
    }
    func setup(){
        tableView = UITableView(frame: CGRect(x: 0, y: self.view.frame.size.height / 2, width: self.view.frame.size.width, height: self.view.frame.size.height / 2))
        tableView?.register(UINib(nibName: "SelectStreamAccountViewCell", bundle: nil), forCellReuseIdentifier: "accountCell")
        tableView?.delegate = self;
        tableView?.dataSource = self;
        tableView?.backgroundColor = UIColor.white
        self.view.addSubview(tableView!)
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        
        //
        let gesture = UITapGestureRecognizer(target: self, action:  #selector (self.tapAction (_:)))
        self.view.addGestureRecognizer(gesture)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func refreshData(){
        DispatchQueue.main.async{ [unowned self] in
            self.tableView?.reloadData()
        }
    }
    func refreshData(targets:[SocialTarget]){
        self.targetList = targets
        DispatchQueue.main.async{ [unowned self] in
            self.tableView?.reloadData()
        }
    }
    @objc func tapAction(_ sender:UITapGestureRecognizer){
        // do other task
        self.dismiss(animated: true, completion: nil)
    }
}
extension SelectStreamAccountViewController{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return accountList.count
        }else{
            return targetList.count
            
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            //select account
            if let cell = tableView.dequeueReusableCell(withIdentifier: "accountCell", for: indexPath) as? SelectStreamAccountViewCell{
                let account = accountList[indexPath.row]
                cell.configView(account: account)
                return cell
            }
        }else{
            if let cell = tableView.dequeueReusableCell(withIdentifier: "accountCell", for: indexPath) as? SelectStreamAccountViewCell{
                
                let index = indexPath.row
                let target = targetList[index]
                cell.configView(target: target)
                return cell
            }
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let account = accountList[indexPath.row]
            didSelectAccount(account)
        }else{
            let target = targetList[indexPath.row]
            didSelectTarget(target)
        }
        self.dismiss(animated: true, completion: nil)
    }
    
}
