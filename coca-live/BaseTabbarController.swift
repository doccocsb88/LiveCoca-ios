//
//  BaseTabbarController.swift
//  coca-live
//
//  Created by Apple on 7/26/18.
//  Copyright © 2018 Coca Live. All rights reserved.
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
        self.view.backgroundColor = UIColor.white
        let icons : [String] = ["ic_tab_home","ic_tab_setup","ic_tab_camera","ic_tab_profile"]

        if let items = tabBar.items {
            for i in 0 ..< items.count {
                let item = items[i]

                setupItem(item: item, imageName: icons[i])

            }
        }
    }
    
    func setupItem(item: UITabBarItem, imageName: String){
        let originImage  = UIImage(named: imageName)
        let itemImage = originImage?.imageWithColor(color1: UIColor.lightGray).withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        
        let tintedImage  = originImage?.imageWithColor(color1: UIColor(hexString: "#FC6076")).withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        item.image = itemImage
        item.selectedImage = tintedImage//imageWithColor(color1: UIColor(hexString: "#FC6076"))
        item.title = nil
        item.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);

    }
    func resetHomeViewController(){

        if let views = self.viewControllers{
            if let view  = views[0] as? StreamViewController{
                view.reset()
            }
        }
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
