//
//  HistoryViewController.swift
//  coca-live
//
//  Created by Apple on 7/26/18.
//  Copyright © 2018 Coca Live. All rights reserved.
//

import UIKit

class HistoryViewController:BaseViewController, UITableViewDataSource, UITableViewDelegate {
    fileprivate let pickerHeight:CGFloat = 240
    fileprivate let page_size:Int = 10
    
    @IBOutlet weak var statusButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var searchTextField: UITextField!
    var picker:UIPickerView?
    var pickerView:UIView?
//    0 - Đang chờ
//    1 - Đang xử lý
//    2 - Đang phát
//    3 - Đang kết thúc
//    4 - Đã kết thúc

    var statusStream:[String] = ["Tất cả","Đang chờ","Đang xử lý","Đang phát","Đang kết thúc","Đã kết thúc"]
    var indexStatus:Int = 0
    var data:[CocaStream] = []
    var totalStream:Int = 0
    var page:Int = 0
    var filterTitle:String?
    var filterStatus:Int?
    var searchTimer:Timer?
    var isLoading:Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initLoadingView("material_loader")
        setup()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if firstTime{
            firstTime = false
            fetchStreams()

        }
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
        self.searchTextField .addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged);
        //
        self.statusButton.imageView?.contentMode = .scaleAspectFit
        self.statusButton.setTitle(statusStream[indexStatus], for: .normal)
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
        updateButton.addTarget(self, action: #selector(tappedUpdateStreamStatus(_:)), for: .touchUpInside)
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
    @objc func fetchStreams(){
        if isLoading == true{
            return
        }
        isLoading = true
        self.showLoadingView()
        page += 1

        APIClient.shared().getListStream(page: page, page_size, filterTitle, filterStatus) {[weak self] (success, message, streams, total) in
            guard let strongSelf = self else{return}
            strongSelf.hideLoadingView()
            strongSelf.isLoading = false
            if success{
                strongSelf.totalStream = total
                strongSelf.data.append(contentsOf: streams)
                strongSelf.tableView.reloadData()
            }else{
                self?.showMessageDialog(nil, message ?? APIError.Error_Message_Generic)
            }
        }
    }
    @IBAction func tappedStatusButton(_ sender: Any) {

        showPickerView()
    }
    @objc func tappedGesture(_ gesture:UITapGestureRecognizer){
        self.view.endEditing(true)
    }
    @objc func tappedUpdateStreamStatus(_ button:UIButton){
        self.statusButton.setTitle(statusStream[indexStatus], for: .normal)
        hidePickerView()
        if indexStatus == 0{
            filterStatus = nil
        }else{
            filterStatus = indexStatus - 1;
        }
        resetParams()
        fetchStreams()
    }
    func resetParams(){
        page = 0
        data.removeAll()
    }
}
extension HistoryViewController{
    @objc func textFieldDidChange(_ textfield:UITextField){
        self.filterTitle = textfield.text
        self.searchTimer?.invalidate()
        self.searchTimer = nil
        self.searchTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(autoFetchStream), userInfo: nil, repeats: false)
    }
    @objc func autoFetchStream(){
        resetParams()
        fetchStreams()
    }
    
}
extension HistoryViewController{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "historyCell", for: indexPath) as! StreamHistoryViewCell
        let stream = data[indexPath.row]
        cell.updateContent(stream)
        if indexPath.row == data.count - 1 && data.count < totalStream{
            fetchStreams()
        }
        cell.didOpenVideoAtIndex = {index in
            let urls = stream.getFacebookUrls(index)
            UIApplication.tryURL(urls: urls)
            
        }
        return cell
    }
    

    
    func openUrl(_ path:String){
        let url = URL(string: path)!
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            //If you want handle the completion block than
            UIApplication.shared.open(url, options: [:], completionHandler: { (success) in
                print("Open url : \(success)")
            })
        }
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
       indexStatus = row
    }
}
