//
//  EmoticonScreen.swift
//  微信聊天框表情
//
//  Created by 梁华建 on 2019/10/5.
//  Copyright © 2019 梁华建. All rights reserved.
//

import UIKit
///随机发射表情的layer
class EmoticonLayer: CALayer {
    
    func emit(text : String?) {
        
        if text == nil
        {
            return
        }
        
        //如果上次动画还没完成那么先把所有表情layer清除掉
        self.sublayers?.removeAll()
        
        EmoticonsViewModel.shared.packages.forEach {
            
            $0.emoticons.forEach({
                
                if $0.chs == "[" + text! + "]"
                {
                    for i in 0..<30 {
                        
                        let image = UIImage.init(named:$0.imagePath)
                        
                        let layer = CALayer()
                        //随机大小
                        let randomSize = arc4random() % 2 == 0 ? CGSize(width: 44, height: 44) : CGSize(width: 33, height: 33)
                        //随机x轴位置
                        layer.frame = CGRect(x: CGFloat(arc4random() % UInt32(screenWidth)), y: -44, width:randomSize.width, height: randomSize.height)
                        
                        layer.contents = image?.cgImage
                        
                        let positionAni = CABasicAnimation.init(keyPath: "position")
                        
                        positionAni.toValue = CGPoint(x:CGFloat(arc4random() % UInt32(screenWidth)), y:screenHeight)
                        
                        positionAni.duration = 2
                        //随机出现时间
                        positionAni.beginTime = CACurrentMediaTime() + TimeInterval(Double(i) * 0.15)
                        layer.add(positionAni, forKey: positionAni.keyPath)
                        
                        self.addSublayer(layer)
                    }
                }
            })
            
        }
        
    }
    
    
}
