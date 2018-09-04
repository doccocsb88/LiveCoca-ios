//
//  LoginViewController.swift
//  facebook-live-ios-sample
//
//  Created by Apple on 8/5/18.
//  Copyright © 2018 Hans Knoechel. All rights reserved.
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

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupView()
        initLoadingView()
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
        guard let username = usernameTextfield.text else{
            return
        }
        guard let password = passwordTextfield.text else{
            return
        }
        loadingAnimation?.isHidden = false
        loadingAnimation?.play()
        APIClient.shared().login(username: username, password: password) {[unowned self ] (success, message) in
            self.loadingAnimation?.isHidden = false
            self.loadingAnimation?.play()
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
}
