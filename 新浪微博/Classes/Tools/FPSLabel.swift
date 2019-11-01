//
//  FPSLabel.swift
//  新浪微博
//
//  Created by 梁华建 on 2019/4/6.
//  Copyright © 2019 梁华建. All rights reserved.
//

import UIKit

class FPSLabel: UILabel {

    private var link:CADisplayLink?
    
    private var lastTime:TimeInterval = 0.0;
    
    private var count:Int = 0;
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        link = CADisplayLink.init(target: self, selector: #selector(FPSLabel.didTick(link:)))
        //commom会无论用户的app处于什么停止还是滑动都会进行fps打印(commonMode会添加timer到所有mode上面)
        //receiver是指didTick方法
        link?.add(to: RunLoop.current, forMode: .common)
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    
    @objc func didTick(link:CADisplayLink) {
        
        if lastTime == 0
        {
            
            lastTime = link.timestamp
            //print("lastTime \(lastTime)")
            return
        }
        //用来记录一秒进入这个方法多少次，如果进入了20次那么count就变成20，20帧
        count += 1
        //在一秒内打印的次数
        let delta = link.timestamp - lastTime
        //print("link.timestamp \(link.timestamp) lastTime\(lastTime)")
        if delta < 1{
            //不够一秒就返回，继续往上面count加一，这样就可以获得一秒内有多少个页面
            return
        }
        //这时候已经到一秒了，我们先把lastTime更新至当前时间以便下一次计算
        lastTime = link.timestamp
        //delta是1.0000000....
        //print("delta :\(delta)")
        let fps = Double(count)/delta
        
        count = 0
        
        text = String.init(format: "%02.0f帧", round(fps))

    }
    
    /*
     Only override draw() if you perform custom drawing.
     An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
         Drawing code
    }
    */

}
