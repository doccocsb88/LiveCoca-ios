//
//  InputPopupViewController.swift
//  coca-live
//
//  Created by Macintosh HD on 9/19/18.
//  Copyright © 2018 Coca Live. All rights reserved.
//

import UIKit

class InputPopupViewController: UIViewController {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var inputTextfield: UITextField!
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    var inputType:Int = 1
    //1 title
    //2 url
    var didInputValue:(String?)->() = {value in}
    override func viewDidLoad() {
        super.viewDidLoad()
        let radius = okButton.frame.height / 2
        okButton.addBorder(cornerRadius: radius, color: .clear)
        cancelButton.addBorder(cornerRadius: radius, color: .clear)
        containerView.addBorder(cornerRadius: 4, color: .clear)
        self.errorLabel.text = nil
        // Do any additional setup after loading the view.
        let tapped = UITapGestureRecognizer(target: self, action: #selector(tapped(_:)))
        
        self.view.addGestureRecognizer(tapped)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if inputType == 1 {
            titleLabel.text = "Nhập tên khung"
            inputTextfield.placeholder = "Tên khung"

        }else if inputType == 2{
            titleLabel.text = "Nhập đường link hình ảnh"
            inputTextfield.placeholder = "http://"

        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @objc func tapped(_ gesture:UIGestureRecognizer){
        
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func tappedOkButton(_ sender: Any) {
        guard let value = inputTextfield.text else{
            if inputType == 1 {
                errorLabel.text = "Vui lòng nhập tên khung"
            }else if inputType == 2{
                errorLabel.text = "Vui lòng nhập đường dẫn đến hình ảnh"
            }
            return
        }
        if inputType == 2 && value.isValidUrl() == false{
            errorLabel.text = "Đường dẫn hình ảnh không hợp lệ"

            return
        }
        errorLabel.text = nil
        inputTextfield.resignFirstResponder()
        didInputValue(value)
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func tappedCancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)

    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
