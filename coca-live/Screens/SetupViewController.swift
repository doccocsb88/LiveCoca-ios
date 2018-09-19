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

class SetupViewController: BaseViewController, UICollectionViewDelegate, UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout{
    fileprivate let itemsPerRow: CGFloat = 2
    fileprivate let sectionInsets = UIEdgeInsets(top: 10.0, left: 20.0, bottom: 10.0, right: 20.0)
    fileprivate let reuseIdentifier = "frameCell"
    fileprivate let giftViewHeight : CGFloat = 400;
    fileprivate let frameViewHeight : CGFloat = 360;
    fileprivate let uploadViewHeight : CGFloat = 250;

    
    @IBOutlet weak var inputUrlButton: UIButton!
    @IBOutlet weak var previewImageView: UIImageView!
    @IBOutlet weak var uploadButton: UIButton!
    @IBOutlet weak var selectImageButton: UIButton!
    @IBOutlet weak var toggleGiftButton: UIButton!
    
    @IBOutlet weak var toggleUploadButton: UIButton!
    @IBOutlet weak var toggleFrameButton: UIButton!
    
    
    @IBOutlet weak var frameCollectionView: UICollectionView!
    @IBOutlet weak var giftCollectionView: UICollectionView!
    @IBOutlet weak var uploadContainerView: UIView!
    
    
    @IBOutlet weak var uploadViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var giftViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var frameViewHeightConstraint: NSLayoutConstraint!
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
        setup()
        setupUI()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        APIClient.shared().getListFrame { (success, message, frames) in
            print("\(success) --- \(message ?? "abc")")
            if success{
                self.listFrame = frames
                self.frameCollectionView.reloadData()
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
        giftCollectionView.register(UINib(nibName: "FrameViewCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        
    }
    func setupUI(){
        viewIndex = 1;
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
        switch viewIndex {
        case 0:
            giftViewHeightConstraint.constant = 0;
            frameViewHeightConstraint.constant = 0;
            uploadViewHeightConstraint.constant = 0;
        case 1:
            giftViewHeightConstraint.constant = giftViewHeight;
            frameViewHeightConstraint.constant = 0;
            uploadViewHeightConstraint.constant = 0;
            break
        case 2:
            giftViewHeightConstraint.constant = 0;
            frameViewHeightConstraint.constant = frameViewHeight;
            uploadViewHeightConstraint.constant = 0;
            break
        case 3:
            giftViewHeightConstraint.constant = 0;
            frameViewHeightConstraint.constant = 0.0;
            uploadViewHeightConstraint.constant = uploadViewHeight;
            break
        default:
            giftViewHeightConstraint.constant = 0;
            frameViewHeightConstraint.constant = 0;
            uploadViewHeightConstraint.constant = 0;
        }
        UIView.animate(withDuration: 1.0, animations: {
            
        }) { (finished) in
            self.view.updateConstraintsIfNeeded()
        }
    }
    @IBAction func openUploadViewTapped(_ sender: Any) {
        if viewIndex == 3{
            viewIndex = 0
        }else{
            viewIndex = 3
        }
        toggleCurrentView()
    }
    @IBAction func openGiftViewTapped(_ sender: Any) {
        if viewIndex == 1{
            viewIndex = 0
        }else{
            viewIndex = 1
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
        showListUpload()

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
        if collectionView == giftCollectionView{
            availableHeight = giftViewHeight - sectionInsets.top * (itemsPerRow + 1);

        }else{
            availableHeight = frameViewHeight - sectionInsets.top * (itemsPerRow + 1);

        }
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
        if collectionView == frameCollectionView {
            return listFrame.count
        }
        return 20;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! FrameViewCell
        if collectionView == frameCollectionView {
            let frame = listFrame[indexPath.row]
            cell.updateContent(frame)
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
        APIClient.shared().upload(type: type, title: "abcdef", url: nil, image: image)
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
            guard let _ = titleFrame else {
                self.showAlertMessage(nil, "Nhập tên khung trước khi upload hình ảnh")
                return}
            APIClient.shared().upload(type: type, title: titleFrame, url: selectedUrl, image: selectedImage)

        }else{
            if self.selectedImage == nil && self.selectedImage == nil{
                self.showAlertMessage(nil, "Vui lòng chọn ảnh từ thư việc hoặc nhập đường dẫn hình ảnh")

            }else{
                APIClient.shared().upload(type: type, title: titleFrame, url: selectedUrl, image: selectedImage)

            }
        }
    }
}
