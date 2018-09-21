//
//  SetupViewController.swift
//  coca-live
//
//  Created by Apple on 7/26/18.
//  Copyright © 2018 Coca Live. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Kingfisher
class SetupViewController: BaseViewController, UICollectionViewDelegate, UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout{
    fileprivate let itemsPerRow: CGFloat = 2
    fileprivate let sectionInsets = UIEdgeInsets(top: 10.0, left: 20.0, bottom: 10.0, right: 20.0)
    fileprivate let reuseIdentifier = "frameCell"
    fileprivate let streamViewHeight : CGFloat = 240;
    fileprivate let frameViewHeight : CGFloat = 360;
    fileprivate let uploadViewHeight : CGFloat = 250;

    
    @IBOutlet weak var inputUrlButton: UIButton!
    @IBOutlet weak var previewImageView: UIImageView!
    @IBOutlet weak var uploadButton: UIButton!
    @IBOutlet weak var selectImageButton: UIButton!
    
    @IBOutlet weak var toggleUploadButton: UIButton!
    @IBOutlet weak var toggleFrameButton: UIButton!
    
    
    @IBOutlet weak var frameCollectionView: UICollectionView!
    @IBOutlet weak var uploadContainerView: UIView!
    @IBOutlet weak var streamScreenContainerView: UIView!
    
    
    @IBOutlet weak var streamScreenView: UIView!
    @IBOutlet weak var waitImageView: UIImageView!
    @IBOutlet weak var byeImageView: UIImageView!
    
    
    @IBOutlet weak var streamScreenHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var uploadViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var frameViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var openScreenButton: UIButton!
    @IBOutlet weak var openFrameButton: UIButton!
    @IBOutlet weak var openUploadButton: UIButton!
    
    
    var frameIndex:Int = NSNotFound
    private var viewIndex = 0;
    var listFrame:[StreamFrame] = []
    let imagePicker = UIImagePickerController()
    var type:String = "frame"
    var selectedImage:UIImage?
    var selectedUrl:String?
    var titleFrame:String?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initLoadingView(nil)
        setup()
        setupUI()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.firstTime {
            firstTime = false
            APIClient.shared().getListFrame { (success, message, frames) in
                print("\(success) --- \(message ?? "abc")")
                if success{
                    self.listFrame = frames
                    self.frameCollectionView.reloadData()
                }
            }
            APIClient.shared().getStreamConfig {[unowned self] (success, message) in
                if success{
                    if let waitPath = StreamConfig.shared().waitImagePath{
                        let url = URL(string: String(format: "%@%@", K.ProductionServer.baseURL, waitPath))
                        self.waitImageView.kf.setImage(with: url)
                    }
                    if let byePath = StreamConfig.shared().byeImagePath{
                        let url = URL(string: String(format: "%@%@", K.ProductionServer.baseURL, byePath))
                        self.byeImageView.kf.setImage(with: url)
                    }
                }
            }
        }
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setup(){
        self.navigationController?.navigationBar.topItem?.title = "CẤU HÌNH"

        frameCollectionView.register(UINib(nibName: "FrameViewCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        
        waitImageView.addBorder(cornerRadius: 2, color: .lightGray)
        byeImageView.addBorder(cornerRadius: 2, color: .lightGray)
        
        //
        openScreenButton.imageView?.contentMode = .scaleAspectFit
        openFrameButton.imageView?.contentMode = .scaleAspectFit
        openUploadButton.imageView?.contentMode = .scaleAspectFit

    }
    func setupUI(){
        viewIndex = 1;
        previewImageView.addBorder(cornerRadius: 2, color: .lightGray)
        let radius = inputUrlButton.frame.height / 2
        inputUrlButton.addBorder(cornerRadius: radius, color: .clear)
        selectImageButton.addBorder(cornerRadius: radius, color: .clear)
        uploadButton.addBorder(cornerRadius: radius, color: .clear)
        toggleCurrentView()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func toggleCurrentView(){
        uploadContainerView.isHidden = true
        switch viewIndex {
        case 0:
            streamScreenHeightConstraint.constant = 0
            frameViewHeightConstraint.constant = 0;
            uploadViewHeightConstraint.constant = 0;
        case 1:
            streamScreenHeightConstraint.constant = streamViewHeight
            frameViewHeightConstraint.constant = 0;
            uploadViewHeightConstraint.constant = 0;
            break
        case 2:
            streamScreenHeightConstraint.constant = 0
            frameViewHeightConstraint.constant = frameViewHeight;
            uploadViewHeightConstraint.constant = 0;
            break
        case 3:
            streamScreenHeightConstraint.constant = 0
            frameViewHeightConstraint.constant = 0.0;
            uploadViewHeightConstraint.constant = uploadViewHeight;
            uploadContainerView.isHidden = false

            break
        default:
            streamScreenHeightConstraint.constant = 0
            frameViewHeightConstraint.constant = 0;
            uploadViewHeightConstraint.constant = 0;
        }
        openScreenButton.isSelected = viewIndex == 1
        openFrameButton.isSelected = viewIndex == 2
        openUploadButton.isSelected = viewIndex == 3

        UIView.animate(withDuration: 1.0, animations: {
            
        }) { (finished) in
            self.view.updateConstraintsIfNeeded()
        }
    }
    @IBAction func openStreamScreenTapped(_ sender: Any) {
        if viewIndex == 1{
            viewIndex = 0
        }else{
            viewIndex = 1
        }
        toggleCurrentView()
  
    }
    
    @IBAction func openUploadViewTapped(_ sender: Any) {
        if viewIndex == 3{
            viewIndex = 0
            uploadContainerView.isHidden = true
            
        }else{
            viewIndex = 3
            uploadContainerView.isHidden = false

        }
        toggleCurrentView()
     
    }

    
    @IBAction func openFrameViewTapped(_ sender: Any) {
        if viewIndex == 2{
            viewIndex = 0
        }else{
            viewIndex = 2
        }
        toggleCurrentView()
    
    }
    @IBAction func tappedInputUrlButton(_ sender: Any) {
        self.showInputView(2)
    }
    
    @IBAction func tappedSelectImageButton(_ sender: Any) {
        openPhotoLibrary()
    }
    @IBAction func tappedUploadButton(_ sender: Any) {
        if self.selectedImage == nil && self.selectedImage == nil{
            self.showAlertMessage(nil, "Vui lòng chọn ảnh từ thư việc hoặc nhập đường dẫn hình ảnh")
            return
            
        }
        showListUpload()

    }
    
    func loadStreamScreenImage(){
        if let waitPath = StreamConfig.shared().waitImagePath{
            let url = URL(string: String(format: "%@%@", K.ProductionServer.baseURL, waitPath))
            self.waitImageView.kf.setImage(with: url)
        }
        if let byePath = StreamConfig.shared().byeImagePath{
            let url = URL(string: String(format: "%@%@", K.ProductionServer.baseURL, byePath))
            self.byeImageView.kf.setImage(with: url)
        }
    }
    
}
extension SetupViewController{
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        //2
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = (view.frame.width - 40) - paddingSpace
        var availableHeight: CGFloat = 0;
     
        availableHeight = frameViewHeight - sectionInsets.top * (itemsPerRow + 1);

        
        let widthPerItem = availableWidth / itemsPerRow
        let heightPerItem = availableHeight / itemsPerRow

        return CGSize(width: widthPerItem, height: heightPerItem)
    }
    //3
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    // 4
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listFrame.count
  
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! FrameViewCell
        let frame = listFrame[indexPath.row]
        cell.updateContent(frame, frameIndex == indexPath.row)
        cell.didSelectFrame = {
            self.frameIndex = indexPath.row
            self.frameCollectionView.reloadData()
            StreamConfig.shared().frameImage = cell.getFrameImage()
            StreamConfig.shared().setFrameImage(frame.getThumbnailUrl())
            if let image = cell.getFrameImage(){
                WarterMarkServices.shared().configFrame(config: ["image":image])

            }
        }
        return cell;
    }
}
extension SetupViewController:UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        defer {
            picker.dismiss(animated: true)
        }
        
