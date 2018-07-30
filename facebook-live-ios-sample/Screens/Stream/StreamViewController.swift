//
//  StreamViewController.swift
//  facebook-live-ios-sample
//
//  Created by Apple on 7/26/18.
//  Copyright © 2018 Hans Knoechel. All rights reserved.
//

import UIKit

class StreamViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    fileprivate let reuseOptionCell = "streamOptionCell"
    fileprivate let reuseUrlCell = "streamUrlCell"

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var addUrlStreamButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setup()
        setupUI()
        FacebookServices.shared().fetchData {
            let pages = FacebookServices.shared().listPages;
            print("pages : \(pages.count)")
        }

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
        tableView.register(UINib(nibName: "StreamOptionViewCell", bundle: nil), forCellReuseIdentifier:reuseOptionCell)
        tableView.register(UINib(nibName: "UrlStreamViewCell", bundle: nil), forCellReuseIdentifier:reuseUrlCell)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        self.view.addGestureRecognizer(tapGesture)
    }
    func setupUI(){
        let buttonSize = nextButton.frame.size;
        nextButton.layer.cornerRadius = buttonSize.height / 2;
        nextButton.layer.masksToBounds = true
        
        addUrlStreamButton.layer.cornerRadius = buttonSize.height /  2
        addUrlStreamButton.layer.masksToBounds = true
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
  
     @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    @IBAction func addUrlStreamTapped(_ sender: Any) {
    }
    
    @IBAction func nextTapped(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "LiveVideoViewController")
        self.present(controller, animated: true, completion: nil)
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
            return 1
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseUrlCell, for: indexPath)
            
            return cell
        }else{
           let cell = tableView.dequeueReusableCell(withIdentifier: reuseOptionCell, for: indexPath) as! StreamOptionViewCell
            cell.selectionStyle = .none
            cell.completionHandler = { a in
                print("click \(a)")

                let myViewController = SelectStreamAccountViewController()
                myViewController.modalPresentationStyle = .overFullScreen
                myViewController.account = FacebookServices.shared().listPages[0]
                
                self.present(myViewController, animated: true, completion: {
                    myViewController.refreshData(info: FacebookServices.shared().listPages[0])
                })
                
            }
            return cell;
        }
    }
    
}
