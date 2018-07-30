//
//  AddStreamAccountViewController.swift
//  facebook-live-ios-sample
//
//  Created by Hai Vu on 7/30/18.
//  Copyright © 2018 Hans Knoechel. All rights reserved.
//

import UIKit

class AddStreamAccountViewController: UIViewController {

    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var accessTokenTextView: UITextView!
    @IBOutlet weak var submitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setup()
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
        
        
    }
    
    
    @IBAction func tappedSubmitButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @objc func checkAction(sender : UITapGestureRecognizer) {
        // Do what you want
        self.view.endEditing(true)
    }
}
