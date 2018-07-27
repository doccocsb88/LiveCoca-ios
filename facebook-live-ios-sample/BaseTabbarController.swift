//
//  BaseTabbarController.swift
//  facebook-live-ios-sample
//
//  Created by Apple on 7/26/18.
//  Copyright © 2018 Hans Knoechel. All rights reserved.
//

import UIKit

class BaseTabbarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func setup(){
        
        let icons : [String] = ["ic_tab_home","ic_tab_camera","ic_tab_setup","ic_tab_profile"]

        if let items = tabBar.items {
            for i in 0 ..< items.count {
                let item = items[i]

                setupItem(item: item, imageName: icons[i])

            }
        }
    }
    
    func setupItem(item: UITabBarItem, imageName: String){
        let itemImage = UIImage(named: imageName)
        item.image = itemImage
        item.selectedImage = itemImage?.imageWithColor(color1: UIColor(hexString: "#FC6076"))
        item.title = nil
        item.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);

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
