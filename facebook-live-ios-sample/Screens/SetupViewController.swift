//
//  SetupViewController.swift
//  coca-live
//
//  Created by Apple on 7/26/18.
//  Copyright © 2018 Coca Live. All rights reserved.
//

import UIKit

class SetupViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout{
    fileprivate let itemsPerRow: CGFloat = 2
    fileprivate let sectionInsets = UIEdgeInsets(top: 10.0, left: 20.0, bottom: 10.0, right: 20.0)
    fileprivate let reuseIdentifier = "frameCell"
    fileprivate let giftViewHeight : CGFloat = 400;
    fileprivate let frameViewHeight : CGFloat = 360;
    fileprivate let uploadViewHeight : CGFloat = 250;

    
    @IBOutlet weak var toggleGiftButton: UIButton!
    
    @IBOutlet weak var toggleUploadButton: UIButton!
    @IBOutlet weak var toggleFrameButton: UIButton!
    
    
    @IBOutlet weak var frameCollectionView: UICollectionView!
    @IBOutlet weak var giftCollectionView: UICollectionView!
    @IBOutlet weak var uploadContainerView: UIView!
    
    
    @IBOutlet weak var uploadViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var giftViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var frameViewHeightConstraint: NSLayoutConstraint!
    private var viewIndex = 0;
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setup()
        setupUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setup(){
        self.navigationController?.navigationBar.topItem?.title = "CẤU HÌNH"

        frameCollectionView.register(UINib(nibName: "FrameViewCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        giftCollectionView.register(UINib(nibName: "FrameViewCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        
    }
    func setupUI(){
        viewIndex = 1;
        toggleCurrentView()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func toggleCurrentView(){
        switch viewIndex {
        case 0:
            giftViewHeightConstraint.constant = 0;
            frameViewHeightConstraint.constant = 0;
            uploadViewHeightConstraint.constant = 0;
        case 1:
            giftViewHeightConstraint.constant = giftViewHeight;
            frameViewHeightConstraint.constant = 0;
            uploadViewHeightConstraint.constant = 0;
            break
        case 2:
            giftViewHeightConstraint.constant = 0;
            frameViewHeightConstraint.constant = frameViewHeight;
            uploadViewHeightConstraint.constant = 0;
            break
        case 3:
            giftViewHeightConstraint.constant = 0;
            frameViewHeightConstraint.constant = 0.0;
            uploadViewHeightConstraint.constant = uploadViewHeight;
            break
        default:
            giftViewHeightConstraint.constant = 0;
            frameViewHeightConstraint.constant = 0;
            uploadViewHeightConstraint.constant = 0;
        }
        UIView.animate(withDuration: 1.0, animations: {
            
        }) { (finished) in
            self.view.updateConstraintsIfNeeded()
        }
    }
    @IBAction func openUploadViewTapped(_ sender: Any) {
        if viewIndex == 3{
            viewIndex = 0
        }else{
            viewIndex = 3
        }
        toggleCurrentView()
    }
    @IBAction func openGiftViewTapped(_ sender: Any) {
        if viewIndex == 1{
            viewIndex = 0
        }else{
            viewIndex = 1
        }
        toggleCurrentView()
    }
    
    @IBAction func openFrameViewTapped(_ sender: Any) {
        if viewIndex == 2{
            viewIndex = 0
        }else{
            viewIndex = 2
        }
        toggleCurrentView()
    }
}
extension SetupViewController{
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        //2
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = (view.frame.width - 40) - paddingSpace
        var availableHeight: CGFloat = 0;
        if collectionView == giftCollectionView{
            availableHeight = giftViewHeight - sectionInsets.top * (itemsPerRow + 1);

        }else{
            availableHeight = frameViewHeight - sectionInsets.top * (itemsPerRow + 1);

        }
        let widthPerItem = availableWidth / itemsPerRow
        let heightPerItem = availableHeight / itemsPerRow

        return CGSize(width: widthPerItem, height: heightPerItem)
    }
    //3
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    // 4
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        
        return cell;
    }
}
extension SetupViewController{
    
}
