//
//  HasStreamPopupView.swift
//  coca-live
//
//  Created by Macintosh HD on 9/1/18.
//  Copyright © 2018 Coca Live. All rights reserved.
//

import UIKit

class HasStreamPopupView: UIViewController {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var closeButton: UIButton!
    
    @IBOutlet weak var cancelAndCreateLiveButton: UIButton!
    
    @IBOutlet weak var gotoBackgroundView: UIImageView!
    @IBOutlet weak var gotoCurrentRoomButton: UIButton!
    var id_room:String?
    var id_social:String?
    var id_target:String?
    var streamDescription: String?
    var didCreateLive:(StreamInfo?) ->() = {info in}

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        // Do any additional setup after loading the view.
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        APIClient.shared().hasStream { (success, message, id_room) in
            if let _ = id_room{
                self.id_room = id_room!
            }
        }
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
        guard let id_room = self.id_room else{
            return
        }
//        guard let id_social = self.id_social else{
//            return
//        }
//        guard let id_target = self.id_target else {
//            return
//        }
        APIClient.shared().endLive(id_room: id_room) {[weak self] (success, message) in
            if success{
//                APIClient.shared().createLive(id_social: id_social, id_target: id_target, caption: self.streamDescription ?? "Coca Live") {[unowned self]  (success,code , message, info) in
//                    if success{
//                        self.didCreateLive(info)
//                    }
//
//                }
                guard let strongSelf = self else{
                    return
                }
                strongSelf.dismiss(animated: true, completion: nil)

            }else{
                
            }
        }
        
    }
    @IBAction func tappedGotoButton(_ sender: Any) {
    }
    @IBAction func tappedCloseButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
