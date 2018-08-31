//
//  Countdown.swift
//  facebook-live-ios-sample
//
//  Created by Hai Vu on 8/31/18.
//  Copyright © 2018 Hans Knoechel. All rights reserved.
//

import UIKit

class CountdownPickerView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    var nextButton:UIButton?
    var prevButton:UIButton?
    var titleLabel:UILabel?
    var collectionView:UICollectionView?
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initView()
    }
    func initView(){
        //
        prevButton = UIButton(frame: CGRect(x: 2, y: 5, width: 30, height: 30))
        prevButton?.addBorder(cornerRadius: 2, color: .lightGray)
        prevButton?.imageView?.contentMode = .scaleAspectFit
        prevButton?.setImage(UIImage(named: "ic_prev"), for: .normal)
        self.addSubview(prevButton!)
        //
        nextButton = UIButton(frame: CGRect(x: 2, y: self.bounds.width - 35, width: 30, height: 30))
        nextButton?.addBorder(cornerRadius: 2, color: .lightGray)
        nextButton?.imageView?.contentMode = .scaleAspectFit
        nextButton?.setImage(UIImage(named: "ic_next"), for: .normal)
        nextButton?.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        self.addSubview(nextButton!)
        
        //
        titleLabel = UILabel(frame: CGRect(x: 35, y: 0, width: self.bounds.width - 70, height: 35))
        titleLabel?.textAlignment = .center
        titleLabel?.textColor = .black
        titleLabel?.text = "Thang tam"
        self.addSubview(titleLabel!)
        
        //
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 2 , left: 2, bottom: 2, right: 2)
        layout.itemSize = CGSize(width: (self.bounds.width - 20) / 3, height: 30)
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 35, width: self.frame.size.width, height: self.frame.size.height - 40), collectionViewLayout: layout)
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.backgroundColor = .white
        collectionView?.register(TimerViewCell.self, forCellWithReuseIdentifier: "TimerViewCell")
        self.addSubview(collectionView!)
        self.addBorder(cornerRadius: 4, color: .lightGray)
        self.backgroundColor = .white
    }
}
extension CountdownPickerView: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 24
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TimerViewCell", for: indexPath)
        
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

private class TimerViewCell:UICollectionViewCell{
    var timerLabel:UILabel?
    override func awakeFromNib() {
        super.awakeFromNib()
        initView()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    func initView(){
        timerLabel = UILabel(frame:self.bounds)
        timerLabel?.text = "00:00"
        timerLabel?.textColor = .black
        timerLabel?.textAlignment = .center
        self.addSubview(timerLabel!)
        self.addBorder(cornerRadius: 2, color: .lightGray)
    }
}
