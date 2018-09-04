//
//  ProfileViewController.swift
//  facebook-live-ios-sample
//
//  Created by Apple on 7/26/18.
//  Copyright © 2018 Hans Knoechel. All rights reserved.
//

import UIKit
class ProfileViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
  

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var changeAvatarButton: UIButton!
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var bioTextView: UITextView!
    @IBOutlet weak var displayNameTitleLabel: UILabel!
    @IBOutlet weak var emailTitleLabel: UILabel!
    @IBOutlet weak var phoneTitleLabel: UILabel!
    @IBOutlet weak var passwordTitleLabel: UILabel!
    
    @IBOutlet weak var displayLabel: UITextField!
    @IBOutlet weak var emailLabel: UITextField!
    @IBOutlet weak var phoneLabel: UITextField!
    @IBOutlet weak var passwordLabel: UITextField!
    
    @IBOutlet weak var addLiveStreamButton: UIButton!
    /**/
    var editButton1:UIButton?
    var editButton2:UIButton?
    var editButton3:UIButton?
    var editButton4:UIButton?

    let imagePicker = UIImagePickerController()
    var curFieldIndex:Int =  NSNotFound
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setup()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        bindData()
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
    func setup(){
        //
        self.navigationController?.navigationBar.topItem?.title = "THÔNG TIN CÁ NHÂN"
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(someAction(_:)))
        self.view.addGestureRecognizer(gesture)
        //
        tableView.register(UINib(nibName: "StreamAccountViewCell", bundle: nil), forCellReuseIdentifier: "streamAccountCell")
        
        //
        changeAvatarButton.addBorder(cornerRadius: 15.0, color: .clear)
        
        let width = 60
        editButton1 = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: 25))
        editButton1?.setTitle("Cập nhật", for: .normal)
