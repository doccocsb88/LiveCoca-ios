//
//  BaseViewController.swift
//  coca-live
//
//  Created by Macintosh HD on 8/30/18.
//  Copyright © 2018 Coca Live. All rights reserved.
//

import UIKit
import Lottie

class BaseViewController: UIViewController {
    var loadingAnimation: LOTAnimationView?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
    
    func initLoadingView(){
        loadingAnimation = LOTAnimationView(name: "soda_loader")
        // Set view to full screen, aspectFill
        loadingAnimation!.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        loadingAnimation!.contentMode = .scaleAspectFill
        loadingAnimation!.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        loadingAnimation!.center = self.view.center
        loadingAnimation!.isHidden = true
        // Add the Animation
        view.addSubview(loadingAnimation!)

    }
    
    func showMessageDialog(_ title:String?, _ message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Đồng ý", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    func showLoadingView(){
        if let _ = self.loadingAnimation {
            self.loadingAnimation!.isHidden = false
            self.loadingAnimation!.play()

        }
        
    }
    func hideLoadingView(){
        if let _ = self.loadingAnimation{
            self.loadingAnimation!.isHidden = true
            self.loadingAnimation!.stop()
        }
        
    }

}
