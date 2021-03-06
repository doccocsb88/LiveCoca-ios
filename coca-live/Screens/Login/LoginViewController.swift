//
//  LoginViewController.swift
//  coca-live
//
//  Created by Apple on 8/5/18.
//  Copyright © 2018 Coca Live. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Lottie
class LoginViewController:BaseViewController{

    
    @IBOutlet weak var container: UIView!
    
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var usernameTextfield: UITextField!
    @IBOutlet weak var usernameView: UIView!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var savePasswordButton: UIButton!
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupView()
        initLoadingView(nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        usernameTextfield.text = Defaults.getUsername()
        passwordTextfield.text = Defaults.getPassword()
        savePasswordButton.isSelected = Defaults.isRemember()
    }
    func setupView(){
        usernameView.addBorder(cornerRadius: 20, color: .lightGray)
        passwordView.addBorder(cornerRadius: 20, color: .lightGray)
        savePasswordButton.imageView?.contentMode = .scaleAspectFit
        loginButton.addBorder(cornerRadius: loginButton.frame.height / 2, color: .clear)
        container.addBorder(cornerRadius: 5, color: .clear)
        container.dropShadow(color: .black, opacity: 0.5, offSet: CGSize(width: 5, height: 5), radius: 5, scale: true)
        //        //
        
        let gesture = UITapGestureRecognizer(target: self, action:  #selector (self.tapAction (_:)))
        container.addGestureRecognizer(gesture)

    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @objc func tapAction(_ sender:UITapGestureRecognizer){
        // do other task
        self.view.endEditing(true)
        self.usernameTextfield.resignFirstResponder()
        self.passwordTextfield.resignFirstResponder()
    }
    @IBAction func tappedSavePasswordButton(_ sender: Any) {
        savePasswordButton.isSelected = !savePasswordButton.isSelected
        Defaults.rememberPassword(savePasswordButton.isSelected)
    }
    
    @IBAction func tappedLoginButton(_ sender: Any){
        guard let username = usernameTextfield.text , username.count > 0 else{
            usernameTextfield.becomeFirstResponder()
            errorLabel.text = "Bạn chưa nhập username / email."
            return
        }
        guard let password = passwordTextfield.text, password.count > 0 else{
            passwordTextfield.becomeFirstResponder()
            errorLabel.text = "Bạn chưa nhập mật khẩu."

            return
        }
        errorLabel.text = nil
        passwordTextfield.resignFirstResponder()
        usernameTextfield.resignFirstResponder()
        self.showLoadingView()
        APIClient.shared().login(username: username, password: password) {[unowned self ] (success, message) in
          self.hideLoadingView()
            if success{
                Defaults.remember(username: username, password: password)
                Defaults.saveToken(APIClient.shared().token ?? "")
                if let appDelegate = UIApplication.shared.delegate as? AppDelegate{
                    appDelegate.setHomeViewAsRoot()
                }

            }else{
                self.showMessageDialog(nil, message)
            }
        }
    }
    @IBAction func tappedSignupButton(_ sender: Any) {
        let signupViewcontroller = SignUpViewController(nibName: "SignUpViewController", bundle: nil)
        
        self.present(signupViewcontroller, animated: true, completion: nil)

    }
}
