//
//  LoginViewController.swift
//  facebook-live-ios-sample
//
//  Created by Apple on 8/5/18.
//  Copyright © 2018 Hans Knoechel. All rights reserved.
//

import UIKit
import Alamofire
class LoginViewController: UIViewController {

    
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
    }
    func setupView(){
        usernameView.addBorder(cornerRadius: 20, color: .lightGray)
        passwordView.addBorder(cornerRadius: 20, color: .lightGray)
        savePasswordButton.imageView?.contentMode = .scaleAspectFit
        loginButton.addBorder(cornerRadius: loginButton.frame.height / 2, color: .clear)
        container.addBorder(cornerRadius: 5, color: .clear)
        container.dropShadow(color: .black, opacity: 0.5, offSet: CGSize(width: 5, height: 5), radius: 5, scale: true)
        
        //
        
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
    }
    
    @IBAction func tappedLoginButton(_ sender: Any){
        let parameters: [String: String] = ["username": "bck00",
                                              "password": "123456"]

        let url = "http://live.cocalive.com:4000/users/login?app=ios&checksum=62cf0a55654e2c294ed1e3fe7718e45e"

        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseJSON { response in
                print(response)
        }
    }
}
