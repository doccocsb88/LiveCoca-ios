//
//  RandomMaskView.swift
//  facebook-live-ios-sample
//
//  Created by Macintosh HD on 8/27/18.
//  Copyright © 2018 Hans Knoechel. All rights reserved.
//

import UIKit

class RandomMaskView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    var scale:CGFloat = 1
    var randomView:UIView?
    var randomBackgroundImageView:UIImageView?
    var number1Label:UILabel?
    var number2Label:UILabel?
    var number3Label:UILabel?
    var number4Label:UILabel?
    var randomButton:UIButton?
    var timer1:Timer?
    var timer2:Timer?
    var timer3:Timer?
    var timer4:Timer?
    var isReady:Bool = true;
    var from:Int = 0;
    var to:Int = 0
    var randomNumber:Int = 0
    var completeHandle:(Bool) ->() = { start in }

    override init(frame:CGRect){
        super.init(frame: frame)
        initView()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    init(frame:CGRect, scale:CGFloat){
        super.init(frame: frame)
        self.scale = scale;
        initView()
    }

    private func initView(){
        if let config = WarterMarkServices.shared().params[ConfigKey.random.rawValue] as? [String : Any]{
            from = config["from"] as! Int
            to = config["to"] as! Int
        }
        let size = self.bounds.size
        let randomWidth = size.width / 2 * scale;
        let randomHeight = (randomWidth / 1008) * 696
        
        let left = (size.width - randomWidth) / 2;
        let topMargin = size.height / 2 - randomHeight / 2
        randomView = UIView(frame: CGRect(x: left, y: topMargin, width: randomWidth, height: randomHeight))
        self.addSubview(randomView!)
        
        //
        randomBackgroundImageView = UIImageView(frame: (randomView?.bounds)!)
        randomBackgroundImageView?.image = UIImage(named: "background_random")
        randomBackgroundImageView?.contentMode = .scaleAspectFit
        randomView?.addSubview(randomBackgroundImageView!)
        //
        //height  : 311 / 696
        //start : 94
        //width : 178
        //margin: 40
        
        var numberLeft = (94 / 1008) * randomWidth
        let numberTop = (385 / 696) * randomHeight;
        let numberWidth = (178 / 1008 ) * randomWidth;
        let numberHeight = (311 / 696) * randomHeight;
        let numberMargin = (38 / 1008) * randomWidth;
        
        number1Label = UILabel(frame: CGRect(x: numberLeft, y: numberTop, width: numberWidth, height: numberHeight))
        number1Label?.textAlignment = .center
        number1Label?.textColor = .black
        number1Label?.font = UIFont.systemFont(ofSize: 25 * scale)
        number1Label?.text = "1"
        randomView?.addSubview(number1Label!)
        ///
        numberLeft = numberLeft + numberMargin +  numberWidth;
        number2Label = UILabel(frame: CGRect(x: numberLeft, y: numberTop, width: numberWidth, height: numberHeight))
        number2Label?.textAlignment = .center
        number2Label?.textColor = .black
        number2Label?.font = UIFont.systemFont(ofSize: 25 * scale)
        number2Label?.text = "2"
        randomView?.addSubview(number2Label!)
        ///
        numberLeft = numberLeft + numberMargin + numberWidth;

        number3Label = UILabel(frame: CGRect(x: numberLeft, y: numberTop, width: numberWidth, height: numberHeight))
        number3Label?.textAlignment = .center
        number3Label?.textColor = .black
        number3Label?.font = UIFont.systemFont(ofSize: 25 * scale)
        number3Label?.text = "3"
        randomView?.addSubview(number3Label!)
        ///
        numberLeft = numberLeft + numberMargin + numberWidth;
        number4Label = UILabel(frame: CGRect(x: numberLeft, y: numberTop, width: numberWidth, height: numberHeight))
        number4Label?.textAlignment = .center
        number4Label?.textColor = .black
        number4Label?.font = UIFont.systemFont(ofSize: 25 * scale)
        number4Label?.text = "4"
        randomView?.addSubview(number4Label!)
        ///

        let buttonHeight = (randomWidth / 860 ) * 165
        
        randomButton = UIButton(frame: CGRect(x: left, y: topMargin + randomHeight + 10 * scale, width: randomWidth, height: buttonHeight))
        randomButton?.setBackgroundImage(UIImage(named: "background_random_button"), for: .normal)
        randomButton?.setTitle("START", for: .normal)
        randomButton?.titleLabel?.font = UIFont.systemFont(ofSize: 25 * scale)
        randomButton?.addTarget(self, action: #selector(didTouchStart(_:)), for: .touchUpInside)
        self.addSubview(randomButton!)
        
    }
    
    @objc func didTouchStart(_ button : UIButton){
        if isReady {
            button.isSelected = !button.isSelected
            if button.isSelected {
                startRandom()
            }else{
                stopRandom()
            }

        }
    }
    
    func startRandom(){
        completeHandle(true)
        randomNumber = Int.randomNumber(range: from...to)
        randomButton?.setTitle("STOP", for: .normal)

        timer1 = Timer.scheduledTimer(timeInterval: 0.02, target: self, selector: #selector(randomNumber1), userInfo: nil, repeats: true)
        timer2 = Timer.scheduledTimer(timeInterval: 0.02, target: self, selector: #selector(randomNumber2), userInfo: nil, repeats: true)
        timer3 = Timer.scheduledTimer(timeInterval: 0.02, target: self, selector: #selector(randomNumber3), userInfo: nil, repeats: true)
        timer4 = Timer.scheduledTimer(timeInterval: 0.02, target: self, selector: #selector(randomNumber4), userInfo: nil, repeats: true)

    }
    func stopRandom(){
        self.isReady = false;
        completeHandle(false)
        randomButton?.setTitle("START", for: .normal)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {[weak self] in
            guard let strongSelf = self else{
                return
            }
            // your code here
            if let timer = strongSelf.timer1 {
                timer.invalidate()
            }
            strongSelf.number1Label?.text = "\(strongSelf.randomNumber /  1000 )"


        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {[weak self] in
            // your code here
            guard let strongSelf = self else{
                return
            }

            if let timer = strongSelf.timer2 {
                timer.invalidate()
            }
            strongSelf.number2Label?.text = "\((strongSelf.randomNumber /  100) % 10 )"


        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {[weak self] in
            // your code here
            guard let strongSelf = self else{
                return
            }

            if let timer = strongSelf.timer3 {
                timer.invalidate()
            }
            strongSelf.number3Label?.text = "\((strongSelf.randomNumber /  10) % 10 )"

        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {[weak self] in
            // your code here
            guard let strongSelf = self else{
                return
            }

            if let timer = strongSelf.timer4 {
                timer.invalidate()
            }
            strongSelf.isReady = true
            strongSelf.number4Label?.text = "\((strongSelf.randomNumber /  1) % 10 )"

        }



    }
    @objc func randomNumber1(){
        let number = Int.randomNumber(range: (0...9))
        number1Label?.text = "\(number)"
    }
    @objc func randomNumber2(){
        let number = Int.randomNumber(range: (0...9))
        number2Label?.text = "\(number)"

    }
    @objc func randomNumber3(){
        let number = Int.randomNumber(range: (0...9))
        number3Label?.text = "\(number)"

    }
    @objc func randomNumber4(){
        let number = Int.randomNumber(range: (0...9))
        number4Label?.text = "\(number)"

    }

}
