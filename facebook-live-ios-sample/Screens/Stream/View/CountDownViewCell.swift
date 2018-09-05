//
//  CountDownViewCell.swift
//  facebook-live-ios-sample
//
//  Created by Apple on 7/29/18.
//  Copyright © 2018 Hans Knoechel. All rights reserved.
//

import UIKit

class CountDownViewCell: UITableViewCell {

    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var timerTextfield: UITextField!
    @IBOutlet weak var muteButton: UIButton!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var showButton: UIButton!
    
    @IBOutlet weak var selectImageButton: UIImageView!
    
    @IBOutlet weak var uploadButton: UIButton!
    var pickerView:CountdownPickerView?
    var completeHandle:(Bool) ->() =  {(isOn) in }
    var tappedUploadImage:() ->() = {}
    var config:[String:Any] = [:]
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        if let _config = WarterMarkServices.shared().params[ConfigKey.countdown.rawValue] as? [String:Any]{
            config = _config
        }
        setup()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setup(){
        let size = cameraButton.frame.size
        showButton.layer.cornerRadius = size.height / 2
        showButton.layer.masksToBounds = true
        //
        muteButton.layer.cornerRadius = size.height / 2
        muteButton.layer.masksToBounds = true
        
        //
        cameraButton.layer.cornerRadius = size.height / 2
        cameraButton.layer.masksToBounds = true
        //
        selectImageButton.layer.cornerRadius = 2
        selectImageButton.layer.masksToBounds = true
        selectImageButton.layer.borderColor = UIColor.lightGray.cgColor
        selectImageButton.layer.borderWidth = 1.0
        
        let origImage = UIImage(named: "ic_upload")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        uploadButton.setImage(tintedImage, for: .normal)
        uploadButton.tintColor = UIColor.lightGray
        uploadButton.imageView?.contentMode = UIViewContentMode.scaleAspectFit
//
        timerTextfield.delegate = self
        
        if let mute = config["mute"] as? Bool{
            muteButton.isSelected = mute
        }
    }
    
    func updateCountdownImage(_ image:UIImage){
        selectImageButton.image = image
    }
    @IBAction func tappedShowButton(_ sender: Any) {
        guard let timer = timerTextfield.text, timer.isValidTimer() else{
            errorLabel.text = "Chưa nhập thời gian bắt đầu stream"
            timerTextfield.becomeFirstResponder()
            return
        }
        timerTextfield.resignFirstResponder()
        errorLabel.text = nil
        
        config["countdown"] = timer
        config["camera"] = nil
        config["image"] = selectImageButton.image
        WarterMarkServices.shared().configCountDown(config:config)
        completeHandle(true)

    }
    @IBAction func tappedMuteButton(_ sender: Any) {
        muteButton.isSelected = !muteButton.isSelected
        config["mute"] = muteButton.isSelected
        WarterMarkServices.shared().configCountDown(config:config)
        completeHandle(true)

    }
    
    @IBAction func tappedCameraButton(_ sender: Any) {
        config["camera"] = true
        config["countdown"] = nil

        WarterMarkServices.shared().configCountDown(config:config)
        completeHandle(true)

    }
    @IBAction func tappedUploadButton(_ sender: Any) {
        tappedUploadImage()
    }
}
extension CountDownViewCell: UITextFieldDelegate{
    func showPickerView(){
        let margin:CGFloat = 10
        if let _ = pickerView{
            self.addSubview(pickerView!)
            
        }else{
            pickerView = CountdownPickerView(frame: CGRect(x: margin, y: 60, width: self.bounds.width - 2*margin, height: self.bounds.height - (60 + margin)))
            pickerView?.didSelectTimer = {[weak self] timer in
                guard let strongSelf = self else{
                    return
                }
                strongSelf.timerTextfield.text = timer
                
            }
            self.addSubview(pickerView!)
        }
    }
    func hidePickerView(){
        if let _ = pickerView{
            pickerView!.removeFromSuperview()
        }
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        showPickerView()
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
        textField.resignFirstResponder()
        hidePickerView()
        return true
    }

}
