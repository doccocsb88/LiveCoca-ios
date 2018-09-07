//
//  HistoryViewController.swift
//  coca-live
//
//  Created by Apple on 7/26/18.
//  Copyright © 2018 Coca Live. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController , UITableViewDataSource, UITableViewDelegate {
    fileprivate let pickerHeight:CGFloat = 240

    @IBOutlet weak var statusButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var searchTextField: UITextField!
    var picker:UIPickerView?
    var pickerView:UIView?
    var statusStream:[String] = ["Tất cả","Đang phát","Đã kết thúc"]
    var currentStatus:Int = 0
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
        
        //
        self.searchTextField.addBorder(cornerRadius: 4, color: .lightGray)
        self.statusButton.addBorder(cornerRadius: 4, color: .lightGray)
        let searchImageView = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        searchImageView.setImage(UIImage(named: "ic_search"), for: .normal)
        searchImageView.imageView?.contentMode = .scaleAspectFit
        searchImageView.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        
        self.searchTextField.leftView = searchImageView
        self.searchTextField.leftViewMode = .always
        
        //
        self.statusButton.imageView?.contentMode = .scaleAspectFit
        self.statusButton.setTitle(statusStream[currentStatus], for: .normal)
        //
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tappedGesture(_:)))
        self.view.addGestureRecognizer(tapGesture)
        
        //
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
//      let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
//        let cancelActionButton = UIAlertAction(title: "Bỏ qua", style: .cancel) { _ in
//            print("Cancel")
//        }
//        alert.addAction(cancelActionButton)
//
//        let saveActionButton = UIAlertAction(title: "Tất cả", style: .default)
//        { _ in
//            print("Save")
//        }
//        alert.addAction(saveActionButton)
//
//        let deleteActionButton = UIAlertAction(title: "Đang phát", style: .default)
//        { _ in
//            print("Delete")
//        }
//        alert.addAction(deleteActionButton)
//
//        //
//        let finishedButton = UIAlertAction(title: "Đã kết thúc", style: .default)
//        { _ in
//            print("Delete")
//        }
//        alert.addAction(finishedButton)
//        self.present(alert, animated: true, completion: nil)
        showPickerView()
    }
    @objc func tappedGesture(_ gesture:UITapGestureRecognizer){
        self.view.endEditing(true)
    }
    @objc func tappedUpdateAcountTarget(_ button:UIButton){
        self.statusButton.setTitle(statusStream[currentStatus], for: .normal)
        hidePickerView()
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
extension HistoryViewController: UIPickerViewDelegate , UIPickerViewDataSource{
    func showPickerView(){
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
           
        }
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return statusStream.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let status = statusStream[row]
        return status
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
       currentStatus = row
    }
}
