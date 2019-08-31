//
//  VideoViewController.swift
//  新浪微博
//
//  Created by 梁华建 on 2019/8/26.
//  Copyright © 2019 梁华建. All rights reserved.
//

import UIKit

class VideoViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    
    var player : WMPlayer?
    
    var playerModel : WMPlayerModel?
    
    func setUpUI(){
        if player == nil
        {
            player = WMPlayer.init(model: playerModel)
        }
        self.view.addSubview(player!)
        player?.snp.makeConstraints({ (make) in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.right.equalTo(self.view.snp.right)
            make.width.equalTo(screenWidth)
            make.height.equalTo(player!.frame.size.height)
        })
        player?.delegate = self
        player?.play()
    }
    func releasePlayer()
    {
        self.player?.pause()
        self.player?.removeFromSuperview()
        self.player = nil
    }
    deinit {
        releasePlayer()
    }
}

extension VideoViewController : WMPlayerDelegate
{
    
}
