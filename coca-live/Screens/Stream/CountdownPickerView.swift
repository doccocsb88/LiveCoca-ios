//
//  Countdown.swift
//  coca-live
//
//  Created by Hai Vu on 8/31/18.
//  Copyright © 2018 Coca Live. All rights reserved.
//

import UIKit

class CountdownPickerView: UIView {
    fileprivate let menuWidth:CGFloat = 275
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
    var didSelectTimer:(String?) ->() = {timer in }
    var timerData:[String] = []
    override init(frame: CGRect) {
        super.init(frame: frame)
        for i in 0...23{
            if i < 10{
                timerData.append("0\(i):00")
            }else{
                timerData.append("\(i):00")
            }
        }
        initView()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initView()
    }
    func initView(){
        //
        let viewWidth = menuWidth - 2*10//margin = 10
        prevButton = UIButton(frame: CGRect(x: 5, y: 2, width: 30, height: 30))
        prevButton?.addBorder(cornerRadius: 2, color: .lightGray)
        prevButton?.imageView?.contentMode = .scaleAspectFit
        prevButton?.setImage(UIImage(named: "ic_prev"), for: .normal)
        prevButton?.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        self.addSubview(prevButton!)
        //
        nextButton = UIButton(frame: CGRect(x: viewWidth - 35, y: 2, width: 30, height: 30))
        nextButton?.addBorder(cornerRadius: 2, color: .lightGray)
        nextButton?.imageView?.contentMode = .scaleAspectFit
        nextButton?.setImage(UIImage(named: "ic_next"), for: .normal)
        nextButton?.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        self.addSubview(nextButton!)
        prevButton?.isHidden = true
        nextButton?.isHidden = true
        
        //
        titleLabel = UILabel(frame: CGRect(x: 35, y: 0, width: viewWidth - 70, height: 35))
        titleLabel?.textAlignment = .center
        titleLabel?.textColor = .black
        titleLabel?.text = Date().getMonthName().capitalized
        self.addSubview(titleLabel!)
        
        //
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 2 , left: 2, bottom: 2, right: 2)
        layout.itemSize = CGSize(width: (self.bounds.width - 30) / 3, height: 30)
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
        return timerData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let curHour = Date().getHour()
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TimerViewCell", for: indexPath) as! TimerViewCell
        let hourText = timerData[indexPath.row].components(separatedBy: ":")[0]
        let hour = Int(hourText) ?? 0
        
        cell.bindData(timer: timerData[indexPath.row], enable: hour > curHour)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let curHour = Date().getHour()
        if curHour < indexPath.row{
                if indexPath.row < 10{
                    didSelectTimer("0\(indexPath.row):00")

                }else{
                    didSelectTimer("\(indexPath.row):00")

                }
            
            self.removeFromSuperview()
        }
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
        timerLabel?.textColor = .black
        timerLabel?.textAlignment = .center
        self.addSubview(timerLabel!)
        self.addBorder(cornerRadius: 2, color: .lightGray)
    }
    func bindData(timer:String,enable:Bool){
        timerLabel?.text = timer
        if enable {
            timerLabel?.textColor = .black
        }else{
            timerLabel?.textColor = .lightGray

        }
    }
    func getTimerText() ->String?{
        if let label = timerLabel{
            return label.text
        }
        return nil
    }
}
