//
//  HasStreamPopupView.swift
//  facebook-live-ios-sample
//
//  Created by Macintosh HD on 9/1/18.
//  Copyright © 2018 Hans Knoechel. All rights reserved.
//

import UIKit

class HasStreamPopupView: UIViewController {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var closeButton: UIButton!
    
    @IBOutlet weak var cancelAndCreateLiveButton: UIButton!
    
    @IBOutlet weak var gotoBackgroundView: UIImageView!
    @IBOutlet weak var gotoCurrentRoomButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupUI(){
        cancelAndCreateLiveButton.addBorder(cornerRadius: 15, color: .clear)
        gotoBackgroundView.addBorder(cornerRadius: 15, color: .clear)
        gotoCurrentRoomButton.addBorder(cornerRadius: 14, color: .clear)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func tappedCreateNewButton(_ sender: Any) {
        
    }
    @IBAction func tappedGotoButton(_ sender: Any) {
    }
    @IBAction func tappedCloseButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
