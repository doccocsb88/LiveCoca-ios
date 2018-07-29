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
    
    var account:FacebookInfo?
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
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func refreshData(info:FacebookInfo){
        self.account = info
        DispatchQueue.main.async{ [unowned self] in
            self.tableView?.reloadData()
        }
        
    }
}
extension SelectStreamAccountViewController{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let a = account{
            return a.pages.count
        }
        return 1;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "accountCell", for: indexPath) as? SelectStreamAccountViewCell{
            
            let index = indexPath.row
            if let page = account?.pages[index]{
                cell.configView(account: page)
            }
            
            return cell
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
