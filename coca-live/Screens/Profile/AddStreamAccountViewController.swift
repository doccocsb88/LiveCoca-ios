//
//  AddStreamAccountViewController.swift
//  coca-live
//
//  Created by Hai Vu on 7/30/18.
//  Copyright © 2018 Coca Live. All rights reserved.
//

import UIKit

class AddStreamAccountViewController: BaseViewController {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var accessTokenTextView: UITextView!
    @IBOutlet weak var submitButton: UIButton!
    
    @IBOutlet weak var containerBottomConstraint: NSLayoutConstraint!
    var bottomMargin:CGFloat = 0;
    var didAddFacebookToken:()->() = {}
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setup()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear(_:)), name: Notification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear(_:)), name: Notification.Name.UIKeyboardWillShow, object: nil)
        accessTokenTextView.text = "";
//        "EAAAAUaZA8jlABAGI9QBGltwlZAEBqa0QJFeCMw6ypYyT9tcBOqZBrqrEgpLhz1s33pChijXPhZBfVZBFuExrFKWvdCZCiekrNrkNDek7ZA0IIZAmbKpZBgXXFTdthoZBsJKDhZC4sjTXKd5mxarLxXORpXkskpJ6qXMjaAZD"
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: Notification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name.UIKeyboardWillShow, object: nil)

    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func  setup(){
        containerView.addBorder(cornerRadius: 4, color: UIColor.lightGray)
        containerView.dropShadow(color: UIColor.black, opacity: 0.5, offSet: CGSize(width: 2, height: 2), radius: 4, scale: true)
        accessTokenTextView.addBorder(cornerRadius: 4, color: UIColor.lightGray)
        submitButton.addBorder(cornerRadius: 15, color: UIColor.clear)
        
        //
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.checkAction))
        self.view.addGestureRecognizer(gesture)
        
        bottomMargin = containerBottomConstraint.constant;
    }
    
    
    @IBAction func tappedSubmitButton(_ sender: Any) {
        guard let access_token = accessTokenTextView.text, access_token.count > 0 else{
            return
        }
        APIClient.shared().addFacebook(access_token: access_token){ [unowned self](success,message) in
            
            print("add access_token\(success) --- \(message ?? "")")
            if success{
                self.didAddFacebookToken()
                self.dismiss(animated: true, completion: nil)
            }else{
                self.showMessageDialog(nil,message ?? "")
            }
            
        }
    }
    
    @IBAction func tappedClose(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func checkAction(sender : UITapGestureRecognizer) {
        // Do what you want
        self.view.endEditing(true)
    }
    
    @objc func keyboardWillAppear(_ notification: Notification) {
        //Do something here
        adjustKeyboardShow(true, notification: notification)
        
    }
    
    @objc func keyboardWillDisappear(_ notification: Notification) {
        //Do something here
        adjustKeyboardShow(false, notification: notification)
    }
    func adjustKeyboardShow(_ open: Bool, notification: Notification) {
        let userInfo = notification.userInfo ?? [:]
        let keyboardFrame = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue

//        let height = (keyboardFrame.height) * (open ? 1 : 0) / 2
        let height = (keyboardFrame.height)  / 2

//        self.commentBoxMarginBottomConstraint.constant = height;
        if open {
            containerBottomConstraint.constant += height

        }else{
            containerBottomConstraint.constant =  bottomMargin

        }
    }
}
