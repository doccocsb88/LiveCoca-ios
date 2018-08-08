////
////  Videos.swift
////  facebook-live-ios-sample
////
////  Created by Apple on 8/8/18.
////  Copyright © 2018 Hans Knoechel. All rights reserved.
////
//
//import Foundation
//import UIKit
//import AudioToolbox
//import GPUImage
//import AssetsLibrary
//import FBSDKMessengerShareKit
//import QuartzCore
//
//class Videos: UIViewController, UIGestureRecognizerDelegate{
//    var videoCamera:GPUImageVideoCamera?
//    var filter:GPUImageChromaKeyFilter?
//    var effectSlider: float_t!
//    var savedImage: UIImage!
//    var backgroundMovie: GPUImageMovie!
//    @IBOutlet weak var gpuImage: GPUImageView!
//    @IBOutlet var borderView: UIView!
//
//    @IBOutlet weak var gpuCamera: GPUImageView!
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.resumeActivities), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil);
//        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.stopActivities), name: NSNotification.Name.UIApplicationWillResignActive, object: nil);
//
//        effectSlider = 0.4
//
//        self.view.backgroundColor = UIColor.red
//        gpuImage.backgroundColor = UIColor.clear
//
//        if let resourceUrl = Bundle.main.url(forResource: "galaxy", withExtension: "mp4") {
//            print(resourceUrl)
//            let fileManager = FileManager.default
//            var isDir : ObjCBool = false
//            if fileManager.fileExists(atPath: resourceUrl.path, isDirectory:&isDir) {
//                if isDir.boolValue {
//                    // file exists and is a directory
//                    print("file exist 1")
//                } else {
//                    // file exists and is not a directory
//                    backgroundMovie = GPUImageMovie.init(url: resourceUrl)
//                    backgroundMovie.shouldRepeat = true
//                    print("file exist 2")
//
//                }
//            } else {
//                // file does not exist
//            }
//            //            if FileManager.defaultManager.fileExistsAtPath(resourceUrl.path!) {
//            //                backgroundMovie = GPUImageMovie.init(url: resourceUrl)
//            //                backgroundMovie.shouldRepeat = true
//            //            }
//        }
//        //        let resourceUrl = URL(fileURLWithPath: "http://techslides.com/demos/sample-videos/small.mp4")
//        //        backgroundMovie = GPUImageMovie.init(url: resourceUrl)
//        //        backgroundMovie.shouldRepeat = true
//
//        // Setup view tappable area
//        let tap = UITapGestureRecognizer(target: self, action: #selector(ViewController.takePhoto))
//        tap.numberOfTapsRequired = 1;
//        gpuImage.addGestureRecognizer(tap)
//
//        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(ViewController.switchCamera))
//        doubleTap.numberOfTapsRequired = 2
//        gpuImage.addGestureRecognizer(doubleTap)
//        tap.require(toFail: doubleTap)
//
//        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(ViewController.sharePhoto))
//        swipeUp.direction = UISwipeGestureRecognizerDirection.up
//        gpuImage.addGestureRecognizer(swipeUp)
//
//        // Setup borderView
//        borderView.backgroundColor = UIColor.clear
//        borderView.layer.borderColor = UIColor.white.cgColor
//        borderView.layer.borderWidth = 8
//        borderView.alpha = 0;
//
//        // Setup camera processing
//        setupCamera()
//    }
//
//    // Called on start
//    func setupCamera() {
//        videoCamera = GPUImageVideoCamera(sessionPreset: AVCaptureSessionPresetHigh, cameraPosition: .back)
//
//        videoCamera!.outputImageOrientation = .portrait;
//        videoCamera!.horizontallyMirrorFrontFacingCamera = true
//
//        //Create the filter
//        filter = GPUImageChromaKeyFilter()
//
//        //Set the color and threshold for filter
//        filter?.setColorToReplaceRed(0.0, green: 1.0, blue: 0.0)
//        filter?.thresholdSensitivity = CGFloat(effectSlider)
//        //        filter?.disableFirstFrameCheck()
//        //        filter?.disableSecondFrameCheck()
//        //Add the sources to the filter
//        videoCamera?.addTarget(filter)
//        //        backgroundMovie.addTarget(filter)
//
//        //Start showing filter output on view
//        filter?.addTarget(gpuImage)
//        //       ÷ GPUImageCropFilter *cropFilter = [[GPUImageCropFilter alloc] initWithCropRegion:CGRectMake(0.0, 0.125, 1.0, 0.75)];
//        let cropFilter = GPUImageCropFilter(cropRegion: CGRect(x: 0.0, y: 0.125, width: 1.0, height: 0.75))
//        backgroundMovie?.addTarget(cropFilter)
//        cropFilter?.addTarget(gpuCamera)
//
//    }
//
//    func captureThis() {
//        let image = (filter?.imageFromCurrentFramebuffer())!
//        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
//
//        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
//        flashBorderView()
//
//        savedImage = image
//    }
//
//    func takePhoto() {
//        filter?.useNextFrameForImageCapture()
//        self.captureThis()
//    }
//
//    func switchCamera() {
//        videoCamera!.rotateCamera()
//    }
//
//    func sharePhoto() {
//        if (savedImage != nil) {
//            FBSDKMessengerSharer.share(savedImage, with: nil)
//        }
//    }
//
//    // Resume Processing
//    func resumeActivities() {
//        videoCamera?.startCapture()
//        backgroundMovie.startProcessing()
//    }
//
//    // Suspend processing
//    func stopActivities() {
//        videoCamera!.stopCapture()
//        backgroundMovie.endProcessing()
//    }
//
//    func flashBorderView() {
//        UIView.animate(withDuration: 0.5, animations: { () -> Void in
//            self.borderView.alpha = 1
//        }) { (Bool) -> Void in
//            self.borderView.alpha = 0;
//        }
//    }
//
//    func load(URL: NSURL) {
//        let sessionConfig = URLSessionConfiguration.default
//        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
//        let request = NSMutableURLRequest(url: URL as URL)
//        request.httpMethod = "GET"
//        let task = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
//            if (error == nil) {
//                // Success
//                let statusCode = (response as! HTTPURLResponse).statusCode
//                print("Success: \(statusCode)")
//
//                // This is your file-variable:
//                // data
//            }
//            else {
//                // Failure
//                print("Failure: %@", error?.localizedDescription);
//            }
//        })
//        //        let task = session.dataTask(with: request) { (data, <#URLResponse?#>, <#Error?#>) in
//        //            <#code#>
//        //        }
//        task.resume()
//    }
//}
