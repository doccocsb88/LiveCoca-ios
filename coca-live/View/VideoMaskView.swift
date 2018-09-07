//
//  VideoMaskView.swift
//  coca-live
//
//  Created by Apple on 8/5/18.
//  Copyright © 2018 Coca Live. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import MediaPlayer

class VideoMaskView: UIView {

    var player: AVPlayer?
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    func playVideo(from file:String) {
//        let file = file.components(separatedBy: ".")
//
//        guard let path = Bundle.main.path(forResource: file[0], ofType:file[1]) else {
//            debugPrint( "\(file.joined(separator: ".")) not found")
//            return
//        }
        let url = URL(string: file)
        player = AVPlayer(url: url!)
        
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = self.bounds
        self.layer.addSublayer(playerLayer)
        player?.play()
        
    }
    
    func stopVideo() {
        player?.pause()
    }

}
