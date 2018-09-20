//
//  StreamPermissionViewController.swift
//  coca-live
//
//  Created by Hai Vu on 9/20/18.
//  Copyright © 2018 Coca Live. All rights reserved.
//

import UIKit
import AVFoundation
class StreamPermissionViewController: UIViewController {

    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var microphoneButton: UIButton!
    @IBOutlet weak var cameraButton: UIButton!
    
    var didRequestPermission:(Bool) ->() = {success in }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if AVCaptureDevice.authorizationStatus(for: .video) ==  .authorized {
            //already authorized
            self.cameraButton.isUserInteractionEnabled = false
            self.cameraButton.setTitleColor(.gray, for: .normal)
        } else {
            self.cameraButton.isUserInteractionEnabled = true
            self.cameraButton.setTitleColor(UIColor(hexString: "#FC6076"), for: .normal)

            
        }
        
        let status = AVCaptureDevice.authorizationStatus(for:AVMediaType.audio)
        if  status  ==  AVAuthorizationStatus.authorized{
            self.microphoneButton.isUserInteractionEnabled = false
            self.microphoneButton.setTitleColor(UIColor.gray, for: .normal)
        }else{
            self.microphoneButton.isUserInteractionEnabled = true
            self.microphoneButton.setTitleColor(UIColor(hexString: "#FC6076"), for: .normal)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func tappedCloseButton(_ sender: Any) {
        didRequestPermission(false)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tappedMicrophoneButton(_ sender: Any) {
        let status = AVCaptureDevice.authorizationStatus(for:AVMediaType.audio)
        switch status  {
        case AVAuthorizationStatus.notDetermined:
            AVCaptureDevice.requestAccess(for: AVMediaType.audio, completionHandler: {[weak self] (granted) in
                guard let strongSelf = self else{return}
                DispatchQueue.main.async {

                    if granted {
                        //access allowed
                        strongSelf.microphoneButton.isUserInteractionEnabled = false
                        strongSelf.microphoneButton.setTitleColor(.lightGray, for: .normal)
                        
                    } else {
                        strongSelf.microphoneButton.isUserInteractionEnabled = true
                        strongSelf.microphoneButton.setTitleColor(UIColor(hexString: "#FC6076"), for: .normal)
                        
                    }
                }
                strongSelf.checkPermissions()
                
            })
            break;
        case AVAuthorizationStatus.authorized:
            break;
        case AVAuthorizationStatus.denied:
            openSettings()
            break
        case AVAuthorizationStatus.restricted:break;
            
        }
    }
    
    @IBAction func tappedCameraButton(_ sender: Any) {
        let status  = AVCaptureDevice.authorizationStatus(for: .video)
        if  status ==  .authorized {
            //already authorized
        } else if status == .denied{
           openSettings()
            
        }else if status == .notDetermined{
            AVCaptureDevice.requestAccess(for: .video, completionHandler: {[weak self]  (granted: Bool) in
                guard let strongSelf = self else{return}
                DispatchQueue.main.async {

                    if granted {
                        //access allowed
                        strongSelf.cameraButton.isUserInteractionEnabled = false
                        strongSelf.cameraButton.setTitleColor(.lightGray, for: .normal)
                        
                    } else {
                        strongSelf.cameraButton.isUserInteractionEnabled = true
                        strongSelf.cameraButton.setTitleColor(UIColor(hexString: "#FC6076"), for: .normal)
                        
                    }
                }
                strongSelf.checkPermissions()
            })
            
        }
    }
    
    func openSettings(){
        let settingsUrl = URL(string: UIApplicationOpenSettingsURLString)!
        UIApplication.shared.open(settingsUrl)
    }
    func checkPermissions(){
        let cameraStatus = AVCaptureDevice.authorizationStatus(for: .video)
        let status = AVCaptureDevice.authorizationStatus(for:AVMediaType.audio)

        if cameraStatus ==  .authorized  && status  ==  .authorized {
            //already authorized
            self.didRequestPermission(true)
            dismiss(animated: true, completion: nil)
        }
    
       
    }
}

