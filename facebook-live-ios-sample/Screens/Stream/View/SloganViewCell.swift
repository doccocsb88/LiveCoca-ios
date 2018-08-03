//
//  SloganViewCell.swift
//  facebook-live-ios-sample
//
//  Created by Apple on 7/29/18.
//  Copyright © 2018 Hans Knoechel. All rights reserved.
//

import UIKit

class SloganViewCell: UITableViewCell , UITableViewDelegate, UITableViewDataSource {
    fileprivate let cellHeight:CGFloat = 30
    @IBOutlet weak var hideButton: UIButton!
    
    @IBOutlet weak var powerButton: UIButton!
    
    @IBOutlet weak var otherButton: UIButton!
    @IBOutlet weak var colorButton: UIButton!
    @IBOutlet weak var alignButton: UIButton!
    
    @IBOutlet weak var updateButton: UIButton!
    
    @IBOutlet weak var sloganTextField: UITextField!
    var value:Int = 0
    var align:NSTextAlignment = .center
    var color:UIColor = .white
    var config:[String:Any] = [:]
    var completeHandle:(Bool) ->() = {(update) in }
    var tableView:UITableView?
    var alignArray:[String:NSTextAlignment] = ["Căn trái":.left,"Căn giữa":.center,"Căn phải":.right]
    var colorArray:[String:UIColor] = ["Mặc định":.white,"Xanh" : .blue,"Đổ":.red,"Tím":.purple,"Vàng":.yellow]
    var selectType:Int = -1
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        tableView = UITableView(frame: CGRect(origin: CGPoint.zero, size: CGSize.zero))
        tableView?.delegate = self;
        tableView?.dataSource = self;
        tableView?.backgroundColor = .red
        
        setup()
        updateView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setup(){
        config =  ["value":0,"text":"" , "color":color,"align":align]
        
        //
        sloganTextField.addBorder(cornerRadius: 4, color: UIColor.lightGray)
        colorButton.addBorder(cornerRadius: 4, color: UIColor.lightGray)
        alignButton.addBorder(cornerRadius: 4, color: UIColor.lightGray)
        updateButton.addBorder(cornerRadius: 15, color: UIColor.clear)
        
        //
        hideButton.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        powerButton.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        otherButton.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        //
        hideButton.tag = 0
        powerButton.tag = 1
        otherButton.tag = 2
        
        //
        colorButton.setTitle("Mặc định", for: .normal)
        alignButton.setTitle("Căn trái", for: .normal)
        
    }
    func updateView(){
        let value = config["value"] as! Int
        hideButton.isSelected =  hideButton.tag == value
        powerButton.isSelected = powerButton.tag == value
        otherButton.isSelected = otherButton.tag == value
        //
        sloganTextField.isEnabled = value == otherButton.tag
    }
    @IBAction func tappedHideButton(_ sender: Any) {
        config["value"] = 0
        sloganTextField.resignFirstResponder()

        updateView()
    }
    
    @IBAction func tappedDefaultButton(_ sender: Any) {
        config["value"] = 1
        sloganTextField.resignFirstResponder()

        updateView()

    }
    
    @IBAction func tappedOtherButton(_ sender: Any) {
        config["value"] = 2
        sloganTextField.becomeFirstResponder()
        updateView()
    }
    
    @IBAction func tappedColorButton(_ sender: Any) {
        colorButton.isSelected = !colorButton.isSelected
        if colorButton.isSelected {
            if let _ = tableView{
                selectType = 0;

                tableView?.frame = CGRect(x: sloganTextField.frame.origin.x, y: sloganTextField.frame.origin.y + sloganTextField.frame.size.height, width: sloganTextField.frame.size.width, height: cellHeight * CGFloat(colorArray.keys.count))
                tableView?.addBorder(cornerRadius: 4, color: UIColor.lightGray)
                tableView?.reloadData()
                self.addSubview(tableView!)
            }
        }else{
            tableView?.removeFromSuperview()
        }
       
    }
    
    @IBAction func tappedAlignButton(_ sender: Any) {
        alignButton.isSelected = !alignButton.isSelected
        if alignButton.isSelected {
            if let _ = tableView{
                selectType = 1;
                tableView?.frame = CGRect(x: sloganTextField.frame.origin.x, y: sloganTextField.frame.origin.y + sloganTextField.frame.size.height, width: sloganTextField.frame.size.width, height: cellHeight * CGFloat(alignArray.keys.count))
                tableView?.addBorder(cornerRadius: 4, color: UIColor.lightGray)
                tableView?.reloadData()
                self.addSubview(tableView!)
            }
        }else{
            tableView?.removeFromSuperview()
        }
       
    }
    
    @IBAction func tappedUpdateButton(_ sender: Any) {
        if let value = config["value"] as? Int, value == 2 {
            if let text = sloganTextField.text, text.count > 0{
                config["text"] = text
                sloganTextField.addBorder(cornerRadius: 4, color: UIColor.lightGray)
                sloganTextField.resignFirstResponder()
                WarterMarkServices.shared().configSlogan(config: config)
                completeHandle(true)
            }else{
                sloganTextField.addBorder(cornerRadius: 4, color: UIColor.red)
                sloganTextField.placeholder = "Vui lòng nhập slogan"
            }
        }else{
            
            WarterMarkServices.shared().configSlogan(config: config)
            completeHandle(true)
        }
        
    }
    
    
}
extension SloganViewCell{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if selectType == 0 {
            return colorArray.keys.count
        }else if selectType == 1{
            return alignArray.keys.count
        }
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        var titles:[String] = []
        if selectType == 0 {
            titles =  Array(colorArray.keys)
        }else if selectType == 1{
             titles =  Array(alignArray.keys)
        }
        cell.frame = CGRect(origin: CGPoint.zero, size: sloganTextField.frame.size)
        let titleLabel = UILabel(frame: cell.bounds)
        titleLabel.textAlignment = .center
        titleLabel.text = titles[indexPath.row]
        cell.addSubview(titleLabel)
        
        return cell;
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var allKeys:[String] = [];
        if selectType == 0 {
            allKeys = Array(colorArray.keys)
            let key = allKeys[indexPath.row]
            if let color = colorArray[key]{
                config["color"] = color
                colorButton.setTitle(key, for: .normal)
            }
            
        }else if selectType == 1{
            allKeys = Array(alignArray.keys)
            let key = allKeys[indexPath.row]
            if let align = alignArray[key]{
                config["align"] = align
                alignButton.setTitle(key, for: .normal)
            }
        }
        
        tableView.removeFromSuperview()
    }
}
