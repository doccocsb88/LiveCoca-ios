//
//  StreamEndedViewController.swift
//  
//
//  Created by Hai Vu on 9/6/18.
//

import UIKit
import Lottie

class StreamEndedViewController: UIViewController {
    var loadingAnimation: LOTAnimationView?
    var didLoadHandle:() ->() = {}
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        initView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        didLoadHandle()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadingAnimation?.play(completion: { (finished) in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {[unowned self] in
                if let appDelegate = UIApplication.shared.delegate as? AppDelegate{
                    appDelegate.popToRootView()
                }
//                self.dismiss(animated: true, completion: nil)
            }

        })
    }
    
    func initView(){
        loadingAnimation = LOTAnimationView(name: "animation_done")
        // Set view to full screen, aspectFill
        loadingAnimation!.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        loadingAnimation!.contentMode = .scaleAspectFill
        loadingAnimation!.frame = CGRect(x: 0, y: 0, width: 150, height: 150)
        loadingAnimation!.center = self.view.center
        loadingAnimation!.isHidden = false
        // Add the Animation
        view.addSubview(loadingAnimation!)
        self.view.backgroundColor = .white
    }
    
}

