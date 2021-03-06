//
//  CatchWordMaskView.swift
//  coca-live
//
//  Created by Apple on 8/5/18.
//  Copyright © 2018 Coca Live. All rights reserved.
//

import UIKit

class CatchWordMaskView: UIView {
    fileprivate let cellHeight:CGFloat = 30

    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    var frameImageView:UIImageView?
    var questionImageView:UIImageView?
    var questionLabel:UILabel?
    var scale:CGFloat = 1
    var tableView:UITableView?
    var data:[FacebookComment] = []
    init(frame: CGRect, scale:CGFloat) {
        super.init(frame: frame)
        self.scale = scale
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
        guard let config = WarterMarkServices.shared().params["catchword"] as? [String:Any] else{return}

        let backgroundColor = UIColor(hexString: "#EB6B79")
        let font = UIFont.systemFont(ofSize: 25)
        let margin = 30 * scale
        let frameMargin = 10 * scale;
        let width = self.bounds.width - margin  * 2

        //
        let questionText = config["question"] as? String
        var questionViewHeight = questionText?.heightWithConstrainedWidth(width: width - margin * 2, font: font) ?? 40 * scale
        questionViewHeight = questionViewHeight > 40 * scale ? questionViewHeight : 40 * scale
        //
        let frameWidth = self.bounds.width - frameMargin  * 2
        let imageHeight = width * 9 / 16
        let frameHeight = questionViewHeight + imageHeight + 70 * scale

        //
       
        //
        
        
        var startY = self.bounds.height  - imageHeight - questionViewHeight - 50 * scale
        frameImageView = UIImageView(frame: CGRect(x: frameMargin, y: startY, width: frameWidth, height: frameHeight))
        frameImageView?.contentMode = .scaleToFill
        self.addSubview(frameImageView!)
        if let frame = config["frame"] as? UIImage{
            frameImageView?.image = frame

        }else{
            frameImageView?.image = UIImage(named: "frame_catchword_default")

        }
        let state = config["state"] as? Int ?? 0
        if  state == 0 {
            
            
            startY = startY + 35 * scale
            let questionView = UIView(frame: CGRect(x: margin, y: startY, width: width, height: questionViewHeight))
            questionView.backgroundColor = backgroundColor
            questionView.addBorder(cornerRadius: questionViewHeight / 2, color: .clear)
            
            questionLabel = UILabel(frame: CGRect(x: margin, y: 0, width: width - margin * 2, height: questionViewHeight))
            questionLabel?.text = config["question"] as? String
            questionLabel?.textColor = .white
            questionLabel?.font = font
            questionView.addSubview(questionLabel!)
            self.addSubview(questionView)
            
            ///
            startY = startY + 10 * scale + questionViewHeight

            questionImageView = UIImageView(frame: CGRect(x: margin, y: startY, width: width, height: imageHeight))
            questionImageView?.contentMode = .scaleAspectFit
            questionImageView?.image = config["image"] as? UIImage
            //        questionImageView?.backgroundColor = UIColor.lightGray
            self.addSubview(questionImageView!)
        }else{
            startY = startY + 35 * scale
            let titleHeight = 30 * scale
            let questionView = UIView(frame: CGRect(x: margin, y: startY, width: width, height: titleHeight))
            questionView.backgroundColor = backgroundColor
            questionView.addBorder(cornerRadius: titleHeight / 2, color: .clear)
            
            questionLabel = UILabel(frame: CGRect(x: margin, y: 0, width: width - margin * 2, height: titleHeight))
            questionLabel?.text = "Danh sách người chơi trả lời đúng."
            questionLabel?.textColor = .white
            questionLabel?.font = font
            questionLabel?.textAlignment = .center
            questionView.addSubview(questionLabel!)
            self.addSubview(questionView)
            
            //
            startY = startY + titleHeight + 10 * scale;
            
            tableView = UITableView(frame: CGRect(x: margin, y: startY, width: width, height: frameHeight - startY - 10 * scale))
            tableView?.delegate = self
            tableView?.dataSource = self
            tableView?.register(UINib(nibName: "AnswerCatchWordViewCell", bundle: nil), forCellReuseIdentifier: "AnswerCatchWordViewCell")
            tableView?.addBorder(cornerRadius: 5, color: .lightGray)
            self.addSubview(tableView!)
            guard let answer =  config["answer"] as? String else{return}
            data = APIUtils.filterComment(answer)
            
        }
        
        //
       
        
    }
}
extension CatchWordMaskView:UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight * scale
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return data.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AnswerCatchWordViewCell", for: indexPath) as! AnswerCatchWordViewCell
        let comment = data[indexPath.row]
        cell.updateContent(comment,indexPath)
        cell.selectionStyle = .none
        return cell
    }
}


