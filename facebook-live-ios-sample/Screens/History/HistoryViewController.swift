//
//  HistoryViewController.swift
//  facebook-live-ios-sample
//
//  Created by Apple on 7/26/18.
//  Copyright © 2018 Hans Knoechel. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController , UITableViewDataSource, UITableViewDelegate {
   
    @IBOutlet weak var statusButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var searchTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setup(){
        self.navigationController?.navigationBar.topItem?.title = "PHÒNG LIVESTREAM"
        tableView.register(UINib(nibName: "StreamHistoryViewCell", bundle: nil), forCellReuseIdentifier: "historyCell")
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func tappedStatusButton(_ sender: Any) {
      let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cancelActionButton = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            print("Cancel")
        }
        alert.addAction(cancelActionButton)
        
        let saveActionButton = UIAlertAction(title: "Save", style: .default)
        { _ in
            print("Save")
        }
        alert.addAction(saveActionButton)
        
        let deleteActionButton = UIAlertAction(title: "Delete", style: .default)
        { _ in
            print("Delete")
        }
        alert.addAction(deleteActionButton)
        self.present(alert, animated: true, completion: nil)
    }
    
}
extension HistoryViewController{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "historyCell", for: indexPath)
        
        return cell
    }
    
}
