//
//  SignUpViewController.swift
//  coca-live
//
//  Created by Macintosh HD on 9/6/18.
//  Copyright © 2018 Coca Live. All rights reserved.
//

import UIKit

class SignUpViewController: BaseViewController {
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var usernameTextfield: UITextField!
    
    @IBOutlet weak var passwordTextfield: UITextField!
    
    @IBOutlet weak var fullnameTextfield: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUI()
        initLoadingView(nil)

    }
    func setupUI(){
        usernameTextfield.addBorder(cornerRadius: 2, color: .lightGray)
        passwordTextfield.addBorder(cornerRadius: 2, color: .lightGray)
        fullnameTextfield.addBorder(cornerRadius: 2, color: .lightGray)
        emailTextField.addBorder(cornerRadius: 2, color: .lightGray)
        container.addBorder(cornerRadius: 5, color: .clear)
        container.dropShadow(color: .black, opacity: 0.5, offSet: CGSize(width: 5, height: 5), radius: 5, scale: true)

        //
        let emailImageView = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        emailImageView.imageView?.contentMode = .scaleAspectFit
        emailImageView.setImage(UIImage(named: "ic_email"), for: .normal)
        emailImageView.imageEdgeInsets = UIEdgeInsets(top: 8, left: 5, bottom: 8, right: 5)
        emailTextField.leftView = emailImageView
        emailTextField.leftViewMode = .always
        //
        let lockView = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        lockView.imageView?.contentMode = .scaleAspectFit
        lockView.setImage(UIImage(named: "ic_lock"), for: .normal)
        lockView.imageEdgeInsets = UIEdgeInsets(top: 8, left: 5, bottom: 8, right: 5)
        passwordTextfield.leftView = lockView
        passwordTextfield.leftViewMode = .always
        //
        let usernameView = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        usernameView.imageView?.contentMode = .scaleAspectFit
        usernameView.setImage(UIImage(named: "ic_tab_profile"), for: .normal)
        usernameView.imageEdgeInsets = UIEdgeInsets(top: 8, left: 5, bottom: 8, right: 5)
        usernameTextfield.leftView = usernameView
        usernameTextfield.leftViewMode = .always

        //
        let nameView = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        nameView.imageView?.contentMode = .scaleAspectFit
        nameView.setImage(UIImage(named: "ic_tab_profile"), for: .normal)
        nameView.imageEdgeInsets = UIEdgeInsets(top: 8, left: 5, bottom: 8, right: 5)
        fullnameTextfield.leftView = nameView
        fullnameTextfield.leftViewMode = .always
        
        
        //
        registerButton.addBorder(cornerRadius: registerButton.frame.height / 2, color: .clear)
        errorLabel.text = nil
        //
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tappedGesture(_:)))
        
        self.view.addGestureRecognizer(gesture)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @objc func tappedGesture(_ gesture:UIGestureRecognizer){
        self.view.endEditing(true)
    }
    @IBAction func tappedCloseButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func tappedRegisterButton(_ sender: Any) {
        guard let username = usernameTextfield.text, username.count > 0 else{
            usernameTextfield.becomeFirstResponder()
            errorLabel.text = "Vui lòng nhập tên đăng nhập"
            return
        }
        guard let password = passwordTextfield.text, password.count > 0 else{
            passwordTextfield.becomeFirstResponder()
            errorLabel.text = "Vui lòng nhập mật khẩu"
            return
        }
        
        guard let fullname = fullnameTextfield.text, fullname.count > 0 else{
            fullnameTextfield.becomeFirstResponder()
            errorLabel.text = "Vui lòng nhập họ và tên"
            return
        }
        
        guard let email = emailTextField.text, email.count > 0 else{
            emailTextField.becomeFirstResponder()
            errorLabel.text = "Vui lòng nhập email"
            return
        }
        if  email.isValidEmail() == false {
            errorLabel.text = "Email không lợp lệ "

            return
        }
       
        errorLabel.text = nil
        self.view.endEditing(true)
        self.showLoadingView()
        APIClient.shared().register(username: username, password: password, fullname: fullname, email: email) { [unowned self](success, message) in
            self.hideLoadingView()
            if success{
                Defaults.saveToken(APIClient.shared().token ?? "")
                if let appDelegate = UIApplication.shared.delegate as? AppDelegate{
                    appDelegate.setHomeViewAsRoot()
                }

            }else{
                self.showMessageDialog(nil, message)
            }
        }
    }
}