//        editButton1?.setImage(UIImage(named: "ic_edit"), for: .normal)
//        editButton1?.setImage(nil, for: .selected)
        editButton1?.setTitle("Lưu", for: .selected)
        editButton1?.setTitleColor(.black, for: .normal)
        editButton1?.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        editButton1?.imageView?.contentMode = .scaleAspectFit
        editButton1?.contentEdgeInsets = UIEdgeInsetsMake(3, 3, 3, 3)
        editButton1?.addTarget(self, action: #selector(tappedEditButton(_:)), for: .touchUpInside)
        editButton1?.tag = 1
        displayLabel.rightView = editButton1
        displayLabel.rightViewMode = .always
        
        
        editButton2 = UIButton(frame: CGRect(x: 0, y: 0, width: width, height: 25))
        editButton2?.setTitle("Cập nhật", for: .normal)
//        editButton2?.setImage(UIImage(named: "ic_edit"), for: .normal)
//        editButton2?.setImage(nil, for: .selected)
        editButton2?.setTitle("Lưu", for: .selected)
        editButton2?.setTitleColor(.black, for: .normal)
        editButton2?.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        editButton2?.imageView?.contentMode = .scaleAspectFit
        editButton2?.contentEdgeInsets = UIEdgeInsetsMake(3, 3, 3, 3)
        editButton2?.addTarget(self, action: #selector(tappedEditButton(_:)), for: .touchUpInside)
        editButton2?.tag = 2
        emailLabel.rightView = editButton2;
        emailLabel.rightViewMode = .always
        
        //
        editButton3 = UIButton(frame: CGRect(x: 0, y: 0, width: width, height: 25))
//        editButton3?.setImage(UIImage(named: "ic_edit"), for: .normal)
//        editButton3?.setImage(nil, for: .selected)
        editButton3?.setTitle("Cập nhật", for: .normal)
        editButton3?.setTitle("Lưu", for: .selected)
        editButton3?.titleLabel?.font = UIFont.systemFont(ofSize: 12)

        editButton3?.imageView?.contentMode = .scaleAspectFit
        editButton3?.contentEdgeInsets = UIEdgeInsetsMake(3, 3, 3, 3)
        editButton3?.addTarget(self, action: #selector(tappedEditButton(_:)), for: .touchUpInside)
        editButton3?.tag = 3
        phoneLabel.rightView = editButton3
        phoneLabel.rightViewMode = .always
        //
        editButton4 = UIButton(frame: CGRect(x: 0, y: 0, width: width, height: 25))
//        editButton4?.setImage(UIImage(named: "ic_edit"), for: .normal)
//        editButton4?.setImage(nil, for: .selected)
        editButton4?.setTitle("Cập nhật", for: .normal)
        editButton4?.setTitle("Lưu", for: .selected)
        editButton4?.titleLabel?.font = UIFont.systemFont(ofSize: 12)

        editButton4?.imageView?.contentMode = .scaleAspectFit
        editButton4?.contentEdgeInsets = UIEdgeInsetsMake(3, 3, 3, 3)
        editButton4?.addTarget(self, action: #selector(tappedEditButton(_:)), for: .touchUpInside)
        editButton4?.tag = 4

        passwordLabel.rightView = editButton4
        passwordLabel.rightViewMode = .always
    }
    func initNavigatorBar(){
        let logoutButton = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        logoutButton.setImage(UIImage(named: "ic_sign_out"), for: .normal)
        logoutButton.imageView?.contentMode = .scaleAspectFit
        logoutButton.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        
        logoutButton.addTarget(self, action: #selector(tappedLogoutButton(_:)), for: .touchUpInside)
        let add = UIBarButtonItem(customView: logoutButton)
        navigationItem.rightBarButtonItems = [add]

    }
    func bindData(){
        if let user = APIClient.shared().user{
            usernameLabel.text = user.username
            displayLabel.text = user.fullname
            emailLabel.text = user.email
            phoneLabel.text = user.phone
            passwordLabel.text = "******"
            bioTextView.text = user.description
            //
            
            if let avatar = user.avatar{
                let path = String(format: "%@%@", K.ProductionServer.baseURL,avatar)
                let url = URL(string: path)
                avatarImageView.kf.setImage(with: url)
            }
            
        }
    }
    
    @IBAction func tappedAddStreamAccountButton(_ sender: Any) {
        let vc = AddStreamAccountViewController(nibName: "AddStreamAccountViewController", bundle: nil)
        vc.modalPresentationStyle = .overFullScreen
        
        self.present(vc, animated: true, completion: nil)
    }
    @IBAction func tappedEditAvatarButton(_ sender: Any) {
        openSelectImage()
        
    }
    @objc func tappedLogoutButton(_ button:UIButton){
        
    }
    func openSelectImage(){
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        let cameraAction = UIAlertAction(title: "Camera", style: .default) {[unowned self] (action) in
            self.openPhotoLibrary(sourceType: .camera)
        }
        let libraryAction = UIAlertAction(title: "Library", style: .default){[unowned self] (action) in
            self.openPhotoLibrary(sourceType: .photoLibrary)
        }
        alert.addAction(cameraAction)
        alert.addAction(libraryAction)
        
        alert.addAction(cancel)


        present(alert, animated: true)

    }
    func openPhotoLibrary(sourceType:UIImagePickerControllerSourceType) {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            print("can't open photo library")
            return
        }
//        .photoLibrary
        imagePicker.sourceType = sourceType
        imagePicker.delegate = self
        present(imagePicker, animated: true)
    }
    
    @objc func tappedEditButton(_ button:UIButton){
        button.isSelected = !button.isSelected
        curFieldIndex = button.tag
        switch curFieldIndex {
        case 1:
            displayLabel.becomeFirstResponder()
            break
        case 2:
            emailLabel.becomeFirstResponder()
            break
        case 3:
            phoneLabel.becomeFirstResponder()
            break
        case 4:
            passwordLabel.becomeFirstResponder()
            break
        default:
            break
        }
        if button.isSelected{
            updateUserInfo()
        }
    }
    @objc func someAction(_ sender:UITapGestureRecognizer){
        self.view.endEditing(true)
        self.curFieldIndex = NSNotFound
    }
    func updateUserInfo(){
        switch curFieldIndex {
        case 1:
            guard let fullname = displayLabel.text else{
                return
            }
            APIClient.shared().updateAccount(username: nil, password: nil, fullname: fullname, phone: nil, email: nil, description: nil)
            break
        case 2:
            break
        case 3:
            break
        case 4:
            break
        default:
            break
        }

    }
}

extension ProfileViewController{
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return APIClient.shared().accounts.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "streamAccountCell", for: indexPath) as! StreamAccountViewCell
        cell.selectionStyle = .none
        let account = APIClient.shared().accounts[indexPath.row]
        cell.bindData(account)
        return cell
    }
    
}
extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        defer {
            picker.dismiss(animated: true)
        }
        
        print(info)
        // get the image
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            return
        }
        
        // do something with it
        avatarImageView.image = image
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        defer {
            picker.dismiss(animated: true)
        }
        
        print("did cancel")
    }
}

extension ProfileViewController: UITextFieldDelegate{
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        let tag = textField.tag
        return tag == curFieldIndex
    }
}
