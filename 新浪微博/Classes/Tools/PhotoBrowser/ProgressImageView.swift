//
//  ProgressImageView.swift
//  新浪微博
//
//  Created by 梁华建 on 2019/4/15.
//  Copyright © 2019 梁华建. All rights reserved.
//

import UIKit

class ProgressImageView: UIImageView {
    //MARK: - 加载进度 0-1
    var progress : CGFloat = 0 {
        didSet{
            progressview.progress = progress
        }
    }
    
    //MARK: - 生命周期
    convenience init() {
        self.init(frame:CGRect.zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - 布局视图
    func setupUI() {
        //1,添加子控件
        addSubview(progressview)
        progressview.backgroundColor = .clear
        //2,布局
        progressview.snp.makeConstraints { (make) in
            make.edges.equalTo(self.snp.edges)
        }
    }
    
    //套一个UIView到ImageView上面，imageView初始化不会调用drawRect
    lazy var progressview = ProgressView()
}

//MARK: - 进图视图
internal class ProgressView : UIView
{
    var progress : CGFloat = 0 {
        didSet{
            //重绘视图
            setNeedsDisplay()
        }
    }
    
    //画一个圆
    override func draw(_ rect: CGRect) {
        
        //rect -> bounds
        let center = CGPoint.init(x: rect.width*0.5, y: rect.height*0.5)
        
        let radius = min(rect.width, rect.height)*0.5
        //默认开始地方是Double.pi/2
        let start = CGFloat(-Double.pi/2)
        
        let end = start + progress*2*CGFloat(Double.pi)
        
        //画弧线
        let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: start, endAngle: end, clockwise: true)
        //连接到中心点，形成弧线
        path.addLine(to: center)
        
        path.close()
        
        UIColor.init(white: 1, alpha: 0.3).setFill()
        
        path.fill()
        
    }
}