        print(info)
        // get the image
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            return
        }
        
        self.previewImageView.image = image
        self.selectedImage = image
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        defer {
            picker.dismiss(animated: true)
        }
        
        print("did cancel")
    }

    func showListUpload(){
        let alert = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Huỷ", style: .destructive) { (action) in
            alert.dismiss(animated: true, completion: nil)
        }
        let frameAction = UIAlertAction(title: "Khung", style: .default){ (action) in
            self.type = K.APIUploadType.frame
            self.showInputView(1)

        }
        let waitingAction = UIAlertAction(title: "Màn hình chờ", style: .default){ (action) in
            self.type = K.APIUploadType.screen_wait
            self.uploadImage()

        }
        let endSceenAction = UIAlertAction(title: "Màn hình kết thúc", style: .default){ (action) in
            self.type = K.APIUploadType.screen_bye
            self.uploadImage()


        }
        alert.addAction(frameAction)
        alert.addAction(waitingAction)
        alert.addAction(endSceenAction)

        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    func openPhotoLibrary() {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            print("can't open photo library")
            return
        }
        
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        present(imagePicker, animated: true)
    }
    func showInputView(_ type:Int){
        let vc = InputPopupViewController(nibName: "InputPopupViewController", bundle: nil)
        vc.modalPresentationStyle = .overFullScreen
        vc.inputType = type
        vc.didInputValue = { [unowned self ]value in
            if type == 1{
                guard let value = value else{
                    return
                    
                }

                self.titleFrame = value
                self.uploadImage()
            }else if type == 2{
                self.selectedUrl = value
            }
        }
        self.present(vc, animated: true, completion: nil)
        
    }
    func uploadImage(){
      
        if type == K.APIUploadType.frame{
            if self.selectedImage == nil{
                self.showAlertMessage(nil, "Vui lòng chọn ảnh muốn upload từ thư viện.")
                return
            }
            guard let _ = titleFrame else {
                self.showAlertMessage(nil, "Nhập tên khung trước khi upload hình ảnh")
                return
                
            }
            APIClient.shared().upload(type: type, title: titleFrame, url: selectedUrl, image: selectedImage){[unowned self] (success, message,frames) in
                if success{
                    self.resetParams()

                    self.listFrame = frames
                    self.frameCollectionView.reloadData()
                }
            }

        }else{
            if self.selectedUrl == nil && self.selectedImage == nil{
                self.showAlertMessage(nil, "Vui lòng chọn ảnh từ thư viện hoặc nhập đường dẫn hình ảnh")
                return
                
            }
            self.showLoadingView()
            
            APIClient.shared().uploadStreamCover(type: type, url: selectedUrl, image: selectedImage){[unowned self] (success, message) in
                self.hideLoadingView()
                self.resetParams()
                if success{
                    self.loadStreamScreenImage()
                }else{
                    self.showAlertMessage(nil, message ?? APIError.Error_Message_Upload)
                }
            }

            
        }
    }
    func resetParams(){
        type = K.APIUploadType.unknow
        titleFrame = nil
        selectedUrl = nil
        selectedImage = nil
    }
}
