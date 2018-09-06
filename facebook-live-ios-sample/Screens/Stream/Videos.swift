////
////  Videos.swift
////  coca-live
////
////  Created by Apple on 8/8/18.
////  Copyright © 2018 Coca Live. All rights reserved.
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


/**/
//
//  LFVideoCapture.m
//  LFLiveKit
//
//  Created by LaiFeng on 16/5/20.
//  Copyright © 2016年 LaiFeng All rights reserved.
//

//#import "LFVideoCapture.h"
//#import "LFGPUImageBeautyFilter.h"
//#import "LFGPUImageEmptyFilter.h"
//
//#if __has_include(<GPUImage/GPUImage.h>)
//#import <GPUImage/GPUImage.h>
//#elif __has_include("GPUImage/GPUImage.h")
//#import "GPUImage/GPUImage.h"
//#else
//#import "GPUImage.h"
//#endif
//
//@interface LFVideoCapture ()
//
//@property (nonatomic, strong) GPUImageVideoCamera *videoCamera;
//@property (nonatomic, strong) LFGPUImageBeautyFilter *beautyFilter;
//@property (nonatomic, strong) GPUImageOutput<GPUImageInput> *filter;
//@property (nonatomic, strong) GPUImageCropFilter *cropfilter;
//@property (nonatomic, strong) GPUImageOutput<GPUImageInput> *output;
//@property (nonatomic, strong) GPUImageView *gpuImageView;
//@property (nonatomic, strong) GPUImageView *cameraView;
//
//@property (nonatomic, strong) LFLiveVideoConfiguration *configuration;
//
//@property (nonatomic, strong) GPUImageAlphaBlendFilter *blendFilter;
//@property (nonatomic, strong) GPUImageUIElement *uiElementInput;
//@property (nonatomic, strong) UIView *waterMarkContentView;
//
//@property (nonatomic, strong) GPUImageMovieWriter *movieWriter;
//@end
//
//@implementation LFVideoCapture
//@synthesize torch = _torch;
//@synthesize beautyLevel = _beautyLevel;
//@synthesize brightLevel = _brightLevel;
//@synthesize zoomScale = _zoomScale;
//
//#pragma mark -- LifeCycle
//- (instancetype)initWithVideoConfiguration:(LFLiveVideoConfiguration *)configuration {
//    if (self = [super init]) {
//        _configuration = configuration;
//        
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willEnterBackground:) name:UIApplicationWillResignActiveNotification object:nil];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willEnterForeground:) name:UIApplicationDidBecomeActiveNotification object:nil];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusBarChanged:) name:UIApplicationWillChangeStatusBarOrientationNotification object:nil];
//        
//        self.beautyFace = YES;
//        self.beautyLevel = 0.5;
//        self.brightLevel = 0.5;
//        self.zoomScale = 1.0;
//        self.mirror = YES;
//    }
//    return self;
//    }
//    
//    - (void)dealloc {
//        [UIApplication sharedApplication].idleTimerDisabled = NO;
//        [[NSNotificationCenter defaultCenter] removeObserver:self];
//        [_videoCamera stopCameraCapture];
//        if(_gpuImageView){
//            [_gpuImageView removeFromSuperview];
//            _gpuImageView = nil;
//        }
//        if (_cameraView) {
//            [_cameraView removeFromSuperview];
//            _cameraView = nil;
//        }
//}
//
//#pragma mark -- Setter Getter
//
//- (GPUImageVideoCamera *)videoCamera{
//    if(!_videoCamera){
//        _videoCamera = [[GPUImageVideoCamera alloc] initWithSessionPreset:_configuration.avSessionPreset cameraPosition:AVCaptureDevicePositionFront];
//        _videoCamera.outputImageOrientation = _configuration.outputImageOrientation;
//        _videoCamera.horizontallyMirrorFrontFacingCamera = NO;
//        _videoCamera.horizontallyMirrorRearFacingCamera = NO;
//        _videoCamera.frameRate = (int32_t)_configuration.videoFrameRate;
//    }
//    return _videoCamera;
//    }
//    
//    
//    - (void)setRunning:(BOOL)running {
//        if (_running == running) return;
//        _running = running;
//        
//        if (!_running) {
//            [UIApplication sharedApplication].idleTimerDisabled = NO;
//            [self.videoCamera stopCameraCapture];
//            if(self.saveLocalVideo) [self.movieWriter finishRecording];
//        } else {
//            [UIApplication sharedApplication].idleTimerDisabled = YES;
//            [self reloadFilter];
//            [self.videoCamera startCameraCapture];
//            if(self.saveLocalVideo) [self.movieWriter startRecording];
//        }
//        }
//        
//        - (void)setPreView:(UIView *)preView {
//            if (self.gpuImageView.superview) [self.gpuImageView removeFromSuperview];
//            if (self.cameraView.superview) [self.cameraView removeFromSuperview];
//            
//            [preView insertSubview:self.gpuImageView atIndex:0];
//            self.gpuImageView.frame = CGRectMake(0, 0, preView.frame.size.width, preView.frame.size.height);
//            
//            [self.gpuImageView insertSubview:self.cameraView atIndex:0];
//            self.cameraView.frame = CGRectMake(preView.frame.size.width / 2, preView.frame.size.height / 2, preView.frame.size.width /2 , preView.frame.size.height / 2);
//            
//            }
//            
//            - (UIView *)preView {
//                return self.gpuImageView.superview;
//                }
//                
//                - (void)setCaptureDevicePosition:(AVCaptureDevicePosition)captureDevicePosition {
//                    if(captureDevicePosition == self.videoCamera.cameraPosition) return;
//                    [self.videoCamera rotateCamera];
//                    self.videoCamera.frameRate = (int32_t)_configuration.videoFrameRate;
//                    [self reloadMirror];
//                    }
//                    
//                    - (AVCaptureDevicePosition)captureDevicePosition {
//                        return [self.videoCamera cameraPosition];
//                        }
//                        
//                        - (void)setVideoFrameRate:(NSInteger)videoFrameRate {
//                            if (videoFrameRate <= 0) return;
//                            if (videoFrameRate == self.videoCamera.frameRate) return;
//                            self.videoCamera.frameRate = (uint32_t)videoFrameRate;
//                            }
//                            
//                            - (NSInteger)videoFrameRate {
//                                return self.videoCamera.frameRate;
//                                }
//                                
//                                - (void)setTorch:(BOOL)torch {
//                                    BOOL ret;
//                                    if (!self.videoCamera.captureSession) return;
//                                    AVCaptureSession *session = (AVCaptureSession *)self.videoCamera.captureSession;
//                                    [session beginConfiguration];
//                                    if (self.videoCamera.inputCamera) {
//                                        if (self.videoCamera.inputCamera.torchAvailable) {
//                                            NSError *err = nil;
//                                            if ([self.videoCamera.inputCamera lockForConfiguration:&err]) {
//                                                [self.videoCamera.inputCamera setTorchMode:(torch ? AVCaptureTorchModeOn : AVCaptureTorchModeOff) ];
//                                                [self.videoCamera.inputCamera unlockForConfiguration];
//                                                ret = (self.videoCamera.inputCamera.torchMode == AVCaptureTorchModeOn);
//                                            } else {
//                                                NSLog(@"Error while locking device for torch: %@", err);
//                                                ret = false;
//                                            }
//                                        } else {
//                                            NSLog(@"Torch not available in current camera input");
//                                        }
//                                    }
//                                    [session commitConfiguration];
//                                    _torch = ret;
//                                    }
//                                    
//                                    - (BOOL)torch {
//                                        return self.videoCamera.inputCamera.torchMode;
//                                        }
//                                        
//                                        - (void)setMirror:(BOOL)mirror {
//                                            _mirror = mirror;
//                                            }
//                                            
//                                            - (void)setBeautyFace:(BOOL)beautyFace{
//                                                _beautyFace = beautyFace;
//                                                [self reloadFilter];
//                                                }
//
//                                                - (void)setBeautyLevel:(CGFloat)beautyLevel {
//                                                    _beautyLevel = beautyLevel;
//                                                    if (self.beautyFilter) {
//                                                        [self.beautyFilter setBeautyLevel:_beautyLevel];
//                                                    }
//                                                    }
//
//                                                    - (CGFloat)beautyLevel {
//                                                        return _beautyLevel;
//                                                        }
//
//                                                        - (void)setBrightLevel:(CGFloat)brightLevel {
//                                                            _brightLevel = brightLevel;
//                                                            if (self.beautyFilter) {
//                                                                [self.beautyFilter setBrightLevel:brightLevel];
//                                                            }
//                                                            }
//
//                                                            - (CGFloat)brightLevel {
//                                                                return _brightLevel;
//                                                                }
//
//                                                                - (void)setZoomScale:(CGFloat)zoomScale {
//                                                                    if (self.videoCamera && self.videoCamera.inputCamera) {
//                                                                        AVCaptureDevice *device = (AVCaptureDevice *)self.videoCamera.inputCamera;
//                                                                        if ([device lockForConfiguration:nil]) {
//                                                                            device.videoZoomFactor = zoomScale;
//                                                                            [device unlockForConfiguration];
//                                                                            _zoomScale = zoomScale;
//                                                                        }
//                                                                    }
//                                                                    }
//
//                                                                    - (CGFloat)zoomScale {
//                                                                        return _zoomScale;
//                                                                        }
//
//                                                                        - (void)setWarterMarkView:(UIView *)warterMarkView{
//                                                                            if(_warterMarkView && _warterMarkView.superview){
//                                                                                [_warterMarkView removeFromSuperview];
//                                                                                _warterMarkView = nil;
//                                                                            }
//                                                                            _warterMarkView = warterMarkView;
//                                                                            self.blendFilter.mix = warterMarkView.alpha;
//                                                                            [self.waterMarkContentView addSubview:_warterMarkView];
//                                                                            [self reloadFilter];
//                                                                            }
//
//                                                                            - (GPUImageUIElement *)uiElementInput{
//                                                                                if(!_uiElementInput){
//                                                                                    _uiElementInput = [[GPUImageUIElement alloc] initWithView:self.waterMarkContentView];
//                                                                                }
//                                                                                return _uiElementInput;
//                                                                                }
//
//                                                                                - (GPUImageAlphaBlendFilter *)blendFilter{
//                                                                                    if(!_blendFilter){
//                                                                                        _blendFilter = [[GPUImageAlphaBlendFilter alloc] init];
//                                                                                        _blendFilter.mix = 1.0;
//                                                                                        [_blendFilter disableSecondFrameCheck];
//                                                                                    }
//                                                                                    return _blendFilter;
//                                                                                    }
//
//                                                                                    - (UIView *)waterMarkContentView{
//                                                                                        if(!_waterMarkContentView){
//                                                                                            _waterMarkContentView = [UIView new];
//                                                                                            _waterMarkContentView.frame = CGRectMake(0, 0, self.configuration.videoSize.width, self.configuration.videoSize.height);
//                                                                                            _waterMarkContentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//                                                                                        }
//                                                                                        return _waterMarkContentView;
//                                                                                        }
//
//                                                                                        - (GPUImageView *)gpuImageView{
//                                                                                            if(!_gpuImageView){
//                                                                                                _gpuImageView = [[GPUImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
//                                                                                                [_gpuImageView setFillMode:kGPUImageFillModePreserveAspectRatioAndFill];
//                                                                                                [_gpuImageView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
//                                                                                            }
//                                                                                            return _gpuImageView;
//}
//
//-(GPUImageView *)cameraView{
//    if (!_cameraView) {
//        CGSize size = [UIScreen mainScreen].bounds.size;
//        _cameraView = [[GPUImageView alloc] initWithFrame:CGRectMake(size.width /2, size.height / 2, size.width /2, size.height / 2)];
//        [_cameraView setFillMode:kGPUImageFillModePreserveAspectRatioAndFill];
//        [_cameraView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
//
//    }
//    return _cameraView;
//}
//
//-(UIImage *)currentImage{
//    if(_filter){
//        [_filter useNextFrameForImageCapture];
//        return _filter.imageFromCurrentFramebuffer;
//    }
//    return nil;
//    }
//
//    - (GPUImageMovieWriter*)movieWriter{
//        if(!_movieWriter){
//            _movieWriter = [[GPUImageMovieWriter alloc] initWithMovieURL:self.saveLocalVideoPath size:self.configuration.videoSize];
//            _movieWriter.encodingLiveVideo = YES;
//            _movieWriter.shouldPassthroughAudio = YES;
//            self.videoCamera.audioEncodingTarget = self.movieWriter;
//        }
//        return _movieWriter;
//}
//
//#pragma mark -- Custom Method
//- (void)processVideo:(GPUImageOutput *)output {
//    __weak typeof(self) _self = self;
//    @autoreleasepool {
//        GPUImageFramebuffer *imageFramebuffer = output.framebufferForOutput;
//        CVPixelBufferRef pixelBuffer = [imageFramebuffer pixelBuffer];
//        if (pixelBuffer && _self.delegate && [_self.delegate respondsToSelector:@selector(captureOutput:pixelBuffer:)]) {
//            [_self.delegate captureOutput:_self pixelBuffer:pixelBuffer];
//        }
//    }
//    }
//
//    - (void)reloadFilter{
//        [self.filter removeAllTargets];
//        [self.blendFilter removeAllTargets];
//        [self.uiElementInput removeAllTargets];
//        [self.videoCamera removeAllTargets];
//        [self.output removeAllTargets];
//        [self.cropfilter removeAllTargets];
//
//        if (self.beautyFace) {
//            self.output = [[LFGPUImageEmptyFilter alloc] init];
//            self.filter = [[LFGPUImageBeautyFilter alloc] init];
//            self.beautyFilter = (LFGPUImageBeautyFilter*)self.filter;
//        } else {
//            self.output = [[LFGPUImageEmptyFilter alloc] init];
//            self.filter = [[LFGPUImageEmptyFilter alloc] init];
//            self.beautyFilter = nil;
//        }
//
//        ///< 调节镜像
//        [self reloadMirror];
//
//        //< 480*640 比例为4:3  强制转换为16:9
//        if([self.configuration.avSessionPreset isEqualToString:AVCaptureSessionPreset640x480]){
//            CGRect cropRect = self.configuration.landscape ? CGRectMake(0, 0.125, 1, 0.75) : CGRectMake(0.125, 0, 0.75, 1);
//            self.cropfilter = [[GPUImageCropFilter alloc] initWithCropRegion:cropRect];
//            [self.videoCamera addTarget:self.cropfilter];
//            [self.cropfilter addTarget:self.filter];
//        }else{
//            //        CGRect cropRect = self.configuration.landscape ? CGRectMake(0, 0.125, 1, 0.75) : CGRectMake(0.125, 0, 0.75, 1);
//            //        self.cropfilter = [[GPUImageCropFilter alloc] initWithCropRegion:cropRect];
//            //        [self.videoCamera addTarget:self.cropfilter];
//            //
//            CGSize size = [UIScreen mainScreen].bounds.size;
//            GPUImageTransformFilter *transformFilter = [[GPUImageTransformFilter alloc] init];
//            transformFilter.affineTransform = CGAffineTransformConcat(CGAffineTransformMakeTranslation(1, 1.5), CGAffineTransformMakeScale(0.5, 0.5));
//
//            [self.videoCamera addTarget:transformFilter];
//
//            [transformFilter addTarget:self.filter];
//
//            //        [self.videoCamera addTarget:self.filter];
//            //        [self.filter addTarget:self.cameraView];
//
//        }
//
//        //< 添加水印
//        if(self.warterMarkView){
//            [self.filter addTarget:self.blendFilter];
//            [self.uiElementInput addTarget:self.blendFilter];
//            [self.blendFilter addTarget:self.gpuImageView];
//
//            if(self.saveLocalVideo) [self.blendFilter addTarget:self.movieWriter];
//            [self.filter addTarget:self.output];
//            [self.uiElementInput update];
//            //        self.cameraView.backgroundColor = [UIColor yellowColor];
//
//        }else{
//            //        self.cameraView.backgroundColor = [UIColor redColor];
//            [self.filter addTarget:self.gpuImageView];
//
//            [self.filter addTarget:self.output];
//
//            if(self.saveLocalVideo) [self.output addTarget:self.movieWriter];
//        }
//
//
//        [self.filter forceProcessingAtSize:self.configuration.videoSize];
//        [self.output forceProcessingAtSize:self.configuration.videoSize];
//        [self.blendFilter forceProcessingAtSize:self.configuration.videoSize];
//        [self.uiElementInput forceProcessingAtSize:self.configuration.videoSize];
//
//        //< 输出数据
//        __weak typeof(self) _self = self;
//        [self.output setFrameProcessingCompletionBlock:^(GPUImageOutput *output, CMTime time) {
//        [_self processVideo:output];
//        }];
//
//        }
//
//        - (void)reloadMirror{
//            if(self.mirror && self.captureDevicePosition == AVCaptureDevicePositionFront){
//                self.videoCamera.horizontallyMirrorFrontFacingCamera = YES;
//            }else{
//                self.videoCamera.horizontallyMirrorFrontFacingCamera = NO;
//            }
//}
//
//#pragma mark Notification
//
//- (void)willEnterBackground:(NSNotification *)notification {
//    [UIApplication sharedApplication].idleTimerDisabled = NO;
//    [self.videoCamera pauseCameraCapture];
//    runSynchronouslyOnVideoProcessingQueue(^{
//        glFinish();
//        });
//    }
//
//    - (void)willEnterForeground:(NSNotification *)notification {
//        [self.videoCamera resumeCameraCapture];
//        [UIApplication sharedApplication].idleTimerDisabled = YES;
//        }
//
//        - (void)statusBarChanged:(NSNotification *)notification {
//            NSLog(@"UIApplicationWillChangeStatusBarOrientationNotification. UserInfo: %@", notification.userInfo);
//            UIInterfaceOrientation statusBar = [[UIApplication sharedApplication] statusBarOrientation];
//
//            if(self.configuration.autorotate){
//                if (self.configuration.landscape) {
//                    if (statusBar == UIInterfaceOrientationLandscapeLeft) {
//                        self.videoCamera.outputImageOrientation = UIInterfaceOrientationLandscapeRight;
//                    } else if (statusBar == UIInterfaceOrientationLandscapeRight) {
//                        self.videoCamera.outputImageOrientation = UIInterfaceOrientationLandscapeLeft;
//                    }
//                } else {
//                    if (statusBar == UIInterfaceOrientationPortrait) {
//                        self.videoCamera.outputImageOrientation = UIInterfaceOrientationPortraitUpsideDown;
//                    } else if (statusBar == UIInterfaceOrientationPortraitUpsideDown) {
//                        self.videoCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
//                    }
//                }
//            }
//}
//
//@end

